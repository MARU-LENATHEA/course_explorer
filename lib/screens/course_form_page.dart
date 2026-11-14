import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseFormPage extends StatefulWidget {
  final Course? course; // Jika null -> Create, Jika ada -> Edit

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;
  late String _selectedStatus;
  bool _isSaving = false;

  bool get isEditMode => widget.course != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course?.code ?? '');
    _titleController = TextEditingController(text: widget.course?.title ?? '');
    _creditsController = TextEditingController(
      text: widget.course?.credits.toString() ?? '',
    );
    _selectedStatus = widget.course?.status ?? 'planned';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final courseData = Course(
      id: widget.course?.id,
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _selectedStatus,
    );

    try {
      if (isEditMode) {
        if (widget.course?.id == null) {
          throw Exception('ID course tidak valid untuk operasi edit');
        }
        await context.read<CourseProvider>().updateCourse(
          widget.course!.id!,
          courseData,
        );
      } else {
        await context.read<CourseProvider>().createCourse(courseData);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'Kos berhasil diperbarui!'
                : 'Kos baru berhasil ditambahkan!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan perubahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Kos' : 'Tambah Kos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Identitas Mahasiswa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$studentId • $studentName',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input Kode Kos (Read-Only saat Edit Mode)
              TextFormField(
                controller: _codeController,
                readOnly: isEditMode,
                decoration: InputDecoration(
                  labelText: isEditMode
                      ? 'Kode Kos (Terkunci)'
                      : 'Kode Kos *',
                  hintText: 'Misal: KOS01',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.qr_code),
                  filled: isEditMode,
                  fillColor: isEditMode ? Colors.grey.shade200 : null,
                  helperText: isEditMode
                      ? 'Kode tidak dapat diubah karena merupakan relasi favorit'
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode kos tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input Nama Kos
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kos *',
                  hintText: 'Misal: Kos Melati Indah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home_work),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kos tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input Jumlah Kamar
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kamar *',
                  hintText: 'Misal: 3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bed),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah kamar tidak boleh kosong';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Jumlah kamar harus berupa angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Status
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Kos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Tombol Simpan dengan Guard isSaving
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submitForm,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSaving
                        ? 'Menyimpan...'
                        : (isEditMode ? 'Simpan Perubahan' : 'Simpan Data Kos'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
