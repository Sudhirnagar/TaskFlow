// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register(String email, String password);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      // Create user in Firebase Authentication
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) throw AuthException('Registration failed');

      final user = credential.user!;
      final now = DateTime.now();

      // Initialize user document in Firestore to store additional data
      await firestore.collection('users').doc(user.uid).set({
        'email': email,
        'createdAt': Timestamp.fromDate(now),
      });

      return UserModel.fromFirebaseUser(user.uid, email, now);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Authenticate with email and password
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) throw AuthException('Login failed');

      // Retrieve user profile data from Firestore
      final doc = await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) throw AuthException('User data not found');

      return UserModel.fromFirestore(doc);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Failed to logout');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;

      // Fetch fresh data from Firestore ensuring consistency
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw AuthException('Failed to get current user');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    // Map Firebase auth state changes to our app's UserModel via Firestore
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) return null;
        return UserModel.fromFirestore(doc);
      } catch (e) {
        return null;
      }
    });
  }

  // Helper method to map Firebase error codes to user-friendly messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'Authentication failed';
    }
  }
}