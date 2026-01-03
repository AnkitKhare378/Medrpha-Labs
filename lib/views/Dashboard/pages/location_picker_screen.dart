// save the selected lat and log in local storage

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentMapCenter;
  String _currentAddress = "Loading address...";
  bool _isLoading = false;

  late Future<CameraPosition> _initialCameraPositionFuture;

  @override
  void initState() {
    super.initState();
    _initialCameraPositionFuture = _getInitialCameraPosition();
  }

  Future<CameraPosition> _getInitialCameraPosition() async {
    try {
      final position = await _determinePosition();

      _currentMapCenter = LatLng(position.latitude, position.longitude);

      await _reverseGeocodeLocation(_currentMapCenter!);

      return CameraPosition(
        target: _currentMapCenter!,
        zoom: 16,
      );
    } catch (e) {
      print("Error fetching initial location: $e");

      setState(() {
        _currentAddress = "Location access denied. Showing default area.";
      });

      return const CameraPosition(
        target: LatLng(26.8500, 80.9499),
        zoom: 14,
      );
    }
  }

  Future<void> _saveLocationToLocalStorage(LatLng location, String address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Storing as doubles and string
    await prefs.setDouble('selected_lat', location.latitude);
    await prefs.setDouble('selected_lng', location.longitude);
    await prefs.setString('selected_address', address);

    print("Saved to Local Storage: ${location.latitude}, ${location.longitude}");
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
  }

  Future<void> _fetchAndSetCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await _determinePosition();
      _currentMapCenter = LatLng(position.latitude, position.longitude);

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentMapCenter!, 16),
      );

    } catch (e) {
      _currentAddress = "Error: ${e.toString()}";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_currentAddress)),
      );
    }
  }

  Future<void> _reverseGeocodeLocation(LatLng coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _currentAddress = "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
      } else {
        _currentAddress = "Address not found for this location.";
      }
    } catch (e) {
      _currentAddress = "Error fetching address.";
    }
    setState(() {
      _isLoading = false;
    });
  }

  // --- Map Callbacks ---

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapCenter = position.target;
    _currentAddress = "Searching for address...";
  }

  void _onCameraIdle() {
    if (_currentMapCenter != null) {
      setState(() {
        _isLoading = true;
      });
      _reverseGeocodeLocation(_currentMapCenter!);
    }
  }


  Widget _buildConfirmationSheet() {
    final iconColor = Colors.blue.shade600;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order will be delivered here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(Icons.location_on, color: iconColor, size: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Show address update loading in the button area
          _isLoading
              ? const Center(child: LinearProgressIndicator(minHeight: 5))
              : SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              // onPressed: () {
              //   Navigator.pop(context, _currentAddress);
              //   print("Confirmed Address: $_currentAddress");
              // },
              onPressed: () async {
                if (_currentMapCenter != null) {
                  // 1. Save to SharedPreferences (for the 50KM filter logic)
                  await _saveLocationToLocalStorage(_currentMapCenter!, _currentAddress);

                  // 2. Return data to the previous screen
                  Navigator.pop(context, {
                    'lat': _currentMapCenter!.latitude,
                    'lng': _currentMapCenter!.longitude,
                    'address': _currentAddress,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Confirm & proceed',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Pickup Location',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Use FutureBuilder to wait for the initial CameraPosition
            FutureBuilder<CameraPosition>(
              future: _initialCameraPositionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching location
                  return const Center(child: CircularProgressIndicator());
                }

                // Use the fetched position or the default fallback position
                final initialPosition = snapshot.data ?? const CameraPosition(target: LatLng(0, 0), zoom: 13);

                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initialPosition,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle, // Update address when map stops moving
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                );
              },
            ),

            // Center Marker (The pin at the center of the map)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue.shade600,
                  size: 40,
                ),
              ),
            ),

            // Current Location Button
            Positioned(
              right: 15,
              bottom: 250,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade600,
                onPressed: _fetchAndSetCurrentLocation,
                child: const Icon(Icons.my_location),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildConfirmationSheet(),
            ),
          ],
        ),
      ),
    );
  }
}