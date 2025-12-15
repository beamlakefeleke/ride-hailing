import '../../../../core/network/api_client.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletTransactionModel> topUp({
    required double amount,
    required String paymentMethod,
    String? paymentMethodDetails,
  });
  
  Future<List<WalletTransactionModel>> getTransactionHistory({
    int page = 0,
    int size = 20,
  });
  
  Future<List<WalletTransactionModel>> getTopUpHistory();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient apiClient;

  WalletRemoteDataSourceImpl(this.apiClient);

  @override
  Future<WalletTransactionModel> topUp({
    required double amount,
    required String paymentMethod,
    String? paymentMethodDetails,
  }) async {
    final response = await apiClient.post(
      '/api/wallet/top-up',
      data: {
        'amount': amount,
        'paymentMethod': paymentMethod,
        if (paymentMethodDetails != null) 'paymentMethodDetails': paymentMethodDetails,
      },
    );
    return WalletTransactionModel.fromJson(response);
  }

  @override
  Future<List<WalletTransactionModel>> getTransactionHistory({
    int page = 0,
    int size = 20,
  }) async {
    final response = await apiClient.get(
      '/api/wallet/transactions',
      queryParameters: {
        'page': page,
        'size': size,
      },
    );
    
    if (response is List) {
      return (response as List)
          .map((json) => WalletTransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    
    return [];
  }

  @override
  Future<List<WalletTransactionModel>> getTopUpHistory() async {
    final response = await apiClient.get('/api/wallet/top-ups');
    
    if (response is List) {
      return (response as List)
          .map((json) => WalletTransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    
    return [];
  }
}

