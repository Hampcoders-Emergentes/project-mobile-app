import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/features/company/presentation/screens/company_shell.dart';
import 'package:mobile_app_electrolink/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mobile_app_electrolink/features/profile/presentation/bloc/profile_event.dart';
import 'package:mobile_app_electrolink/features/profile/presentation/bloc/profile_state.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String email;

  const CompanyProfileScreen({super.key, required this.email});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _companyNameController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _streetNumberController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedCountry = 'Perú';

  @override
  void dispose() {
    _companyNameController.dispose();
    _taxIdController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _streetNumberController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

      context.read<ProfileBloc>().add(
            CompleteCompanyProfile(
              companyName: _companyNameController.text.trim(),
              taxId: _taxIdController.text.trim(),
              phoneNumber: '+51${_phoneController.text.trim()}',
              email: widget.email,
              billingStreet: _streetController.text.trim(),
              billingNumber: _streetNumberController.text.trim(),
              billingDistrict: _districtController.text.trim(),
              billingCity: _cityController.text.trim(),
              billingCountry: _selectedCountry,
              billingPostalCode: _postalCodeController.text.trim(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ),
          );
        } else if (state is ProfileSubmitSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const CompanyShell()),
            (route) => false,
          );
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
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      _buildProgressIndicator(),
                      const SizedBox(height: 24),
                      _buildFormCard(),
                      const SizedBox(height: 24),
                      _buildInfoCards(),
                      const SizedBox(height: 24),
                    ],
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
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.darkNavy),
          ),
          const SizedBox(width: 16),
          const Text(
            'ElectroLink',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: AppColors.darkNavy),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.darkNavy,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 12,
            child: Container(
              height: 2,
              color: const Color(0xFFE2E8F0),
            ),
          ),
          Positioned(
            left: 0,
            top: 12,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.333,
              height: 2,
              color: AppColors.darkNavy,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStep('1', 'Detalles', true),
              _buildStep('2', 'Alertas', false),
              _buildStep('3', 'Usuarios', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String label, bool active) {
    final circleBg = active ? AppColors.darkNavy : const Color(0xFFE0E3E5);
    final circleText = active ? Colors.white : const Color(0xFF76777D);
    final labelColor = active ? AppColors.darkNavy : const Color(0xFF76777D);
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: circleBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: circleText,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildCardHeader(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    label: 'Razón Social / Nombre de la Empresa',
                    hint: 'Ej. ElectroIndustrias S.A.C.',
                    controller: _companyNameController,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'RUC (11 dígitos)',
                    hint: '20XXXXXXXXX',
                    controller: _taxIdController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                  const SizedBox(height: 24),
                  _buildPhoneField(),
                  const SizedBox(height: 24),
                  _buildDisabledEmailField(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('UBICACIÓN DE LA SEDE PRINCIPAL'),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Dirección / Calle',
                    hint: 'Av. Industrial 450 - Of. 201',
                    controller: _streetController,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Distrito',
                    hint: 'San Isidro',
                    controller: _districtController,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Ciudad',
                    hint: 'Lima',
                    controller: _cityController,
                  ),
                  const SizedBox(height: 24),
                  _buildCountryField(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Código Postal',
                    hint: '15046',
                    controller: _postalCodeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  _buildFooter(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 33, 25, 17),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Perfil de\nEmpresa',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkNavy,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Complete la información legal y operativa de su organización.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildOnlineBadge(),
        ],
      ),
    );
  }

  Widget _buildOnlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x1A6CF8BB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF4EDEA3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'SISTEMA\nEN LÍNEA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00714D),
              height: 1.3,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grayText,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF6B7280)),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.darkNavy),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Teléfono Principal',
            style: TextStyle(fontSize: 14, color: AppColors.grayText),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: '999 999 999',
            hintStyle: const TextStyle(color: Color(0xFF6B7280)),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Text(
                '+51',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grayText,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.darkNavy),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDisabledEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Correo Corporativo',
            style: TextStyle(fontSize: 14, color: AppColors.grayText),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.email_outlined, size: 16, color: AppColors.grayText),
              const SizedBox(width: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF76777D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.darkNavy, width: 4),
        ),
      ),
      child: Text(
        title,
            style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavy,
                  height: 1.25,
                  letterSpacing: -0.32,
                ),
      ),
    );
  }

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'País',
            style: TextStyle(fontSize: 14, color: AppColors.grayText),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCountry,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.grayText),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darkNavy,
              ),
              items: const [
                DropdownMenuItem(value: 'Perú', child: Text('Perú')),
                DropdownMenuItem(value: 'Colombia', child: Text('Colombia')),
                DropdownMenuItem(value: 'Chile', child: Text('Chile')),
                DropdownMenuItem(value: 'Argentina', child: Text('Argentina')),
                DropdownMenuItem(value: 'México', child: Text('México')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCountry = value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Column(
        children: [
          const Text(
            '* Todos los campos son obligatorios para la certificación de la cuenta.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.grayText,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final isLoading = state is ProfileLoading;
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Siguiente: Configurar Alertas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        _buildInfoCard(
          icon: Icons.lock_outline,
          title: 'Encriptación',
          subtitle: 'Datos protegidos bajo estándar AES-256.',
        ),
        const SizedBox(height: 24),
        _buildInfoCard(
          icon: Icons.verified_outlined,
          title: 'Validación RUC',
          subtitle: 'Conexión directa con base de datos SUNAT.',
        ),
        const SizedBox(height: 24),
        _buildInfoCard(
          icon: Icons.support_agent_outlined,
          title: 'Soporte B2B',
          subtitle: 'Asistencia técnica 24/7 disponible.',
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grayText),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavy,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grayText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
