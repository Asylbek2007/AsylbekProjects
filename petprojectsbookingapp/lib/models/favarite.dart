import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/src/core/services/favorites_service.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/room_info_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService _favoritesService = FavoritesService.instance;
  Set<String> _favoriteRooms = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh favorites when returning to this page
    _loadFavorites();
  }

  @override
  void didUpdateWidget(FavoritesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh when widget updates
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _favoritesService.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteRooms = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeFavorite(String roomName) async {
    try {
      await _favoritesService.removeFavorite(roomName);
      setState(() {
        _favoriteRooms.remove(roomName);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$roomName removed from favorites'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing favorite: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFavoriteRooms() {
    List<Map<String, dynamic>> allRooms = [
      {
        'name': 'Тапчан',
        'type': 'Meeting Rooms',
        'image':
            'https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'description': 'Large meeting room with modern facilities',
      },
      {
        'name': '103 каб',
        'type': 'Conference Rooms',
        'image':
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'description': 'Conference room for presentations',
      },
      {
        'name': '105 каб',
        'type': 'Study Rooms',
        'image':
            'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'description': 'Quiet study room for individual work',
      },
      {
        'name': 'Private Office',
        'type': 'Private Rooms',
        'image':
            'https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'description': 'Private office space for confidential meetings',
      },
      {
        'name': 'Library Study',
        'type': 'Study Rooms',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'description': 'Silent study environment with books',
      },
      {
        'name': 'Tech Lab',
        'type': 'Conference Rooms',
        'image':
            'https://images.unsplash.com/photo-1518709268805-4e9042af2176?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'description': 'High-tech room with modern equipment',
      },
    ];

    return allRooms
        .where((room) => _favoriteRooms.contains(room['name']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          backgroundColor: Color(0xFF2A2A3E),
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final favoriteRooms = _getFavoriteRooms();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Color(0xFF2A2A3E),
        foregroundColor: Colors.white,
      ),
      body:
          favoriteRooms.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A2A3E),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap the heart icon on rooms to add them to favorites',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadFavorites,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Favorite Rooms',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A2A3E),
                        ),
                      ),
                      SizedBox(height: 20),
                      ...favoriteRooms.map(
                        (room) => Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: _FavoriteRoomCard(
                            room: room,
                            onRemove: () => _removeFavorite(room['name']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class _FavoriteRoomCard extends StatelessWidget {
  final Map<String, dynamic> room;
  final VoidCallback onRemove;

  const _FavoriteRoomCard({required this.room, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RoomInfoPage(
                  roomName: room['name'],
                  location: 'Main Building',
                  roomType: room['type'],
                  price: '', // Empty price since we removed pricing
                  image: room['image'],
                  description: room['description'],
                ),
          ),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(room['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.favorite, color: Colors.red, size: 24),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      room['type'],
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
