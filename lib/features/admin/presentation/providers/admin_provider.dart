import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/firebase_providers.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../auth/domain/models/user_model.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(firestoreProvider));
});

final pendingTeachersProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(adminRepositoryProvider).getPendingTeachers();
});

final allStudentsProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(adminRepositoryProvider).getAllStudents();
});

final adminNotifierProvider = StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  return AdminNotifier(ref.watch(adminRepositoryProvider));
});

class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repository;

  AdminNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> approveTeacher(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.approveTeacher(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
