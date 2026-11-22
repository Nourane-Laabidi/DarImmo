import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/listing.dart';

class AppUser {
  final String id;
  String name;
  final String email;
  String password;
  String phone;
  final String role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class ChatLine {
  final String text;
  final bool mine;
  ChatLine(this.text, this.mine);
}

class Thread {
  final String id;
  final String peerName;
  final String initials;
  final String listingId;
  final String listingTitle;
  final String priceLabel;
  final List<ChatLine> lines;
  int unread;
  String time;

  Thread({
    required this.id,
    required this.peerName,
    required this.initials,
    required this.listingId,
    required this.listingTitle,
    required this.priceLabel,
    required this.lines,
    this.unread = 0,
    this.time = 'Aujourd’hui',
  });

  String get last => lines.isEmpty ? '' : lines.last.text;
}

class AppNotice {
  final String title;
  final String body;
  final String time;
  bool read;
  AppNotice(this.title, this.body, this.time, {this.read = false});
}

class AppStore extends ChangeNotifier {
  static final instance = AppStore();

  AppStore() {
    _seed();
  }

  final List<AppUser> users = [];
  final List<Listing> listings = [];
  final List<Thread> threads = [];
  final List<AppNotice> notices = [];
  final Set<String> favoriteIds = {};

  AppUser? current;
  bool dark = false;
  bool notificationsOn = true;
  String language = 'Français';

  static const demoCode = '482913';
  static const meLat = 36.8065;
  static const meLng = 10.1815;

  void _seed() {
    users.addAll([
      AppUser(
        id: 'u1',
        name: 'Nourane Laabidi',
        email: 'nourane.laabidi.2005@gmail.com',
        password: 'darimmo',
        phone: '22 111 222',
        role: 'user',
      ),
      AppUser(
        id: 'u2',
        name: 'Sami Ben Ali',
        email: 'sami@darimmo.tn',
        password: 'sami123',
        phone: '98 123 456',
        role: 'user',
      ),
      AppUser(
        id: 'u3',
        name: 'Leila Trabelsi',
        email: 'leila@darimmo.tn',
        password: 'leila123',
        phone: '55 444 333',
        role: 'user',
      ),
      AppUser(
        id: 'admin',
        name: 'Équipe DarImmo',
        email: 'admin@darimmo.tn',
        password: 'admin123',
        phone: '70 000 000',
        role: 'admin',
      ),
    ]);

    listings.addAll([
      const Listing(
        id: '1',
        title: 'Villa avec jardin et piscine',
        description:
            'Villa lumineuse à quelques minutes de la plage, avec grand jardin, piscine et garage double. Quartier calme et sécurisé, proche des commerces et des écoles.',
        type: 'villa',
        transactionType: 'sale',
        city: 'La Marsa',
        address: 'Rue de la Plage',
        price: 485000,
        surface: 240,
        land: 600,
        bedrooms: 4,
        bathrooms: 3,
        images: [
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=1200&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8784,
        lng: 10.3247,
        ownerId: 'u2',
        ownerName: 'Sami Ben Ali',
        phone: '98 123 456',
        createdAt: 10,
      ),
      const Listing(
        id: '2',
        title: 'Appartement S+2 vue mer',
        description:
            'Superbe appartement S+2 avec vue imprenable sur la mer, résidence gardée, place de parking et climatisation.',
        type: 'apartment',
        transactionType: 'rent',
        city: 'Les Berges du Lac',
        address: 'Rue du Lac Turkana',
        price: 1200,
        surface: 95,
        bedrooms: 2,
        bathrooms: 1,
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8430,
        lng: 10.2720,
        ownerId: 'u2',
        ownerName: 'Sami Ben Ali',
        phone: '98 123 456',
        createdAt: 20,
      ),
      const Listing(
        id: '3',
        title: 'Studio meublé centre-ville',
        description:
            'Studio meublé et lumineux, idéal étudiant ou jeune actif, à deux pas de l’avenue Habib Bourguiba.',
        type: 'apartment',
        transactionType: 'sale',
        city: 'Tunis',
        address: 'Avenue Habib Bourguiba',
        price: 310000,
        surface: 48,
        bedrooms: 1,
        bathrooms: 1,
        images: [
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8002,
        lng: 10.1850,
        ownerId: 'u1',
        ownerName: 'Nourane Laabidi',
        phone: '22 111 222',
        createdAt: 40,
      ),
      const Listing(
        id: '4',
        title: 'Villa moderne S+4',
        description:
            'Villa de standing avec finitions haut de gamme, suite parentale, terrasse et piscine à débordement.',
        type: 'villa',
        transactionType: 'sale',
        city: 'La Marsa',
        address: 'Rue des Orangers',
        price: 560000,
        surface: 280,
        land: 700,
        bedrooms: 5,
        bathrooms: 3,
        images: [
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8890,
        lng: 10.3180,
        ownerId: 'u2',
        ownerName: 'Sami Ben Ali',
        phone: '98 123 456',
        createdAt: 30,
      ),
      const Listing(
        id: '5',
        title: 'Villa jumelée proche plage',
        description:
            'Villa jumelée récente, proche de la plage, jardin privatif et séjour ouvert sur la terrasse.',
        type: 'villa',
        transactionType: 'sale',
        city: 'Gammarth',
        address: 'Route de la Marsa',
        price: 395000,
        surface: 190,
        land: 320,
        bedrooms: 3,
        bathrooms: 2,
        images: [
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.9070,
        lng: 10.2910,
        ownerId: 'u3',
        ownerName: 'Leila Trabelsi',
        phone: '55 444 333',
        createdAt: 25,
      ),
      const Listing(
        id: '6',
        title: 'Maison avec patio',
        description:
            'Maison traditionnelle rénovée avec patio, idéale pour une famille, à Carthage.',
        type: 'villa',
        transactionType: 'rent',
        city: 'Carthage',
        address: 'Rue Hannibal',
        price: 1800,
        surface: 160,
        land: 200,
        bedrooms: 3,
        bathrooms: 2,
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8528,
        lng: 10.3230,
        ownerId: 'u3',
        ownerName: 'Leila Trabelsi',
        phone: '55 444 333',
        createdAt: 15,
      ),
      const Listing(
        id: '7',
        title: 'Duplex S+3 au Lac',
        description:
            'Duplex traversant avec grande terrasse, deux places de parking et vue dégagée.',
        type: 'apartment',
        transactionType: 'sale',
        city: 'Les Berges du Lac',
        address: 'Rue du Lac Léman',
        price: 420000,
        surface: 140,
        bedrooms: 3,
        bathrooms: 2,
        images: [
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8380,
        lng: 10.2450,
        ownerId: 'u1',
        ownerName: 'Nourane Laabidi',
        phone: '22 111 222',
        createdAt: 35,
      ),
      const Listing(
        id: '8',
        title: 'Local commercial centre-ville',
        description:
            'Local en angle avec vitrine, idéal commerce ou showroom, fort passage.',
        type: 'commercial',
        transactionType: 'rent',
        city: 'Tunis',
        address: 'Rue de Marseille',
        price: 2200,
        surface: 80,
        bedrooms: 0,
        bathrooms: 1,
        images: [
          'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'pending',
        lat: 36.7990,
        lng: 10.1800,
        ownerId: 'u1',
        ownerName: 'Nourane Laabidi',
        phone: '22 111 222',
        createdAt: 50,
      ),
      const Listing(
        id: '9',
        title: 'Appartement S+2 vue mer',
        description:
            'Annonce en attente de validation. Appartement meublé face à la mer.',
        type: 'apartment',
        transactionType: 'rent',
        city: 'Les Berges du Lac',
        address: 'Rue du Lac Constance',
        price: 1500,
        surface: 90,
        bedrooms: 2,
        bathrooms: 1,
        images: [
          'https://images.unsplash.com/photo-1502672023488-70e25813eb80?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'pending',
        lat: 36.8460,
        lng: 10.2680,
        ownerId: 'u2',
        ownerName: 'Sami Ben Ali',
        phone: '98 123 456',
        createdAt: 60,
      ),
      const Listing(
        id: '10',
        title: 'Terrain constructible',
        description:
            'Terrain viabilisé, titre bleu, en zone urbaine. Idéal pour une villa.',
        type: 'land',
        transactionType: 'sale',
        city: 'Hammamet',
        address: 'Route de Bir Bouregba',
        price: 280000,
        surface: 500,
        land: 500,
        bedrooms: 0,
        bathrooms: 0,
        images: [
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'pending',
        lat: 36.4000,
        lng: 10.6167,
        ownerId: 'u3',
        ownerName: 'Leila Trabelsi',
        phone: '55 444 333',
        createdAt: 55,
      ),
      const Listing(
        id: '11',
        title: 'Bureau open space',
        description: 'Plateau de bureaux climatisé, fibre optique, au centre du Lac.',
        type: 'office',
        transactionType: 'rent',
        city: 'Les Berges du Lac',
        address: 'Rue du Lac Windermere',
        price: 3500,
        surface: 180,
        bedrooms: 0,
        bathrooms: 2,
        images: [
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?q=80&w=1200&auto=format&fit=crop',
        ],
        status: 'approved',
        lat: 36.8355,
        lng: 10.2400,
        ownerId: 'u2',
        ownerName: 'Sami Ben Ali',
        phone: '98 123 456',
        createdAt: 12,
      ),
    ]);

    favoriteIds.addAll(['1', '2', '4', '5']);

    threads.addAll([
      Thread(
        id: 'c1',
        peerName: 'Sami Ben Ali',
        initials: 'SB',
        listingId: '1',
        listingTitle: 'Villa avec jardin et piscine',
        priceLabel: '485 000 DT',
        unread: 1,
        time: 'Aujourd’hui',
        lines: [
          ChatLine('Bonjour, la villa est-elle toujours disponible ?', true),
          ChatLine(
              'Bonjour, oui, elle est disponible. Souhaitez-vous la visiter ?',
              false),
          ChatLine('Oui, samedi matin si possible.', true),
          ChatLine(
              'Parfait, samedi à 10h. Je vous envoie l’adresse exacte.', false),
        ],
      ),
      Thread(
        id: 'c2',
        peerName: 'Leila Trabelsi',
        initials: 'LT',
        listingId: '5',
        listingTitle: 'Villa jumelée proche plage',
        priceLabel: '395 000 DT',
        unread: 1,
        time: '09:12',
        lines: [
          ChatLine('Je peux visiter demain à 15h ?', false),
        ],
      ),
      Thread(
        id: 'c3',
        peerName: 'Ahmed Ben Ali',
        initials: 'AB',
        listingId: '4',
        listingTitle: 'Villa moderne S+4',
        priceLabel: '560 000 DT',
        time: 'Hier',
        lines: [
          ChatLine('Le prix est-il négociable ?', false),
          ChatLine('Oui, légèrement, selon le délai.', true),
        ],
      ),
      Thread(
        id: 'c4',
        peerName: 'Karim Jebali',
        initials: 'KJ',
        listingId: '7',
        listingTitle: 'Duplex S+3 au Lac',
        priceLabel: '420 000 DT',
        time: 'Hier',
        lines: [
          ChatLine('Merci pour les photos !', false),
        ],
      ),
      Thread(
        id: 'c5',
        peerName: 'Inès Gharbi',
        initials: 'IG',
        listingId: '3',
        listingTitle: 'Studio meublé centre-ville',
        priceLabel: '310 000 DT',
        unread: 2,
        time: 'Lun.',
        lines: [
          ChatLine('Le studio est-il libre ce mois-ci ?', false),
        ],
      ),
    ]);

    notices.addAll([
      AppNotice('Nouveau message', 'Sami Ben Ali vous a répondu à propos de la villa.', 'Aujourd’hui'),
      AppNotice('Annonce approuvée', 'Votre studio meublé est en ligne.', 'Hier', read: true),
      AppNotice('Biens près de vous', '2 nouvelles villas à La Marsa correspondent à vos favoris.', 'Hier'),
    ]);
  }

  List<Listing> get approved =>
      listings.where((l) => l.status == 'approved').toList();

  List<Listing> get pending =>
      listings.where((l) => l.status == 'pending').toList();

  List<Listing> get mine => listings
      .where((l) => l.ownerId == (current?.id ?? 'u1'))
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Listing> get favorites =>
      listings.where((l) => favoriteIds.contains(l.id)).toList();

  int get unreadMessages => threads.fold(0, (s, t) => s + t.unread);

  int get unreadNotices =>
      notificationsOn ? notices.where((n) => !n.read).length : 0;

  Listing? byId(String id) {
    for (final l in listings) {
      if (l.id == id) return l;
    }
    return null;
  }

  Thread? threadById(String id) {
    for (final t in threads) {
      if (t.id == id) return t;
    }
    return null;
  }

  String? login(String email, String password, {required bool admin}) {
    final e = email.trim().toLowerCase();
    AppUser? user;
    for (final u in users) {
      if (u.email.toLowerCase() == e) user = u;
    }
    if (user == null || user.password != password) {
      return 'Email ou mot de passe incorrect';
    }
    if (admin && user.role != 'admin') {
      return 'Accès réservé aux administrateurs';
    }
    if (!admin && user.role == 'admin') {
      return 'Ce compte est administrateur. Utilisez l’espace admin.';
    }
    current = user;
    notifyListeners();
    return null;
  }

  void loginGoogle() {
    current = users.first;
    notifyListeners();
  }

  String? register(String name, String email, String password, String phone) {
    final e = email.trim().toLowerCase();
    if (users.any((u) => u.email.toLowerCase() == e)) {
      return 'Cet email est déjà utilisé';
    }
    final user = AppUser(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: e,
      password: password,
      phone: phone.trim(),
      role: 'user',
    );
    users.add(user);
    current = user;
    notifyListeners();
    return null;
  }

  String? requestReset(String email) {
    final e = email.trim().toLowerCase();
    if (!users.any((u) => u.email.toLowerCase() == e)) {
      return 'Aucun compte avec cet email';
    }
    return null;
  }

  String? resetPassword(String email, String code, String password) {
    if (code.trim() != demoCode) return 'Code incorrect';
    final e = email.trim().toLowerCase();
    AppUser? user;
    for (final u in users) {
      if (u.email.toLowerCase() == e) user = u;
    }
    if (user == null) return 'Aucun compte avec cet email';
    user.password = password;
    notifyListeners();
    return null;
  }

  void logout() {
    current = null;
    notifyListeners();
  }

  void updateProfile(String name, String phone) {
    final u = current;
    if (u == null) return;
    u.name = name.trim();
    u.phone = phone.trim();
    notifyListeners();
  }

  void setDark(bool value) {
    dark = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    notificationsOn = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    language = value;
    notifyListeners();
  }

  void markNoticesRead() {
    for (final n in notices) {
      n.read = true;
    }
    notifyListeners();
  }

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (!favoriteIds.add(id)) favoriteIds.remove(id);
    notifyListeners();
  }

  List<Listing> search({
    required String mode,
    String type = '',
    String query = '',
    double minPrice = 0,
    double maxPrice = 100000000,
    int minBeds = 0,
    bool aroundMe = false,
    double radiusKm = 10,
    String sort = 'recent',
  }) {
    final q = query.trim().toLowerCase();
    final hits = approved.where((l) {
      if (mode.isNotEmpty && l.transactionType != mode) return false;
      if (type.isNotEmpty && l.type != type) return false;
      if (l.price < minPrice || l.price > maxPrice) return false;
      if (minBeds > 0 && l.bedrooms < minBeds) return false;
      if (q.isNotEmpty &&
          !l.city.toLowerCase().contains(q) &&
          !l.title.toLowerCase().contains(q) &&
          !l.address.toLowerCase().contains(q)) {
        return false;
      }
      if (aroundMe && l.lat != null && l.lng != null) {
        if (kmBetween(meLat, meLng, l.lat!, l.lng!) > radiusKm) return false;
      }
      return true;
    }).toList();

    switch (sort) {
      case 'price_asc':
        hits.sort((a, b) => a.price.compareTo(b.price));
      case 'price_desc':
        hits.sort((a, b) => b.price.compareTo(a.price));
      default:
        hits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return hits;
  }

  List<Listing> near(String mode) {
    final hits = search(mode: mode);
    hits.sort((a, b) {
      final da = a.lat == null
          ? 9999.0
          : kmBetween(meLat, meLng, a.lat!, a.lng!);
      final db = b.lat == null
          ? 9999.0
          : kmBetween(meLat, meLng, b.lat!, b.lng!);
      return da.compareTo(db);
    });
    return hits;
  }

  Listing publish({
    required String title,
    required String description,
    required String type,
    required String transactionType,
    required String city,
    required String address,
    required double price,
    required int surface,
    required int land,
    required int bedrooms,
    required int bathrooms,
    required double lat,
    required double lng,
  }) {
    final owner = current ?? users.first;
    final item = Listing(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      type: type,
      transactionType: transactionType,
      city: city,
      address: address.trim(),
      price: price,
      surface: surface,
      land: land,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      images: [_stock(type)],
      status: 'pending',
      lat: lat,
      lng: lng,
      ownerId: owner.id,
      ownerName: owner.name,
      phone: owner.phone.isEmpty ? '00 000 000' : owner.phone,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    listings.add(item);
    notices.insert(
      0,
      AppNotice(
        'Annonce envoyée',
        '« ${item.title} » est en attente de validation.',
        'À l’instant',
      ),
    );
    notifyListeners();
    return item;
  }

  void moderate(String id, bool approve) {
    final i = listings.indexWhere((l) => l.id == id);
    if (i < 0) return;
    final next = approve ? 'approved' : 'rejected';
    listings[i] = listings[i].copyWith(status: next);
    notices.insert(
      0,
      AppNotice(
        approve ? 'Annonce approuvée' : 'Annonce refusée',
        listings[i].title,
        'À l’instant',
      ),
    );
    notifyListeners();
  }

  String ensureThread(Listing listing) {
    for (final t in threads) {
      if (t.listingId == listing.id) return t.id;
    }
    final id = 'c${DateTime.now().millisecondsSinceEpoch}';
    threads.insert(
      0,
      Thread(
        id: id,
        peerName: listing.ownerName,
        initials: _initials(listing.ownerName),
        listingId: listing.id,
        listingTitle: listing.title,
        priceLabel: listing.priceLabel,
        lines: [],
        time: 'À l’instant',
      ),
    );
    notifyListeners();
    return id;
  }

  void markThreadRead(String id) {
    final t = threadById(id);
    if (t == null || t.unread == 0) return;
    t.unread = 0;
    notifyListeners();
  }

  void send(String threadId, String text) {
    final t = threadById(threadId);
    final trimmed = text.trim();
    if (t == null || trimmed.isEmpty) return;
    t.lines.add(ChatLine(trimmed, true));
    t.time = 'À l’instant';
    t.unread = 0;
    if (notificationsOn) {
      notices.insert(
        0,
        AppNotice('Message envoyé', 'À ${t.peerName}', 'À l’instant', read: true),
      );
    }
    notifyListeners();
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
  }

  static String _stock(String type) => switch (type) {
        'villa' =>
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=1200&auto=format&fit=crop',
        'land' =>
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1200&auto=format&fit=crop',
        'commercial' =>
          'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=1200&auto=format&fit=crop',
        'office' =>
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?q=80&w=1200&auto=format&fit=crop',
        _ =>
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=1200&auto=format&fit=crop',
      };
}

double kmBetween(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLon = rad(lon2 - lon1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.pow(math.sin(dLon / 2), 2);
  return 2 * r * math.asin(math.sqrt(a));
}
