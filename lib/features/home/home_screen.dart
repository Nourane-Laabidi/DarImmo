import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/listing_card.dart';
import '../../models/listing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _mode = 'sale';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openResults({String type = ''}) {
    final q = Uri.encodeQueryComponent(_search.text.trim());
    context.push('/results?mode=$_mode&q=$q&type=$type');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStore.instance,
      builder: (context, _) {
        final store = AppStore.instance;
        final near = store.near(_mode).take(6).toList();
        final recent = store.search(mode: _mode).take(4).toList();
        return Scaffold(
          backgroundColor: Ui.bg,
          bottomNavigationBar: const AppBottomNav(index: 0),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Ui.mute),
                              const SizedBox(width: 4),
                              Text('Tunis, Tunisie',
                                  style: TextStyle(color: Ui.mute, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Trouvez votre\nchez-vous',
                              style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                  color: Ui.ink)),
                        ],
                      ),
                      Stack(
                        children: [
                          Material(
                            color: Ui.card,
                            shape: const CircleBorder(),
                            child: IconButton(
                              onPressed: () => context.push('/notifications'),
                              icon: Icon(Icons.notifications_none, color: Ui.ink),
                            ),
                          ),
                          if (store.unreadNotices > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: AppColors.price, shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _search,
                          style: TextStyle(color: Ui.ink),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _openResults(),
                          decoration: InputDecoration(
                            hintText: 'Ville, quartier, adresse',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            fillColor: Ui.card,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12)),
                        child: IconButton(
                          icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                          onPressed: () => context
                              .push('/results?mode=$_mode&filters=1'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      _chip('Acheter', 'sale'),
                      _chip('Louer', 'rent'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
                  child: SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _categoryChip(Icons.apartment, 'Appartement', 'apartment'),
                        _categoryChip(Icons.home_outlined, 'Villa', 'villa'),
                        _categoryChip(Icons.grid_view, 'Terrain', 'land'),
                        _categoryChip(Icons.storefront_outlined, 'Local', 'commercial'),
                        _categoryChip(Icons.business_outlined, 'Bureau', 'office'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Près de vous',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Ui.ink)),
                      TextButton(
                        onPressed: _openResults,
                        child: const Text('Voir tout',
                            style: TextStyle(
                                color: AppColors.primary, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: near.isEmpty
                      ? Center(
                          child: Text('Aucun bien pour ce mode',
                              style: TextStyle(color: Ui.mute)))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: near.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (_, i) => ListingCard(
                            listing: near[i],
                            isFavorite: store.isFavorite(near[i].id),
                            onFavoriteTap: () => store.toggleFavorite(near[i].id),
                            onTap: () => context.push('/detail/${near[i].id}'),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text('Récemment ajoutés',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Ui.ink)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      for (final l in recent) ...[
                        ListingRow(
                          listing: l,
                          isFavorite: store.isFavorite(l.id),
                          onFavoriteTap: () => store.toggleFavorite(l.id),
                          onTap: () => context.push('/detail/${l.id}'),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String label, String value) {
    final selected = _mode == value;
    return GestureDetector(
      onTap: () => setState(() => _mode = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Ui.card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? AppColors.primary : Ui.line),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Ui.ink)),
      ),
    );
  }

  Widget _categoryChip(IconData icon, String label, String type) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _openResults(type: type),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Ui.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Ui.line)),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 12, color: Ui.ink, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
