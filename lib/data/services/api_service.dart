import 'package:dio/dio.dart';

class ApiResponse {
  final bool isSuccess;
  final String? errorCode;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    this.errorCode,
    this.errorMessage,
  });
}

class ApiService {
  final Dio dio;
  bool forceFailure = false;
  int networkLatencyMs = 1000;

  ApiService({Dio? dio}) : dio = dio ?? Dio();

  Future<ApiResponse> reserveInventory(String itemId, int quantity) async {
    try {
      await Future.delayed(Duration(milliseconds: networkLatencyMs));

      if (forceFailure) {
        return ApiResponse(
          isSuccess: false,
          errorCode: 'OUT_OF_STOCK',
          errorMessage: 'Sorry, this item just sold out!',
        );
      }

      return ApiResponse(isSuccess: true);
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> removeFromInventory(String itemId) async {
    try {
      await Future.delayed(Duration(milliseconds: networkLatencyMs));

      if (forceFailure) {
        return ApiResponse(
          isSuccess: false,
          errorCode: 'REMOVAL_FAILED',
          errorMessage: 'Could not remove item from cart.',
        );
      }

      return ApiResponse(isSuccess: true);
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: 'Network error: ${e.toString()}',
      );
    }
  }

  void setNetworkLatency(int milliseconds) {
    networkLatencyMs = milliseconds;
  }

  void setForceFailure(bool value) {
    forceFailure = value;
  }
}
