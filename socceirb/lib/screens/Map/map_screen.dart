// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  final String routeName = "/map";

  final LatLng _center = const LatLng(44.837789, -0.57918);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13,
          ),
        ),
      ),
    );
  }
}
