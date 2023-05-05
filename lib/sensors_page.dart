import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  String _accelerometer = "";
  String _userAccelerometer = "";
  String _gyroscope = "";
  String _magnetometer = "";
  String _gps = "";

  @override
  Widget build(BuildContext context) {
    accelerometerEvents.listen((AccelerometerEvent event) {
      print(event);
      setState(() {
        _accelerometer = event.toString();
      });
    });
// [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      print(event);
      setState(() {
        _userAccelerometer = event.toString();
      });
    });
// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

    gyroscopeEvents.listen((GyroscopeEvent event) {
      print(event);
      setState(() {
        _gyroscope = event.toString();
      });
    });
// [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]

    magnetometerEvents.listen((MagnetometerEvent event) {
      print(event);
      setState(() {
        _magnetometer = event.toString();
      });
    });

    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      setState(() {
        _gps = position == null
            ? 'Unknown'
            : 'gps: ${position.latitude.toString()}, ${position.longitude.toString()}';
        print(_gps);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Sensors"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Accelerometer"),
            Text(
              _accelerometer,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text("User accelerometer"),
            Text(
              _userAccelerometer,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text("Gyroscope"),
            Text(
              _gyroscope,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text("Magnetometer"),
            Text(
              _magnetometer,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text("Gps"),
            Text(
              _gps,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
