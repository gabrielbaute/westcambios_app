import 'package:flutter/material.dart';
import '../../themes/west_themes.dart';

class WestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const WestAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 2,
      // Usamos el color de tu tema
      backgroundColor: WestColors.orangePrimary,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ), // Para que el icono del Drawer sea blanco
    );
  }

  // Este es el requisito de PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
