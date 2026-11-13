import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_electrolink/core/enums/user_role.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/core/widgets/homeowner_shell.dart';
import 'package:mobile_app_electrolink/features/profile/presentation/screens/company_profile_screen.dart';
import 'package:mobile_app_electrolink/features/technical/presentation/screens/technical_dashboard_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import 'auth_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  static const _passwordPolicyMessage =
      'La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 carácter especial.';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (_emailError != null) setState(() => _emailError = null);
    });
    _passwordController.addListener(() {
      if (_passwordError != null) setState(() => _passwordError = null);
    });
    _confirmPasswordController.addListener(() {
      if (_confirmPasswordError != null) {
        setState(() => _confirmPasswordError = null);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateByRole(UserRole role) {
    final Widget destination;
    switch (role) {
      case UserRole.technician:
        destination = const TechnicalDashboardScreen();
      case UserRole.company:
        destination = CompanyProfileScreen(email: _emailController.text.trim());
      case UserRole.homeowner:
        destination = const HomeownerShell();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[^A-Za-z0-9]'));
  }

  bool _validateFields() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    setState(() {
      _emailError = _isValidEmail(email)
          ? null
          : 'Ingrese un correo electrónico corporativo válido.';
      _passwordError = _isValidPassword(password) ? null : _passwordPolicyMessage;
      _confirmPasswordError = (confirm.isNotEmpty && confirm == password)
          ? null
          : 'Las contraseñas no coinciden.';
    });
    return _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  void _goToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateFields()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe aceptar los Términos y Condiciones.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(
          RegisterSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.errorRed),
          );
        } else if (state is AuthSuccess) {
          _navigateByRole(state.user.role);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _buildFormCard(),
                        const SizedBox(height: 24),
                        _buildFooterSupport(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          GestureDetector(
            onTap: _goToLogin,
            child: const Icon(Icons.arrow_back, color: AppColors.darkNavy),
          ),
          const SizedBox(width: 8),
          const Text(
            'ElectroLink',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.bolt, color: AppColors.accentYellow, size: 36),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Registro de Empresa',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure su cuenta corporativa para comenzar el monitoreo.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grayText,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            label: 'Correo Electrónico Corporativo',
            hint: 'nombre@empresa.com',
            icon: Icons.email_outlined,
            controller: _emailController,
            errorText: _emailError,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Contraseña',
            errorText: _passwordError,
            hint: '********',
            icon: Icons.lock_outline,
            isPassword: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Confirmar Contraseña',
            hint: 'Reingrese su contraseña',
            icon: Icons.lock_outline,
            isPassword: true,
            controller: _confirmPasswordController,
            errorText: _confirmPasswordError,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                height: 16,
                width: 16,
                child: Checkbox(
                  value: _acceptTerms,
                  onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grayText,
                    ),
                    children: [
                      const TextSpan(text: 'Acepto los '),
                      TextSpan(
                        text: 'Términos de Servicio',
                        style: const TextStyle(
                          color: AppColors.darkNavy,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' y la '),
                      TextSpan(
                        text: 'Política de Privacidad',
                        style: const TextStyle(
                          color: AppColors.darkNavy,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' de ElectroLink.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (isLoading || !_acceptTerms) ? null : _onRegister,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CREAR CUENTA DE EMPRESA',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 14),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.lightGray)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'O REGÍSTRESE CON',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.grayText.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.lightGray)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderLight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.vpn_key_outlined, size: 16, color: AppColors.darkNavy),
                    SizedBox(width: 8),
                    Text(
                      'SSO CORPORATIVO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkNavy,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
              child: TextButton(
                onPressed: _goToLogin,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: AppColors.grayText,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(text: '¿Ya tiene una cuenta? '),
                      TextSpan(
                        text: 'Inicie Sesión',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSupport() {
    return const Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0.6,
        ),
        children: [
          TextSpan(
            text: 'SOPORTE TÉCNICO 24/7: ',
            style: TextStyle(
              color: AppColors.grayText,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '0-800-ELECTRO',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
