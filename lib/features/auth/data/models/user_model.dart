// lib/features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.createdAt,
  });

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

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}