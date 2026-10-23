import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/patients/presentation/screens/create_patient_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';

/// Enrutador de la app. El login es el punto de entrada y el refresh se
/// realiza automáticamente desde ApiClient cuando una petición protegida
/// recibe 401.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/patients/create', builder: (context, state) => const CreatePatientScreen()),
      GoRoute(path: '/shell', builder: (context, state) => const MainShell()),
    ],
  );
});
