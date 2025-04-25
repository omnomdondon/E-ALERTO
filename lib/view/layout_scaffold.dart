import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/model/destination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  void _onTap(BuildContext context, int index) async {
    if (index == 2) {
      // Report tab index
      // Step 1: Push the camera screen using root navigator
      final imagePath = await context.push<String>(Routes.reportCamera);

      // Step 2: If photo captured, push ReportScreen with image path
      if (imagePath != null && mounted) {
        context.goNamed(
          'report',
          extra: imagePath,
        );
      } else {
        // User cancelled camera: return to previous report screen (if needed)
        widget.navigationShell.goBranch(2);
      }
    } else {
      widget.navigationShell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        destinations: destinations
            .asMap()
            .entries
            .map(
              (entry) => NavigationDestination(
                icon: IconTheme(
                  data: IconThemeData(
                    color: widget.navigationShell.currentIndex == entry.key
                        ? COLOR_PRIMARY
                        : Colors.grey,
                  ),
                  child: Icon(entry.value.outlineIcon ?? entry.value.icon),
                ),
                label: "",
                selectedIcon: Icon(
                  entry.value.icon,
                  color: COLOR_PRIMARY,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
