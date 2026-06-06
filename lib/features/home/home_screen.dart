import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shops/shop_list_screen.dart';
import '../map/map_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    ShopListScreen(),
    MapScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          appBar: _currentIndex == 0
              ? AppBar(
                  title: const Text('Trago Amargo'),
                  actions: [
                    if (auth.isAuthenticated) _notificationBell(context, auth),
                    if (!auth.isAuthenticated)
                      TextButton.icon(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(context, '/login');
                          if (result == true && mounted) setState(() {});
                        },
                        icon: const Icon(Icons.person, size: 18, color: Colors.white),
                        label: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                  ],
                )
              : null,
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Cafeterías'),
              BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationBell(BuildContext context, AuthProvider auth) {
    return StreamBuilder<int>(
      stream: context.read<FirestoreService>().getUnreadCountStream(auth.user!.uid),
      initialData: 0,
      builder: (_, snap) {
        final count = snap.data ?? 0;
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),
            if (count > 0)
              Positioned(
                right: 6, top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        );
      },
    );
  }
}
