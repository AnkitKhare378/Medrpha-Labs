import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Add your image paths here
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Digital\nInventory",
      subtitle: "Track reagents, equipment, and supplies in real-time with automated low-stock alerts.",
      bgColor: const Color(0xFF1A36CC),
      textColor: Colors.white,
      imagePath: 'assets/images/onboard1.png',
    ),
    OnboardingData(
      title: "Sample\nManagement",
      subtitle: "Organize and track laboratory samples from collection to analysis with secure QR coding.",
      bgColor: Colors.white,
      textColor: const Color(0xFF1A36CC),
      imagePath: 'assets/images/onboard2.png',
    ),
    OnboardingData(
      title: "Data\nInsights",
      subtitle: "Generate comprehensive reports and visualize experimental results with precision.",
      bgColor: const Color(0xFFFDB03E),
      textColor: Colors.white,
      imagePath: 'assets/images/onboard3.png',
    ),
  ];

  void _onFinish() {
    Navigator.pushNamed(
      context,
      "login_screen", // Or RoutesName.loginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _pages[_currentPage].bgColor,
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (int page) => setState(() => _currentPage = page),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final data = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      // PERFORMANCE: RepaintBoundary prevents unneeded repaints
                      RepaintBoundary(
                        child: Center(
                          child: SizedBox(
                            height: 350,
                            child: Image.asset(
                              data.imagePath,
                              fit: BoxFit.contain,
                              // Precision tip: use cacheWidth/Height if images are large
                              // cacheWidth: 800,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        data.title,
                        style: GoogleFonts.poppins(
                          color: data.textColor,
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data.subtitle,
                        style: GoogleFonts.poppins(
                          color: data.textColor.withOpacity(0.8),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 60,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onFinish,
                    child: Text(
                      "Skip",
                      style: GoogleFonts.poppins(
                        color: _pages[_currentPage].textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildNextButton(),
                  _buildPageIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    bool isLast = _currentPage == _pages.length - 1;
    bool isDesignPage = _currentPage == 1;

    return GestureDetector(
      onTap: () {
        if (isLast) {
          _onFinish();
        } else {
          _controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: ShapeDecoration(
          color: isDesignPage ? const Color(0xFF1A36CC) : Colors.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isLast ? Icons.check : Icons.chevron_right,
            key: ValueKey<int>(_currentPage),
            color: isDesignPage ? Colors.white : const Color(0xFF1A36CC),
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pages.length, (index) {
        bool isSelected = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(left: 6),
          width: isSelected ? 14 : 6,
          height: 4,
          decoration: BoxDecoration(
            color: _pages[_currentPage].textColor.withOpacity(isSelected ? 1 : 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color textColor;
  final String imagePath; // Added imagePath field

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.textColor,
    required this.imagePath,
  });
}