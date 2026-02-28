import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../models/LabM/lab_model.dart';
import '../../../../view_model/LabVM/AllLab/lab_bloc.dart';
import '../../../../view_model/LabVM/AllLab/lab_event.dart';
import '../../../../view_model/LabVM/AllLab/lab_state.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/go_to_cart_bar.dart';
import '../widgets/lab_shimmer_loading.dart';
import 'company_medicine_view.dart';

class AllLabMedicinePage extends StatefulWidget {
  final String labName;
  const AllLabMedicinePage({required this.labName, super.key});

  @override
  State<AllLabMedicinePage> createState() => _AllLabMedicinePageState();
}

class _AllLabMedicinePageState extends State<AllLabMedicinePage> {
  static const String _imageBaseUrl = 'https://www.online-tech.in/LabImage/';

  double? userLat;
  double? userLng;
  bool _isLoadingPrefs = true; // Track if location is loaded

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabBloc>().add(FetchLabsEvent());
    });
  }

  Future<void> _loadUserLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userLat = prefs.getDouble('selected_lat');
        userLng = prefs.getDouble('selected_lng');
        _isLoadingPrefs = false;
      });
    } catch (e) {
      setState(() => _isLoadingPrefs = false);
    }
  }

  /// Safely calculates distance between two points
  double _calculateDistance(String? latStr, String? lngStr) {
    if (userLat == null || userLng == null || latStr == null || lngStr == null) {
      return 0.0;
    }
    final double? lat = double.tryParse(latStr);
    final double? lng = double.tryParse(lngStr);

    if (lat == null || lng == null) return 0.0;

    return Geolocator.distanceBetween(userLat!, userLng!, lat, lng);
  }

  List<LabModel> _getNearbyStores(List<LabModel> allLabs) {
    // Filter first
    List<LabModel> nearbyLabs = allLabs.where((lab) {
      if (lab.isMedicineStore != true) return false;

      double distanceInMeters = _calculateDistance(lab.latitude, lab.longnitude);

      // If location is unknown, you might want to show it anyway or hide it.
      // Here we hide it if location is available but it's too far.
      if (userLat != null && userLng != null) {
        return distanceInMeters <= 50000; // 50 KM Limit
      }
      return true; // If user location is missing, show all medicine stores
    }).toList();

    // Sort only if we have user coordinates
    if (userLat != null && userLng != null) {
      nearbyLabs.sort((a, b) {
        double distA = _calculateDistance(a.latitude, a.longnitude);
        double distB = _calculateDistance(b.latitude, b.longnitude);
        return distA.compareTo(distB);
      });
    }

    return nearbyLabs;
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.labName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoadingPrefs
          ? const LabShimmerLoading()
          : BlocBuilder<LabBloc, LabState>(
        builder: (context, state) {
          if (state is LabLoading) return const LabShimmerLoading();

          if (state is LabError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.red)),
              ),
            );
          }

          if (state is LabLoaded) {
            final stores = _getNearbyStores(state.labs);

            if (stores.isEmpty) {
              return Center(
                child: Text('No stores found nearby.', style: GoogleFonts.poppins()),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final lab = stores[index];

                // Safe distance calculation for UI
                double distKm = _calculateDistance(lab.latitude, lab.longnitude) / 1000;

                final imageUrl = (lab.labImage != null && lab.labImage!.isNotEmpty)
                    ? '$_imageBaseUrl${lab.labImage}'
                    : null;

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(SlidePageRoute(
                      page: CompanyMedicineView(
                        storeId: lab.id ?? 0,
                        companyName: lab.labName ?? "Unknown Store",
                      ),
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl != null
                              ? Image.network(
                            imageUrl,
                            width: 60, height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(width: 60, height: 60, color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
                          )
                              : Container(width: 60, height: 60, color: Colors.grey.shade200, child: const Icon(Icons.store)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lab.labName ?? "Unnamed Store",
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                              if (userLat != null)
                                Text("${distKm.toStringAsFixed(1)} KM away",
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                              Text(lab.description ?? "",
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: cartCount > 0
          ? GoToCartBar(cartCount: cartCount)
          : null,
    );
  }
}