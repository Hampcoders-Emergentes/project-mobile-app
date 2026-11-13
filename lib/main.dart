import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/staff/data/staff_api.dart';
import 'features/staff/data/staff_repository.dart';
import 'features/staff/presentation/staff_session.dart';
import 'features/staff/presentation/staff_login_screen.dart';
import 'features/staff/presentation/staff_dashboard_screen.dart';

void main() => runApp(const ElectroLinkApp());

class ElectroLinkApp extends StatefulWidget {
  final StaffSession? session;
  const ElectroLinkApp({super.key, this.session});
  @override
  State<ElectroLinkApp> createState() => _ElectroLinkAppState();
}

class _ElectroLinkAppState extends State<ElectroLinkApp> {
  late final StaffSession session;
  @override
  void initState() {
    super.initState();
    session =
        widget.session ??
        StaffSession(StaffApi(), const SecureSessionStorage());
    session.restore();
  }

  @override
  void dispose() {
    if (widget.session == null) session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: session,
    child: MaterialApp(
      title: 'ElectroLink · Operaciones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkNavy),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.darkNavy,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: BlocBuilder<StaffSession, StaffSessionState>(
        builder: (context, state) {
          if (state.status == SessionStatus.restoring) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Recuperando sesión',
                ),
              ),
            );
          }
          if (state.status != SessionStatus.signedIn) {
            return const StaffLoginScreen();
          }
          // Disposing this navigator on logout also removes any equipment detail.
          return Navigator(
            key: ValueKey(state.userId),
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => StaffDashboardScreen(
                repository: StaffRepository(session.api),
                email: state.email,
              ),
            ),
          );
        },
      ),
    ),
  );
}
