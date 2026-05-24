import 'package:equatable/equatable.dart';
import '../entities/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class InitializeCartEvent extends CartEvent {
  const InitializeCartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final String itemId;
  final String name;
  final String imageUrl;
  final double price;

  const AddToCartEvent({
    required this.itemId,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  List<Object?> get props => [itemId, name, imageUrl, price];
}

class IncrementQuantityEvent extends CartEvent {
  final String itemId;

  const IncrementQuantityEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class DecrementQuantityEvent extends CartEvent {
  final String itemId;

  const DecrementQuantityEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;

  const RemoveFromCartEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearErrorEvent extends CartEvent {
  const ClearErrorEvent();

  @override
  List<Object?> get props => [];
}
