import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String myPosition = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    // request permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        myPosition = 'Permission denied';
      });
      return;
    }

    // ensure service enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        myPosition = 'Location service disabled';
      });
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition();
      // format similar to the example screenshot
      final lat = pos.latitude.toStringAsFixed(5);
      final lon = pos.longitude.toStringAsFixed(6);
      setState(() {
        myPosition = 'Latitude: $lat, Longitude: $lon';
      });
    } catch (e) {
      setState(() {
        myPosition = 'Error getting location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Current Location - Febrian Arka Samudra - 2341720066',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(myPosition, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
