import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/firebase_providers.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../domain/repositories/student_repository.dart';
import '../../../teacher/domain/models/content_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl(ref.watch(firestoreProvider));
});

final selectedClassProvider = StateProvider<String>((ref) => '6th');

final subjectsByClassProvider = StreamProvider<List<SubjectModel>>((ref) {
  final classId = ref.watch(selectedClassProvider);
  return ref.watch(studentRepositoryProvider).getSubjectsByClass(classId);
});

final enrolledSubjectsProvider = StreamProvider<List<SubjectModel>>((ref) {
  final user = ref.watch(currentUserDataProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(studentRepositoryProvider).getEnrolledSubjects(user.id);
});

final studentNotifierProvider = StateNotifierProvider<StudentNotifier, AsyncValue<void>>((ref) {
  return StudentNotifier(ref.watch(studentRepositoryProvider));
});

class StudentNotifier extends StateNotifier<AsyncValue<void>> {
  final StudentRepository _repository;

  StudentNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> enroll(String studentId, String subjectId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.enrollInSubject(studentId, subjectId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
