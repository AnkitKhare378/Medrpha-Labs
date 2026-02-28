import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/payment_method_service/payment_service.dart';
import '../../../models/LabM/lab_model.dart';
import '../../../models/device_product.dart';
import '../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../view_model/CartVM/get_cart_view_model.dart';
import '../../../view_model/LabVM/AllLab/lab_bloc.dart';
import '../../../view_model/LabVM/AllLab/lab_event.dart';
import '../../../view_model/LabVM/AllLab/lab_state.dart';
import '../../../view_model/PaymentVM/payment_cubit.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../HomeScreen/pages/select_address_page.dart';
import 'store/cart_notifier.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/cart_header.dart';
import 'widgets/cart_product_card.dart';
import 'widgets/coupon_widget.dart';
import 'widgets/empty_cart_section.dart';
import 'widgets/payment_details_card.dart';
import '../../../../view_model/AddressVM/GetUserAddress/get_address_view_model.dart';
import 'widgets/slot_card.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  String selectedAddress = 'Please add address to continue';
  int selectedAddressId = 0;
  int selectedAddressTypeId = 0;
  int? userId;
  double couponDiscount = 0.0;
  String appliedCouponCode = "";
  bool isSlotEmpty = false;
  bool isOutOfRange = false;
  double? selectedLat;
  double? selectedLng;
  String? selectedAppointmentTime;
  String? selectedAppointmentDate;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchAddresses();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabBloc>().add(FetchLabsEvent());
    });
  }

  Future<void> _loadUserIdAndFetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');

    if (mounted) {
      setState(() { userId = id; });
      if (id != null) {
        context.read<GetCartBloc>().add(FetchCart(id));
        context.read<GetUserAddressBloc>().add(FetchUserAddresses(id.toString()));
      }
    }
  }

  String _formatAddress(Map<String, String> a) {
    final flat = a['flat']?.trim() ?? '';
    final street = a['street']?.trim() ?? '';
    final locality = a['locality']?.trim() ?? '';
    final pincode = a['pincode']?.trim() ?? '';
    List<String> parts = [];
    if (flat.isNotEmpty) parts.add(flat);
    if (street.isNotEmpty) parts.add(street);
    if (locality.isNotEmpty) parts.add(locality);
    if (pincode.isNotEmpty) parts.add(pincode);
    return parts.isNotEmpty ? parts.join(', ') : 'Address details incomplete.';
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAddressRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              label.contains("Pickup") ? Icons.biotech_outlined : Icons.local_shipping_outlined,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
                  Text(
                    selectedAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context).push(SlidePageRoute(page: const SelectAddressPage()));
                if (result != null && mounted) {
                  setState(() {
                    selectedAddress = result['address']!;
                    selectedAddressId = result['addressId']!;
                    selectedAddressTypeId = result['addressTypeId'];
                    selectedLat = double.tryParse(result['lat']?.toString() ?? '');
                    selectedLng = double.tryParse(result['lng']?.toString() ?? '');
                  });
                  final lat = result['lat'];
                  final lng = result['lng'];

                  print("------------------------------------------");
                  print("SELECTED ADDRESS COORDINATES:");
                  print("Latitude: $lat");
                  print("Longitude: $lng");
                  print("------------------------------------------");
                }
              },
              child: Text("Change", style: GoogleFonts.poppins(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(context.read<PaymentService>())..fetchPaymentMethods(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetCartBloc, GetCartState>(
            listener: (context, state) {
              if (state is GetCartLoaded) {
                context.read<CartProvider>().setCartDataFromApi(state.cart);
              } else if (state is GetCartEmpty) {
                context.read<CartProvider>().clearCartAfterOrder();
              }
            },
          ),
          // Listener to automatically select the first address from the list
          BlocListener<GetUserAddressBloc, GetUserAddressState>(
            listener: (context, addrState) {
              if (addrState is GetUserAddressLoaded && addrState.addresses.isNotEmpty) {
                final addr = addrState.addresses.first;
                setState(() {
                  selectedAddress = _formatAddress(addr.toDisplayMap());
                  selectedAddressId = addr.id;
                  selectedAddressTypeId = addr.addressTypeId;
                  selectedLat = double.tryParse(addr.latitude ?? '');
                  selectedLng = double.tryParse(addr.longitude ?? '');
                });
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CartHeader(onBack: () {
            context.read<DashboardBloc>().add(DashboardTabChanged(0));
            Navigator.of(context).popUntil((route) => route.isFirst);
          }),
          body: BlocBuilder<GetCartBloc, GetCartState>(
            builder: (context, cartState) {
              if (cartState is GetCartLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Wrap with LabBloc builder to access lab coordinates
              return BlocBuilder<LabBloc, LabState>(
                builder: (context, labState) {
                  // 1. Reset the local flag for this specific build cycle
                  bool detectedOutOfRange = false;

                  if (cartState is GetCartLoaded && labState is LabLoaded) {
                    for (var item in cartState.cart.items) {
                      final matchingLab = labState.labs.firstWhere(
                            (lab) => lab.id == item.storeId,
                        orElse: () => LabModel(id: -1, labName: ''),
                      );

                      if (matchingLab.id != -1 && selectedLat != null && selectedLng != null) {
                        double labLat = double.tryParse(matchingLab.latitude ?? '0') ?? 0;
                        double labLng = double.tryParse(matchingLab.longnitude ?? '0') ?? 0;

                        double distanceInMeters = Geolocator.distanceBetween(
                          selectedLat!,
                          selectedLng!,
                          labLat,
                          labLng,
                        );

                        double distanceInKm = distanceInMeters / 1000;

                        // 2. Check threshold
                        if (distanceInKm > 50.0) {
                          detectedOutOfRange = true;

                          // 3. Show SnackBar only if we are transitioning from "In Range" to "Out of Range"
                          if (!isOutOfRange) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${item.itemName} is too far from your selected location.",
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            });
                          }
                        }
                      }
                    }
                  }

                  // 4. Sync the global state variable with the detected build status
                  if (isOutOfRange != detectedOutOfRange) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isOutOfRange = detectedOutOfRange;
                      });
                    });
                  }

                  final cart = context.watch<CartProvider>();
                  if (cart.items.isEmpty) return const EmptyCartSection();

                  final Map<int, List<CartItem>> groupedItems = {};
                  for (var item in cart.items.values) {
                    groupedItems.putIfAbsent(item.categoryId, () => []).add(item);
                  }

                  final List<Widget> cartWidgets = [];
                  final sortedCategoryIds = groupedItems.keys.toList()..sort();
                  final bool hasServicesInCart = groupedItems.containsKey(2);
                  final bool needsSlot = groupedItems.containsKey(2) || groupedItems.containsKey(3);

                  for (final catId in sortedCategoryIds) {
                    final items = groupedItems[catId]!;
                    if (items.isEmpty) continue;

                    final titles = {1: "Products", 2: "Services", 3: "Packages"};
                    cartWidgets.add(_buildSectionHeading(titles[catId] ?? "Category $catId"));
                    cartWidgets.add(const Divider(height: 1));

                    for (final item in items) {
                      cartWidgets.add(CartProductCard(
                        product: DeviceProduct(
                          name: item.name,
                          imageUrl: "${ApiConstants.testImageBaseUrl}${item.image}",
                          originalPrice: item.originalPrice,
                          discountedPrice: item.discountedPrice,
                          discountPercentage: '',
                          category: '',
                          isSaved: false,
                        ),
                      ));
                    }

                    if (catId == 1) {
                      cartWidgets.add(_buildAddressRow("Delivering to"));
                    } else if (catId == 2) {
                      cartWidgets.add(_buildAddressRow("Pickup from"));
                    }
                  }

                  return Column(
                    children: [
                      // 5. Warning Banner if items are out of range
                      if (isOutOfRange)
                        Container(
                          width: double.infinity,
                          color: Colors.red.shade50,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Items are not available at this location.",
                                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            ...cartWidgets,
                            if (needsSlot && cartState is GetCartLoaded)
                              Builder(
                                builder: (context) {
                                  final serviceItem = cartState.cart.items.firstWhere(
                                        (item) => item.categoryId == 2 || item.categoryId == 3,
                                    orElse: () => cartState.cart.items.first,
                                  );
                                  if (serviceItem.storeId != null && serviceItem.storeId != 0) {
                                    return SlotCard(
                                      forOrder: false,
                                      storeId: serviceItem.storeId!,
                                      onAvailabilityChanged: (isEmpty) {
                                        if (isSlotEmpty != isEmpty) {
                                          setState(() {
                                            isSlotEmpty = isEmpty;
                                          });
                                        }
                                      },

                                      onDateSelected: (formattedDate) {
                                        setState(() {
                                          selectedAppointmentDate = formattedDate;
                                        });

                                        print("------------------------------------------");
                                        print("SELECTED APPOINTMENT DATE: $formattedDate");
                                        print("------------------------------------------");
                                      },
                                      // Capture the time and format it as HH:mm:ss
                                      onTimeSelected: (formattedTime) {
                                        setState(() {
                                          // If formattedTime is "14:00", we ensure it becomes "14:00:00"
                                          selectedAppointmentTime = formattedTime.contains(':00:00')
                                              ? formattedTime
                                              : "$formattedTime:00";
                                        });

                                        // Printing the selected time in the requested format
                                        print("------------------------------------------");
                                        print("SELECTED APPOINTMENT TIME: $selectedAppointmentTime");
                                        print("------------------------------------------");
                                      },


                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            const SizedBox(height: 8),
                            CouponWidget(
                              onApplied: (code, discount) {
                                setState(() {
                                  appliedCouponCode = code;
                                  couponDiscount = discount;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            const PaymentDetailsCard(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                      CartBottomBar(
                        userId: userId ?? 0,
                        cartId: cart.apiCartId,
                        subTotal: cart.totalAmount,
                        discountAmount: cart.totalDiscount + couponDiscount,
                        totalAmount: cart.totalPayable - couponDiscount,
                        deliveryAddress: selectedAddress,
                        selectedAddressId: selectedAddressId,
                        selectedAddressTypeId: selectedAddressTypeId,
                        isSlotEmpty: isSlotEmpty,
                        isOutOfRange: isOutOfRange, slotTime: selectedAppointmentTime ?? "", slotDate: selectedAppointmentDate ?? "", // Correctly passing the validated state
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}