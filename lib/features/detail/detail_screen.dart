import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/store.dart';
import '../../core/theme.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _more = false;
  int _photo = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStore.instance,
      builder: (context, _) {
        final store = AppStore.instance;
        final l = store.byId(widget.id);
        if (l == null) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Annonce introuvable'),
              ),
            ),
          );
        }
        final fav = store.isFavorite(l.id);
        final desc = l.description;
        final short = desc.length > 120 && !_more ? '${desc.substring(0, 120)}…' : desc;
        return Scaffold(
          backgroundColor: Ui.bg,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: l.images.isEmpty ? 1 : l.images.length,
                            onPageChanged: (i) => setState(() => _photo = i),
                            itemBuilder: (_, i) {
                              if (l.images.isEmpty) {
                                return Container(color: AppColors.primary);
                              }
                              return CachedNetworkImage(
                                imageUrl: l.images[i],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.primary,
                                  child: const Icon(Icons.home_work_outlined,
                                      color: Colors.white54, size: 72),
                                ),
                              );
                            },
                          ),
                          if (l.images.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var i = 0; i < l.images.length; i++)
                                    Container(
                                      width: 7,
                                      height: 7,
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: i == _photo
                                            ? Colors.white
                                            : Colors.white54,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(l.priceLabel,
                                    style: const TextStyle(
                                        color: AppColors.price,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF14B8A6).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(l.isSale ? 'À vendre' : 'À louer',
                                    style: const TextStyle(
                                        color: Color(0xFF0F766E),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(l.title,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Ui.ink)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Icon(Icons.location_on, color: Ui.mute, size: 16),
                            const SizedBox(width: 4),
                            Text('${l.address}, ${l.city}',
                                style: TextStyle(color: Ui.mute)),
                          ]),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _spec('${l.bedrooms}', 'Chambres'),
                              const SizedBox(width: 8),
                              _spec('${l.bathrooms}', 'Salles de bain'),
                              const SizedBox(width: 8),
                              _spec('${l.surface}', 'm²'),
                              if (l.land > 0) ...[
                                const SizedBox(width: 8),
                                _spec('${l.land}', 'm² terrain'),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Ui.ink)),
                          const SizedBox(height: 8),
                          Text(short,
                              style: TextStyle(color: Ui.mute, height: 1.5)),
                          if (desc.length > 120)
                            TextButton(
                              onPressed: () => setState(() => _more = !_more),
                              child: Text(_more ? 'Voir moins' : 'Voir plus'),
                            ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Ui.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Ui.line),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    l.ownerName
                                        .trim()
                                        .split(' ')
                                        .where((p) => p.isNotEmpty)
                                        .map((p) => p[0])
                                        .take(2)
                                        .join()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l.ownerName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Ui.ink)),
                                    Text('Propriétaire',
                                        style: TextStyle(color: Ui.mute, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _round(
                        Icons.arrow_back,
                        () => context.canPop() ? context.pop() : context.go('/'),
                      ),
                      _round(
                        fav ? Icons.favorite : Icons.favorite_border,
                        () => store.toggleFavorite(l.id),
                        color: AppColors.price,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Ui.card,
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Appeler'),
                                  content: Text('${l.ownerName}\n${l.phone}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Fermer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Appeler',
                                style: TextStyle(
                                    color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final id = store.ensureThread(l);
                              context.push('/chat/$id');
                            },
                            child: const Text('Contacter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _round(IconData icon, VoidCallback onTap, {Color? color}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: color ?? Colors.black),
      ),
    );
  }

  Widget _spec(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Ui.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Ui.line),
        ),
        child: Column(
          children: [
            Text(val,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Ui.ink)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Ui.mute, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
