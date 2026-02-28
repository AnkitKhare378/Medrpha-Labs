import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/banner_shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../data/repositories/all_banner_service/get_all_banner_service.dart';
import '../../../../view_model/BannerVM/get_all_banner_view_model.dart';

const String _imageHostUrl = 'https://www.online-tech.in/BannerImage/';

class AdvBanner extends StatefulWidget {
  const AdvBanner({super.key});

  @override
  State<AdvBanner> createState() => _AdvBannerState();
}

class _AdvBannerState extends State<AdvBanner> {
  final PageController _controller = PageController();
  late GetAllBannerBloc _bannerBloc;

  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _bannerBloc = GetAllBannerBloc(GetAllBannerService())..add(const FetchBanners());
  }

  void _startAutoSlide(int totalPages) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        if (_currentPage < totalPages - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _bannerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bannerBloc,
      child: BlocConsumer<GetAllBannerBloc, GetAllBannerState>(
        listener: (context, state) {
          if (state is GetAllBannerLoaded) {
            // Filter list to count only valid items for Category 1
            final filteredCount = state.banners
                .where((b) => b.bannerCategoryId == 3 && b.image != null && b.image!.isNotEmpty)
                .length;

            if (filteredCount > 0) {
              _startAutoSlide(filteredCount);
            }
          }
        },
        builder: (context, state) {
          if (state is GetAllBannerLoading) {
            return const SizedBox(
              height: 180,
              child: Center(child: BannerShimmer()),
            );
          }

          if (state is GetAllBannerError) {
            return const SizedBox.shrink();
          }

          if (state is GetAllBannerLoaded) {
            // Apply filtering: ONLY Category 1 AND non-null images
            final List<String> bannerImageUrls = state.banners
                .where((b) =>
            b.bannerCategoryId == 3 &&
                b.image != null &&
                b.image!.isNotEmpty
            )
                .map((b) => Uri.encodeFull('$_imageHostUrl${b.image}'))
                .toList();

            if (bannerImageUrls.isEmpty) return const SizedBox.shrink();

            return Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: bannerImageUrls.length,
                    onPageChanged: (index) {
                      _currentPage = index;
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            bannerImageUrls[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              );
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
                  count: bannerImageUrls.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}