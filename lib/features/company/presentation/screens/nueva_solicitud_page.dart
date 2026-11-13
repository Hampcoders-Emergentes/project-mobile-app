import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/features/company/presentation/screens/success_page.dart';

class NuevaSolicitudPage extends StatefulWidget {
  const NuevaSolicitudPage({super.key});

  @override
  State<NuevaSolicitudPage> createState() => _NuevaSolicitudPageState();
}

class _NuevaSolicitudPageState extends State<NuevaSolicitudPage> {
  static const _serviceTypes = [
    (title: 'Mantenimiento General', subtitle: 'Revisiones periódicas'),
    (title: 'Mantenimiento IoT', subtitle: 'Sensores y conectividad'),
    (title: 'Reparación de Urgencia', subtitle: 'Fallas críticas'),
  ];

  static const _properties = [
    'Planta Norte - Sector B (Alerta Activa)',
    'Planta Norte - Sector A',
    'Sede Central - Piso 3',
  ];

  int _selectedServiceType = 1;
  String _selectedProperty = _properties.first;
  late final TextEditingController _descriptionCtrl;

  @override
  void initState() {
    super.initState();
    _descriptionCtrl = TextEditingController(
      text: 'Caída de tensión detectada por sensor de monitoreo continuo en '
          'el sub-panel B4. Se requiere inspección física del cableado y '
          'breakers.',
    );
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIotSuggestionBanner(),
                    const SizedBox(height: 24),
                    _buildServiceTypeCard(),
                    const SizedBox(height: 24),
                    _buildPropertyCard(),
                    const SizedBox(height: 24),
                    _buildDescriptionCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back, size: 24, color: AppColors.darkText),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Nueva Solicitud',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIotSuggestionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDCF2E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sensors, size: 26, color: Color(0xFF006C49)),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugerencia del Sistema IoT',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006C49),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hemos detectado una anomalía en el panel principal. Los '
                  'campos han sido pre-completados para agilizar tu solicitud.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3F4A46),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard() {
    return _SectionCard(
      icon: Icons.build_outlined,
      title: 'Tipo de Servicio',
      child: Column(
        children: List.generate(_serviceTypes.length, (index) {
          final type = _serviceTypes[index];
          final isSelected = _selectedServiceType == index;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _serviceTypes.length - 1 ? 14 : 0,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedServiceType = index),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF7F8FA) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.darkText : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    _buildRadio(isSelected),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grayText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.darkText,
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: isSelected ? AppColors.darkText : AppColors.borderLight,
          width: isSelected ? 6 : 2,
        ),
      ),
    );
  }

  Widget _buildPropertyCard() {
    return _SectionCard(
      icon: Icons.apartment_outlined,
      title: 'Instalación / Propiedad',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedProperty,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.darkText),
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.darkText,
              height: 1.3,
            ),
            items: _properties
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedProperty = value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _SectionCard(
      icon: Icons.description_outlined,
      title: 'Descripción del Problema',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            controller: _descriptionCtrl,
            maxLines: 5,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkText,
              height: 1.45,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.darkText),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pre-completado por ElectroLink',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.grayText,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continuar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: AppColors.darkText),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
