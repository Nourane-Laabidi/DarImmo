import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/api_client.dart';
import '../../models/listing.dart';

class PropertyService {
  Future<List<Listing>> fetchAll({
    String? transactionType,
    String? type,
    String? city,
  }) async {
    final res = await ApiClient.instance.dio.get(
      '/properties',
      queryParameters: {
        if (transactionType != null) 'transactionType': transactionType,
        if (type != null) 'type': type,
        if (city != null && city.isNotEmpty) 'city': city,
      },
    );
    final list = (res.data['data']['properties'] as List? ?? []);
    return list
        .map((e) => Listing.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Listing> fetchOne(String id) async {
    final res = await ApiClient.instance.dio.get('/properties/$id');
    final data = res.data['data'];
    final json =
        (data is Map && data['property'] != null) ? data['property'] : data;
    return Listing.fromJson(json as Map<String, dynamic>);
  }

  Future<String> create(Map<String, dynamic> body) async {
    final res = await ApiClient.instance.dio.post('/properties', data: body);
    final d = res.data['data'];
    final p = (d is Map && d['property'] != null) ? d['property'] : d;
    return p['_id'].toString();
  }

  /// The backend accepts 5 images per request, so we send them in batches.
  Future<void> uploadImages(String id, List<XFile> files) async {
    for (var i = 0; i < files.length; i += 5) {
      final form = FormData();
      for (final f in files.skip(i).take(5)) {
        form.files.add(MapEntry(
          'images',
          MultipartFile.fromBytes(await f.readAsBytes(), filename: f.name),
        ));
      }
      await ApiClient.instance.dio.post('/properties/$id/images',
          data: form, options: Options(contentType: 'multipart/form-data'));
    }
  }
}
