import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/company/presentation/screens/company_profile_page.dart';
import '../../features/company/presentation/screens/company_services_page.dart';
import '../../features/company/presentation/widgets/company_drawer.dart';
import '../../features/dashboard/presentation/widgets/dashboard_drawer.dart';
import '../../features/iot_dashboard/data/repositories/iot_dashboard_repository_impl.dart';
import '../../features/iot_dashboard/presentation/bloc/iot_dashboard_bloc.dart';
import '../../features/iot_dashboard/presentation/bloc/iot_dashboard_event.dart';
import '../../features/iot_dashboard/presentation/pages/iot_home_tab.dart';
import '../../features/iot_dashboard/presentation/pages/iot_monitoring_tab.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/service_request/presentation/pages/service_request_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../enums/user_role.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../theme/app_theme.dart';
import 'app_bottom_nav_bar.dart';

/// Shell único para homeowner y company.
///
/// El dashboard y el monitoreo IoT son compartidos (mismo ownerId neutral
/// contra el backend); el rol solo decide drawer y páginas secundarias.
class MainShell extends StatefulWidget {
  final UserRole role;
  final int initialIndex;

  const MainShell({super.key, required this.role, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _selectedIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  bool get _isCompany => widget.role == UserRole.company;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IotDashboardBloc(
        repository: IotDashboardRepositoryImpl(
          ApiClient(baseUrl: ApiEndpoints.baseUrl),
          role: widget.role,
        ),
      )..add(const FetchIotDashboard()),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _isCompany
            ? CompanyDrawer(
                currentIndex: _selectedIndex,
                onNavigateToTab: _onTabSelected,
              )
            : DashboardDrawer(onNavigateToTab: _onTabSelected),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              IotHomeTab(onMenuTap: _openDrawer),
              _isCompany
                  ? CompanyServicesPage(onMenuTap: _openDrawer)
                  : ServicesPage(onMenuTap: _openDrawer),
              IotMonitoringTab(onMenuTap: _openDrawer),
              _isCompany
                  ? CompanyProfilePage(onMenuTap: _openDrawer)
                  : ProfilePage(onMenuTap: _openDrawer),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
        ),
        // Un solo FAB: nueva solicitud desde Servicios. Añadir dispositivo
        // vive en el header del tab IoT.
        floatingActionButton: _selectedIndex == 1
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ServiceRequestPage()),
                  );
                },
                backgroundColor: AppColors.primaryBlue,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
