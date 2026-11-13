import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/features/auth/presentation/screens/auth_screen.dart';

class TechnicalDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onMenuSelected;

  const TechnicalDrawer({
    super.key,
    required this.currentIndex,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Encabezado del menú (Perfil del Técnico)
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1E2746),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'L',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E2746)),
                ),
              ),
              accountName: const Text(
                'Luis Sanchez',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text(
                'tecnico@electrolink.com',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),

            // Opciones del Menú Coincidentes con el Dashboard e Index
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.grid_view,
              title: 'Mi Catálogo',
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.build_outlined,
              title: 'Servicios',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.inventory_2_outlined,
              title: 'Inventario',
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.person_outline,
              title: 'Mi Perfil',
              index: 4,
            ),

            const Divider(),
            const Spacer(),

            // Opción de Cerrar Sesión al final
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear los elementos del menú con estado activo/inactivo
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF1E2746) : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF1E2746) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFF5F8FF),
      onTap: () => onMenuSelected(index), // Llama al callback pasando el índice seleccionado
    );
  }
}