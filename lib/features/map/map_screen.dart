import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_bottom_nav.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(index: 1),
      body: Stack(
        children: [
          // Carte
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(36.8784, 10.3247),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.darimmo.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(36.8784, 10.3247),
                    width: 80, height: 40,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(20)),
                      child: const Text('485 K', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  Marker(
                    point: const LatLng(36.8840, 10.3180),
                    width: 80, height: 40,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1E3A8A))),
                      child: const Text('395 K', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                    child: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back, size: 20)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                      child: const Row(children: [Icon(Icons.search, color: Colors.grey, size: 20), SizedBox(width: 8), Text('La Marsa', style: TextStyle(fontWeight: FontWeight.w500))]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bouton Rechercher
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 0, right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Rechercher dans cette zone'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), minimumSize: const Size(0, 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          
          // Bouton Géoloc
          Positioned(
            bottom: 180, right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.my_location, color: Colors.grey),
            ),
          ),
          
          // Carte flottante du bas
          Positioned(
            left: 16, right: 16, bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)])),
                    child: const Icon(Icons.home_work, color: Colors.white54),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('485 000 DT', style: TextStyle(color: Color(0xFFD97706), fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('Villa avec jardin et piscine', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        const Text('La Marsa · 4 ch · 3 sdb · 240 m²', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}