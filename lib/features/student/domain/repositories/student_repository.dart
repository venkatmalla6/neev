import '../../../teacher/domain/models/content_models.dart';

abstract class StudentRepository {
  Stream<List<SubjectModel>> getSubjectsByClass(String classId);
  Future<void> enrollInSubject(String studentId, String subjectId);
  Stream<List<SubjectModel>> getEnrolledSubjects(String studentId);
}
