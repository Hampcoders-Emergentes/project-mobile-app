// lib/features/company/presentation/screens/company_profile_page.dart

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_top_bar.dart';

class CompanyProfilePage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const CompanyProfilePage({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(onMenuTap: onMenuTap),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Perfil Corporativo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildMenuSection('General', [
                  _buildMenuItem(Icons.business, 'Sedes Corporativas'),
                  _buildMenuItem(Icons.settings, 'Configuración de la Cuenta'),
                ]),
                const SizedBox(height: 24),
                _buildMenuSection('Administración', [
                  _buildMenuItem(Icons.people, 'Gestión de Usuarios'),
                  _buildMenuItem(Icons.credit_card, 'Suscripción'),
                ]),
                const SizedBox(height: 24),
                _buildMenuSection('Soporte', [
                  _buildMenuItem(Icons.help, 'Centro de Ayuda'),
                  _buildMenuItem(Icons.exit_to_app, 'Cerrar Sesión',
                      isLogout: true),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return const Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              // Utiliza una imagen de perfil real si la tienes, o un placeholder
              // backgroundImage: NetworkImage(profileImageUrl),
              backgroundColor: Colors.grey,
              child: Icon(Icons.business, size: 30, color: Colors.white),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Facility Manager',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('ElectroLink Enterprise'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : null),
      title: Text(
        title,
        style: isLogout ? const TextStyle(color: Colors.red) : null,
      ),
      trailing: isLogout
          ? null
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}