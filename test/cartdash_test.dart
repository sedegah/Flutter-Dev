import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cartdash/domain/entities/cart_item.dart';
import 'package:cartdash/domain/models/cart_event.dart';
import 'package:cartdash/domain/models/cart_state.dart';
import 'package:cartdash/presentation/bloc/cart_bloc.dart';

void main() {
  group('CartDash MVP Tests', () {
    group('CartItem Tests', () {
      test('CartItem copyWith works correctly', () {
        final originalItem = const CartItem(
          id: '1',
          name: 'Test Item',
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
          price: 29.99,
        );

        // Update single property
        final updatedItem = originalItem.copyWith(quantity: 5);

        expect(updatedItem.id, equals('1'));
        expect(updatedItem.name, equals('Test Item'));
        expect(updatedItem.quantity, equals(5));
        expect(updatedItem.price, equals(29.99));
        expect(updatedItem.subtotal, equals(149.95));
        expect(originalItem.quantity, equals(2)); // Original unchanged
      });

      test('CartItem subtotal calculates correctly', () {
        final item = const CartItem(
          id: '1',
          name: 'Test Item',
          imageUrl: 'https://example.com/image.jpg',
          quantity: 3,
          price: 10.0,
        );

        expect(item.subtotal, equals(30.0));
      });

      test('CartItem equality works with Equatable', () {
        final item1 = const CartItem(
          id: '1',
          name: 'Test Item',
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
          price: 29.99,
        );

        final item2 = const CartItem(
          id: '1',
          name: 'Test Item',
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
          price: 29.99,
        );

        expect(item1, equals(item2));
      });
    });

    group('CartBloc Tests', () {
      late CartBloc cartBloc;
      late MockApiService mockApiService;

      setUp(() {
        mockApiService = MockApiService();
        cartBloc = CartBloc(apiService: mockApiService);
      });

      tearDown(() {
        cartBloc.close();
      });

      blocTest<CartBloc, CartState>(
        'CartBloc processes AddToCartEvent correctly',
        build: () => cartBloc,
        seed: () => const CartUpdated(items: [], totalPrice: 0.0),
        act: (bloc) {
          bloc.add(const AddToCartEvent(
            itemId: 'item1',
            name: 'Test Product',
            imageUrl: 'https://example.com/product.jpg',
            price: 19.99,
          ));
        },
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.isProcessing, 'isProcessing', true)
              .having((state) => state.items.length, 'items length', 1)
              .having(
                (state) => state.items[0].name,
                'item name',
                'Test Product',
              )
              .having((state) => state.items[0].quantity, 'quantity', 1)
              .having((state) => state.totalPrice, 'totalPrice', 19.99),
          isA<CartUpdated>()
              .having((state) => state.isProcessing, 'isProcessing', false)
              .having((state) => state.items.length, 'items length', 1)
              .having((state) => state.totalPrice, 'totalPrice', 19.99)
              .having((state) => state.errorMessage, 'errorMessage', null),
        ],
      );

      blocTest<CartBloc, CartState>(
        'CartBloc rolls back on API failure',
        build: () => cartBloc,
        seed: () => const CartUpdated(
          items: [
            CartItem(
              id: 'existing',
              name: 'Existing Item',
              imageUrl: 'https://example.com/existing.jpg',
              quantity: 1,
              price: 10.0,
            ),
          ],
          totalPrice: 10.0,
        ),
        act: (bloc) {
          mockApiService.setForceFailure(true);
          bloc.add(const AddToCartEvent(
            itemId: 'newitem',
            name: 'New Product',
            imageUrl: 'https://example.com/new.jpg',
            price: 25.0,
          ));
        },
        expect: () => [
          // Optimistic update
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 2)
              .having((state) => state.isProcessing, 'isProcessing', true),
          // Rollback on failure
          isA<CartUpdated>()
              .having((state) => state.items.length, 'rollback items length', 1)
              .having((state) => state.items[0].id, 'first item id', 'existing')
              .having((state) => state.totalPrice, 'rollback totalPrice', 10.0)
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Sorry, this item just sold out!',
              )
              .having((state) => state.isProcessing, 'isProcessing', false),
        ],
      );

      blocTest<CartBloc, CartState>(
        'CartBloc initializes cart correctly',
        build: () => cartBloc,
        act: (bloc) {
          bloc.add(const InitializeCartEvent());
        },
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 0)
              .having((state) => state.totalPrice, 'totalPrice', 0.0),
        ],
      );
    });
  });
}

// Mock implementation for testing
class MockApiService implements ApiService {
  @override
  final dio = null;

  bool _forceFailure = false;

  @override
  int networkLatencyMs = 0;

  @override
  bool forceFailure = false;

  void setForceFailure(bool value) {
    forceFailure = value;
  }

  @override
  Future<ApiResponse> reserveInventory(String itemId, int quantity) async {
    await Future.delayed(Duration(milliseconds: networkLatencyMs));

    if (forceFailure) {
      return ApiResponse(
        isSuccess: false,
        errorCode: 'OUT_OF_STOCK',
        errorMessage: 'Sorry, this item just sold out!',
      );
    }

    return ApiResponse(isSuccess: true);
  }

  @override
  Future<ApiResponse> removeFromInventory(String itemId) async {
    return ApiResponse(isSuccess: true);
  }
}
