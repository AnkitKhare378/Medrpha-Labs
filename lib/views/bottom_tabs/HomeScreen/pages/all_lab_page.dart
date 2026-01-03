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
import '../../TestScreen/lab_test_list_page.dart';
import '../widgets/lab_shimmer_loading.dart';

class AllLabsPage extends StatefulWidget {
  final String labName;
  const AllLabsPage({required this.labName, super.key});

  @override
  State<AllLabsPage> createState() => _AllLabsPageState();
}

class _AllLabsPageState extends State<AllLabsPage> {
  static const String _imageBaseUrl = 'https://www.online-tech.in/LabImage/';
  List<LabModel> selectedLabs = [];

  // Variables to hold user's saved location
  double? userLat;
  double? userLng;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabBloc>().add(FetchLabsEvent());
    });
  }

  /// Fetches the latitude and longitude saved from the Location Picker
  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userLat = prefs.getDouble('selected_lat');
      userLng = prefs.getDouble('selected_lng');
    });
  }

  /// Filters labs within 50KM and sorts them by distance (Nearest First)
  List<LabModel> _processLabs(List<LabModel> allLabs) {
    // If user location is missing, we show all labs but can't sort by distance
    if (userLat == null || userLng == null) {
      return allLabs.where((lab) => lab.isLab == true).toList();
    }

    // 1. Filter: isLab must be true AND distance must be <= 50KM
    List<LabModel> nearbyLabs = allLabs.where((lab) {
      if (lab.isLab != true) return false;
      if (lab.latitude == null || lab.longnitude == null) return false;

      try {
        final double lLat = double.parse(lab.latitude!);
        final double lLng = double.parse(lab.longnitude!);

        double distanceInMeters = Geolocator.distanceBetween(
          userLat!,
          userLng!,
          lLat,
          lLng,
        );

        return distanceInMeters <= 50000; // 50 KM Limit
      } catch (e) {
        return false;
      }
    }).toList();

    // 2. Sort: Nearest First
    nearbyLabs.sort((a, b) {
      double distA = Geolocator.distanceBetween(
        userLat!, userLng!,
        double.parse(a.latitude!), double.parse(a.longnitude!),
      );
      double distB = Geolocator.distanceBetween(
        userLat!, userLng!,
        double.parse(b.latitude!), double.parse(b.longnitude!),
      );
      return distA.compareTo(distB);
    });

    return nearbyLabs;
  }

  void toggleCompare(LabModel lab) {
    setState(() {
      if (selectedLabs.contains(lab)) {
        selectedLabs.remove(lab);
      } else if (selectedLabs.length < 5) {
        selectedLabs.add(lab);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You can only select up to 5 labs for comparison."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.labName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<LabBloc, LabState>(
        builder: (context, state) {
          if (state is LabLoading) {
            return const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: LabShimmerLoading(),
            );
          }

          if (state is LabError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load labs: ${state.message}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LabBloc>().add(FetchLabsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is LabLoaded) {
            final filteredAndSortedLabs = _processLabs(state.labs);

            if (filteredAndSortedLabs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No labs found within 50 KM of your location.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredAndSortedLabs.length,
                    itemBuilder: (context, index) {
                      final lab = filteredAndSortedLabs[index];
                      final isSelected = selectedLabs.contains(lab);

                      final imageUrl = lab.labImage != null && lab.labImage!.isNotEmpty
                          ? '$_imageBaseUrl${lab.labImage}'
                          : null;

                      // Pre-calculate distance for the UI
                      double distanceKm = 0.0;
                      if (userLat != null && lab.latitude != null) {
                        distanceKm = Geolocator.distanceBetween(
                            userLat!, userLng!,
                            double.parse(lab.latitude!), double.parse(lab.longnitude!)
                        ) / 1000;
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(SlidePageRoute(
                            page: LabTestListPage(labId: lab.id, labName: lab.labName),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageUrl != null
                                      ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.business, size: 40, color: Colors.grey),
                                  )
                                      : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lab.labName,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    // Distance Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${distanceKm.toStringAsFixed(1)} KM away",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text("Email: ${lab.email ?? 'N/A'}",
                                        style: GoogleFonts.poppins(fontSize: 12)),
                                    Text("Phone: ${lab.phoneNo ?? 'N/A'}",
                                        style: GoogleFonts.poppins(fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                  color: isSelected ? Colors.blueAccent : Colors.grey,
                                ),
                                onPressed: () => toggleCompare(lab),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const LabShimmerLoading();
        },
      ),
    );
  }
}