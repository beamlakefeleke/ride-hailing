import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class ProfileLoaded extends AccountState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class LoggedOut extends AccountState {}

class ProfileUpdated extends AccountState {
  final User user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}

