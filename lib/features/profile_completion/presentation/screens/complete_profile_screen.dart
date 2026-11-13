import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/core/network/api_endpoints.dart';
import 'package:mobile_app_electrolink/core/widgets/homeowner_shell.dart';
import '../../data/profile_repository.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Perú');
  final _postalCodeCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyRelationCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();

  DateTime? _dateOfBirth;
  String _contactTime = 'Morning';
  bool _smsNotif = true;
  bool _emailNotif = true;
  bool _pushNotif = true;
  bool _showEmergency = false;

  @override
  void dispose() {
    for (final ctrl in [
      _firstNameCtrl, _lastNameCtrl, _phoneCtrl, _dniCtrl,
      _streetCtrl, _numberCtrl, _districtCtrl, _cityCtrl,
      _countryCtrl, _postalCodeCtrl, _emergencyNameCtrl,
      _emergencyRelationCtrl, _emergencyPhoneCtrl,
    ]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      _showSnack('Selecciona tu fecha de nacimiento');
      return;
    }

    setState(() => _saving = true);

    final data = <String, dynamic>{
      'firstName': _firstNameCtrl.text.trim(),
      'lastName': _lastNameCtrl.text.trim(),
      'phoneNumber': _phoneCtrl.text.trim(),
      'dni': _dniCtrl.text.trim(),
      'dateOfBirth':
          '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}',
      'street': _streetCtrl.text.trim(),
      'number': _numberCtrl.text.trim(),
      'district': _districtCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'country': _countryCtrl.text.trim(),
      'postalCode': _postalCodeCtrl.text.trim(),
      'preferredContactTime': _contactTime,
      'smsNotifications': _smsNotif,
      'emailNotifications': _emailNotif,
      'pushNotifications': _pushNotif,
    };

    if (_showEmergency &&
        _emergencyNameCtrl.text.isNotEmpty &&
        _emergencyRelationCtrl.text.isNotEmpty &&
        _emergencyPhoneCtrl.text.isNotEmpty) {
      data['emergencyContact'] = {
        'name': _emergencyNameCtrl.text.trim(),
        'relationship': _emergencyRelationCtrl.text.trim(),
        'phoneNumber': _emergencyPhoneCtrl.text.trim(),
      };
    }

    try {
      final client = ApiClient(baseUrl: ApiEndpoints.baseUrl);
      final repo = ProfileRepository(client);
      await repo.completeAsHomeowner(data);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeownerShell()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 10, now.month, now.day),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2746),
        foregroundColor: Colors.white,
        title: const Text('Completa tu perfil'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionHeader('Información personal'),
              _card([
                _field('Nombres', _firstNameCtrl, validator: _req),
                _field('Apellidos', _lastNameCtrl, validator: _req),
                _field('Teléfono', _phoneCtrl, keyboard: TextInputType.phone, validator: _req),
                _field('DNI', _dniCtrl, keyboard: TextInputType.number, validator: _req),
                _dateField(),
              ]),
              const SizedBox(height: 20),
              _sectionHeader('Dirección'),
              _card([
                _field('Calle', _streetCtrl, validator: _req),
                Row(
                  children: [
                    Expanded(flex: 2, child: _field('Número', _numberCtrl, validator: _req)),
                    const SizedBox(width: 12),
                    Expanded(flex: 3, child: _field('Distrito', _districtCtrl, validator: _req)),
                  ],
                ),
                _field('Ciudad', _cityCtrl, validator: _req),
                Row(
                  children: [
                    Expanded(flex: 3, child: _field('País', _countryCtrl, validator: _req)),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: _field('C.P.', _postalCodeCtrl, keyboard: TextInputType.number, validator: _req)),
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              _sectionHeader('Preferencias de contacto'),
              _card([
                const Text('Horario de contacto preferido',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Morning', label: Text('Mañana')),
                    ButtonSegment(value: 'Afternoon', label: Text('Tarde')),
                    ButtonSegment(value: 'Evening', label: Text('Noche')),
                  ],
                  selected: {_contactTime},
                  onSelectionChanged: (v) => setState(() => _contactTime = v.first),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: const Color(0xFF1E2746),
                  ),
                ),
                const SizedBox(height: 16),
                _switch('Notificaciones SMS', _smsNotif, (v) => setState(() => _smsNotif = v)),
                _switch('Notificaciones Email', _emailNotif, (v) => setState(() => _emailNotif = v)),
                _switch('Notificaciones Push', _pushNotif, (v) => setState(() => _pushNotif = v)),
              ]),
              const SizedBox(height: 20),
              _sectionHeader('Contacto de emergencia (opcional)'),
              _card([
                _switch('Agregar contacto de emergencia', _showEmergency,
                    (v) => setState(() => _showEmergency = v)),
                if (_showEmergency) ...[
                  const SizedBox(height: 12),
                  _field('Nombre completo', _emergencyNameCtrl),
                  _field('Parentesco', _emergencyRelationCtrl),
                  _field('Teléfono', _emergencyPhoneCtrl, keyboard: TextInputType.phone),
                ],
              ]),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2746),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Guardar y continuar', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null;

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2746))),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? keyboard, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboard ?? TextInputType.text,
            validator: validator,
            decoration: InputDecoration(
              hintText: label,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1E2746))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fecha de nacimiento', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          InkWell(
            onTap: _pickDate,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    _dateOfBirth != null
                        ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                        : 'Seleccionar fecha',
                    style: TextStyle(color: _dateOfBirth != null ? Colors.black : Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF1E2746),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
