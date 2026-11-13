import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final VoidCallback onPublishTap;

  const ServicesScreen({super.key, required this.onPublishTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado del Servicio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Servicio #4582',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2746)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: Color(0xFF00BFA5)),
                        const SizedBox(width: 6),
                        const Text('In Progress', style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                  child: const Text('BC Ops', style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Botón de acceso rápido para Publicar Servicio (para pruebas de flujo)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onPublishTap,
                icon: const Icon(Icons.add, color: Color(0xFF1E2746)),
                label: const Text('Publicar Nuevo Servicio de Catálogo', style: TextStyle(color: Color(0xFF1E2746))),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF1E2746))),
              ),
            ),
            const SizedBox(height: 15),

            // Tarjeta de Lecturas IoT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2746),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.wifi_tethering, color: Colors.white70, size: 18),
                          const SizedBox(width: 8),
                          const Text('IOT LIVE READINGS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 6, color: Color(0xFF00BFA5)),
                            const SizedBox(width: 4),
                            const Text('Syncing', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIotMetric('Voltage', '218', 'V'),
                      _buildIotMetric('Current', '12.5', 'A'),
                      _buildIotMetric('Power Factor', '0.92', ''),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Tarjeta Relay Control
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Relay Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text('Caution: Ensure load is verified before altering circuit state.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5350),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.power_settings_new),
                      label: const Text('Cortar Circuito (OPEN)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Tarjeta Photo Log
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PHOTO LOG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPhotoPlaceholder('Antes'),
                      Container(
                        width: 90,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: NetworkImage('https://via.placeholder.com/150'), // Simulación de la foto del tablero
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      _buildPhotoPlaceholder('Después'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Report Notes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TECHNICAL REPORT NOTES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Icon(Icons.edit_note, color: Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter diagnostic findings, parts replaced, or general observations...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón de Finalizar Servicio
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Finalizar Servicio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIotMetric(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic, //  CORREGIDO
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(unit, style: const TextStyle(color: Colors.white60, fontSize: 14)),
            ]
          ],
        )
      ],
    );
  }

  Widget _buildPhotoPlaceholder(String label) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}