// import 'package:flutter/material.dart';
// import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/category_item.dart';
// import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/fixed_app_bar.dart';
// import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/popular_products.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '';
// import '../../../../core/constants/app_colors.dart';
// import '../category_page.dart';
// import '../sections/popular_brands_section.dart';
//
// class MedicinePage extends StatefulWidget {
//   const MedicinePage({super.key});
//
//   @override
//   _MedicinePageState createState() => _MedicinePageState();
// }
//
// class _MedicinePageState extends State<MedicinePage> {
//   final List<CategoryItem> bodyParts = [
//     CategoryItem(
//       'Liver Care',
//       'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1725615776827.png?dpr=3',
//       Color(0xFFE3F2FD),
//     ),
//     CategoryItem(
//       'Cardiac Care',
//       'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1725616214089.png?dpr=3',
//       Color(0xFFFCE4EC),
//     ),
//     CategoryItem(
//       'Hair Loss',
//       'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1725616509547.png?dpr=3',
//       Color(0xFFF3E5F5),
//     ),
//     CategoryItem(
//       'Kidney Care',
//       'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:125/theme-image-1725616509547.png?dpr=3',
//       Color(0xFFE8F5E8),
//     ),
//   ];
//
//   final List<HealthIssueItem> healthIssues = [
//     HealthIssueItem(
//       name: 'Bacterial Infection',
//       imageUrl:
//           'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:250/theme-image-1726064336870.png?dpr=3',
//       backgroundColor: Color(0xFFFFF3E0),
//     ),
//     HealthIssueItem(
//       name: 'Cough & Cold',
//       imageUrl:
//           'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:250/theme-image-1726064366781.png?dpr=3',
//       backgroundColor: Color(0xFFFCE4EC),
//     ),
//     HealthIssueItem(
//       name: 'Dandruff',
//       imageUrl:
//           'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:250/theme-image-1726064395165.png?dpr=3',
//       backgroundColor: Color(0xFFF3E5F5),
//     ),
//   ];
//
//   final List<ProductItem> bestSellerProducts = [
//     ProductItem(
//       name: 'Nivea Men Roll On Deodorant - Fresh Active',
//       imageUrl:
//           'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/KP8INZVsZo-nivea_men_roll_on_deodorant_fresh_active_25_ml_52990_0_5.jpg',
//       originalPrice: '₹192.00',
//       discountedPrice: '₹117.50',
//       discountPercentage: '39% OFF',
//       isSaved: false,
//     ),
//     ProductItem(
//       name: 'Nivea Anti Marks 5 in 1 Cream',
//       imageUrl:
//           'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/pictures/item/free/resize-w:180/agJPiB22GN-nivea_aloe_hydration_5_in_1_complete_care_body_lotion_all_skin_types_75_ml_523336_0_0.jpg',
//       originalPrice: '₹150.00',
//       discountedPrice: '₹111.00',
//       discountPercentage: '26% OFF',
//       isSaved: true,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Column(
//         children: [
//           // Fixed Header with Teal Color
//           FixedAppBar(),
//
//           // Scrollable Content
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//
//                   // Prescription Upload Section
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           offset: const Offset(0, 2),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             Icons.file_upload_outlined,
//                             color: Colors.red.shade400,
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'Order using prescription',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.textColor,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 6,
//                                       vertical: 2,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.orange.shade100,
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       '⚡',
//                                       style: GoogleFonts.poppins(fontSize: 10),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Upload prescription and we will help place order on your behalf.',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // Upload Prescription Button
//                   Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       child: Text(
//                         'Upload Prescription',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // No prescription and Call to order section
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.08),
//                                   offset: const Offset(0, 2),
//                                   blurRadius: 8,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: const BoxDecoration(
//                                         color: Colors.green,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'No prescription?',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: AppColors.textColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Search, add medicines & select FREE doctor consultation at checkout.',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.08),
//                                   offset: const Offset(0, 2),
//                                   blurRadius: 8,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: const BoxDecoration(
//                                         color: Colors.purple,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'Call to order',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: AppColors.textColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Directly call our customer support to place your order.',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Welcome Offer Banner
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF8E24AA), Color(0xFF673AB7)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.yellow.shade400,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   '#WelcomeOffer',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'First Order,\nFull Benefits',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Place your first order and get\nFlat 30% off on meds\nUp to 15% Value back\nFree Membership + Free Shipping',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 11,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.yellow.shade400,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   'Shop now',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Container(
//                           width: 110,
//                           height: 100,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               'https://img.freepik.com/free-vector/geometric-style-trendy-welcome-banner-corporate-hiring-event_1017-50041.jpg?semt=ais_hybrid&w=740&q=80',
//                               fit: BoxFit.cover,
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return _buildShimmerEffect(100, 100);
//                                   },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Paytm Cashback Banner
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColors.primaryColor.withOpacity(0.1),
//                           AppColors.primaryColor.withOpacity(0.05),
//                         ],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: AppColors.primaryColor.withOpacity(0.2),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Get up to Rs. 300',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.textColor,
//                                 ),
//                               ),
//                               Text(
//                                 'Paytm UPI Cashback',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   color: AppColors.textColor.withOpacity(0.8),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF00BCD4),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                               'paytm',
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // For Your Body Parts Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'For Your Body Parts',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textColor,
//                           ),
//                         ),
//                         Text(
//                           'View All',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.tealColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   SizedBox(
//                     height: 120,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: bodyParts.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(width: 16),
//                       itemBuilder: (context, index) {
//                         return buildCategoryItem(bodyParts[index], context);
//                       },
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   /* // Common Health Issues Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Common Health Issues',
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textColor,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   SizedBox(
//                     height: 120,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: healthIssues.length,
//                       separatorBuilder: (context, index) => const SizedBox(width: 16),
//                       itemBuilder: (context, index) {
//                         return _buildHealthIssueItem(healthIssues[index]);
//                       },
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),*/
//
//                   // Best Seller Section
//                   // Best Seller Section - Fixed
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(
//                       top: 20,
//                       bottom: 20,
//                     ), // Remove horizontal padding
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header section with proper padding
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.yellow.shade400,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(
//                                   Icons.military_tech,
//                                   color: Colors.red,
//                                   size: 20,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 'Best Seller',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             'Save from top selling Items',
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.white.withOpacity(0.8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // Products list with proper padding
//                         SizedBox(
//                           height: 216,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                             ), // Add padding here
//                             itemCount: bestSellerProducts.length,
//                             separatorBuilder: (context, index) =>
//                                 const SizedBox(width: 16),
//                             itemBuilder: (context, index) {
//                               return _buildBestSellerProduct(
//                                 bestSellerProducts[index],
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // Popular Brands Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Popular Brands',
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textColor,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   const PopularBrandsSection(),
//
//                   const SizedBox(height: 30),
//
//                   // Netmeds First Membership Section
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           offset: const Offset(0, 2),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 color: Colors.yellow.shade400,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.star,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Text(
//                               'Medrpha First Membership',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.purple.shade50,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.local_shipping,
//                                       color: Colors.purple,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Unlimited FREE delivery',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 10,
//                                       color: AppColors.textColor,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.pink.shade50,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.percent,
//                                       color: Colors.pink,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     '2% cashback on all orders',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 10,
//                                       color: AppColors.textColor,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue.shade50,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.support_agent,
//                                       color: Colors.blue,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Priority Support',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 10,
//                                       color: AppColors.textColor,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green.shade50,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.science,
//                                       color: Colors.green,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     '10% discount on lab tests',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 10,
//                                       color: AppColors.textColor,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Starting at just',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹99',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.textColor,
//                                     ),
//                                   ),
//                                   Text(
//                                     'for 3 months.',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primaryColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 24,
//                                   vertical: 12,
//                                 ),
//                               ),
//                               child: Text(
//                                 'View Plans',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHealthIssueItem(HealthIssueItem item) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: 90,
//         decoration: BoxDecoration(
//           color: item.backgroundColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               offset: const Offset(0, 2),
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Container(
//                 margin: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     item.imageUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return _buildShimmerEffect(
//                         double.infinity,
//                         double.infinity,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   item.name,
//                   style: GoogleFonts.poppins(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textColor,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBestSellerProduct(ProductItem product) {
//     return Container(
//       width: 140,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image section with bookmark
//           Stack(
//             children: [
//               Container(
//                 height: 100,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: Image.network(
//                     product.imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return _buildShimmerEffect(double.infinity, 100);
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         height: 100,
//                         width: double.infinity,
//                         color: Colors.grey.shade200,
//                         child: const Icon(
//                           Icons.image_not_supported,
//                           color: Colors.grey,
//                           size: 40,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       product.isSaved = !product.isSaved;
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Icon(
//                       product.isSaved ? Icons.bookmark : Icons.bookmark_border,
//                       color: product.isSaved
//                           ? AppColors.tealColor
//                           : Colors.grey,
//                       size: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Content section with fixed height
//           // Content section
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product name
//                   SizedBox(
//                     height: 32,
//                     child: Text(
//                       product.name,
//                       style: GoogleFonts.poppins(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.textColor,
//                         height: 1.2,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   // Price row
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Text(
//                           product.discountedPrice,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textColor,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Flexible(
//                         child: Text(
//                           product.originalPrice,
//                           style: GoogleFonts.poppins(
//                             fontSize: 9,
//                             color: Colors.grey,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   // Discount badge
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 4,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade50,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         product.discountPercentage,
//                         style: GoogleFonts.poppins(
//                           fontSize: 8,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   // Add button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 24,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle add to cart
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.tealColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         padding: EdgeInsets.zero,
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         'Add',
//                         style: GoogleFonts.poppins(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShimmerEffect(double width, double height) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
// }
//
// // Data classes
// class BodyPartItem {
//   final String name;
//   final String imageUrl;
//   final Color backgroundColor;
//
//   BodyPartItem({
//     required this.name,
//     required this.imageUrl,
//     required this.backgroundColor,
//   });
// }
//
// class HealthIssueItem {
//   final String name;
//   final String imageUrl;
//   final Color backgroundColor;
//
//   HealthIssueItem({
//     required this.name,
//     required this.imageUrl,
//     required this.backgroundColor,
//   });
// }
//
// class ProductItem {
//   final String name;
//   final String imageUrl;
//   final String originalPrice;
//   final String discountedPrice;
//   final String discountPercentage;
//   bool isSaved;
//
//   ProductItem({
//     required this.name,
//     required this.imageUrl,
//     required this.originalPrice,
//     required this.discountedPrice,
//     required this.discountPercentage,
//     required this.isSaved,
//   });
// }
