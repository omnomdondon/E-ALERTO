import 'package:e_alerto/constants.dart';
import 'package:e_alerto/model/destination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        destinations: destinations
            .asMap()
            .entries
            .map(
              (entry) => NavigationDestination(
                icon: IconTheme(
                  data: IconThemeData(
                    color: navigationShell.currentIndex == entry.key
                        ? COLOR_PRIMARY // Selected icon color
                        : Colors.grey, // Default (unselected) color
                  ),
                  child: Icon(entry.value.outlineIcon ?? entry.value.icon),
                ),
                label: entry.value.label,
                selectedIcon: Icon(
                  entry.value.icon,
                  color: COLOR_PRIMARY, // Selected icon color
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
