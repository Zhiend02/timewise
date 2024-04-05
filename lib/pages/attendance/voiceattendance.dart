import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:timewise/pages//global.dart' as globals;



class VoiceInputScreen extends StatefulWidget {
  @override
  _VoiceInputScreenState createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  List<String> _numbersList = [];
  List<String> _uniqueNumbersList = [];
  String _statusMessage = 'Start'; // Initialize with a default value

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
          setState(() => _statusMessage = 'Wait...'); // Change status message to "Wait..." when listening
        } else {
          setState(() => _statusMessage = 'Start'); // Change status message to "Start" otherwise
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Input'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? 'Stop Listening' : '$_statusMessage'), // Display status message
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Placeholder button, no action required
              child: Text('Print Numbers List Automatically'), // Text changed

            ),

          ],
        ),
      ),
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
    setState(() => _statusMessage = 'Start'); // Change status message back to "Start"
    globals.UniqueNumbersList.addAll(_uniqueNumbersList);
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
    _uniqueNumbersList = _numbersList.toSet().toList();
    // print('Unique Numbers List: $uniqueNumbersList');
  }
}

void main() {
  runApp(MaterialApp(
    home: VoiceInputScreen(),
  ));
}
//also perfect and  directly printing the list
// microphone stoping issue in mobile