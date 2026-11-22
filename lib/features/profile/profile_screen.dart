import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const AppBottomNav(index: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profil', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Carte Utilisateur
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: const BoxDecoration(color: Color(0xFF1E3A8A), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text('NL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nourane Laabidi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Text('nourane.laabidi.2005@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('Modifier le profil', style: TextStyle(color: const Color(0xFF1E3A8A), fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Statistiques (3 colonnes)
              Row(
                children: [
                  Expanded(child: _statBox('3', 'Annonces')),
                  const SizedBox(width: 8),
                  Expanded(child: _statBox('12', 'Favoris')),
                  const SizedBox(width: 8),
                  Expanded(child: _statBox('5', 'Messages')),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Menu
              _menuItem(Icons.home_outlined, 'Mes annonces', () {}),
              const Divider(height: 1, indent: 50),
              _menuItem(Icons.favorite_border, 'Mes favoris', () => context.push('/favorites')),
              const Divider(height: 1, indent: 50),
              _menuItem(Icons.notifications_none, 'Notifications', () {}, trailing: Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFF14B8A6))),
              const Divider(height: 1, indent: 50),
              _menuItem(Icons.language, 'Langue', () {}, trailing: const Text('Français', style: TextStyle(color: Colors.grey))),
              const Divider(height: 1, indent: 50),
              _menuItem(Icons.dark_mode_outlined, 'Mode sombre', () {}, trailing: Switch(value: false, onChanged: (v) {}, activeColor: const Color(0xFF14B8A6))),
              
              const SizedBox(height: 24),
              
              // Déconnexion
              Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.red.shade200), borderRadius: BorderRadius.circular(12)),
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Se déconnecter', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E3A8A), size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}