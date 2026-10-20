import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/home_page.dart';
import 'services/course_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CourseService>(create: (_) => CourseService()),
        ProxyProvider<CourseService, CourseRepository>(
          update: (_, service, _) => CourseRepository(service),
        ),
        ChangeNotifierProxyProvider<CourseRepository, CourseProvider>(
          create: (context) => CourseProvider(context.read<CourseRepository>()),
          update: (_, repository, provider) =>
              provider ?? CourseProvider(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E88E5),
      ),
      home: const HomePage(),
    );
  }
}
