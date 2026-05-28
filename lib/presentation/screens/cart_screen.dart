import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const CartScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> products = [
    {'id': '1',  'name': 'Wireless Headphones',  'price': 79.99,  'image': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400&q=80'},
    {'id': '2',  'name': 'Smart Watch',           'price': 199.99, 'image': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=400&q=80'},
    {'id': '3',  'name': 'USB-C Cable',           'price': 12.99,  'image': 'https://images.unsplash.com/photo-1563822249548-9a72b6353cd1?w=400&q=80'},
    {'id': '4',  'name': 'Phone Case',            'price': 24.99,  'image': 'https://images.unsplash.com/photo-1601784551146-ce0a660023ed?w=400&q=80'},
    {'id': '5',  'name': 'Screen Protector',      'price': 9.99,   'image': 'https://images.unsplash.com/photo-1605787020600-b9ebd5df1d07?w=400&q=80'},
    {'id': '6',  'name': 'Portable Charger',      'price': 34.99,  'image': 'https://images.unsplash.com/photo-1605248389231-03d9d4e85e8a?w=400&q=80'},
    {'id': '7',  'name': 'Bluetooth Speaker',     'price': 59.99,  'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&q=80'},
    {'id': '8',  'name': 'Phone Stand',           'price': 14.99,  'image': 'https://images.unsplash.com/photo-1616440347437-b1c73416efc2?w=400&q=80'},
    {'id': '9',  'name': 'Laptop Bag',            'price': 49.99,  'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&q=80'},
    {'id': '10', 'name': 'Wireless Mouse',        'price': 29.99,  'image': 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400&q=80'},
    {'id': '11', 'name': 'Mechanical Keyboard',   'price': 89.99,  'image': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&q=80'},
    {'id': '12', 'name': 'Desk Lamp',             'price': 39.99,  'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400&q=80'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const InitializeCartEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      const step = 180.0;
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _scrollController.animateTo(
          (_scrollController.offset + step).clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _scrollController.animateTo(
          (_scrollController.offset - step).clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final borderColor = isDark ? const Color(0xFF2E3B4E) : const Color(0xFFE2E8F0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'cartdash.',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -1.0, color: textColor),
        ),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded, size: 22), onPressed: () {}),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartUpdated && state.errorMessage != null) {
            showRollbackErrorBottomSheet(
              context,
              errorMessage: state.errorMessage!,
              onDismiss: () => context.read<CartBloc>().add(const ClearErrorEvent()),
            );
          }
        },
        child: Column(
          children: [
            DemoControlPanel(apiService: widget.apiService),
            Expanded(
              child: Focus(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: (node, event) {
                  _handleKeyEvent(event);
                  return KeyEventResult.ignored;
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final crossAxisCount = screenWidth > 900
                        ? 4
                        : screenWidth > 600
                            ? 3
                            : 2;
                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.80,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductGridItem(
                          product: product,
                          onAddToCart: () {
                            context.read<CartBloc>().add(AddToCartEvent(
                              itemId: product['id'],
                              name: product['name'],
                              imageUrl: product['image'],
                              price: product['price'],
                            ));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.items.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(top: BorderSide(color: borderColor, width: 1)),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          children: state.items.map((item) => CartItemCard(
                            item: item,
                            onIncrement: () => context.read<CartBloc>().add(IncrementQuantityEvent(item.id)),
                            onDecrement: () => context.read<CartBloc>().add(DecrementQuantityEvent(item.id)),
                            onRemove: () => context.read<CartBloc>().add(RemoveFromCartEvent(item.id)),
                            isProcessing: state.isProcessing,
                          )).toList(),
                        ),
                      ),
                    ),
                  FloatingCheckoutBar(
                    totalPrice: state.totalPrice,
                    itemCount: state.items.length,
                    onCheckout: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proceeding to checkout...'), behavior: SnackBarBehavior.floating),
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

class ProductGridItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductGridItem({Key? key, required this.product, required this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF2E3B4E) : const Color(0xFFE2E8F0);
    final textColor = theme.colorScheme.onSurface;
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final accentColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                product['image'],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(Icons.image_not_supported_outlined, color: subtextColor, size: 28),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product['name'],
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$${(product['price'] as double).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textColor),
            ),
            GestureDetector(
              onTap: onAddToCart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: accentColor, width: 1),
                ),
                child: Text(
                  'ADD',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: accentColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
