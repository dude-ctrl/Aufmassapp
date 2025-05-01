import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GLM50-27CG Test',
      theme: ThemeData.dark(),
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothDevice? connectedDevice;
  String status = "Suche nach GLM50-27CG...";

  @override
  void initState() {
    super.initState();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    FlutterBlue.instance.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name.contains('GLM50-27CG')) {
          _connectToDevice(r.device);
        }
      }
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    await FlutterBlue.instance.stopScan();
    try {
      await device.connect();
    } catch (_) {}
    setState(() {
      connectedDevice = device;
      status = "Verbunden mit: ${device.name}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GLM50-27CG')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            status,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
