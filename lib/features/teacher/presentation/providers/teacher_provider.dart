import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/firebase_providers.dart';
import '../../data/repositories/teacher_repository_impl.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../../domain/models/content_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepositoryImpl(ref.watch(firestoreProvider));
});

final teacherSubjectsProvider = StreamProvider<List<SubjectModel>>((ref) {
  final user = ref.watch(currentUserDataProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(teacherRepositoryProvider).getTeacherSubjects(user.id);
});

final teacherNotifierProvider = StateNotifierProvider<TeacherNotifier, AsyncValue<void>>((ref) {
  return TeacherNotifier(ref.watch(teacherRepositoryProvider));
});

class TeacherNotifier extends StateNotifier<AsyncValue<void>> {
  final TeacherRepository _repository;

  TeacherNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> addSubject(SubjectModel subject) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createSubject(subject);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addVideo(VideoModel video) async {
    state = const AsyncValue.loading();
    try {
      await _repository.uploadVideo(video);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
