import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class LocationPickerScreen extends StatefulWidget {
  final bool isAutoFetch;
  const LocationPickerScreen({super.key, this.isAutoFetch = false});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentMapCenter;
  String _currentAddress = "Loading address...";
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  // --- Autocomplete Variables ---
  List<dynamic> _placePredictions = [];
  Timer? _debounce;
  final String _googleApiKey = "AIzaSyCzSRqABK9Y9M6rEFntgRvx4v0B74IlCEs"
      ""; // REPLACE THIS
  final _uuid = const Uuid();
  String? _sessionToken;

  late Future<CameraPosition> _initialCameraPositionFuture;

  @override
  void initState() {
    super.initState();
    _initialCameraPositionFuture = _getInitialCameraPosition();
    _sessionToken = _uuid.v4();
    if (widget.isAutoFetch) {
      _runAutoFetchAndPop();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _runAutoFetchAndPop() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );

      if (placemarks.isNotEmpty && mounted) {
        Placemark p = placemarks.first;
        String address = "${p.street}, ${p.locality}, ${p.administrativeArea} ${p.postalCode}";

        // Return result immediately without user confirmation
        Navigator.pop(context, {
          'lat': position.latitude,
          'lng': position.longitude,
          'address': address,
        });
      }
    } catch (e) {
      debugPrint("Auto-fetch failed: $e");
      // If auto-fetch fails, just stay on the screen so user can pick manually
    }
  }

  // --- Google Places Logic ---

  /// Handles the typing logic with a debounce to save API costs
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _getAutocompletePredictions(query);
      } else {
        setState(() => _placePredictions = []);
      }
    });
  }

  /// Fetches suggestions from Google Places API
  Future<void> _getAutocompletePredictions(String query) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleApiKey&sessiontoken=$_sessionToken&components=country:in"; // Filtered to India

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _placePredictions = data['predictions'];
        });
      }
    } catch (e) {
      debugPrint("Autocomplete Error: $e");
    }
  }

  /// Gets LatLng from a specific Place ID when user clicks a list item
  Future<void> _getLatLngFromPlaceId(String placeId, String mainText) async {
    final url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey";

    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body)['result'];
        final lat = result['geometry']['location']['lat'];
        final lng = result['geometry']['location']['lng'];
        final target = LatLng(lat, lng);

        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));

        setState(() {
          _currentMapCenter = target;
          _placePredictions = []; // Clear suggestions
          _searchController.text = mainText; // Set text to selection
          _sessionToken = _uuid.v4(); // Reset token for next search
        });

        await _reverseGeocodeLocation(target);
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      debugPrint("Details Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- Original Logic ---

  Future<CameraPosition> _getInitialCameraPosition() async {
    try {
      final position = await _determinePosition();
      _currentMapCenter = LatLng(position.latitude, position.longitude);
      await _reverseGeocodeLocation(_currentMapCenter!);
      return CameraPosition(target: _currentMapCenter!, zoom: 16);
    } catch (e) {
      return const CameraPosition(target: LatLng(26.8500, 80.9499), zoom: 14);
    }
  }

  Future<void> _saveLocationToLocalStorage(LatLng location, String address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('selected_lat', location.latitude);
    await prefs.setDouble('selected_lng', location.longitude);
    await prefs.setString('selected_address', address);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchAndSetCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await _determinePosition();
      _currentMapCenter = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentMapCenter!, 16));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _reverseGeocodeLocation(LatLng coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
      if (placemarks.isNotEmpty) {
        Placemark p = placemarks.first;
        setState(() {
          _currentAddress = "${p.street}, ${p.locality}, ${p.administrativeArea} ${p.postalCode}";
        });
      }
    } catch (e) {
      _currentAddress = "Address not found";
    }
    setState(() => _isLoading = false);
  }

  void _onMapCreated(GoogleMapController controller) => _mapController = controller;

  void _onCameraIdle() {
    if (_currentMapCenter != null) {
      setState(() => _isLoading = true);
      _reverseGeocodeLocation(_currentMapCenter!);
    }
  }

  // --- UI Widgets ---

  Widget _buildConfirmationSheet() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deliver to:', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 8),
              Expanded(child: Text(_currentAddress, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_currentMapCenter != null) {
                  // 1. Save locally inside the picker as well (Optional but good practice)
                  await _saveLocationToLocalStorage(_currentMapCenter!, _currentAddress);

                  // 2. THIS IS THE KEY PART: Pass the data back to the previous screen
                  if (mounted) {
                    Navigator.pop(context, {
                      'lat': _currentMapCenter!.latitude,
                      'lng': _currentMapCenter!.longitude,
                      'address': _currentAddress,
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Confirm Location', style: TextStyle(color: Colors.white, fontSize: 16)),
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
        appBar: AppBar(
          title: Text('Select Location', style: GoogleFonts.poppins()),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            FutureBuilder<CameraPosition>(
              future: _initialCameraPositionFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return GoogleMap(
                  initialCameraPosition: snapshot.data!,
                  onMapCreated: _onMapCreated,
                  onCameraMove: (pos) => _currentMapCenter = pos.target,
                  onCameraIdle: _onCameraIdle,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                );
              },
            ),

            const Center(child: Padding(padding: EdgeInsets.only(bottom: 35), child: Icon(Icons.location_on, color: Colors.red, size: 40))),

            // --- Search Bar and Suggestion List ---
            Positioned(
              top: 15, left: 15, right: 15,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)]),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: "Search for area, street...",
                        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); setState(() => _placePredictions = []); })
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  if (_placePredictions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _placePredictions.length,
                        separatorBuilder: (c, i) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final prediction = _placePredictions[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(prediction['structured_formatting']['main_text'] ?? ""),
                            subtitle: Text(prediction['structured_formatting']['secondary_text'] ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
                            onTap: () => _getLatLngFromPlaceId(prediction['place_id'], prediction['structured_formatting']['main_text']),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            Positioned(right: 15, bottom: 200, child: FloatingActionButton(mini: true, backgroundColor: Colors.white, onPressed: _fetchAndSetCurrentLocation, child: const Icon(Icons.my_location, color: Colors.blue))),
            Align(alignment: Alignment.bottomCenter, child: _buildConfirmationSheet()),
          ],
        ),
      ),
    );
  }
}