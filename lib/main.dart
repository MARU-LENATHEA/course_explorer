import 'package:flutter/material.dart';

const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const TahapSatuApp());
}

class TahapSatuApp extends StatelessWidget {
  const TahapSatuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 1 - Flexible Layout'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity, // Mengikuti lebar maksimal parent layar
            color: Colors.green[200],
            padding: const EdgeInsets.all(16),
            child: const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
