// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';                   // ✅ provider
// import '../../../../config/routes/routes_name.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../models/device_product.dart';
// import '../../CartScreen/store/cart_notifier.dart';
// import '../fixed_app_bar.dart';
// import 'list/device_products_data.dart';
// import 'widgets/horizontal_product_list.dart';
// import 'widgets/category_grid.dart';
// import '../../HomeScreen/pages/widgets/section_header.dart';
//
// class DevicePage extends StatelessWidget {
//   final String categoryName;
//
//   const DevicePage({super.key, required this.categoryName});
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceProducts = deviceProductsData;
//     final cartCount = context.watch<CartProvider>().totalCount;
//
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Column(
//         children: [
//           const FixedAppBar(),
//
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   SectionHeader(title: 'Medrpha $categoryName Store'),
//                   const SizedBox(height: 16),
//
//                   HorizontalProductList(
//                     category: 'store',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Blood Glucose Monitor & Strips'),
//                   const SizedBox(height: 16),
//                   HorizontalProductList(
//                     category: 'glucose',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Blood Pressure Monitors'),
//                   const SizedBox(height: 16),
//                   HorizontalProductList(
//                     category: 'bp',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Shop By Category'),
//                   CategoryGrid(allProducts: deviceProducts),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Orthopedic Support'),
//                   const SizedBox(height: 16),
//                   HorizontalProductList(
//                     category: 'orthopedic',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Oximeters'),
//                   const SizedBox(height: 16),
//                   HorizontalProductList(
//                     category: 'oximeter',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Search & Filter'),
//                   const SizedBox(height: 16),
//                   HorizontalProductList(
//                     category: 'search',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                   const SectionHeader(title: 'Weighing Scale'),
//                   const SizedBox(height: 16),
//                   HorizontalProductList(
//                     category: 'scale',
//                     allProducts: deviceProducts,
//                   ),
//
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//
//       // ✅ Floating bottom bar shows only if there are items in cart
//       bottomNavigationBar: cartCount > 0
//           ? Container(
//         margin: const EdgeInsets.all(16),
//         padding:
//         const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//         decoration: BoxDecoration(
//           color: AppColors.primaryColor,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '$cartCount item${cartCount > 1 ? 's' : ''} in cart',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: AppColors.primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 onPressed: () =>
//                     Navigator.pushNamed(context, RoutesName.cartScreen),
//                 child: Text(
//                   'Go to Cart',
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//           : null,
//     );
//   }
// }
