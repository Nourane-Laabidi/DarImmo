import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../models/listing.dart';

class ResultsScreen extends StatefulWidget {
  final String mode;
  final String query;
  final String initialType;
  final bool openFilters;
  const ResultsScreen({
    super.key,
    this.mode = 'sale',
    this.query = '',
    this.initialType = '',
    this.openFilters = false,
  });
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late String _mode;
  late String _type;
  late String _query;
  double _minPrice = 0;
  double _maxPrice = 1000000;
  int _minBeds = 0;
  bool _around = false;
  double _radius = 10;
  String _sort = 'recent';
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    _type = widget.initialType;
    _query = widget.query;
    _search.text = widget.query;
    if (_mode == 'rent') _maxPrice = 5000;
    if (widget.openFilters) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openFilters());
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Listing> get _filtered => AppStore.instance.search(
        mode: _mode,
        type: _type,
        query: _query,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minBeds: _minBeds,
        aroundMe: _around,
        radiusKm: _radius,
        sort: _sort,
      );

  int get _filterCount {
    var n = 0;
    if (_type.isNotEmpty) n++;
    final cap = _mode == 'rent' ? 5000 : 1000000;
    if (_minPrice > 0 || _maxPrice < cap) n++;
    if (_minBeds > 0) n++;
    if (_around) n++;
    if (_sort != 'recent') n++;
    return n;
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<_Draft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Ui.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _FilterSheet(
        draft: _Draft(
          mode: _mode,
          type: _type,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          beds: _minBeds,
          around: _around,
          radius: _radius,
          sort: _sort,
          query: _query,
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      _mode = result.mode;
      _type = result.type;
      _minPrice = result.minPrice;
      _maxPrice = result.maxPrice;
      _minBeds = result.beds;
      _around = result.around;
      _radius = result.radius;
      _sort = result.sort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStore.instance,
      builder: (context, _) {
        final items = _filtered;
        final store = AppStore.instance;
        return Scaffold(
          backgroundColor: Ui.bg,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Material(
                        color: Ui.card,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Ui.ink, size: 20),
                          onPressed: () =>
                              context.canPop() ? context.pop() : context.go('/'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          style: TextStyle(color: Ui.ink),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (v) => setState(() => _query = v.trim()),
                          decoration: InputDecoration(
                            hintText: 'Ville, quartier, adresse',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            filled: true,
                            fillColor: Ui.card,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Ui.line),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    children: [
                      GestureDetector(
                        onTap: _openFilters,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              const Icon(Icons.tune, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                  'Filtres${_filterCount > 0 ? ' · $_filterCount' : ''}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _chip(_mode == 'rent' ? 'Location' : 'Vente', () {}),
                      if (_type.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _chip(_typeLabel(_type), () => setState(() => _type = '')),
                      ],
                      if (_maxPrice < (_mode == 'rent' ? 5000 : 1000000)) ...[
                        const SizedBox(width: 8),
                        _chip('< ${_fmt(_maxPrice)}', () => setState(() {
                              _maxPrice = _mode == 'rent' ? 5000 : 1000000;
                            })),
                      ],
                      if (_minBeds > 0) ...[
                        const SizedBox(width: 8),
                        _chip('$_minBeds+ ch', () => setState(() => _minBeds = 0)),
                      ],
                      if (_around) ...[
                        const SizedBox(width: 8),
                        _chip('${_radius.round()} km', () => setState(() => _around = false)),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${items.length} biens trouvés',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                            color: Ui.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Ui.line)),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Ui.line,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text('Liste',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Ui.ink)),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/map'),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text('Carte',
                                    style: TextStyle(fontSize: 12, color: Ui.mute)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text('Aucun bien ne correspond aux filtres',
                              style: TextStyle(color: Ui.mute)))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (_, i) =>
                              _card(items[i], store.isFavorite(items[i].id), store),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Ui.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Ui.line)),
        child: Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Ui.ink)),
      ),
    );
  }

  Widget _card(Listing l, bool fav, AppStore store) {
    return GestureDetector(
      onTap: () => context.push('/detail/${l.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Ui.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _thumb(l),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Text(l.isSale ? 'À vendre' : 'À louer',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => store.toggleFavorite(l.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration:
                          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(fav ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.price, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.priceLabel,
                          style: const TextStyle(
                              color: AppColors.price,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text(l.city, style: TextStyle(color: Ui.mute, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(l.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15, color: Ui.ink)),
                  const SizedBox(height: 4),
                  Text('${l.bedrooms} ch   ${l.bathrooms} sdb   ${l.surface} m²',
                      style: TextStyle(color: Ui.mute, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumb(Listing l) {
    final url = l.imageUrl;
    if (url == null) {
      return Container(
        height: 160,
        color: AppColors.primary,
        child: const Icon(Icons.home_work_outlined, color: Colors.white54, size: 50),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(
        height: 160,
        color: AppColors.primary,
        child: const Icon(Icons.home_work_outlined, color: Colors.white54, size: 50),
      ),
    );
  }
}

String _typeLabel(String type) => switch (type) {
      'apartment' => 'Appartement',
      'villa' => 'Villa',
      'land' => 'Terrain',
      'commercial' => 'Local',
      'office' => 'Bureau',
      _ => type,
    };

String _fmt(double v) {
  final s = v.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}

class _Draft {
  String mode;
  String type;
  double minPrice;
  double maxPrice;
  int beds;
  bool around;
  double radius;
  String sort;
  String query;
  _Draft({
    required this.mode,
    required this.type,
    required this.minPrice,
    required this.maxPrice,
    required this.beds,
    required this.around,
    required this.radius,
    required this.sort,
    required this.query,
  });
}

class _FilterSheet extends StatefulWidget {
  final _Draft draft;
  const _FilterSheet({required this.draft});
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _Draft d;
  @override
  void initState() {
    super.initState();
    d = widget.draft;
  }

  double get _cap => d.mode == 'rent' ? 5000 : 1000000;

  int get _count => AppStore.instance
      .search(
        mode: d.mode,
        type: d.type,
        query: d.query,
        minPrice: d.minPrice,
        maxPrice: d.maxPrice.clamp(0, _cap),
        minBeds: d.beds,
        aroundMe: d.around,
        radiusKm: d.radius,
        sort: d.sort,
      )
      .length;

  void _reset() {
    setState(() {
      d.type = '';
      d.minPrice = 0;
      d.maxPrice = _cap;
      d.beds = 0;
      d.around = false;
      d.radius = 10;
      d.sort = 'recent';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (d.maxPrice > _cap) d.maxPrice = _cap;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: SizedBox(width: 40, child: Divider(thickness: 4))),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtres',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Ui.ink)),
                TextButton(onPressed: _reset, child: const Text('Réinitialiser')),
              ],
            ),
            Text('Transaction', style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _modeBtn('Acheter', 'sale')),
                const SizedBox(width: 10),
                Expanded(child: _modeBtn('Louer', 'rent')),
              ],
            ),
            const SizedBox(height: 16),
            Text('Type de bien', style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in const {
                  'apartment': 'Appartement',
                  'villa': 'Villa',
                  'land': 'Terrain',
                  'commercial': 'Local',
                  'office': 'Bureau',
                }.entries)
                  ChoiceChip(
                    label: Text(e.value),
                    selected: d.type == e.key,
                    onSelected: (_) =>
                        setState(() => d.type = d.type == e.key ? '' : e.key),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Prix  ${_fmt(d.minPrice)} – ${_fmt(d.maxPrice)} DT',
                style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
            RangeSlider(
              values: RangeValues(d.minPrice.clamp(0, _cap), d.maxPrice.clamp(0, _cap)),
              min: 0,
              max: _cap,
              divisions: d.mode == 'rent' ? 50 : 100,
              onChanged: (v) => setState(() {
                d.minPrice = v.start;
                d.maxPrice = v.end;
              }),
            ),
            Text('Chambres', style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final n in [1, 2, 3, 4])
                  ChoiceChip(
                    label: Text(n == 4 ? '4+' : '$n'),
                    selected: d.beds == n,
                    onSelected: (_) => setState(() => d.beds = d.beds == n ? 0 : n),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Autour de moi', style: TextStyle(color: Ui.ink)),
              subtitle: Text('Position simulée : Tunis centre',
                  style: TextStyle(color: Ui.mute, fontSize: 12)),
              value: d.around,
              onChanged: (v) => setState(() => d.around = v),
            ),
            if (d.around)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rayon ${d.radius.round()} km', style: TextStyle(color: Ui.ink)),
                  Slider(
                    value: d.radius,
                    min: 2,
                    max: 40,
                    divisions: 19,
                    onChanged: (v) => setState(() => d.radius = v),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text('Trier par', style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: d.sort,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'recent', child: Text('Plus récents')),
                DropdownMenuItem(value: 'price_asc', child: Text('Prix croissant')),
                DropdownMenuItem(value: 'price_desc', child: Text('Prix décroissant')),
              ],
              onChanged: (v) => setState(() => d.sort = v ?? 'recent'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, d),
                child: Text('Afficher $_count biens'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeBtn(String label, String value) {
    final on = d.mode == value;
    return on
        ? ElevatedButton(
            onPressed: () => setState(() {
              d.mode = value;
              d.maxPrice = value == 'rent' ? 5000 : 1000000;
              d.minPrice = 0;
            }),
            child: Text(label),
          )
        : OutlinedButton(
            onPressed: () => setState(() {
              d.mode = value;
              d.maxPrice = value == 'rent' ? 5000 : 1000000;
              d.minPrice = 0;
            }),
            child: Text(label),
          );
  }
}
