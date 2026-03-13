import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/student_provider.dart';
import '../../../teacher/presentation/providers/teacher_provider.dart';

class SubjectDetailPage extends ConsumerWidget {
  final String subjectId;
  const SubjectDetailPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement video provider integration
    
    return Scaffold(
      appBar: AppBar(title: const Text('Course Content')),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue.withOpacity(0.1),
            child: const Icon(Icons.book, size: 100, color: Colors.blue),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Syllabus & Classes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  'Recorded Lectures',
                  Icons.video_library,
                  [
                    _buildVideoTile(context, 'Introduction to Chapter 1', '15 mins', 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'),
                    _buildVideoTile(context, 'Core Concepts', '45 mins', 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  'Study Materials',
                  Icons.picture_as_pdf,
                  [
                    _buildMaterialTile(context, 'Chapter 1 Notes', 'PDF • 2MB'),
                    _buildMaterialTile(context, 'Summary Cheat Sheet', 'PDF • 1MB'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  'Assessments',
                  Icons.quiz,
                  [
                    _buildQuizTile(context, 'Chapter 1 Quiz', '10 Questions'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildVideoTile(BuildContext context, String title, String duration, String url) {
    return ListTile(
      leading: const Icon(Icons.play_circle_outline, color: Colors.blue),
      title: Text(title),
      subtitle: Text(duration),
      trailing: const Icon(Icons.download, size: 20),
      onTap: () => context.push('/student/video/${Uri.encodeComponent(url)}'),
    );
  }

  Widget _buildMaterialTile(BuildContext context, String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.description, color: Colors.orange),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.file_download, size: 20),
      onTap: () {},
    );
  }

  Widget _buildQuizTile(BuildContext context, String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.help_outline, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => context.push('/student/quiz/$subjectId'),
    );
  }
}
