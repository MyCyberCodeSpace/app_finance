import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar mainAppBar({
  required BuildContext context,
  required String text,
  bool showMenuButton = true,
}) {
  return AppBar(
    title: Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    ),
    centerTitle: false,
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColorBlack,
      ),
    ),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    automaticallyImplyLeading: true,
    actions: showMenuButton
        ? [
            Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip: 'Menu',
                ),
              ),
            ),
          ]
        : null,
  );
}

class TwoLineMenuIcon extends StatelessWidget {
  const TwoLineMenuIcon({super.key});

  final Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(height: 2.5, width: 24, color: color),
          const SizedBox(height: 6),
          Container(height: 2, width: 12, color: color),
        ],
      ),
    );
  }
}
