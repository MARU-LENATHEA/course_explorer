import '../models/course_model.dart';

final List<Course> mockCourses = [
  Course(
    id: '1',
    title: 'Responsive Layout',
    code: 'MOB04',
    status: 'Active',
    description: 'Penerapan antarmuka adaptif menggunakan MediaQuery, LayoutBuilder, dan breakpoint.',
    credits: 3,
  ),
  Course(
    id: '2',
    title: 'Navigation & Routing',
    code: 'MOB05',
    status: 'Planned',
    description: 'Memahami stack navigasi, perpindahan route menggunakan Navigator push dan pop.',
    credits: 3,
  ),
  Course(
    id: '3',
    title: 'User Interaction',
    code: 'MOB06',
    status: 'Planned',
    description: 'Penanganan interaksi sentuhan, ripple feedback dengan InkWell, dan gesture detection.',
    credits: 2,
  ),
  Course(
    id: '4',
    title: 'Form Handling & Validation',
    code: 'MOB07',
    status: 'Planned',
    description: 'Validasi form secara menyeluruh menggunakan FormState dan TextFormField.',
    credits: 3,
  ),
  Course(
    id: '5',
    title: 'State Management Basic',
    code: 'MOB08',
    status: 'Planned',
    description: 'Pengelolaan state internal widget dan siklus pembaruan tampilan aplikasi.',
    credits: 3,
  ),
];
