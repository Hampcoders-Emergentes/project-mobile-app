import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mi Inventario Técnico', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2746))),
            const Text('Gestión jerárquica de componentes y stock.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),

            // Botón Crear Componente
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2746),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Crear Nuevo Tipo/Componente', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),

            // Card Valoración Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          const Text('Valoración Total del Inventario', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic, // Corregido: sintaxis correcta para alineación base
                        children: [
                          const Text('\$12,450.00', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E2746))),
                          const SizedBox(width: 4),
                          Text('USD', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildMiniStat('Total items', '342', null),
                          const SizedBox(width: 24),
                          _buildMiniStat('Alertas de Stock', '3', Colors.orangeAccent),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.archive_outlined, color: Color(0xFF1E2746)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Listas Desplegables (ExpansionTile)
            _buildCategoryTile(
              index: '1.',
              title: 'Protecciones Eléctricas',
              subtitle: 'Interruptores, diferenciales, fusibles',
              icon: Icons.shield_outlined,
              initiallyExpanded: true,
              children: [
                _buildComponentItem('Interruptor Termomagnético 20A', 'Cod: PR-TM-20A-01', '15 ud', 'Mín: 10', 'Óptimo', const Color(0xFFE0F2F1), const Color(0xFF00796B)),
                _buildComponentItem('Interruptor Diferencial 30mA 2P', 'Cod: PR-DF-30M-02', '2 ud', 'Mín: 5', 'Bajo', const Color(0xFFFFF3E0), const Color(0xFFE65100), hasAlert: true),
              ],
            ),
            const SizedBox(height: 12),
            _buildCategoryTile(
              index: '2.',
              title: 'Conductores y Cableado',
              subtitle: 'Cables unifilares, mangueras, tubos',
              icon: Icons.cable,
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color? valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Row(
          children: [
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            if (valueColor != null) ...[ // Corregido el caracter extraño '尊null'
              const SizedBox(width: 4),
              Icon(Icons.warning_amber_rounded, size: 12, color: valueColor),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryTile({required String index, required String title, required String subtitle, required IconData icon, bool initiallyExpanded = false, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF5F8FF), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF1E2746)),
          ),
          title: Text('$index $title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2746))),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          children: paddingAll(children),
        ),
      ),
    ); // Corregido: Llaves de cierre alineadas y estructuradas de forma correcta
  }

  List<Widget> paddingAll(List<Widget> children) {
    return children.map((w) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: w)).toList();
  }

  Widget _buildComponentItem(String name, String code, String qty, String min, String tag, Color tagBg, Color tagColor, {bool hasAlert = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hasAlert ? const Color(0xFFFFE0B2) : Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(code, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(qty, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: hasAlert ? Colors.red : Colors.black87)),
                  const SizedBox(width: 8),
                  Text(min, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(Icons.circle, size: 6, color: tagColor),
                const SizedBox(width: 4),
                Text(tag, style: TextStyle(color: tagColor, fontWeight: FontWeight.bold, fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }
}