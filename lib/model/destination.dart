
import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.label, 
    required this.icon,
    this.outlineIcon,
  });

  final String label;
  final IconData icon;
  final IconData? outlineIcon;

}

const destinations = [
  Destination(
    label: 'home', 
    icon: Icons.home,
    outlineIcon: Icons.home_outlined,
  ),
  Destination(
    label: 'search', 
    icon: Icons.search,
    outlineIcon: Icons.search_outlined,),
  Destination(
    label: 'profile', 
    icon: Icons.person,
    outlineIcon: Icons.person_outline,),
];