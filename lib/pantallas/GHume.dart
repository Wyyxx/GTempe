import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GHume extends StatefulWidget {
  const GHume({Key? key}) : super(key: key);

  @override
  _GHumeState createState() => _GHumeState();
}

class _GHumeState extends State<GHume> {
  double humidity = 0;

  @override
  void initState() {
    super.initState();
    fetchHumidity();
  }

  Future<void> fetchHumidity() async {
    final ref = FirebaseDatabase.instance.ref();
    final humi = await ref.child("Living Room/humidity/value").get();
    if (humi.exists) {
      setState(() {
        humidity = double.parse(humi.value.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: -10,
          maximum: 100,
          pointers: <GaugePointer>[
            NeedlePointer(value: humidity),
          ],
          ranges: <GaugeRange>[
            GaugeRange(startValue: -10, endValue: 0, color: Colors.brown),
            GaugeRange(startValue: 1, endValue: 50, color: Colors.yellow),
            GaugeRange(startValue: 51, endValue: 100, color: Colors.purple),
          ],
        ),
      ],
    );
  }
}
