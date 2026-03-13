import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final userData = await getUserData(userCredential.user!.uid);
    if (userData == null) {
      throw Exception('User data not found');
    }
    return userData;
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      id: userCredential.user!.uid,
      name: name,
      email: email,
      role: role,
      createdAt: DateTime.now(),
    );

    // Save user to Firestore
    await _firestore.collection('users').doc(userModel.id).set(userModel.toMap());

    // Initialize role-specific documents
    if (role == 'teacher') {
      await _firestore.collection('teachers').doc(userModel.id).set({
        'subjects': [],
        'classes': [],
        'isApproved': false,
      });
    } else if (role == 'student') {
      await _firestore.collection('students').doc(userModel.id).set({
        'classId': '',
        'enrolledSubjects': [],
      });
    }

    return userModel;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
