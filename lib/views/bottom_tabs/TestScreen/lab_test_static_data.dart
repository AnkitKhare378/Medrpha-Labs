import 'package:flutter/material.dart';

class LabTestStaticData {
  static const List<String> searchTexts = [
    'Blood Test, Diabetes',
    'Health Checkup',
    'Thyroid Test',
    'Liver Function',
    'Kidney Test',
  ];

  static final List<PopularTest> popularTests = [
    PopularTest(
      id: "1",
      name: "Complete Blood Count (CBC)",
      labName: "Redcliffe Lab",
      labsCount: "2 more labs",
      reportsIn: "24 Hours",
      price: "₹299.00",
      originalPrice: "₹450.00",
      discount: "34% OFF",
      iconUrl: "https://cdn-icons-png.flaticon.com/512/3103/3103477.png",
    ),
    PopularTest(
      id: "2",
      name: "HbA1C, Also known as Glycated Hemoglobin",
      labName: "Redcliffe Lab",
      labsCount: "2 more labs",
      reportsIn: "24 Hours",
      price: "₹299.00",
      originalPrice: "₹440.00",
      discount: "32% OFF",
      iconUrl: "https://cdn-icons-png.flaticon.com/512/2877/2877088.png",
    ),
  ];

  static final List<HealthConcernItem> healthConcerns = [
    HealthConcernItem(
      'Diabetes',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1739267697545.png?dpr=3',
      Color(0xFFE3F2FD),
    ),
    HealthConcernItem(
      'Heart Health',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1739268038106.png?dpr=3',
      Color(0xFFFCE4EC),
    ),
    HealthConcernItem(
      'Kidney Health',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1739268095055.png?dpr=3',
      Color(0xFFE8F5E8),
    ),
    HealthConcernItem(
      'Liver Health',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1739268186123.png?dpr=3',
      Color(0xFFFFF3E0),
    ),
    HealthConcernItem(
      'Thyroid',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1739268320325.png?dpr=3',
      Color(0xFFF3E5F5),
    ),
  ];

  static const List<String> carouselImages = [
    'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1752834027138.jpeg?dpr=3',
    'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1739270242893.jpeg?dpr=3',
    'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1755846661201.png?dpr=3',
    'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1755846616561.png?dpr=3',
  ];

  static final List<OfferItem> offers = [
    OfferItem(
      'Complete Blood Count',
      '₹299',
      '₹599',
      '50% OFF',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:1000/theme-image-1753427008583.png?dpr=3',
      Color(0xFFE3F2FD),
    ),
    OfferItem(
      'Diabetes Package',
      '₹449',
      '₹899',
      '50% OFF',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:1000/theme-image-1753427666000.jpeg?dpr=3',
      Color(0xFFFCE4EC),
    ),
    OfferItem(
      'Thyroid Profile',
      '₹699',
      '₹1399',
      '50% OFF',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:1000/theme-image-1753429164296.png?dpr=3',
      Color(0xFFF3E5F5),
    ),
    OfferItem(
      'Complete Blood Count',
      '₹299',
      '₹599',
      '50% OFF',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:1000/theme-image-1753427887395.png?dpr=3',
      Color(0xFFE3F2FD),
    ),
    OfferItem(
      'Complete Blood Count',
      '₹299',
      '₹599',
      '50% OFF',
      'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:1000/theme-image-1753429309521.jpeg?dpr=3',
      Color(0xFFE3F2FD),
    ),
  ];

  static final List<CheckupPlan> checkupPlans = [
    CheckupPlan(
      'Essential Health Checkup',
      '₹999',
      '₹2999',
      '67% OFF',
      '25 Tests Included',
      'https://via.placeholder.com/300x200/E3F2FD/1976D2?text=Essential+Plan',
      Color(0xFFE3F2FD),
    ),
    CheckupPlan(
      'Comprehensive Health Checkup',
      '₹1999',
      '₹4999',
      '60% OFF',
      '50 Tests Included',
      'https://via.placeholder.com/300x200/E8F5E8/4CAF50?text=Comprehensive+Plan',
      Color(0xFFE8F5E8),
    ),
    CheckupPlan(
      'Premium Health Checkup',
      '₹2999',
      '₹7999',
      '63% OFF',
      '75 Tests Included',
      'https://via.placeholder.com/300x200/FFF3E0/FF9800?text=Premium+Plan',
      Color(0x00fff3e0),
    ),
  ];

  static const List<String> planBanners = [
    "https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1747814937252.png?dpr=3",
    "https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1747814996564.png?dpr=3",
    "https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:500/theme-image-1747815042409.png?dpr=3",
  ];
}


// Data classes
class HealthConcernItem {
  final String name;
  final String imageUrl;
  final Color backgroundColor;

  HealthConcernItem(this.name, this.imageUrl, this.backgroundColor);
}

class OfferItem {
  final String name;
  final String discountedPrice;
  final String originalPrice;
  final String discount;
  final String imageUrl;
  final Color backgroundColor;

  OfferItem(
      this.name,
      this.discountedPrice,
      this.originalPrice,
      this.discount,
      this.imageUrl,
      this.backgroundColor,
      );
}

class CheckupPlan {
  final String name;
  final String discountedPrice;
  final String originalPrice;
  final String discount;
  final String testsIncluded;
  final String imageUrl;
  final Color backgroundColor;

  CheckupPlan(
      this.name,
      this.discountedPrice,
      this.originalPrice,
      this.discount,
      this.testsIncluded,
      this.imageUrl,
      this.backgroundColor,
      );
}

class PopularTest {
  final String id;
  final String name;
  final String labName;
  final String labsCount; // e.g. "2 more labs"
  final String reportsIn; // e.g. "24 Hours"
  final String price; // e.g. "₹299.00"
  final String originalPrice; // e.g. "₹450.00"
  final String discount; // e.g. "34% OFF"
  final String iconUrl; // network image url

  PopularTest({
    required this.id,
    required this.name,
    required this.labName,
    required this.labsCount,
    required this.reportsIn,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.iconUrl,
  });
}