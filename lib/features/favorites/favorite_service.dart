import '../../core/api_client.dart';
import '../../models/listing.dart';

class FavoriteService {
  final _dio = ApiClient.instance.dio;

  List _extract(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final k in ['favorites', 'properties', 'items']) {
        if (data[k] is List) return data[k] as List;
      }
    }
    return [];
  }

  Future<List<Listing>> fetchAll() async {
    final res = await _dio.get('/favorites');
    final out = <Listing>[];
    for (final e in _extract(res.data['data'])) {
      if (e is! Map) continue;
      final p = e['property'] is Map ? e['property'] : e;
      if (p is Map && p['title'] != null) {
        out.add(Listing.fromJson(Map<String, dynamic>.from(p)));
      }
    }
    return out;
  }

  Future<void> add(String id) async {
    await _dio.post('/favorites/$id');
  }

  Future<void> remove(String id) async {
    await _dio.delete('/favorites/$id');
  }
}
