// file: lib/pages/cart/my_cart_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ---------------------------------------------------------------f

import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/payment_method_service/payment_service.dart';
import '../../../models/device_product.dart';
import '../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../view_model/CartVM/get_cart_view_model.dart';
import '../../../view_model/PaymentVM/payment_cubit.dart';
import '../../../view_model/PaymentVM/payment_state.dart';
import '../../Dashboard/widgets/slide_page_route.dart';
import '../HomeScreen/pages/select_address_page.dart';
import 'store/cart_notifier.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/cart_header.dart';
import 'widgets/cart_product_card.dart';
import 'widgets/empty_cart_section.dart';
import 'widgets/payment_details_card.dart';
import '../../../../view_model/AddressVM/GetUserAddress/get_address_view_model.dart';
import '../../../../models/AddressM/get_address_model.dart';
import 'widgets/slot_card.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  String selectedAddress = 'Fetching default address...';
  int selectedAddressId = 0;
  int selectedAddressTypeId = 0;

  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchAddresses();
  }

  Future<void> _loadUserIdAndFetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    print(id);

    if (mounted) {
      setState(() {
        userId = id;
      });

      if (id != null) {
        // 1. 🚀 Trigger BLoC to fetch cart data from API
        context.read<GetCartBloc>().add(FetchCart(id));

        // 2. Trigger fetching user addresses
        context.read<GetUserAddressBloc>().add(FetchUserAddresses(id.toString()));
      } else {
        setState(() {
          selectedAddress = 'Please log in to select an address.';
        });
      }
    }
  }

  // Utility to format address (copied from SelectAddressPage)
  String _formatAddress(Map<String, String> a) {
    final flat = a['flat']?.trim() ?? '';
    final street = a['street']?.trim() ?? '';
    final locality = a['locality']?.trim() ?? '';
    final pincode = a['pincode']?.trim() ?? '';

    // 1. Start with flat and street, separated by comma and newline
    String address = '';

    // Add flat (if present)
    if (flat.isNotEmpty) {
      address += flat;
    }

    // Add street, prefixed with comma or space if flat exists
    if (street.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ', ';
      }
      address += street;
    }

    // Add newline for locality/pincode
    if (locality.isNotEmpty || pincode.isNotEmpty) {
      address += ', ';
    }

    // Add locality (if present)
    if (locality.isNotEmpty) {
      address += locality;
    }

    // Add pincode, prefixed by separator
    if (pincode.isNotEmpty) {
      if (locality.isNotEmpty) {
        address += ' – '; // Separator
      }
      address += pincode;
    }

    // If the address is still empty after checks, provide a fallback
    return address.isNotEmpty ? address : 'Address details incomplete.';
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  final Map<int, String> categoryNames = {
    1: "Products",
    2: "Services",
    3: "Packages"
  };

  @override
  Widget build(BuildContext context) {
    // 3. 👂 Wrap with BlocListener for GetCartBloc to synchronize CartProvider
    return BlocListener<GetCartBloc, GetCartState>(
      listener: (context, state) {
        if (state is GetCartLoaded) {
          // 4. 🔄 On success, update the local CartProvider state
          context.read<CartProvider>().setCartDataFromApi(state.cart);
        } else if (state is GetCartEmpty) {
          // If the API explicitly returns an empty cart, clear the local one
          context.read<CartProvider>().clearCartAfterOrder();
        } else if (state is GetCartError) {
          // Handle error, e.g., show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load cart data: ${state.message}')),
          );
        }
      },
      child: BlocProvider(
        create: (context) => PaymentCubit(context.read<PaymentService>())..fetchPaymentMethods(),
        child: Builder(
          builder: (context) {
            final cart = context.watch<CartProvider>();
            final int cartId = cart.apiCartId;
            final totalAmount = cart.totalPayable;

            final groupedItems = cart.items.values.where((item) => item.qty > 0).fold<Map<int, List<CartItem>>>(
              {},
                  (map, item) {
                map.putIfAbsent(item.categoryId, () => []).add(item);
                return map;
              },
            );

            final List<Widget> cartWidgets = [];
            final sortedCategoryIds = groupedItems.keys.toList()..sort();

            // 🎯 Check if the 'Services' category (ID 2) is present in the cart
            final bool hasServicesInCart = groupedItems.containsKey(2);

            for (final categoryId in sortedCategoryIds) {
              final items = groupedItems[categoryId]!;
              final categoryTitle = categoryNames[categoryId] ?? "Category $categoryId";
              cartWidgets.add(_buildSectionHeading(categoryTitle));
              cartWidgets.add(const Divider(height: 1, thickness: 0.5));
              for (final item in items) {
                // Assuming CartItem has necessary product details
                final product = DeviceProduct(
                  name: item.name,
                  imageUrl: 'https://via.placeholder.com/150',
                  originalPrice: item.originalPrice,
                  discountedPrice: item.discountedPrice,
                  discountPercentage: '',
                  category: '',
                  isSaved: false,
                );
                cartWidgets.add(CartProductCard(product: product));
              }
            }

            return SafeArea(
              top: false,
              child: Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: CartHeader(
                  onBack: () {
                    context.read<DashboardBloc>().add(DashboardTabChanged(0));
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                // Show loading indicator if cart is being fetched initially
                body: BlocBuilder<GetCartBloc, GetCartState>(
                  // ❌ Removed buildWhen to ensure the builder reacts to loaded/empty states
                  builder: (context, state) {
                    // Show Loading indicator only if fetching data AND the local cart is empty
                    if (state is GetCartLoading && cart.items.isEmpty) {
                      return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                    }

                    // If not loading, or if loading finished and cart is empty, show EmptyCartSection
                    if (cart.items.isEmpty) {
                      return const EmptyCartSection();
                    }

                    // The rest of the logic relies on the CartProvider which is synced by the listener
                    return BlocListener<GetUserAddressBloc, GetUserAddressState>(
                      // Listen to address loading state to set the default address
                      listener: (context, state) {
                        if (state is GetUserAddressLoaded && state.addresses.isNotEmpty) {
                          final firstAddress = state.addresses.first;
                          final firstAddressid = firstAddress.id;
                          final firstAddressTypeid = firstAddress.addressTypeId;
                          final displayMap = firstAddress.toDisplayMap();
                          final formattedAddress = _formatAddress(displayMap);
                          print(formattedAddress);

                          // Set the first address as default
                          if (mounted) {
                            setState(() {
                              selectedAddress = formattedAddress;
                              selectedAddressId = firstAddressid;
                              selectedAddressTypeId = firstAddressid;
                            });
                          }
                        } else if (state is GetUserAddressLoaded && state.addresses.isEmpty) {
                          if (mounted) {
                            setState(() {
                              selectedAddress = 'No address found. Please add one.';
                            });
                          }
                        }
                      },
                      // Cart is not empty, display the ListView content
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          ...cartWidgets,

                          // 🎯 Conditionally display SlotCard only if Services are in cart
                          if (hasServicesInCart) ...[
                            const SizedBox(height: 5),
                            const SlotCard(),
                            const SizedBox(height: 5),
                          ],

                          const SizedBox(height: 8),
                          const PaymentDetailsCard(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  },
                ),
                bottomNavigationBar: cart.items.isEmpty
                    ? null
                    : CartBottomBar(
                  userId : userId ?? 0,
                  cartId: cartId,
                  // Using actual cart values
                  subTotal: 2, // You should calculate this from cart.items
                  discountAmount: 0, // You should calculate this from cart.items
                  totalAmount: totalAmount.toDouble(),
                  deliveryAddress: selectedAddress,
                  selectedAddressId : selectedAddressId,
                  selectedAddressTypeId : selectedAddressTypeId,
                  onChangeAddress: () async {
                    final result = await Navigator.of(context).push(
                      SlidePageRoute(page: const SelectAddressPage()),
                    );
                    if (result != null && mounted) {
                      setState(() {
                        selectedAddress = result['address']!;
                        selectedAddressId = result['addressId']!;
                        selectedAddressTypeId = result['addressTypeId'];
                      });
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}