import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';


class CustomDialogWidget extends StatefulWidget {
  @override
  _CustomDialogWidgetState createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  List<String> _numbersList = [];
  String _statusMessage = 'Start';

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognizer();
    _checkPermission();
  }

  void _initializeSpeechRecognizer() {
    _speechToText.initialize(
      onError: (error) => print('Error: $error'),
      onStatus: (status) {
        if (status == stt.SpeechToText.listeningStatus) {
          setState(() =>
          _statusMessage =
          'Wait...'); // Change status message to "Wait..." when listening
        } else {
          setState(() =>
          _statusMessage =
          'Start'); // Change status message to "Start" otherwise
        }
      },
    );
  }

  void _checkPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Custom Dialog'),
      content: Container(
        height: 300, // Custom height
        width: 300, // Custom width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.network(
              'assets/images/mic.svg',
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 30),
            Text(_text),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening
                  ? 'Stop Listening'
                  : '$_statusMessage'), // Display status message
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Placeholder button, no action required
              child: Text('Print Numbers List Automatically'), // Text changed
            ),
            const Text('You can add your microphone input here.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }


  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _statusMessage = 'Wait...'; // Change status message to "Wait..."
        _numbersList.clear(); // Clear the numbers list before listening again
      });
      _speechToText.listen(
        onResult: (result) {
          setState(() => _text = result.recognizedWords);
          _processSpeechInput(result.recognizedWords);
        },
      );
    } else {
      print('Speech recognition not available');
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speechToText.stop();
    setState(() =>
    _statusMessage = 'Start'); // Change status message back to "Start"
    _printNumbersList(); // Call method to print numbers list automatically
    _printUniqueNumbersList(); // Call method to print unique numbers list automatically
  }

  void _processSpeechInput(String input) {
    // Split the recognized sentence into words
    List<String> words = input.split(' ');

    String currentNumber = ''; // Variable to track the current number being processed

    for (String word in words) {
      // Check if the word is a number
      if (RegExp(r'^\d+$').hasMatch(word)) {
        // If a new number is encountered, store the previous number
        if (currentNumber.isNotEmpty) {
          int number = int.parse(currentNumber);
          _numbersList.add(number.toString());
        }
        currentNumber = word; // Update the current number
      } else if (word.toLowerCase() == 'and') {
        // If "and" is encountered, store the word format of the current number
        if (currentNumber.isNotEmpty) {
          int number = int.parse(currentNumber);
          _numbersList.add(number.toString());
        }
        currentNumber = ''; // Reset currentNumber after processing "and"
      }
    }

    // Store the last number if any
    if (currentNumber.isNotEmpty) {
      int number = int.parse(currentNumber);
      _numbersList.add(number.toString());
    }
  }

  void _printNumbersList() {
    print('Numbers List: $_numbersList');
  }

  void _printUniqueNumbersList() {
    // Convert numbers list to a set to remove duplicates, then back to list
    List<String> uniqueNumbersList = _numbersList.toSet().toList();
    print('Unique Numbers List: $uniqueNumbersList');
  }
}

