import 'package:equatable/equatable.dart';

// Core domain entity representing an authenticated user within the application
class User extends Equatable {
  // Immutable properties defining the user's unique identity and metadata
  final String id;
  final String email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  // Properties used to determine value equality between two User instances
  @override
  List<Object> get props => [id, email, createdAt];
}