import 'package:flutter/material.dart';
import 'package:client_app/ui/pages/notifications_page.dart';
import 'package:client_app/ui/components/navigation/custom_drawer.dart';
import 'package:client_app/ui/components/navigation/custom_bottom_nav.dart';
import 'package:client_app/ui/components/navigation/custom_app_bar.dart';
import 'package:client_app/services/calc_service.dart';
import 'package:client_app/ui/pages/calculator_page.dart';
import 'package:client_app/services/notification_service.dart';
import 'package:client_app/ui/pages/history_page.dart';

class MainLayout extends StatefulWidget {
  final CalcService calcService;
  // 2. Añadimos el servicio al constructor para recibirlo desde el main
  final NotificationService notificationService;

  const MainLayout({
    super.key,
    required this.calcService,
    required this.notificationService,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 3. Ahora usamos widget.notificationService inyectado
    _pages = [
      CalculatorPage(calcService: widget.calcService),
      HistoryPage(apiClient: widget.calcService.apiClient),
      NotificationsPage(notificationService: widget.notificationService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WestAppBar(title: "WestCambios"),
      drawer: CustomDrawer(apiClient: widget.calcService.apiClient),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTabChange: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
