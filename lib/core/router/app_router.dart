import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/teacher/presentation/pages/teacher_dashboard.dart';
import '../../features/teacher/presentation/pages/add_subject_page.dart';
import '../../features/student/presentation/pages/student_dashboard.dart';
import '../../features/student/presentation/pages/subject_detail_page.dart';
import '../../features/student/presentation/pages/video_player_screen.dart';
import '../../features/student/presentation/pages/quiz_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userData = ref.watch(currentUserDataProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/teacher',
        builder: (context, state) => const TeacherDashboard(),
        routes: [
          GoRoute(
            path: 'add-subject',
            builder: (context, state) => const AddSubjectPage(),
          ),
          GoRoute(
            path: 'add-video',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Add Video Logic Here'))),
          ),
          GoRoute(
            path: 'add-quiz',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Add Quiz Logic Here'))),
          ),
          GoRoute(
            path: 'live-class',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Live Class Scheduler Here'))),
          ),
        ],
      ),
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentDashboard(),
        routes: [
          GoRoute(
            path: 'subject/:subjectId',
            builder: (context, state) {
              final subjectId = state.pathParameters['subjectId']!;
              return SubjectDetailPage(subjectId: subjectId);
            },
          ),
          GoRoute(
            path: 'video/:videoUrl',
            builder: (context, state) {
              final videoUrl = state.pathParameters['videoUrl']!;
              return VideoPlayerScreen(videoUrl: Uri.decodeComponent(videoUrl));
            },
          ),
          GoRoute(
            path: 'quiz/:subjectId',
            builder: (context, state) {
              final subjectId = state.pathParameters['subjectId']!;
              return QuizPage(subjectId: subjectId);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      // If user is not logged in, they must be at login or signup
      if (authState.value == null) {
        return (isLoggingIn || isSigningUp) ? null : '/login';
      }

      // If user is logged in, but we are still loading user data (role)
      if (userData.isLoading) return null;

      // If user is logged in, redirect based on role if they are on auth pages
      if (isLoggingIn || isSigningUp) {
        final role = userData.value?.role;
        if (role == 'admin') return '/admin';
        if (role == 'teacher') return '/teacher';
        if (role == 'student') return '/student';
      }

      return null;
    },
  );
});
