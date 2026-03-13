import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../teacher/domain/models/content_models.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final FirebaseFirestore _firestore;

  StudentRepositoryImpl(this._firestore);

  @override
  Stream<List<SubjectModel>> getSubjectsByClass(String classId) {
    return _firestore
        .collection('subjects')
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubjectModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> enrollInSubject(String studentId, String subjectId) async {
    await _firestore.collection('subscriptions').add({
      'studentId': studentId,
      'subjectId': subjectId,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    await _firestore.collection('students').doc(studentId).update({
      'enrolledSubjects': FieldValue.arrayUnion([subjectId]),
    });
  }

  @override
  Stream<List<SubjectModel>> getEnrolledSubjects(String studentId) {
    return _firestore
        .collection('subscriptions')
        .where('studentId', isEqualTo: studentId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .asyncMap((snapshot) async {
          List<SubjectModel> subjects = [];
          for (var doc in snapshot.docs) {
            final subjectId = doc['subjectId'];
            final subDoc = await _firestore.collection('subjects').doc(subjectId).get();
            if (subDoc.exists) {
              subjects.add(SubjectModel.fromMap(subDoc.data()!, subDoc.id));
            }
          }
          return subjects;
        });
  }
}
