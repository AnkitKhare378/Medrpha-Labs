import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SelectedAddressData {
  final String fullAddress;
  final String flatHouseNumber;
  final String streetLandmark;
  final String localityArea;
  final String pincode;

  SelectedAddressData({
    required this.fullAddress,
    required this.flatHouseNumber,
    required this.streetLandmark,
    required this.localityArea,
    required this.pincode,
  });
}

class SelectedLocationInfo {
  final String fullAddress;
  final double latitude;
  final double longitude;

  SelectedLocationInfo({
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
  });
}


class LocationPickerBox extends StatefulWidget {
  const LocationPickerBox({super.key});

  @override
  //  Reference the public state class
  State<LocationPickerBox> createState() => LocationPickerBoxState();
}

class LocationPickerBoxState extends State<LocationPickerBox> {
  GoogleMapController? _mapController;
  LatLng? _currentMapCenter;
  String _currentAddress = "Loading address...";
  bool _isLoading = false;

  late Future<CameraPosition> _initialCameraPositionFuture;

  // Public getter to allow parent widget to access the currently determined address
  String get currentAddress => _currentAddress;

  // ✅ NEW: Public getter for the current coordinates
  LatLng? get currentCoordinates => _currentMapCenter;

  @override
  void initState() {
    super.initState();
    _initialCameraPositionFuture = _getInitialCameraPosition();
  }

  // --- Location and Geocoding Logic ---

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
        target: LatLng(26.8500, 80.9499), // Fallback
        zoom: 14,
      );
    }
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
      // Using a global key or context from a widget in the tree to show SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_currentAddress)),
        );
      }
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
        // Construct a clean, full address string
        _currentAddress = "${place.street ?? ''}, ${place.subLocality ?? place.locality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}, ${place.country ?? ''}";
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
    // Set loading state and temporary address while user is moving the map
    setState(() {
      _isLoading = true;
      _currentAddress = "Searching for address...";
    });
  }

  void _onCameraIdle() {
    if (_currentMapCenter != null) {
      // Address reverse geocoding is triggered when map movement stops
      _reverseGeocodeLocation(_currentMapCenter!);
    }
  }

  // --- Widget Build ---

  @override
  Widget build(BuildContext context) {
    // Determine the height for the map box
    final height = MediaQuery.of(context).size.height * 0.55;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Stack(
        children: [
          // 1. Google Map
          FutureBuilder<CameraPosition>(
            future: _initialCameraPositionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final initialPosition = snapshot.data ?? const CameraPosition(target: LatLng(0, 0), zoom: 13);

              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initialPosition,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              );
            },
          ),

          // 2. Center Marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.location_on,
                color: Colors.red.shade600,
                size: 40,
              ),
            ),
          ),

          // 3. Current Location Button
          Positioned(
            right: 15,
            bottom: 15,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade600,
              onPressed: _fetchAndSetCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),

          // 4. Address Display and Loader
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pin_drop_outlined, size: 18, color: Colors.blue.shade600),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}