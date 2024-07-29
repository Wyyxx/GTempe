import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rtdata/pantallas/GTemp.dart';
import 'package:rtdata/pantallas/GHume.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double humidity = 0, temperature = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      getData();
    });
    getData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> getData() async {
    setState(() {
      temperature = 0;
      humidity = 0;
    });
    final ref = FirebaseDatabase.instance.ref();
    final temp = await ref.child("Living Room/temperature/value").get();
    final humi = await ref.child("Living Room/humidity/value").get();
    if (temp.exists && humi.exists) {
      setState(() {
        temperature = double.parse(temp.value.toString());
        humidity = double.parse(humi.value.toString());
        print('Temperature updated: $temperature');
        print('Humidity updated: $humidity\n');
      });
    } else {
      setState(() {
        temperature = -1;
        humidity = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperatura y Humedad"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
              );
              await getData();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: GTemp()),
          const Divider(height: 5),
          const Expanded(child: GHume()),
          const Divider(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                temperatureMessage(),
                style: TextStyle(color: temperatureColor()),
              ),
              Text(
                humidityMessage(),
                style: TextStyle(color: humidityColor()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String temperatureMessage() {
    if (temperature < 0) {
      return "Hace frío";
    } else if (temperature <= 30.50) {
      return "Temperatura agradable";
    } else {
      return "Temperatura muy alta";
    }
  }

  Color temperatureColor() {
    if (temperature < 0) {
      return Colors.blue;
    } else if (temperature <= 30.50) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  String humidityMessage() {
    if (humidity < 0) {
      return "Tiempo seco";
    } else if (humidity <= 50.50) {
      return "Humedad media";
    } else {
      return "Humedad alta";
    }
  }

  Color humidityColor() {
    if (humidity < 0) {
      return Colors.brown;
    } else if (humidity <= 50.50) {
      return Colors.yellow;
    } else {
      return Colors.purple;
    }
  }
}
