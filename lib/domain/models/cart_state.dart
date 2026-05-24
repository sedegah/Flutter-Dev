import 'package:equatable/equatable.dart';
import '../entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();

  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object?> get props => [];
}

class CartUpdated extends CartState {
  final List<CartItem> items;
  final double totalPrice;
  final String? errorMessage;
  final bool isProcessing;

  const CartUpdated({
    required this.items,
    required this.totalPrice,
    this.errorMessage,
    this.isProcessing = false,
  });

  CartUpdated copyWith({
    List<CartItem>? items,
    double? totalPrice,
    String? errorMessage,
    bool? isProcessing,
  }) {
    return CartUpdated(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      errorMessage: errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  List<Object?> get props => [items, totalPrice, errorMessage, isProcessing];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
