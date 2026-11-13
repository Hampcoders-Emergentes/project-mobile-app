import 'package:flutter/material.dart';
import '../widgets/technical_drawer.dart';
import '../widgets/agenda_card.dart';
import 'services_screen.dart';
import 'inventory_screen.dart';
import 'publish_service_screen.dart';

class TechnicalDashboardScreen extends StatefulWidget {
  const TechnicalDashboardScreen({super.key});

  @override
  State<TechnicalDashboardScreen> createState() => _TechnicalDashboardScreenState();
}

class _TechnicalDashboardScreenState extends State<TechnicalDashboardScreen> {
  bool isAvailable = true;
  int _selectedIndex = 0;

  // Función para cambiar de índice y cerrar el Drawer automáticamente si estuviera abierto
  void _onSectionSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Validamos de forma segura si el Drawer está desplegado para cerrarlo
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Método auxiliar para navegar al formulario de Publicar Servicio
  void _navigateToPublishScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PublishServiceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definimos qué cuerpo (body) renderizar según el índice activo
    final List<Widget> screens = [
      _buildHomeBody(),                                                 // Índice 0: Home
      const Center(child: Text('Mi Catálogo (Próximamente)', style: TextStyle(color: Color(0xFF1E2746), fontWeight: FontWeight.bold))), // Índice 1: Catálogo
      ServicesScreen(onPublishTap: _navigateToPublishScreen),           // Índice 2: Servicios
      const InventoryScreen(),                                          // Índice 3: Inventario
      const Center(child: Text('Profile (Próximamente)', style: TextStyle(color: Color(0xFF1E2746), fontWeight: FontWeight.bold))),    // Índice 4: Perfil
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      // Pasamos las variables requeridas al Drawer para sincronizar la selección lateral
      drawer: TechnicalDrawer(
        currentIndex: _selectedIndex,
        onMenuSelected: _onSectionSelected,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E2746)),
        title: const Text('ElectroLink', style: TextStyle(color: Color(0xFF1E2746), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_outlined), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          )
        ],
      ),
      body: screens[_selectedIndex], // Muestra la pantalla correspondiente
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1E2746),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () {},
      )
          : null, // El botón flotante solo se muestra en el Home principal
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E2746),
        unselectedItemColor: Colors.grey,
        onTap: _onSectionSelected, // Sincroniza la barra inferior
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Catalogo'),
          BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Servicios'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Inventario'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // Contenido del Home original separado
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hello, Luis!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E2746))),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF00BFA5)),
                    SizedBox(width: 8),
                    Text('Disponible para trabajos', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Switch(
                  value: isAvailable,
                  activeThumbColor: const Color(0xFF00BFA5),
                  onChanged: (value) => setState(() => isAvailable = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildMetricCard('TRABAJOS HOY', '3', null)),
              const SizedBox(width: 15),
              Expanded(child: _buildMetricCard('GANANCIAS MES', 'S/2,480', const Color(0xFF00BFA5))),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFE0B2))),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('2 componentes con stock bajo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E2746),
                          elevation: 0,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                        onPressed: () => _onSectionSelected(3), // Redirige directamente al Inventario
                        child: const Text('Ver Inventario', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Agenda", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2746))),
              TextButton(onPressed: () {}, child: const Text('Ver todo', style: TextStyle(color: Colors.blue))),
            ],
          ),
          const SizedBox(height: 10),
          const AgendaCard(time: '9:00 AM', clientName: 'Ana Torres', address: 'Av. Los Conquistadores 124', status: 'En curso'),
          const AgendaCard(time: '12:00 PM', clientName: 'Roberto Silva', address: 'Calle Las Palmeras 402', status: 'Pendiente'),
          const AgendaCard(time: '3:30 PM', clientName: 'María López', address: 'Mz A Lote 15, Surco', status: 'Pendiente'),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color? valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: valueColor ?? const Color(0xFF1E2746))),
        ],
      ),
    );
  }
}