// lib/features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

// Data layer representation of the User entity with Firestore serialization logic
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.createdAt,
  });

  // Factory to create a model directly from authentication results
  factory UserModel.fromFirebaseUser(
    String uid,
    String email,
    DateTime createdAt,
  ) {
    return UserModel(
      id: uid,
      email: email,
      createdAt: createdAt,
    );
  }

  // Factory to parse a Firestore document snapshot into a strongly-typed model
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Converts the model instance into a Map suitable for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}