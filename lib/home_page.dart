import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_ride/sensors_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Smooth Ride"),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Ride smooth with SmoothRide"),
        SizedBox.fromSize(size: const Size.fromHeight(20)),
        ElevatedButton(onPressed: () {
          _start(context);
        }, child: Text("Start"))
      ],
    ),
    );
  }

  _start(BuildContext context) async {
    LocationPermission permission;

    // Test if location services are enabled.
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Location permissions are denied'),
        ));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location permissions are permanently denied, we cannot request permissions.'),
      ));
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => const SensorsPage()));

  }
}
