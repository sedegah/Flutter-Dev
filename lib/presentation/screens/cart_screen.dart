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
    return Scaffold(
      appBar: AppBar(
        title: const Text('CartDash'),
        backgroundColor: Colors.green,
        elevation: 0,
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
                      color: Colors.grey[100],
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.shopping_bag, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Add to Cart Button
            ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
