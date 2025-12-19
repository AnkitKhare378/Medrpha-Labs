// lib/main.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medrpha_labs/data/repositories/all_banner_service/get_all_banner_service.dart';
import 'package:medrpha_labs/data/repositories/blood_service/get_blood_service.dart';
import 'package:medrpha_labs/data/repositories/faq_service/get_frequently_service.dart';
import 'package:medrpha_labs/data/repositories/medicine_service/medicine_by_Id_service.dart';
import 'package:medrpha_labs/data/repositories/rating_service/rating_delete_service.dart';
import 'package:medrpha_labs/data/repositories/synonym_service/test_synonyms_service.dart';
import 'package:medrpha_labs/data/repositories/test_service/all_test_search.dart';
import 'package:medrpha_labs/models/MedicineM/get_medicine_by_company_service.dart';
import 'package:medrpha_labs/view_model/AddressVM/GetUserAddress/get_address_view_model.dart';
import 'package:medrpha_labs/view_model/BannerVM/get_all_banner_view_model.dart';
import 'package:medrpha_labs/view_model/BloodVM/get_blood_view_model.dart';
import 'package:medrpha_labs/view_model/FamilyMemberVM/get_family_members_view_model.dart';
import 'package:medrpha_labs/view_model/FamilyMemberVM/relation_cubit.dart';
import 'package:medrpha_labs/view_model/FaqVM/get_frequently_view_model.dart';
import 'package:medrpha_labs/view_model/MedicineVM/get_medicine_by_company_view_model.dart';
import 'package:medrpha_labs/view_model/MedicineVM/medicine_detail_view_model.dart';
import 'package:medrpha_labs/view_model/OrderVM/OrderHistory/order_history_bloc.dart';
import 'package:medrpha_labs/view_model/PaymentVM/payment_cubit.dart';
import 'package:medrpha_labs/view_model/RatingVM/insert_rating_view_model.dart';
import 'package:medrpha_labs/view_model/SynonymsVM/test_synonym_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repositories/address_service/address_delete_service.dart';
import 'data/repositories/cart_service/get_cart_service.dart';
import 'data/repositories/customer_service/customer_service.dart';
import 'data/repositories/customer_service/edit_profile_service.dart';
import 'data/repositories/family_member_service/family_member_delete_service.dart';
import 'data/repositories/family_member_service/family_member_update_service.dart';
import 'data/repositories/family_member_service/insert_family_member_service.dart';
import 'data/repositories/family_member_service/get_family_members_service.dart';
import 'data/repositories/family_member_service/relation_service.dart';
import 'package:medrpha_labs/view_model/FamilyMemberVM/UpdateFamilyMember/family_member_update_cubit.dart';
import 'data/repositories/lab_service/lab_service.dart'; // Import LabService
import 'data/repositories/lab_service/symptom_service.dart';
import 'data/repositories/order_service/order__history_service.dart';
import 'data/repositories/order_service/order_service.dart';
import 'data/repositories/package_service/package_service.dart';
import 'data/repositories/payment_method_service/payment_service.dart';
import 'data/repositories/rating_service/get_rating_service.dart';
import 'data/repositories/rating_service/insert_rating_service.dart';
import 'data/repositories/test_service/test_detail_service.dart';
import 'data/repositories/test_service/test_search_service.dart';
import 'data/repositories/test_service/test_service.dart';
import 'data/repositories/wallet_service/update_wallet_service.dart';
import 'data/repositories/wallet_service/wallet_service.dart';
import 'data/repositories/wishlist_service/get_wishlist_service.dart';
import 'firebase_options.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';

// 🟢 NEW IMPORTS FOR ADDRESS BLOCS AND SERVICE
import 'data/repositories/address_service/user_address_insert_service.dart';
import 'data/repositories/address_service/address_type_service.dart';
import 'data/repositories/address_service/get_user_address_service.dart';
import 'data/repositories/address_service/get_user_address_by_id_service.dart';
import 'data/repositories/address_service/user_address_update_service.dart';

// 🌟 REQUIRED IMPORTS
import 'view_model/AddressVM/DeleteAddress/delete_address_bloc.dart';
import 'view_model/AddressVM/UserAddressInsert/user_address_insert_bloc.dart';
import 'view_model/AddressVM/AddressType/address_type_view_model.dart';
import 'view_model/AddressVM/GetUserAddressById/get_user_address_by_id_view_model.dart';
import 'view_model/AddressVM/UserAddressUpdate/user_address_update_view_model.dart';
import 'view_model/CartVM/get_cart_view_model.dart';
import 'view_model/CustomerVM/customer_bloc.dart';
import 'view_model/CustomerVM/edit_profile_cubit.dart';
import 'view_model/FamilyMemberVM/DeleteFamilyMember/family_member_delete_cubit.dart';
import 'view_model/FamilyMemberVM/insert_family_member_view_model.dart';
// Existing Blocs
import 'pages/dashboard/bloc/categtory_bloc/category_bloc.dart';
import 'pages/dashboard/bloc/dashboard_event.dart';
import 'pages/login/bloc/login_bloc.dart';
import 'pages/otp/bloc/otp_bloc.dart';
import 'pages/splash/bloc/splash_bloc.dart';
import 'pages/dashboard/bloc/dashboard_bloc.dart';

// Providers
import 'view_model/LabVM/AllLab/lab_bloc.dart';
import 'view_model/LabVM/AllSymptoms/symptom_bloc.dart';
import 'view_model/OrderVM/CreateOrder/create_order_bloc.dart';
import 'view_model/PackageVM/package_bloc.dart';
import 'view_model/RatingVM/get_rating_view_model.dart';
import 'view_model/RatingVM/rating_delete_view_model.dart';
import 'view_model/TestVM/AllLabTest/lab_test_cubit.dart';
import 'view_model/TestVM/AllTestSearch/all_test_serach_model.dart';
import 'view_model/TestVM/TestDetail/test_detail_view_model.dart';
import 'view_model/TestVM/TestSearch/lab_test_search_cubit.dart';
import 'view_model/WalletVM/updateWallet/update_wallet_bloc.dart';
import 'view_model/WalletVM/wallet_bloc.dart';
import 'view_model/WishlistVM/get_wishlist_bloc.dart';
import 'view_model/provider/save_for_later_provider.dart';
import 'views/bottom_tabs/CartScreen/store/cart_notifier.dart';
import 'data/repositories/category_repository.dart';
import 'core/network/custom_http_overrides.dart';

const String _kFirstTimeKey = 'is_first_time';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late String startRoute;
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  final isFirstTime = prefs.getBool(_kFirstTimeKey) ?? true;

  if (isFirstTime) {
    startRoute = RoutesName.splashScreen;
    await prefs.setBool(_kFirstTimeKey, false);
  } else if (userId != null) {
    startRoute = RoutesName.dashboardScreen;
  } else {
    startRoute = RoutesName.loginScreen;
  }

  HttpOverrides.global = CustomHttpOverrides();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }
  } catch (e) {
    debugPrint('🔥 Firebase initialization error: $e');
  }

  final cartProvider = CartProvider();

  try {
    await cartProvider.load();
  } catch (e) {
    debugPrint('⚠️ CartProvider load error (Data Type Mismatch): $e');
  }

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepository(),
        ),
        // ⭐️ FIX: Register LabService here so it's available for LabBloc
        RepositoryProvider<LabService>(
          create: (_) => LabService(),
        ),

        // ✨ NEW: Register CustomerService Repository
        RepositoryProvider<CustomerService>(
          create: (_) => CustomerService(),
        ),

        // 🟢 Register Address Services as Repositories
        RepositoryProvider<UserAddressInsertService>(
          create: (_) => UserAddressInsertService(),
        ),
        RepositoryProvider<AddressTypeService>(
          create: (_) => AddressTypeService(),
        ),
        RepositoryProvider<GetUserAddressService>(
          create: (_) => GetUserAddressService(),
        ),
        RepositoryProvider<GetUserAddressByIdService>(
          create: (_) => GetUserAddressByIdService(),
        ),
        RepositoryProvider<UserAddressUpdateService>(
          create: (_) => UserAddressUpdateService(),
        ),
        // 👇 Register Family Member Services as Repositories
        RepositoryProvider<InsertFamilyMemberService>(
          create: (_) => InsertFamilyMemberService(),
        ),
        RepositoryProvider<GetFamilyMembersService>(
          create: (_) => GetFamilyMembersService(),
        ),
        RepositoryProvider<RelationService>(
          create: (_) => RelationService(),
        ),
        RepositoryProvider<FamilyMemberUpdateService>(
          create: (_) => FamilyMemberUpdateService(),
        ),
        RepositoryProvider<FamilyMemberDeleteService>(
          create: (_) => FamilyMemberDeleteService(),
        ),
        RepositoryProvider<TestService>(
          create: (_) => TestService(),
        ),
        RepositoryProvider<TestSearchService>(
          create: (_) => TestSearchService(),
        ),
        RepositoryProvider<SymptomService>(
          create: (_) => SymptomService(),
        ),
        RepositoryProvider<PaymentService>(
          create: (_) => PaymentService(),
        ),
        RepositoryProvider<EditProfileService>(
          create: (_) => EditProfileService(),
        ),
        RepositoryProvider<WalletService>(
          create: (_) => WalletService(),
        ),
        RepositoryProvider<GetWishlistService>(
          create: (_) => GetWishlistService(),
        ),
        RepositoryProvider<PackageService>(
          create: (_) => PackageService(),
        ),
        RepositoryProvider<OrderService>(
          create: (_) => OrderService(),
        ),
        RepositoryProvider<AllTestSearchService>(
          create: (_) => AllTestSearchService(),
        ),
        RepositoryProvider<TestDetailService>(
          create: (_) => TestDetailService(),
        ),
        RepositoryProvider<TestSynonymsService>(
          create: (_) => TestSynonymsService(),
        ),
        RepositoryProvider<InsertRatingService>(
          create: (_) => InsertRatingService(),
        ),
        RepositoryProvider<GetRatingService>(
          create: (_) => GetRatingService(),
        ),
        RepositoryProvider<RatingDeleteService>(
          create: (_) => RatingDeleteService(),
        ),
        RepositoryProvider<GetCartService>(
          create: (_) => GetCartService(),
        ),
        RepositoryProvider<GetAllBannerService>(
          create: (_) => GetAllBannerService(),
        ),
        RepositoryProvider<GetBloodGroupService>(
          create: (_) => GetBloodGroupService(),
        ),
        RepositoryProvider<FrequentlyService>(
          create: (_) => FrequentlyService(),
        ),
        RepositoryProvider<GetMedicineByCompanyService>(
          create: (_) => GetMedicineByCompanyService(),
        ),
        RepositoryProvider<MedicineService>(
          create: (_) => MedicineService(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ChangeNotifierProvider(
            create: (context) => SaveForLaterProvider(
              // CRITICAL FIX: Get the CartProvider instance from the context
              Provider.of<CartProvider>(context, listen: false),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => InsertFamilyMemberViewModel(),
          ),
        ],
        child: MyApp(initialRoute: startRoute),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => OtpBloc()),
        BlocProvider(create: (_) => DashboardBloc()..add(DashboardShowLabsDialog())),
        BlocProvider(create: (context) => CategoryBloc(context.read<CategoryRepository>())),

        BlocProvider<AllTestCubit>(
          create: (context) => AllTestCubit(
            context.read<TestService>(),
          ),
        ),

        BlocProvider<CustomerBloc>(
          create: (context) => CustomerBloc(
            context.read<CustomerService>(), // Inject the registered service
          ),
        ),

        BlocProvider<LabTestSearchCubit>(
          // Inject the TestService (TestService handles both AllTests and Search)
          create: (context) => LabTestSearchCubit(
            context.read<TestSearchService>(),
          ),
        ),

        // Address Blocs
        BlocProvider(
          create: (context) => AddressTypeBloc(
            service: context.read<AddressTypeService>(),
          )..add(FetchAddressTypes()),
        ),
        BlocProvider(
          create: (context) => UserAddressInsertBloc(
            service: context.read<UserAddressInsertService>(),
          ),
        ),
        BlocProvider(
          create: (context) => GetUserAddressBloc(
            service: context.read<GetUserAddressService>(),
          ),
        ),
        BlocProvider(
          create: (context) => GetUserAddressByIdBloc(
            service: context.read<GetUserAddressByIdService>(),
          ),
        ),
        BlocProvider(
          create: (context) => UserAddressUpdateBloc(
            service: context.read<UserAddressUpdateService>(),
          ),
        ),

        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(
            context.read<PaymentService>(), // Inject the registered service
          ),
        ),

        // 🌟 Lab Bloc now works because LabService is registered above in main()
        BlocProvider<LabBloc>(
          create: (context) => LabBloc(
            context.read<LabService>(),
          ),
        ),

        BlocProvider<SymptomBloc>(
          create: (context) => SymptomBloc(
            context.read<SymptomService>(), // Inject the SymptomService
          ),
        ),

        // Family Member Get Cubit
        BlocProvider(
          create: (context) => GetFamilyMembersCubit(
            service: context.read<GetFamilyMembersService>(),
          ),
        ),

        // Family Member Update Cubit
        BlocProvider(
          create: (context) => FamilyMemberUpdateCubit(
            service: context.read<FamilyMemberUpdateService>(),
          ),
        ),

        BlocProvider(
          create: (context) => FamilyMemberDeleteCubit(
            context.read<FamilyMemberDeleteService>(),
          ),
        ),

        // Relation Cubit
        BlocProvider(
          create: (context) => RelationCubit(
            service: context.read<RelationService>(),
          )..fetchRelations(),
        ),

        BlocProvider<DeleteAddressBloc>(
          create: (context) => DeleteAddressBloc(
            addressDeleteService: AddressDeleteService(),
          ),
        ),

        BlocProvider<EditProfileCubit>(
          create: (context) => EditProfileCubit(
            context.read<EditProfileService>(), // Inject the registered EditProfileService
          ),
        ),
        BlocProvider<WalletBloc>(
          create: (context) => WalletBloc(
            walletService: context.read<WalletService>(), // Inject the registered WalletService
          ),
        ),

        RepositoryProvider<UpdateWalletService>(
          create: (_) => UpdateWalletService(),
        ),

        BlocProvider<UpdateWalletViewModel>(
          create: (context) => UpdateWalletViewModel(
            context.read<UpdateWalletService>(),
          ),
        ),

        BlocProvider<GetWishlistBloc>(
          create: (context) => GetWishlistBloc(
            wishlistService: context.read<GetWishlistService>(), // Inject the registered WishlistService
          ),
        ),

        BlocProvider<PackageBloc>(
          create: (context) => PackageBloc()
            ..add(FetchPackages()), // Fetch data immediately
        ),

        BlocProvider<CreateOrderBloc>(
          create: (context) => CreateOrderBloc(
            context.read<OrderService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<OrderHistoryBloc>(
          create: (context) => OrderHistoryBloc(
            context.read<OrderHistoryService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<TestSearchBloc>(
          create: (context) => TestSearchBloc(
            context.read<AllTestSearchService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<TestDetailBloc>(
          create: (context) => TestDetailBloc(
            context.read<TestDetailService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<TestSynonymBloc>(
          create: (context) => TestSynonymBloc(
            context.read<TestSynonymsService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<InsertRatingCubit>(
          create: (context) => InsertRatingCubit(
            context.read<InsertRatingService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<GetRatingCubit>(
          create: (context) => GetRatingCubit(
            context.read<GetRatingService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<RatingDeleteCubit>(
          create: (context) => RatingDeleteCubit(
            context.read<RatingDeleteService>(), // Inject the registered OrderService
          ),
        ),

        BlocProvider<GetCartBloc>(
          create: (context) => GetCartBloc(
            context.read<GetCartService>(),
          ),
        ),

        BlocProvider<GetAllBannerBloc>(
          create: (context) => GetAllBannerBloc(
            context.read<GetAllBannerService>(),
          ),
        ),

        BlocProvider<GetBloodGroupBloc>(
          create: (context) => GetBloodGroupBloc(
            context.read<GetBloodGroupService>(),
          ),
        ),
        BlocProvider<FrequentlyBloc>(
          create: (context) => FrequentlyBloc(
            context.read<FrequentlyService>(),
          ),
        ),
        BlocProvider<GetMedicineByCompanyBloc>(
          create: (context) => GetMedicineByCompanyBloc(
            context.read<GetMedicineByCompanyService>(),
          ),
        ),
        BlocProvider<MedicineDetailCubit>(
          create: (context) => MedicineDetailCubit(
            context.read<MedicineService>(),
          ),
        ),

      ],
      child: MaterialApp(
        title: 'Medrpha Labs',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}