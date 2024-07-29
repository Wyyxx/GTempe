import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GTemp extends StatefulWidget {
  const GTemp({Key? key}) : super(key: key);

  @override
  _GTempState createState() => _GTempState();
}

class _GTempState extends State<GTemp> {
  double temperature = 0;

  @override
  void initState() {
    super.initState();
    fetchTemperature();
  }

  Future<void> fetchTemperature() async {
    final ref = FirebaseDatabase.instance.ref();
    final temp = await ref.child("Living Room/temperature/value").get();
    if (temp.exists) {
      setState(() {
        temperature = double.parse(temp.value.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: -10,
          maximum: 50,
          pointers: <GaugePointer>[
            NeedlePointer(value: temperature),
          ],
          ranges: <GaugeRange>[
            GaugeRange(startValue: -10, endValue: 0, color: Colors.blue),
            GaugeRange(startValue: 1, endValue: 30, color: Colors.green),
            GaugeRange(startValue: 31, endValue: 50, color: Colors.red),
          ],
        ),
      ],
    );
  }
}
