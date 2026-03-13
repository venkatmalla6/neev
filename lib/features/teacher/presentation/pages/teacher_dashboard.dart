import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome, Teacher!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildDashboardAction(
            context,
            'Manage Subjects',
            'Add or edit your course subjects',
            Icons.book,
            Colors.blue,
            '/teacher/add-subject',
          ),
          _buildDashboardAction(
            context,
            'Upload recorded classes',
            'Add video lectures for students',
            Icons.video_library,
            Colors.red,
            '/teacher/add-video',
          ),
          _buildDashboardAction(
            context,
            'Create Quiz',
            'Design tests and assessments',
            Icons.quiz,
            Colors.orange,
            '/teacher/add-quiz',
          ),
          _buildDashboardAction(
            context,
            'Live Class Link',
            'Schedule a new meeting',
            Icons.video_call,
            Colors.green,
            '/teacher/live-class',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardAction(BuildContext context, String title, String subtitle, IconData icon, Color color, String route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push(route),
      ),
    );
  }
}
