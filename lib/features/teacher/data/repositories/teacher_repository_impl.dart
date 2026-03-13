import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/content_models.dart';
import '../../domain/repositories/teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final FirebaseFirestore _firestore;

  TeacherRepositoryImpl(this._firestore);

  @override
  Future<void> createSubject(SubjectModel subject) async {
    await _firestore.collection('subjects').add(subject.toMap());
  }

  @override
  Future<void> uploadVideo(VideoModel video) async {
    await _firestore.collection('videos').add(video.toMap());
  }

  @override
  Future<void> uploadMaterial(String subjectId, String title, String fileUrl) async {
    await _firestore.collection('materials').add({
      'subjectId': subjectId,
      'title': title,
      'fileUrl': fileUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<SubjectModel>> getTeacherSubjects(String teacherId) {
    return _firestore
        .collection('subjects')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubjectModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<VideoModel>> getSubjectVideos(String subjectId) {
    return _firestore
        .collection('videos')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
