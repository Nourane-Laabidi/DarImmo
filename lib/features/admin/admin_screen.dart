import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ==========================================
// MOCK DATA POUR L'ADMIN
// ==========================================
class _AdminAnnonce {
  final String title;
  final String author;
  final List<Color> gradient;
  final String status; // pending, active, rejected
  const _AdminAnnonce({
    required this.title,
    required this.author,
    required this.gradient,
    this.status = 'pending',
  });
}

class _AdminUser {
  final String name;
  final String email;
  final String initials;
  final String role; // client, admin
  const _AdminUser({
    required this.name,
    required this.email,
    required this.initials,
    this.role = 'client',
  });
}

const _mockAnnonces = [
  _AdminAnnonce(
    title: 'Appartement S+2 vue mer',
    author: 'Par Sami Ben Ali · Les Berges du Lac',
    gradient: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
    status: 'pending',
  ),
  _AdminAnnonce(
    title: 'Terrain constructible',
    author: 'Par Leïla Trabelsi · Hammamet',
    gradient: [Color(0xFFD97706), Color(0xFF7C3AED)],
    status: 'pending',
  ),
  _AdminAnnonce(
    title: 'Villa moderne avec piscine',
    author: 'Par Ahmed Ben Ali · La Marsa',
    gradient: [Color(0xFF0F766E), Color(0xFF1E3A8A)],
    status: 'active',
  ),
  _AdminAnnonce(
    title: 'Studio centre-ville',
    author: 'Par Karim Jebali · Tunis',
    gradient: [Color(0xFFDC2626), Color(0xFF7C3AED)],
    status: 'pending',
  ),
];

const _mockUsers = [
  _AdminUser(name: 'Nourane Laabidi', email: 'nourane.laabidi.2005@gmail.com', initials: 'NL'),
  _AdminUser(name: 'Sami Ben Ali', email: 'sami.benali@gmail.com', initials: 'SB'),
  _AdminUser(name: 'Leïla Trabelsi', email: 'leila.trabelsi@yahoo.fr', initials: 'LT'),
  _AdminUser(name: 'Karim Jebali', email: 'karim.jebali@gmail.com', initials: 'KJ'),
  _AdminUser(name: 'Ahmed Ben Ali', email: 'ahmed.benali@hotmail.com', initials: 'AB'),
];

// ==========================================
// ADMIN SCREEN PRINCIPAL
// ==========================================
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            _DashboardTab(),
            _AnnoncesTab(),
            _UtilisateursTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B1121),
        selectedItemColor: const Color(0xFF14B8A6),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tableau'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Annonces'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Utilisateurs'),
        ],
      ),
    );
  }
}

// ==========================================
// ONGLET 1 : TABLEAU DE BORD
// ==========================================
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, 'Espace administrateur', 'Tableau de bord'),
          const SizedBox(height: 20),
          Row(
            children: [
              _statCard('Utilisateurs', '${_mockUsers.length}'),
              const SizedBox(width: 12),
              _statCard('Annonces actives', '${_mockAnnonces.where((a) => a.status == 'active').length}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('À valider', '${_mockAnnonces.where((a) => a.status == 'pending').length}',
                  color: const Color(0xFF14B8A6)),
              const SizedBox(width: 12),
              _statCard('Signalements', '0', color: const Color(0xFFF87171)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Annonces à valider',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 12),
          ..._mockAnnonces
              .where((a) => a.status == 'pending')
              .map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _annonceCard(context, a),
                  )),
        ],
      ),
    );
  }
}

// ==========================================
// ONGLET 2 : ANNONCES
// ==========================================
class _AnnoncesTab extends StatefulWidget {
  const _AnnoncesTab();
  @override
  State<_AnnoncesTab> createState() => _AnnoncesTabState();
}

class _AnnoncesTabState extends State<_AnnoncesTab> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all'
        ? _mockAnnonces
        : _mockAnnonces.where((a) => a.status == _filter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, 'Espace administrateur', 'Annonces'),
          const SizedBox(height: 20),
          // Filtres
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Toutes', 'all'),
                const SizedBox(width: 8),
                _filterChip('En attente', 'pending'),
                const SizedBox(width: 8),
                _filterChip('Actives', 'active'),
                const SizedBox(width: 8),
                _filterChip('Refusées', 'rejected'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('${filtered.length} annonce${filtered.length > 1 ? 's' : ''}',
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 12),
          ...filtered.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _annonceCard(context, a),
              )),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF14B8A6) : const Color(0xFF131C2F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF14B8A6) : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ONGLET 3 : UTILISATEURS
// ==========================================
class _UtilisateursTab extends StatefulWidget {
  const _UtilisateursTab();
  @override
  State<_UtilisateursTab> createState() => _UtilisateursTabState();
}

class _UtilisateursTabState extends State<_UtilisateursTab> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _mockUsers
        .where((u) =>
            u.name.toLowerCase().contains(_search.text.toLowerCase()) ||
            u.email.toLowerCase().contains(_search.text.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, 'Espace administrateur', 'Utilisateurs'),
          const SizedBox(height: 20),
          // Barre de recherche
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Rechercher un utilisateur...',
              hintStyle: const TextStyle(color: Colors.white30),
              prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
              filled: true,
              fillColor: const Color(0xFF131C2F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('${filtered.length} utilisateur${filtered.length > 1 ? 's' : ''}',
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 12),
          ...filtered.map((u) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _userTile(context, u),
              )),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGETS PARTAGÉS
// ==========================================
Widget _header(BuildContext context, String subtitle, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          Text(title,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () => context.go('/login'),
      ),
    ],
  );
}

Widget _statCard(String title, String value, {Color color = Colors.white}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    ),
  );
}

Widget _annonceCard(BuildContext context, _AdminAnnonce a) {
  final isPending = a.status == 'pending';
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF131C2F),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: a.gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.home_work_outlined, color: Colors.white54, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(a.author,
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  _statusBadge(a.status),
                ],
              ),
            ),
          ],
        ),
        if (isPending) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${a.title} approuvée')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6).withOpacity(0.2),
                    foregroundColor: const Color(0xFF14B8A6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Approuver'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${a.title} refusée')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF87171),
                    side: const BorderSide(color: Color(0xFFF87171)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Refuser'),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _statusBadge(String status) {
  Color color;
  String label;
  switch (status) {
    case 'active':
      color = const Color(0xFF14B8A6);
      label = 'Active';
      break;
    case 'rejected':
      color = const Color(0xFFF87171);
      label = 'Refusée';
      break;
    default:
      color = const Color(0xFFF59E0B);
      label = 'En attente';
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
  );
}

Widget _userTile(BuildContext context, _AdminUser u) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF131C2F),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFF1E3A8A),
          child: Text(u.initials,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(u.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(u.email, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
          color: const Color(0xFF131C2F),
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$value pour ${u.name}')),
            );
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
                value: 'Voir profil',
                child: Text('Voir profil', style: TextStyle(color: Colors.white))),
            PopupMenuItem(
                value: 'Bloquer',
                child: Text('Bloquer', style: TextStyle(color: Color(0xFFF87171)))),
          ],
        ),
      ],
    ),
  );
}