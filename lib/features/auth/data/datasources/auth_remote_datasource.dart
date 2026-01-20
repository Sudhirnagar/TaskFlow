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
      print("🔵 Starting Registration...");

      // 1. Create User in Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException('Registration failed');
      }

      final user = userCredential.user!;
      final now = DateTime.now();
      print("🟢 Auth Account Created! User ID: ${user.uid}");

      // 2. Store Data in Firestore (Yahan error aane ke high chance hain)
      print("🔵 Saving data to Firestore...");

      await firestore.collection('users').doc(user.uid).set({
        'email': email,
        'createdAt': Timestamp.fromDate(now),
        // 'userId': user.uid  <-- Agar rules mein resource.data.userId check kar rahe ho toh ye add karna padega
      });

      print("🟢 Firestore Write Success!");

      return UserModel.fromFirebaseUser(user.uid, email, now);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print("❌ Auth Error: ${e.code}");
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      // YAHAN HAI ASLI FIX:
      print("❌ CRITICAL SIGNUP ERROR: $e");

      // Screen par error dikhane ke liye:
      throw AuthException("Signup Error: $e");
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Auth Attempt
      print("🔵 Attempting Login...");
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException('Login failed');
      }

      final user = userCredential.user!;
      print("🟢 Auth Success! User ID: ${user.uid}");

      // 2. Firestore Fetch Attempt (Yahan failure ke high chance hain)
      print("🔵 Fetching Firestore Data...");
      final doc = await firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        print("🔴 User doc does not exist!");
        throw AuthException('User data not found');
      }

      print("🟢 Firestore Data Found: ${doc.data()}");

      // 3. Model Parsing (Agar data galat format mein hai toh yahan fat sakta hai)
      return UserModel.fromFirestore(doc);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print("❌ Auth Error: ${e.code}");
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e, stackTrace) {
      // YAHAN HAI ASLI FIX:
      print("❌ CRITICAL ERROR: $e");
      print(
          "Stack trace: $stackTrace"); // Ye batayega exactly kaunsi line fat rahi hai

      // Error message ko user ko dikhane ke liye pass karein
      throw AuthException("Technical Error: $e");
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

      final doc = await firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw AuthException('Failed to get current user');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
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
