import '../../../auth/domain/models/user_model.dart';

abstract class AdminRepository {
  Stream<List<UserModel>> getPendingTeachers();
  Future<void> approveTeacher(String teacherId);
  Stream<List<UserModel>> getAllStudents();
}
