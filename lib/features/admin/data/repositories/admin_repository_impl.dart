import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../auth/domain/models/user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseFirestore _firestore;

  AdminRepositoryImpl(this._firestore);

  @override
  Stream<List<UserModel>> getPendingTeachers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .snapshots()
        .asyncMap((snapshot) async {
          List<UserModel> pending = [];
          for (var doc in snapshot.docs) {
            final teacherDoc = await _firestore.collection('teachers').doc(doc.id).get();
            if (teacherDoc.exists && teacherDoc.data()?['isApproved'] == false) {
              pending.add(UserModel.fromMap(doc.data(), doc.id));
            }
          }
          return pending;
        });
  }

  @override
  Future<void> approveTeacher(String teacherId) async {
    await _firestore.collection('teachers').doc(teacherId).update({
      'isApproved': true,
    });
  }

  @override
  Stream<List<UserModel>> getAllStudents() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
