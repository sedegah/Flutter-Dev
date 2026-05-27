import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../../domain/models/cart_event.dart';
import '../../domain/models/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/floating_checkout_bar.dart';
import '../widgets/rollback_error_sheet.dart';
import '../widgets/demo_control_panel.dart';
import '../../data/services/api_service.dart';

class CartScreen extends StatefulWidget {
  final ApiService apiService;

  const CartScreen({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Wireless Headphones',
      'price': 79.99,
      'image': 'https://via.placeholder.com/150?text=Headphones',
    },
    {
      'id': '2',
      'name': 'Smart Watch',
      'price': 199.99,
      'image': 'https://via.placeholder.com/150?text=SmartWatch',
    },
    {
      'id': '3',
      'name': 'USB-C Cable',
      'price': 12.99,
      'image': 'https://via.placeholder.com/150?text=USB-C',
    },
    {
      'id': '4',
      'name': 'Phone Case',
      'price': 24.99,
      'image': 'https://via.placeholder.com/150?text=PhoneCase',
    },
    {
      'id': '5',
      'name': 'Screen Protector',
      'price': 9.99,
      'image': 'https://via.placeholder.com/150?text=Protector',
    },
    {
      'id': '6',
      'name': 'Portable Charger',
      'price': 34.99,
      'image': 'https://via.placeholder.com/150?text=Charger',
    },
    {
      'id': '7',
      'name': 'Bluetooth Speaker',
      'price': 59.99,
      'image': 'https://via.placeholder.com/150?text=Speaker',
    },
    {
      'id': '8',
      'name': 'Phone Stand',
      'price': 14.99,
      'image': 'https://via.placeholder.com/150?text=Stand',
    },
    {
      'id': '9',
      'name': 'Laptop Bag',
      'price': 49.99,
      'image': 'https://via.placeholder.com/150?text=Bag',
    },
    {
      'id': '10',
      'name': 'Wireless Mouse',
      'price': 29.99,
      'image': 'https://via.placeholder.com/150?text=Mouse',
    },
    {
      'id': '11',
      'name': 'USB Hub',
      'price': 19.99,
      'image': 'https://via.placeholder.com/150?text=Hub',
    },
    {
      'id': '12',
      'name': 'Keyboard',
      'price': 79.99,
      'image': 'https://via.placeholder.com/150?text=Keyboard',
    },
    {
      'id': '13',
      'name': 'Monitor Stand',
      'price': 44.99,
      'image': 'https://via.placeholder.com/150?text=Monitor',
    },
    {
      'id': '14',
      'name': 'Desk Lamp',
      'price': 39.99,
      'image': 'https://via.placeholder.com/150?text=Lamp',
    },
    {
      'id': '15',
      'name': 'Cable Organizer',
      'price': 11.99,
      'image': 'https://via.placeholder.com/150?text=Organizer',
    },
    {
      'id': '16',
      'name': 'Phone Tripod',
      'price': 17.99,
      'image': 'https://via.placeholder.com/150?text=Tripod',
    },
    {
      'id': '17',
      'name': 'Webcam',
      'price': 69.99,
      'image': 'https://via.placeholder.com/150?text=Webcam',
    },
    {
      'id': '18',
      'name': 'Microphone',
      'price': 89.99,
      'image': 'https://via.placeholder.com/150?text=Microphone',
    },
    {
      'id': '19',
      'name': 'Earbuds Case',
      'price': 9.99,
      'image': 'https://via.placeholder.com/150?text=Case',
    },
    {
      'id': '20',
      'name': 'Phone Strap',
      'price': 7.99,
      'image': 'https://via.placeholder.com/150?text=Strap',
    },
    {
      'id': '21',
      'name': 'Cooling Pad',
      'price': 39.99,
      'image': 'https://via.placeholder.com/150?text=Cooling',
    },
    {
      'id': '22',
      'name': 'Desktop Organizer',
      'price': 24.99,
      'image': 'https://via.placeholder.com/150?text=Desk',
    },
    {
      'id': '23',
      'name': 'Lightning Cable',
      'price': 14.99,
      'image': 'https://via.placeholder.com/150?text=Lightning',
    },
    {
      'id': '24',
      'name': 'HDMI Cable',
      'price': 9.99,
      'image': 'https://via.placeholder.com/150?text=HDMI',
    },
    {
      'id': '25',
      'name': 'Adapter Pack',
      'price': 19.99,
      'image': 'https://via.placeholder.com/150?text=Adapter',
    },
    {
      'id': '26',
      'name': 'Wireless Charger',
      'price': 29.99,
      'image': 'https://via.placeholder.com/150?text=Charger',
    },
    {
      'id': '27',
      'name': 'Phone Ring',
      'price': 8.99,
      'image': 'https://via.placeholder.com/150?text=Ring',
    },
    {
      'id': '28',
      'name': 'Car Phone Mount',
      'price': 16.99,
      'image': 'https://via.placeholder.com/150?text=Mount',
    },
    {
      'id': '29',
      'name': 'Tempered Glass',
      'price': 11.99,
      'image': 'https://via.placeholder.com/150?text=Glass',
    },
    {
      'id': '30',
      'name': 'Screen Cleaner',
      'price': 6.99,
      'image': 'https://via.placeholder.com/150?text=Cleaner',
    },
    {
      'id': '31',
      'name': 'SSD External',
      'price': 119.99,
      'image': 'https://via.placeholder.com/150?text=SSD',
    },
    {
      'id': '32',
      'name': 'USB Flash Drive',
      'price': 22.99,
      'image': 'https://via.placeholder.com/150?text=USB',
    },
    {
      'id': '33',
      'name': 'SD Card',
      'price': 24.99,
      'image': 'https://via.placeholder.com/150?text=SD',
    },
    {
      'id': '34',
      'name': 'Power Bank 10K',
      'price': 27.99,
      'image': 'https://via.placeholder.com/150?text=Bank',
    },
    {
      'id': '35',
      'name': 'Phone Lens',
      'price': 44.99,
      'image': 'https://via.placeholder.com/150?text=Lens',
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const InitializeCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CartDash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartUpdated && state.errorMessage != null) {
            showRollbackErrorBottomSheet(
              context,
              errorMessage: state.errorMessage!,
              onDismiss: () {
                context.read<CartBloc>().add(const ClearErrorEvent());
              },
            );
          }
        },
        child: Column(
          children: [
            // Demo Control Panel
            DemoControlPanel(apiService: widget.apiService),
            // Product List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductListItem(
                    product: product,
                    onAddToCart: () {
                      context.read<CartBloc>().add(
                            AddToCartEvent(
                              itemId: product['id'],
                              name: product['name'],
                              imageUrl: product['image'],
                              price: product['price'],
                            ),
                          );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cart Items Display
                  if (state.items.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                            color: isDark ? const Color(0xFF243046) : const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: state.items.map((item) {
                          return CartItemCard(
                            item: item,
                            onIncrement: () {
                              context.read<CartBloc>().add(
                                    IncrementQuantityEvent(item.id),
                                  );
                            },
                            onDecrement: () {
                              context.read<CartBloc>().add(
                                    DecrementQuantityEvent(item.id),
                                  );
                            },
                            onRemove: () {
                              context.read<CartBloc>().add(
                                    RemoveFromCartEvent(item.id),
                                  );
                            },
                            isProcessing: state.isProcessing,
                          );
                        }).toList(),
                      ),
                    ),
                  // Floating Checkout Bar
                  FloatingCheckoutBar(
                    totalPrice: state.totalPrice,
                    itemCount: state.items.length,
                    onCheckout: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proceeding to checkout...')),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Add to Cart Button
            ElevatedButton.icon(
              onPressed: onAddToCart,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
