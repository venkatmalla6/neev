import '../../../../features/teacher/domain/models/content_models.dart';

abstract class TeacherRepository {
  Future<void> createSubject(SubjectModel subject);
  Future<void> uploadVideo(VideoModel video);
  Future<void> uploadMaterial(String subjectId, String title, String fileUrl);
  Stream<List<SubjectModel>> getTeacherSubjects(String teacherId);
  Stream<List<VideoModel>> getSubjectVideos(String subjectId);
}
