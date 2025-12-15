import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WalletRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WalletTransaction>> topUp({
    required double amount,
    required String paymentMethod,
    String? paymentMethodDetails,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final transaction = await remoteDataSource.topUp(
          amount: amount,
          paymentMethod: paymentMethod,
          paymentMethodDetails: paymentMethodDetails,
        );
        return Right(transaction);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransaction>>> getTransactionHistory({
    int page = 0,
    int size = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final transactions = await remoteDataSource.getTransactionHistory(
          page: page,
          size: size,
        );
        return Right(transactions);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransaction>>> getTopUpHistory() async {
    if (await networkInfo.isConnected) {
      try {
        final transactions = await remoteDataSource.getTopUpHistory();
        return Right(transactions);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

