import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Triggered on app startup to check if a user session already persists
class AuthCheckRequested extends AuthEvent {}

// Triggered when the user submits the sign-up form
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// Triggered when the user submits the login form
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// Triggered when the user clicks the logout button
class AuthLogoutRequested extends AuthEvent {}