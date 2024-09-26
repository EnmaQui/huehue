import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String) onFilterSelected;

  const CustomDrawer({required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Categorías',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Iglesias'),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
              onFilterSelected('church');
            },
          ),
          ListTile(
            title: Text('Museos'),
            onTap: () {
              Navigator.pop(context);
              onFilterSelected('museum');
            },
          ),
          ListTile(
            title: Text('Parques'),
            onTap: () {
              Navigator.pop(context);
              onFilterSelected('park');
            },
          ),
          ListTile(
            title: Text('Playas'), // Opción de Playas
            onTap: () {
              Navigator.pop(context);
              onFilterSelected('beach'); // Cambia el valor según sea necesario
            },
          ),
          ListTile(
            title: Text('Galeria de arte'), // Opción de Playas
            onTap: () {
              Navigator.pop(context);
              onFilterSelected('art_gallery'); // Cambia el valor según sea necesario
            },
          ),
          ListTile(
            title: Text('Estadio'), // Opción de Playas
            onTap: () {
              Navigator.pop(context);
              onFilterSelected('stadium'); // Cambia el valor según sea necesario
            },
          ),
        ],
      ),
    );
  }
}
