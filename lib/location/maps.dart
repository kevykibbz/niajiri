import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Niajiri/maps config/directions_model.dart';
import 'package:Niajiri/maps config/directions_repository.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key,});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
    tilt: 50.0,
  );

  late GoogleMapController _googleMapController;
  late Marker _origin;
  late Marker _destination;
  late Directions _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View location'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.green : Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Origin'),
          ),
          TextButton(
            onPressed: () {
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Dest'),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: const <Widget>[
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _initialCameraPosition,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        onPressed: () {
          _googleMapController.animateCamera(
            // ignore: unnecessary_null_comparison
            _info != null
                ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
                : CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });
    // Get directions
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin.position, destination: pos);
    setState(() => _info = directions!);
  }
}
