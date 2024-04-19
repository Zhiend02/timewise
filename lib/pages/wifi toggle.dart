import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiToggle extends StatefulWidget {
  @override
  _WifiToggleState createState() => _WifiToggleState();
}

class _WifiToggleState extends State<WifiToggle> {
  bool _isWifiEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkWifiStatus();
  }

  void _checkWifiStatus() async {
    try {
      bool isEnabled = await WiFiForIoTPlugin.isEnabled();
      setState(() {
        _isWifiEnabled = isEnabled;
      });
    } catch (e) {
      print('Error checking Wi-Fi status: $e');
    }
  }

  void _toggleWifi() async {
    try {
      if (_isWifiEnabled) {
        await WiFiForIoTPlugin.setEnabled(false);
      } else {
        await WiFiForIoTPlugin.setEnabled(true);
      }
      _checkWifiStatus(); // Update the Wi-Fi status after toggling
    } catch (e) {
      print('Error toggling Wi-Fi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Wi-Fi Status: ${_isWifiEnabled ? 'Enabled' : 'Disabled'}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _toggleWifi,
          child: Text(
            _isWifiEnabled ? 'Disable Wi-Fi' : 'Enable Wi-Fi',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
