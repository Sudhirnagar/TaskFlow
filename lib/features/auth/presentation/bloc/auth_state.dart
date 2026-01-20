// lib/features/auth/presentation/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state before any check or action has occurred
class AuthInitial extends AuthState {}

// State active while waiting for an API response (Login/Register/Check)
class AuthLoading extends AuthState {}

// State when a valid user session exists
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

// State when no user is logged in (Guest mode)
class AuthUnauthenticated extends AuthState {}

// State when an authentication attempt fails
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}