import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../core/store.dart';
import '../../core/theme.dart';

class _City {
  final String name;
  final double lat;
  final double lng;
  const _City(this.name, this.lat, this.lng);
}

const _cities = [
  _City('Tunis', 36.8065, 10.1815),
  _City('La Marsa', 36.8784, 10.3247),
  _City('Les Berges du Lac', 36.8430, 10.2720),
  _City('Gammarth', 36.9070, 10.2910),
  _City('Carthage', 36.8528, 10.3230),
  _City('Hammamet', 36.4000, 10.6167),
];

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});
  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  int _step = 0;
  String _mode = 'sale';
  String _type = 'apartment';
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _surface = TextEditingController();
  final _land = TextEditingController();
  final _address = TextEditingController();
  int _beds = 2;
  int _baths = 1;
  int _photos = 0;
  _City _city = _cities[1];
  late double _lat = _city.lat;
  late double _lng = _city.lng;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    _surface.dispose();
    _land.dispose();
    _address.dispose();
    super.dispose();
  }

  void _toast(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  bool _validate() {
    if (_step == 0) {
      if (_title.text.trim().length < 3) {
        _toast('Indiquez un titre');
        return false;
      }
      if (_desc.text.trim().length < 10) {
        _toast('Décrivez le bien (10 caractères minimum)');
        return false;
      }
    }
    if (_step == 1) {
      final price = double.tryParse(_price.text.replaceAll(' ', '')) ?? 0;
      final surface = int.tryParse(_surface.text) ?? 0;
      if (price <= 0) {
        _toast('Indiquez un prix');
        return false;
      }
      if (surface <= 0) {
        _toast('Indiquez la surface');
        return false;
      }
      if (_address.text.trim().isEmpty) {
        _toast('Indiquez l’adresse');
        return false;
      }
    }
    return true;
  }

  void _next() {
    if (!_validate()) return;
    if (_step < 3) {
      setState(() => _step++);
      return;
    }
    final item = AppStore.instance.publish(
      title: _title.text,
      description: _desc.text,
      type: _type,
      transactionType: _mode,
      city: _city.name,
      address: _address.text,
      price: double.parse(_price.text.replaceAll(' ', '')),
      surface: int.parse(_surface.text),
      land: int.tryParse(_land.text) ?? 0,
      bedrooms: _beds,
      bathrooms: _baths,
      lat: _lat,
      lng: _lng,
    );
    _toast('Annonce envoyée. Elle apparaît dans « À valider ».');
    context.go('/my-listings');
    // Keep the id referenced so the new listing stays easy to open from Mes annonces.
    assert(item.id.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ui.card,
      appBar: AppBar(
        backgroundColor: Ui.card,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Ui.ink),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text('Publier une annonce',
            style: TextStyle(color: Ui.ink, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _step ? AppColors.primary : Ui.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Étape ${_step + 1} sur 4 · ${_stepTitle()}',
              style: TextStyle(color: Ui.mute, fontSize: 12),
            ),
            const SizedBox(height: 24),
            if (_step == 0) _stepType(),
            if (_step == 1) _stepDetails(),
            if (_step == 2) _stepPhotos(),
            if (_step == 3) _stepRecap(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (_step == 0) {
                      context.canPop() ? context.pop() : context.go('/');
                    } else {
                      setState(() => _step--);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Retour',
                      style: TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_step == 3 ? 'Publier' : 'Continuer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _stepTitle() => switch (_step) {
        0 => 'Type de bien',
        1 => 'Caractéristiques',
        2 => 'Photos et position',
        _ => 'Récapitulatif',
      };

  Widget _stepType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaction', style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _pick('Acheter', _mode == 'sale', () => setState(() => _mode = 'sale'))),
            const SizedBox(width: 8),
            Expanded(child: _pick('Louer', _mode == 'rent', () => setState(() => _mode = 'rent'))),
          ],
        ),
        const SizedBox(height: 16),
        Text('Type', style: TextStyle(fontWeight: FontWeight.w600, color: Ui.ink)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
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
                selected: _type == e.key,
                onSelected: (_) => setState(() => _type = e.key),
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _title,
          decoration: const InputDecoration(labelText: 'Titre de l’annonce'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _desc,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
      ],
    );
  }

  Widget _stepDetails() {
    return Column(
      children: [
        TextField(
          controller: _price,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: _mode == 'rent' ? 'Loyer (DT / mois)' : 'Prix (DT)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _surface,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Surface (m²)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _land,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Terrain (m², optionnel)'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _counter('Chambres', _beds, (v) => setState(() => _beds = v))),
            const SizedBox(width: 12),
            Expanded(child: _counter('Sdb', _baths, (v) => setState(() => _baths = v))),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _address,
          decoration: const InputDecoration(labelText: 'Adresse'),
        ),
      ],
    );
  }

  Widget _stepPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos ($_photos sur 10)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Ui.ink)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _photoBox(add: true)),
            const SizedBox(width: 8),
            Expanded(child: _photoBox(label: _photos > 0 ? 'Principale' : '', colors: const [Color(0xFF1E3A8A), Color(0xFF14B8A6)])),
            const SizedBox(width: 8),
            Expanded(
              child: _photoBox(
                colors: _photos > 1
                    ? const [Color(0xFF0F766E), Color(0xFF93C5FD)]
                    : const [Color(0xFFE2E8F0), Color(0xFFE2E8F0)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Ville', style: TextStyle(fontWeight: FontWeight.bold, color: Ui.ink)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final c in _cities)
              ChoiceChip(
                label: Text(c.name),
                selected: _city.name == c.name,
                onSelected: (_) => setState(() {
                  _city = c;
                  _lat = c.lat;
                  _lng = c.lng;
                }),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Position du bien',
            style: TextStyle(fontWeight: FontWeight.bold, color: Ui.ink)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 200,
            child: FlutterMap(
              key: ValueKey(_city.name),
              options: MapOptions(
                initialCenter: LatLng(_lat, _lng),
                initialZoom: 13,
                onTap: (_, point) => setState(() {
                  _lat = point.latitude;
                  _lng = point.longitude;
                }),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.darimmo.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: LatLng(_lat, _lng),
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: AppColors.primary, size: 36),
                  ),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Touchez la carte pour placer le repère',
            style: TextStyle(color: Ui.mute, fontSize: 12)),
      ],
    );
  }

  Widget _stepRecap() {
    final price = _price.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_title.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Ui.ink)),
        const SizedBox(height: 8),
        Text('${_mode == 'rent' ? 'Location' : 'Vente'} · ${_label(_type)}',
            style: TextStyle(color: Ui.mute)),
        const SizedBox(height: 8),
        Text('$price DT · ${_surface.text} m² · $_beds ch · $_baths sdb',
            style: const TextStyle(color: AppColors.price, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('${_address.text}, ${_city.name}', style: TextStyle(color: Ui.ink)),
        const SizedBox(height: 8),
        Text(_desc.text, style: TextStyle(color: Ui.mute, height: 1.4)),
        const SizedBox(height: 12),
        Text('$_photos photo(s) · repère ${_lat.toStringAsFixed(4)}, ${_lng.toStringAsFixed(4)}',
            style: TextStyle(color: Ui.mute, fontSize: 12)),
        const SizedBox(height: 12),
        Text('L’annonce sera visible par tous après validation par l’administrateur.',
            style: TextStyle(color: Ui.mute)),
      ],
    );
  }

  String _label(String type) => switch (type) {
        'apartment' => 'Appartement',
        'villa' => 'Villa',
        'land' => 'Terrain',
        'commercial' => 'Local',
        'office' => 'Bureau',
        _ => type,
      };

  Widget _pick(String label, bool on, VoidCallback tap) {
    return on
        ? ElevatedButton(onPressed: tap, child: Text(label))
        : OutlinedButton(onPressed: tap, child: Text(label));
  }

  Widget _counter(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Ui.mute, fontSize: 12)),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$value', style: TextStyle(fontWeight: FontWeight.bold, color: Ui.ink)),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget _photoBox({bool add = false, String label = '', List<Color>? colors}) {
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: add
            ? () => setState(() {
                  if (_photos < 10) _photos++;
                })
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: add ? Ui.bg : null,
            gradient: colors == null ? null : LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(12),
            border: add ? Border.all(color: Ui.line) : null,
          ),
          child: add
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Ui.mute),
                    Text('Ajouter', style: TextStyle(color: Ui.mute, fontSize: 10)),
                  ],
                )
              : label.isEmpty
                  ? null
                  : Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(6)),
                        child: Text(label,
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
        ),
      ),
    );
  }
}
