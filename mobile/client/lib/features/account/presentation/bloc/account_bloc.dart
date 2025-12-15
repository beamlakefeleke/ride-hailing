import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/update_profile.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetProfile getProfile;
  final Logout logout;
  final UpdateProfile updateProfile;

  AccountBloc({
    required this.getProfile,
    required this.logout,
    required this.updateProfile,
  }) : super(AccountInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<LogoutEvent>(_onLogout);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    
    final result = await getProfile();
    
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    
    final result = await logout();
    
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (_) => emit(LoggedOut()),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    
    final result = await updateProfile(UpdateProfileParams(
      fullName: event.fullName,
      email: event.email,
      phoneNumber: event.phoneNumber,
      countryCode: event.countryCode,
      gender: event.gender,
      dateOfBirth: event.dateOfBirth,
      profileImageUrl: event.profileImageUrl,
    ));
    
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (user) => emit(ProfileUpdated(user)),
    );
  }
}

