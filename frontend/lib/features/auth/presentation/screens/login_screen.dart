import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../providers/auth_providers.dart';

/// Inicio de sesión conectado a POST /api/v1/auth/login.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(loginControllerProvider.notifier).submit(
          email: _email.text.trim(),
          password: _password.text,
        );
    if (!mounted) return;
    ref.read(loginControllerProvider).whenOrNull(
      data: (result) {
        if (result != null) context.go('/shell');
      },
      error: (error, _) {
        final message = error is ApiException
            ? error.message
            : 'No pudimos iniciar sesión. Intenta de nuevo.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.lock_outline, size: 52),
                    const SizedBox(height: 16),
                    Text(
                      'Bienvenido a AgeCare',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                      validator: (value) =>
                          (value?.contains('@') ?? false) ? null : 'Ingresa un correo válido',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) =>
                          (value?.isNotEmpty ?? false) ? null : 'Ingresa tu contraseña',
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Entrar'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: state.isLoading ? null : () => context.go('/register'),
                      child: const Text('Crear una cuenta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
