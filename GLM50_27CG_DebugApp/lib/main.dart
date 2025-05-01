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
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  String measurement = "Kein Wert";

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
    await device.connect(autoConnect: false).catchError((e) {});
    setState(() {
      connectedDevice = device;
    });
    // In echtem Projekt: GATT-Service + Notifications auslesen
    setState(() {
      measurement = "Verbindung hergestellt – Messwert folgt …";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GLM50-27CG')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            connectedDevice == null
                ? Text("Suche nach GLM50-27CG...", style: TextStyle(fontSize: 18))
                : Text("Verbunden mit: ${connectedDevice!.name}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 32),
            Text("Letzter Messwert:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(measurement, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
