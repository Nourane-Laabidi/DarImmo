class Listing {
  final String id;
  final String title;
  final String description;
  final String type;
  final String transactionType;
  final String city;
  final String address;
  final double price;
  final int surface;
  final int land;
  final int bedrooms;
  final int bathrooms;
  final List<String> images;
  final double? lat;
  final double? lng;
  final String status;
  final String ownerId;
  final String ownerName;
  final String phone;
  final int createdAt;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.transactionType,
    required this.city,
    required this.address,
    required this.price,
    required this.surface,
    required this.bedrooms,
    required this.bathrooms,
    required this.images,
    required this.status,
    this.land = 0,
    this.lat,
    this.lng,
    this.ownerId = 'u2',
    this.ownerName = 'Sami Ben Ali',
    this.phone = '98 123 456',
    this.createdAt = 0,
  });
  factory Listing.fromJson(Map<String, dynamic> json) {
    final imageValues = json['images'];
    final images = imageValues is List
        ? imageValues.map((image) => image.toString()).toList()
        : json['imageUrl'] == null
            ? <String>[]
            : <String>[json['imageUrl'].toString()];

    return Listing(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      surface: (json['surface'] as num?)?.toInt() ?? 0,
      land: (json['land'] as num?)?.toInt() ?? 0,
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      images: images,
      status: json['status']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      ownerId: json['ownerId']?.toString() ?? 'u2',
      ownerName: json['ownerName']?.toString() ?? 'Sami Ben Ali',
      phone: json['phone']?.toString() ?? '98 123 456',
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
    );
  }

  Listing copyWith({String? status}) => Listing(
        id: id,
        title: title,
        description: description,
        type: type,
        transactionType: transactionType,
        city: city,
        address: address,
        price: price,
        surface: surface,
        land: land,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        images: images,
        status: status ?? this.status,
        lat: lat,
        lng: lng,
        ownerId: ownerId,
        ownerName: ownerName,
        phone: phone,
        createdAt: createdAt,
      );

  String? get imageUrl => images.isEmpty ? null : images.first;

  String get priceLabel => transactionType == 'rent'
      ? '${_thousands(price)} DT / mois'
      : '${_thousands(price)} DT';

  String get shortPrice {
    if (price >= 1000) return '${(price / 1000).round()} K';
    return '${price.round()}';
  }

  String get typeLabel => switch (type) {
        'apartment' => 'Appartement',
        'villa' => 'Villa',
        'land' => 'Terrain',
        'commercial' => 'Local',
        'office' => 'Bureau',
        _ => type,
      };

  String get details =>
      '$city · $bedrooms ch · $bathrooms sdb · $surface m²';

  bool get isSale => transactionType == 'sale';
}


String _thousands(double v) {
  final s = v.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}
