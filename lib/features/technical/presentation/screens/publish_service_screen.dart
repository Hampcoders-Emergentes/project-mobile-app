import 'package:flutter/material.dart';

class PublishServiceScreen extends StatefulWidget {
  const PublishServiceScreen({super.key});

  @override
  State<PublishServiceScreen> createState() => _PublishServiceScreenState();
}

class _PublishServiceScreenState extends State<PublishServiceScreen> {
  bool requiresIot = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2746)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Publicar Servicio', style: TextStyle(color: Color(0xFF1E2746), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección Información General
            _buildFormCard(
              icon: Icons.info_outline,
              title: 'Información General',
              children: [
                _buildInputField('Nombre del Servicio', 'ej. Instalación de Tablero IoT'),
                _buildDropdownField('Categoría (EServiceCategory)'),
                _buildInputField('Tiempo Estimado', 'ej. 2h 30m', prefixIcon: Icons.access_time),
                _buildInputField('Descripción de la Intervención', 'Detalla los procedimientos y resultados esperados...', maxLines: 3),
              ],
            ),
            const SizedBox(height: 14),

            // Tarifa Base
            _buildFormCard(
              icon: Icons.payments_outlined,
              title: 'Tarifa Base',
              children: [
                _buildInputField('Precio (Money)', '0.00', prefixText: '\$ ', suffixText: 'PEN'),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('Monto antes de impuestos y viáticos.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                )
              ],
            ),
            const SizedBox(height: 14),

            // Certificación IoT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.sensors, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Certificación IoT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          'Habilita esta opción si el servicio requiere configuración de telemetría o dispositivos inteligentes.',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: requiresIot,
                    activeThumbColor: Colors.blue,
                    onChanged: (val) => setState(() => requiresIot = val),
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Componentes necesarios
            _buildFormCard(
              icon: Icons.construction_outlined,
              title: 'Componentes',
              trailing: TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 14), label: const Text('Añadir', style: TextStyle(fontSize: 12))),
              children: [
                Text('Lista de materiales requeridos para la ejecución.', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(1.5), 2: FlexColumnWidth(1.5)},
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('ITEM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('CANT.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('ACCIÓN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                      ],
                    ),
                    _buildTableRowData('Cable THW AWG 10', '15m'),
                    _buildTableRowData('Breaker 20A', '2u'),
                    _buildTableRowData('Módulo Smart Relay', '1u'),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required IconData icon, required String title, Widget? trailing, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF1E2746), size: 18),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2746))),
                ],
              ),
              ?trailing,
            ],
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {IconData? prefixIcon, String? prefixText, String? suffixText, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
          const SizedBox(height: 6),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : (prefixText != null ? Container(alignment: Alignment.center, width: 20, child: Text(prefixText)) : null),
              suffixIcon: suffixText != null ? Container(alignment: Alignment.center, width: 40, child: Text(suffixText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
            hint: const Text('Selecciona una categoría...', style: TextStyle(fontSize: 13, color: Colors.grey)),
            items: const [],
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRowData(String item, String cant) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: Text(item, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: Text(cant, style: const TextStyle(fontSize: 12))),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints()
          ),
        ),
      ],
    );
  }
}