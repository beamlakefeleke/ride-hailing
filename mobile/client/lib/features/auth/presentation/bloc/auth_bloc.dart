import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/social_login.dart';
import '../../domain/usecases/complete_profile.dart';
import '../../domain/usecases/check_phone.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp sendOtpUseCase;
  final VerifyOtp verifyOtpUseCase;
  final SocialLogin socialLoginUseCase;
  final CompleteProfile completeProfileUseCase;
  final CheckPhone checkPhoneUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.socialLoginUseCase,
    required this.completeProfileUseCase,
    required this.checkPhoneUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SocialLoginEvent>(_onSocialLogin);
    on<CompleteProfileEvent>(_onCompleteProfile);
    on<CheckPhoneEvent>(_onCheckPhone);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(
      SendOtpParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const OtpSent('OTP sent successfully')),
    );
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(
      SendOtpParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const OtpResent('OTP resent successfully')),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        if (authResponse.requiresProfileCompletion) {
          emit(AuthSuccess(authResponse));
        } else {
          emit(AuthSuccess(authResponse));
        }
      },
    );
  }

  Future<void> _onSocialLogin(
    SocialLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await socialLoginUseCase(
      SocialLoginParams(
        provider: event.provider,
        providerId: event.providerId,
        email: event.email,
        fullName: event.fullName,
        profileImageUrl: event.profileImageUrl,
        accessToken: event.accessToken,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        if (authResponse.requiresProfileCompletion) {
          emit(AuthSuccess(authResponse));
        } else {
          emit(AuthSuccess(authResponse));
        }
      },
    );
  }

  Future<void> _onCompleteProfile(
    CompleteProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await completeProfileUseCase(
      CompleteProfileParams(
        fullName: event.fullName,
        email: event.email,
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) => emit(ProfileCompleted(authResponse)),
    );
  }

  Future<void> _onCheckPhone(
    CheckPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await checkPhoneUseCase(
      CheckPhoneParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (exists) => emit(PhoneChecked(exists)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthLoggedOut()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isAuthenticated = await authRepository.isAuthenticated();
    if (isAuthenticated) {
      final result = await authRepository.getCurrentUser();
      result.fold(
        (failure) => emit(AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user)),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }
}

