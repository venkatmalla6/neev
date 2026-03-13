import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/teacher_provider.dart';
import '../../domain/models/content_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddSubjectPage extends ConsumerStatefulWidget {
  const AddSubjectPage({super.key});

  @override
  ConsumerState<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends ConsumerState<AddSubjectPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  String _selectedClass = '6th';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(currentUserDataProvider).value;
      if (user == null) return;

      final subject = SubjectModel(
        id: '', // Firestore will generate
        name: _nameController.text.trim(),
        classId: _selectedClass,
        teacherId: user.id,
        price: double.parse(_priceController.text.trim()),
        coverImage: _imageController.text.trim(),
      );

      try {
        await ref.read(teacherNotifierProvider.notifier).addSubject(subject);
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Subject')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Subject Name (e.g. Physics)'),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: const InputDecoration(labelText: 'Class'),
                items: ['6th', '7th', '8th', '9th']
                    .map((c) => DropdownMenuItem(value: c, child: Text('$c Class')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedClass = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (INR)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Cover Image URL'),
                validator: (v) => v!.isEmpty ? 'Enter image URL' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                child: state.isLoading 
                    ? const CircularProgressIndicator() 
                    : const Text('Create Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
