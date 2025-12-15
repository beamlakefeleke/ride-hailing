import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../config/environment.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/domain/usecases/social_login.dart';
import '../../features/auth/domain/usecases/complete_profile.dart';
import '../../features/auth/domain/usecases/check_phone.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/location/data/datasources/location_remote_data_source.dart';
import '../../features/location/data/datasources/location_local_data_source.dart';
import '../../features/location/data/repositories_impl/location_repository_impl.dart';
import '../../features/location/domain/repositories/location_repository.dart';
import '../../features/location/domain/usecases/search_locations.dart';
import '../../features/location/domain/usecases/get_recent_destinations.dart';
import '../../features/location/domain/usecases/get_saved_addresses.dart';
import '../../features/location/domain/usecases/save_address.dart';
import '../../features/location/domain/usecases/delete_saved_address.dart';
import '../../features/location/presentation/bloc/location_bloc.dart';
import '../../features/rides/data/datasources/ride_remote_data_source.dart';
import '../../features/rides/data/repositories_impl/ride_repository_impl.dart';
import '../../features/rides/domain/repositories/ride_repository.dart';
import '../../features/rides/domain/usecases/estimate_price.dart';
import '../../features/rides/domain/usecases/book_ride.dart';
import '../../features/rides/domain/usecases/get_ride.dart';
import '../../features/rides/domain/usecases/get_ride_history.dart';
import '../../features/rides/domain/usecases/cancel_ride.dart';
import '../../features/rides/presentation/bloc/ride_bloc.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';
import '../../features/activity/data/datasources/activity_remote_data_source.dart';
import '../../features/activity/data/repositories_impl/activity_repository_impl.dart';
import '../../features/activity/domain/repositories/activity_repository.dart';
import '../../features/activity/domain/usecases/get_ongoing_rides.dart';
import '../../features/activity/domain/usecases/get_scheduled_rides.dart';
import '../../features/activity/domain/usecases/get_completed_rides.dart';
import '../../features/activity/domain/usecases/get_cancelled_rides.dart';
import '../../features/activity/presentation/bloc/activity_bloc.dart';
import '../../features/account/data/datasources/account_remote_data_source.dart';
import '../../features/account/data/repositories_impl/account_repository_impl.dart';
import '../../features/account/domain/repositories/account_repository.dart';
import '../../features/account/domain/usecases/get_profile.dart';
import '../../features/account/domain/usecases/logout.dart';
import '../../features/account/domain/usecases/update_profile.dart';
import '../../features/account/presentation/bloc/account_bloc.dart';
import '../../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../../features/wallet/data/repositories_impl/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/wallet/domain/usecases/top_up.dart';
import '../../features/wallet/domain/usecases/get_transaction_history.dart';
import '../../features/wallet/domain/usecases/get_top_up_history.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/ratings/data/datasources/rating_remote_data_source.dart';
import '../../features/ratings/data/repositories_impl/rating_repository_impl.dart';
import '../../features/ratings/domain/repositories/rating_repository.dart';
import '../../features/ratings/domain/usecases/rate_ride.dart';
import '../../features/ratings/domain/usecases/get_ride_rating.dart';
import '../../features/ratings/presentation/bloc/rating_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      socialLoginUseCase: sl(),
      completeProfileUseCase: sl(),
      checkPhoneUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => SocialLogin(sl()));
  sl.registerLazySingleton(() => CompleteProfile(sl()));
  sl.registerLazySingleton(() => CheckPhone(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  //! Features - Location
  // Bloc
  sl.registerFactory(
    () => LocationBloc(
      searchLocations: sl(),
      getRecentDestinations: sl(),
      getSavedAddresses: sl(),
      saveAddress: sl(),
      deleteSavedAddress: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchLocations(sl()));
  sl.registerLazySingleton(() => GetRecentDestinations(sl()));
  sl.registerLazySingleton(() => GetSavedAddresses(sl()));
  sl.registerLazySingleton(() => SaveAddress(sl()));
  sl.registerLazySingleton(() => DeleteSavedAddress(sl()));

  // Repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(sl()),
  );

  //! Features - Rides
  // Bloc
  sl.registerFactory(
    () => RideBloc(
      estimatePrice: sl(),
      bookRide: sl(),
      getRide: sl(),
      getRideHistory: sl(),
      cancelRide: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => EstimatePrice(sl()));
  sl.registerLazySingleton(() => BookRide(sl()));
  sl.registerLazySingleton(() => GetRide(sl()));
  sl.registerLazySingleton(() => GetRideHistory(sl()));
  sl.registerLazySingleton(() => CancelRide(sl()));

  // Repository
  sl.registerLazySingleton<RideRepository>(
    () => RideRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RideRemoteDataSource>(
    () => RideRemoteDataSourceImpl(sl()),
  );

  //! Features - Payment
  // Bloc
  sl.registerFactory(() => PaymentBloc());

  //! Features - Activity
  // Bloc
  sl.registerFactory(
    () => ActivityBloc(
      getOngoingRides: sl(),
      getScheduledRides: sl(),
      getCompletedRides: sl(),
      getCancelledRides: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetOngoingRides(sl()));
  sl.registerLazySingleton(() => GetScheduledRides(sl()));
  sl.registerLazySingleton(() => GetCompletedRides(sl()));
  sl.registerLazySingleton(() => GetCancelledRides(sl()));

  // Repository
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(sl()),
  );

  //! Features - Account
  // Bloc
  sl.registerFactory(
    () => AccountBloc(
      getProfile: sl(),
      logout: sl(),
      updateProfile: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  // Repository
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(sl()),
  );

  //! Features - Wallet
  // Bloc
  sl.registerFactory(
    () => WalletBloc(
      topUp: sl(),
      getTransactionHistory: sl(),
      getTopUpHistory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => TopUp(sl()));
  sl.registerLazySingleton(() => GetTransactionHistory(sl()));
  sl.registerLazySingleton(() => GetTopUpHistory(sl()));

  // Repository
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(sl()),
  );

  //! Features - Ratings
  // Bloc
  sl.registerFactory(
    () => RatingBloc(
      rateRide: sl(),
      getRideRating: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RateRide(sl()));
  sl.registerLazySingleton(() => GetRideRating(sl()));

  // Repository
  sl.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RatingRemoteDataSource>(
    () => RatingRemoteDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton(() => ApiClient(baseUrl: Environment.apiBaseUrl));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
}

