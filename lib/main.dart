import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('android_iOS_battery');

  String _battery = '0';

  Future<void> _getBatteryLevel() async {
    String battery;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      battery = "$result";
    } on PlatformException catch (e) {
      battery = "FAILED TO GET BATTERY LEVEL: '${e.message}'";
    }
    setState(() {
      _battery = battery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            CircularPercentIndicator(
              progressColor:
                  double.parse(_battery) > 49 ? Colors.green : Colors.red,
              arcBackgroundColor: Colors.black,
              arcType: ArcType.FULL,
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: double.parse(_battery) / 100,
              center: Text(
                _battery + " %",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
