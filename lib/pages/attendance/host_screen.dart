
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var name = preferences.getString('name');
  print(name);
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: name == null ? const Login() : const MyHomePagehost(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePagehost extends StatefulWidget {
  const MyHomePagehost({Key? key}) : super(key: key);
  @override
  State<MyHomePagehost> createState() => _MyHomePagehostState();
}

class _MyHomePagehostState extends State<MyHomePagehost> {
  Icon buticon = const Icon(Icons.bluetooth);
  String button = 'Start';
  String name = '';
  String text = 'Caution! Ask all the students to switch on Bluetooth first';
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  onClick() {
    if (devices.isNotEmpty) {
      _onButtonClicked(devices.first);
    } else {
      // Handle the case when devices list is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No devices available')),
      );
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('email');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => const Login()));
  }

  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  bool isInit = false;

  void requestPermissions() async {
    // Request Bluetooth permission
    var bluetoothStatus = await Permission.bluetooth.request();
    if (bluetoothStatus != PermissionStatus.granted) {
      // Handle denied Bluetooth permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bluetooth permission denied')),
      );
    }

    // Request Location permission
    var locationStatus = await Permission.locationWhenInUse.request();
    if (locationStatus != PermissionStatus.granted) {
      // Handle denied Location permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission denied')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  // _onTabItemListener(Device device) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final erno = prefs.getString('erno');
  //   if (device.state == SessionState.connected) {
  //     nearbyService.sendMessage(device.deviceId, erno!);
  //   }
  // }

  int getItemCount() {
    return connectedDevices.length;
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
      // nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    nearbyService = NearbyService();
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model!;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel!;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: devInfo,
        strategy: Strategy.P2P_STAR,
        callback: (isRunning) async {
          if (isRunning) {
            print("Service running");
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            await Future.delayed(Duration(microseconds: 200));
            await nearbyService.startAdvertisingPeer();
            await nearbyService.startBrowsingForPeers();
          } else {
            print("Service not running");
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
          devicesList.forEach((element) {
            print(
                " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");
            devices.add(element);

            if (Platform.isAndroid) {
              if (element.state == SessionState.connected) {
                nearbyService.stopBrowsingForPeers();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(element.deviceId + element.deviceName)));
              } else {
                nearbyService.startBrowsingForPeers();
              }
            }
          });
          devices.clear();
          devices.addAll(devicesList);
          connectedDevices.clear();
          connectedDevices.addAll(
              devicesList.where((d) => d.state == SessionState.connected).toList());


          // Print the list of discovered devices
          print("Discovered Devices:");
          devicesList.forEach((device) {
            print("Device ID: ${device.deviceId}, Device Name: ${device.deviceName}, State: ${device.state}");
          });

        });

    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          print("dataReceivedSubscription: ${jsonEncode(data)}");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonEncode(data))));
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Track Attendance',

          ),
          actions: [
            MaterialButton(
              onPressed: logout,
              child: Row(children: [
                Icon(Icons.logout),
                SizedBox(width: size.width * 0.03),
                Text(
                  'Logout',

                )
              ]),
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Text('Welcome, ',
                   ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: const Text(
                    'Click the button below to start collecting Attendance'),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              MaterialButton(
                onPressed: onClick,
                child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade800),
                    width: size.width * 0.35,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: Row(children: [
                        buticon,
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Text(button)
                      ]),
                    )),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Text(text),
              ),
            ]),
          ),
        ));
  }
}
