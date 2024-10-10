// ignore_for_file: always_use_package_imports

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:field_master/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    required this.initialLocation,
    super.key,
    this.isSelecting = true,
  });
  final PlaceLocation initialLocation;
  final bool isSelecting;
  @override
  MapsScreenState createState() => MapsScreenState();
}

class MapsScreenState extends State<MapsScreen> {
  LatLng? pickedlocation;
  Position? currentLocation;

  void _selectLocation(LatLng selectedLocation) {
    log('lat ${selectedLocation.latitude}');
    log('lng ${selectedLocation.longitude}');
    setState(() {
      pickedlocation = selectedLocation;
    });
  }

  Future<void> _selectPlace() async {
    // currentLocation = await location.Location().getLocation();
    currentLocation = await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _selectPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(
                Icons.check,
                color: pickedlocation == null
                    ? null
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: pickedlocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(pickedlocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (pickedlocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: pickedlocation ??
                      LatLng(
                        currentLocation!.latitude,
                        currentLocation!.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
