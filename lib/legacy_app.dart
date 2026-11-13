import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/auth/auth_bloc.dart';
import 'core/auth/token_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart' as feature_auth;
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/company/presentation/screens/company_shell.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_event.dart';
import 'features/profile/presentation/bloc/profile_state.dart';
import 'features/profile/presentation/screens/company_profile_screen.dart';

void main() {
  runApp(const ElectroLinkApp());
}

class ElectroLinkApp extends StatelessWidget {
  const ElectroLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(TokenService.instance)..add(AppStarted()),
        ),
        BlocProvider(create: (_) => feature_auth.AuthBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
      ],
      child: MaterialApp(
        title: 'ElectroLink',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decide la pantalla inicial: sin sesión guardada se exige el registro;
/// con sesión se verifica si el perfil ya fue completado.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      listener: (context, state) {
        // Sin sesión guardada la app arranca en el inicio de sesión;
        // desde ahí el botón "Registrarse" lleva al registro de empresa.
        final Widget destination = state is AuthAuthenticated
            ? ProfileGate(email: state.email)
            : const AuthScreen();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
      child: const _SplashView(),
    );
  }
}

/// Con sesión activa consulta el perfil: si aún no está completo redirige a
/// la vista de completar datos; si ya lo está, entra directo a la app.
class ProfileGate extends StatefulWidget {
  final String email;

  const ProfileGate({super.key, required this.email});

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadSuccess) {
          final Widget destination = state.isComplete
              ? const CompanyShell()
              : CompanyProfileScreen(email: widget.email);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        } else if (state is ProfileError) {
          // Token vencido o backend no disponible: se vuelve al login.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          );
        }
      },
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.bolt, color: AppColors.accentYellow, size: 50),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.darkNavy),
          ],
        ),
      ),
    );
  }
}
