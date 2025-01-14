import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  // Liste des éléments du menu
  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.home, "label": "Home", "route": "/home"},
    {"icon": Icons.person, "label": "Profile", "route": "/profile"},
    {"icon": Icons.settings, "label": "Settings", "route": "/settings"},
    {"icon": Icons.info, "label": "About", "route": "/about"},
  ];

   CustomDrawer({super.key});

  // Fonction pour naviguer vers une route
  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header du Drawer
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                SizedBox(height: 10),
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "john.doe@example.com",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          // Liste des éléments du Drawer
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Icon(item["icon"]),
                  title: Text(item["label"]),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    _navigateTo(context, item["route"]); // Navigue vers la route
                  },
                );
              },
            ),
          ),
          // Bouton Déconnexion en bas
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              // Logique pour déconnecter l'utilisateur
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully")),
              );
            },
          ),
        ],
      ),
    );
  }
}
