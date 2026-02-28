import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

// Models
import '../../../../models/LabM/lab_model.dart';
import '../../../../models/CompanyM/company_model.dart';

// Blocs
import '../../../../view_model/LabVM/AllLab/lab_bloc.dart';
import '../../../../view_model/LabVM/AllLab/lab_event.dart';
import '../../../../view_model/LabVM/AllLab/lab_state.dart';
import '../../../../view_model/CompanyVM/company_bloc.dart'; // Ensure path is correct

// Widgets & Others
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/go_to_cart_bar.dart';
import '../../TestScreen/lab_test_list_page.dart';
import '../widgets/lab_shimmer_loading.dart';
import 'lab_packages.dart';

class AllLabsPage extends StatefulWidget {
  final String labName;
  final bool? isPackage;
  const AllLabsPage({required this.labName, this.isPackage, super.key});

  @override
  State<AllLabsPage> createState() => _AllLabsPageState();
}

class _AllLabsPageState extends State<AllLabsPage> {
  static const String _imageBaseUrl = 'https://www.online-tech.in/LabImage/';
  List<LabModel> selectedLabs = [];
  double? userLat;
  double? userLng;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabBloc>().add(FetchLabsEvent());
      context.read<CompanyBloc>().add(FetchCompaniesEvent());
    });
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userLat = prefs.getDouble('selected_lat');
      userLng = prefs.getDouble('selected_lng');
    });
  }

  List<LabModel> _processLabs(List<LabModel> allLabs) {
    if (userLat == null || userLng == null) {
      return allLabs.where((lab) => lab.isLab == true).toList();
    }

    List<LabModel> nearbyLabs = allLabs.where((lab) {
      if (lab.isLab != true) return false;
      if (lab.latitude == null || lab.longnitude == null) return false;
      try {
        double distanceInMeters = Geolocator.distanceBetween(
          userLat!, userLng!,
          double.parse(lab.latitude!), double.parse(lab.longnitude!),
        );
        return distanceInMeters <= 50000;
      } catch (e) { return false; }
    }).toList();

    nearbyLabs.sort((a, b) {
      double distA = Geolocator.distanceBetween(userLat!, userLng!, double.parse(a.latitude!), double.parse(a.longnitude!));
      double distB = Geolocator.distanceBetween(userLat!, userLng!, double.parse(b.latitude!), double.parse(b.longnitude!));
      return distA.compareTo(distB);
    });

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
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, companyState) {
          // Create a lookup map for efficiency: Map<ID, Name>
          Map<int, String> companyLookup = {};
          if (companyState is CompanyLoaded) {
            for (var company in companyState.companies) {
              companyLookup[company.id] = company.name;
            }
          }

          return BlocBuilder<LabBloc, LabState>(
            builder: (context, labState) {
              if (labState is LabLoading || companyState is CompanyLoading) {
                return const SingleChildScrollView(padding: EdgeInsets.all(16), child: LabShimmerLoading());
              }

              if (labState is LabError) {
                return _buildErrorWidget(labState.message);
              }

              if (labState is LabLoaded) {
                final filteredAndSortedLabs = _processLabs(labState.labs);

                if (filteredAndSortedLabs.isEmpty) {
                  return _buildEmptyWidget();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAndSortedLabs.length,
                  itemBuilder: (context, index) {
                    final lab = filteredAndSortedLabs[index];
                    final isSelected = selectedLabs.contains(lab);

                    // GET COMPANY NAME BY MATCHING ID
                    final companyName = companyLookup[lab.companyId] ?? "Unknown Company";

                    final imageUrl = lab.labImage != null && lab.labImage!.isNotEmpty
                        ? '$_imageBaseUrl${lab.labImage}' : null;
                    
                    print(lab.id);

                    double distanceKm = 0.0;
                    if (userLat != null && lab.latitude != null) {
                      distanceKm = Geolocator.distanceBetween(
                          userLat!, userLng!,
                          double.parse(lab.latitude!), double.parse(lab.longnitude!)
                      ) / 1000;
                    }

                    return InkWell(
                      onTap: () {
                        // Determine the destination page based on isPackage flag
                        final Widget destinationPage = (widget.isPackage ?? false)
                            ? LabTestPackages(labId: lab.id, labName: lab.labName) // Pass lab info if needed
                            : LabTestListPage(labId: lab.id, labName: lab.labName);

                        Navigator.of(context).push(
                          SlidePageRoute(page: destinationPage),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.grey.shade300, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabImage(imageUrl),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lab.labName, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                                  // DISPLAY COMPANY NAME HERE
                                  Text(
                                    "By $companyName",
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                  ),

                                  const SizedBox(height: 6),
                                  _buildDistanceBadge(distanceKm),
                                  const SizedBox(height: 6),
                                  Text("Email: ${lab.email ?? 'N/A'}", style: GoogleFonts.poppins(fontSize: 12)),
                                  Text("Phone: ${lab.phoneNo ?? 'N/A'}", style: GoogleFonts.poppins(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const LabShimmerLoading();
            },
          );
        },
      ),
      bottomNavigationBar: cartCount > 0 ? GoToCartBar(cartCount: cartCount) : null,
    );
  }

  // --- UI Helper Methods ---

  Widget _buildLabImage(String? imageUrl) {
    return Container(
      width: 100, height: 100,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null
            ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.business, size: 40, color: Colors.grey))
            : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      ),
    );
  }

  Widget _buildDistanceBadge(double distance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
      child: Text("${distance.toStringAsFixed(1)} KM away",
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.red)),
          ElevatedButton(onPressed: () => context.read<LabBloc>().add(FetchLabsEvent()), child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Text('No labs found within 50 KM.', style: GoogleFonts.poppins(fontSize: 16)),
    );
  }
}