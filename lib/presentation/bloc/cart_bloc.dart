import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/models/cart_event.dart';
import '../../domain/models/cart_state.dart';
import '../../data/services/api_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiService apiService;

  CartBloc({required this.apiService}) : super(const CartInitial()) {
    on<InitializeCartEvent>(_onInitialize);
    on<AddToCartEvent>(_onAddToCart);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearErrorEvent>(_onClearError);
  }

  Future<void> _onInitialize(
    InitializeCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartUpdated(items: [], totalPrice: 0.0));
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartUpdated) return;

    final currentState = state as CartUpdated;
    final previousItems = List<CartItem>.from(currentState.items);
    final previousTotal = currentState.totalPrice;

    final existingItemIndex =
        currentState.items.indexWhere((item) => item.id == event.itemId);

    List<CartItem> updatedItems;
    if (existingItemIndex >= 0) {
      updatedItems = List<CartItem>.from(currentState.items);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] =
          existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      updatedItems = [
        ...currentState.items,
        CartItem(
          id: event.itemId,
          name: event.name,
          imageUrl: event.imageUrl,
          quantity: 1,
          price: event.price,
        ),
      ];
    }

    final updatedTotal =
        updatedItems.fold(0.0, (sum, item) => sum + item.subtotal);

    emit(CartUpdated(
      items: updatedItems,
      totalPrice: updatedTotal,
      isProcessing: true,
    ));

    try {
      final response = await apiService.reserveInventory(event.itemId, 1);

      if (!response.isSuccess) {
        throw Exception(response.errorMessage ?? 'Failed to add item');
      }

      emit(CartUpdated(
        items: updatedItems,
        totalPrice: updatedTotal,
        isProcessing: false,
      ));
    } catch (e) {
      emit(CartUpdated(
        items: previousItems,
        totalPrice: previousTotal,
        errorMessage: 'Sorry, this item just sold out!',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartUpdated) return;

    final currentState = state as CartUpdated;
    final itemIndex =
        currentState.items.indexWhere((item) => item.id == event.itemId);

    if (itemIndex < 0) return;

    final previousItems = List<CartItem>.from(currentState.items);
    final previousTotal = currentState.totalPrice;

    final updatedItems = List<CartItem>.from(currentState.items);
    final item = updatedItems[itemIndex];
    updatedItems[itemIndex] = item.copyWith(quantity: item.quantity + 1);

    final updatedTotal =
        updatedItems.fold(0.0, (sum, item) => sum + item.subtotal);

    emit(CartUpdated(
      items: updatedItems,
      totalPrice: updatedTotal,
      isProcessing: true,
    ));

    try {
      final response =
          await apiService.reserveInventory(event.itemId, 1);

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      emit(CartUpdated(
        items: updatedItems,
        totalPrice: updatedTotal,
        isProcessing: false,
      ));
    } catch (e) {
      emit(CartUpdated(
        items: previousItems,
        totalPrice: previousTotal,
        errorMessage: 'Item quantity update failed!',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartUpdated) return;

    final currentState = state as CartUpdated;
    final itemIndex =
        currentState.items.indexWhere((item) => item.id == event.itemId);

    if (itemIndex < 0) return;

    final item = currentState.items[itemIndex];
    if (item.quantity <= 1) {
      add(RemoveFromCartEvent(event.itemId));
      return;
    }

    final previousItems = List<CartItem>.from(currentState.items);
    final previousTotal = currentState.totalPrice;

    final updatedItems = List<CartItem>.from(currentState.items);
    updatedItems[itemIndex] =
        item.copyWith(quantity: item.quantity - 1);

    final updatedTotal =
        updatedItems.fold(0.0, (sum, item) => sum + item.subtotal);

    emit(CartUpdated(
      items: updatedItems,
      totalPrice: updatedTotal,
      isProcessing: true,
    ));

    try {
      final response =
          await apiService.reserveInventory(event.itemId, 1);

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      emit(CartUpdated(
        items: updatedItems,
        totalPrice: updatedTotal,
        isProcessing: false,
      ));
    } catch (e) {
      emit(CartUpdated(
        items: previousItems,
        totalPrice: previousTotal,
        errorMessage: 'Item quantity update failed!',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartUpdated) return;

    final currentState = state as CartUpdated;
    final previousItems = List<CartItem>.from(currentState.items);
    final previousTotal = currentState.totalPrice;

    final updatedItems =
        currentState.items.where((item) => item.id != event.itemId).toList();

    final updatedTotal =
        updatedItems.fold(0.0, (sum, item) => sum + item.subtotal);

    emit(CartUpdated(
      items: updatedItems,
      totalPrice: updatedTotal,
      isProcessing: true,
    ));

    try {
      final response = await apiService.removeFromInventory(event.itemId);

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      emit(CartUpdated(
        items: updatedItems,
        totalPrice: updatedTotal,
        isProcessing: false,
      ));
    } catch (e) {
      emit(CartUpdated(
        items: previousItems,
        totalPrice: previousTotal,
        errorMessage: 'Item removal failed!',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartUpdated) {
      final currentState = state as CartUpdated;
      emit(CartUpdated(
        items: currentState.items,
        totalPrice: currentState.totalPrice,
        isProcessing: currentState.isProcessing,
      ));
    }
  }
}
