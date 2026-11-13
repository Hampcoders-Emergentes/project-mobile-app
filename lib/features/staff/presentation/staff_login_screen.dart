import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import 'staff_session.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});
  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();
  bool _hidden = true;
  void _submit() {
    if (context.read<StaffSession>().state.status == SessionStatus.signingIn) {
      return;
    }
    if (_form.currentState!.validate()) {
      TextInput.finishAutofillContext();
      context.read<StaffSession>().signIn(_email.text.trim(), _password.text);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<StaffSession, StaffSessionState>(
    builder: (context, state) {
      final loading = state.status == SessionStatus.signingIn;
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: AutofillGroup(
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.darkNavy,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.bolt,
                                color: AppColors.accentYellow,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'ElectroLink',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkNavy,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tu local, bajo control',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Acceso para personal operativo y de limpieza. Consulta equipos y alertas de tu local.',
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _email,
                          enabled: !loading,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          autocorrect: false,
                          validator: (value) =>
                              value == null ||
                                  !RegExp(
                                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                  ).hasMatch(value.trim())
                              ? 'Ingresa un correo válido.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _password,
                          enabled: !loading,
                          obscureText: _hidden,
                          autofillHints: const [AutofillHints.password],
                          autocorrect: false,
                          enableSuggestions: false,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _hidden
                                  ? 'Mostrar contraseña'
                                  : 'Ocultar contraseña',
                              onPressed: () =>
                                  setState(() => _hidden = !_hidden),
                              icon: Icon(
                                _hidden
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Ingresa tu contraseña.'
                              : null,
                        ),
                        if (state.error != null) ...[
                          const SizedBox(height: 16),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              state.error!,
                              style: const TextStyle(color: AppColors.errorRed),
                            ),
                          ),
                        ],
                        if (state.storageNeedsClear)
                          TextButton(
                            onPressed: () =>
                                context.read<StaffSession>().signOut(),
                            child: const Text('Borrar sesión guardada'),
                          ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: loading ? null : _submit,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: AppColors.darkNavy,
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    semanticsLabel: 'Iniciando sesión',
                                  ),
                                )
                              : const Text('Iniciar sesión'),
                        ),
                        const SizedBox(height: 24),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              color: AppColors.grayText,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Usa la cuenta autorizada para tu local. Si no tienes acceso, consulta con el responsable.',
                                style: TextStyle(color: AppColors.grayText),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
