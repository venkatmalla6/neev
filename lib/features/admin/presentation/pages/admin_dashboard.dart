import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/admin_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingTeachersAsync = ref.watch(pendingTeachersProvider);
    final allStudentsAsync = ref.watch(allStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context, 
                    'Students', 
                    allStudentsAsync.when(data: (l) => l.length.toString(), loading: () => '...', error: (_, __) => '0'), 
                    Icons.school, 
                    Colors.green
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context, 
                    'Pending Approvals', 
                    pendingTeachersAsync.when(data: (l) => l.length.toString(), loading: () => '...', error: (_, __) => '0'), 
                    Icons.pending_actions, 
                    Colors.orange
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Teacher Approval Requests',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            pendingTeachersAsync.when(
              data: (teachers) => teachers.isEmpty
                  ? const Center(child: Text('No pending requests.'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: teachers.length,
                      itemBuilder: (context, index) {
                        final teacher = teachers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(teacher.name),
                            subtitle: Text(teacher.email),
                            trailing: ElevatedButton(
                              onPressed: () => ref.read(adminNotifierProvider.notifier).approveTeacher(teacher.id),
                              child: const Text('Approve'),
                            ),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
