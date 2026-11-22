import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import 'favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final String listingId;
  final bool compact;
  const FavoriteButton({
    super.key,
    required this.listingId,
    this.compact = false,
  });
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final _service = FavoriteService();
  bool _fav = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _service.fetchAll();
      if (mounted) {
        setState(() => _fav = list.any((l) => l.id == widget.listingId));
      }
    } catch (_) {}
  }

  Future<void> _toggle() async {
    setState(() => _busy = true);
    try {
      if (_fav) {
        await _service.remove(widget.listingId);
      } else {
        await _service.add(widget.listingId);
      }
      if (mounted) setState(() => _fav = !_fav);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(apiError(e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 32.0 : 40.0;
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: size, height: size),
          iconSize: widget.compact ? 18 : 24,
          tooltip: _fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
          icon: Icon(
            _fav ? Icons.favorite : Icons.favorite_border,
            color: _fav ? Colors.red : AppColors.price,
          ),
          onPressed: _busy ? null : _toggle,
        ),
      ),
    );
  }
}
