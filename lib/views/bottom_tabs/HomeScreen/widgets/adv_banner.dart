// adv_banner.dart (Combined with BLoC Logic)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/banner_shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../data/repositories/all_banner_service/get_all_banner_service.dart';
import '../../../../view_model/BannerVM/get_all_banner_view_model.dart';

const String _imageHostUrl = 'https://www.online-tech.in/uploads/';

class AdvBanner extends StatefulWidget {
  const AdvBanner({super.key});

  @override
  State<AdvBanner> createState() => _AdvBannerState();
}

class _AdvBannerState extends State<AdvBanner> {
  // Page controller remains for the PageView
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetAllBannerBloc>(
      create: (context) => GetAllBannerBloc(GetAllBannerService())
        ..add(const FetchBanners()),

      child: BlocBuilder<GetAllBannerBloc, GetAllBannerState>(
        builder: (context, state) {

          if (state is GetAllBannerLoading) {
            return const SizedBox(
              height: 180,
              child: Center(child: BannerShimmer()),
            );
          }

          // --- Handle Error State ---
          else if (state is GetAllBannerError) {
            // return Container(
            //   height: 180,
            //   color: Colors.red.shade100,
            //   padding: const EdgeInsets.all(16.0),
            //   child: Center(
            //     child: Text(
            //       'Error loading banners: ${state.message}',
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(color: Colors.red),
            //     ),
            //   ),
            // );
            return SizedBox(height: 0,);
          }

          // --- Handle Loaded State ---
          else if (state is GetAllBannerLoaded) {

            // Generate full URLs from the loaded model data
            final List<String> bannerImageUrls = state.banners
                .where((b) => b.image != null)
                .map((b) => '$_imageHostUrl${b.image}')
                .toList();

            if (bannerImageUrls.isEmpty) {
              return const SizedBox.shrink(); // Hide if no banners found
            }

            return Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: bannerImageUrls.length, // Use fetched count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            bannerImageUrls[index], // Use fetched URL
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error, color: Colors.grey));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SmoothPageIndicator(
                  controller: _controller,
                  count: bannerImageUrls.length, // Use fetched count
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
              ],
            );
          }

          // --- Handle Initial/Default State ---
          return const SizedBox.shrink();
        },
      ),
    );
  }
}