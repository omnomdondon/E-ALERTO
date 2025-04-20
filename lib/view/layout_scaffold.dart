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
  void _onTap(BuildContext context, int index) {
    if (index == 2) {
      // Report tab index
      // Use root navigator to push camera screen
      context.pushNamed(
        Routes.cameraPage,
        extra: {'fromNavigation': true},
      ).then((imagePath) {
        if (imagePath != null && mounted) {
          // Use shell navigator to push report screen
          widget.navigationShell.goBranch(
            2,
            initialLocation: false,
          );
        }
      });
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

// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/model/destination.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class LayoutScaffold extends StatelessWidget {
//   const LayoutScaffold({
//     required this.navigationShell,
//     Key? key,
//   }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

//   final StatefulNavigationShell navigationShell;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: navigationShell,
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: navigationShell.currentIndex,
//         onDestinationSelected: navigationShell.goBranch,
//         indicatorColor: Colors.transparent,
//         backgroundColor: Colors.white,
//         destinations: destinations
//             .asMap()
//             .entries
//             .map(
//               (entry) => NavigationDestination(
//                 icon: IconTheme(
//                   data: IconThemeData(
//                     color: navigationShell.currentIndex == entry.key
//                         ? COLOR_PRIMARY // Selected icon color
//                         : Colors.grey, // Default (unselected) color
//                   ),
//                   child: Icon(entry.value.outlineIcon ?? entry.value.icon),
//                 ),
//                 label: "", // entry.value.label,
//                 selectedIcon: Icon(
//                   entry.value.icon,
//                   color: COLOR_PRIMARY, // Selected icon color
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }
