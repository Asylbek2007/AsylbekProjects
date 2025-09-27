import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petprojectsbookingapp/src/core/services/favorites_service.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/room_info_page.dart';

class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({super.key});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FavoritesService _favoritesService = FavoritesService.instance;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  Set<String> _favoriteRooms = {};

  final List<String> _filterOptions = [
    'All',
    'Meeting Rooms',
    'Conference Rooms',
    'Study Rooms',
    'Private Rooms',
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _favoritesService.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteRooms = favorites;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _toggleFavorite(String roomName) async {
    if (_favoriteRooms.contains(roomName)) {
      await _favoritesService.removeFavorite(roomName);
      setState(() {
        _favoriteRooms.remove(roomName);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$roomName removed from favorites'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await _favoritesService.addFavorite(roomName);
      setState(() {
        _favoriteRooms.add(roomName);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$roomName added to favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _getUserName() {
    final user = _auth.currentUser;
    if (user != null) {
      // Try to get display name first, then email username, then default
      return user.displayName?.split(' ').first ??
          user.email?.split('@').first ??
          'User';
    }
    return 'Guest';
  }

  List<Map<String, dynamic>> _getFilteredRooms() {
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

    return allRooms.where((room) {
      // Filter by category
      bool categoryMatch =
          _selectedFilter == 'All' || room['type'] == _selectedFilter;

      // Filter by search query
      bool searchMatch =
          _searchQuery.isEmpty ||
          room['name'].toLowerCase().contains(_searchQuery) ||
          room['type'].toLowerCase().contains(_searchQuery) ||
          room['description'].toLowerCase().contains(_searchQuery);

      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Color(0xFF2A2A3E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.signal_cellular_4_bar,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.wifi, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Icon(Icons.battery_full, color: Colors.white, size: 16),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Text(
                  'Hi ${_getUserName()}, you\'re at',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Pushkin 154',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Looking for room',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            suffixIcon: Icon(Icons.search, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF9B71),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.tune, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ), // Add bottom padding for navigation bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          _filterOptions.map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: FilterChip(
                                label: Text(
                                  filter,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.grey[700],
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (value) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                selectedColor: Color(0xFF4A6CF7),
                                backgroundColor: Colors.grey[200],
                                checkmarkColor: Colors.white,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Featured room (first filtered result)
                  Builder(
                    builder: (context) {
                      final filteredRooms = _getFilteredRooms();
                      if (filteredRooms.isEmpty) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[100],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No rooms found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Try adjusting your search or filter',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final featuredRoom = filteredRooms.first;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => RoomInfoPage(
                                    roomName: featuredRoom['name'],
                                    location: 'Main Building',
                                    roomType: featuredRoom['type'],
                                    price:
                                        '', // Empty price since we removed pricing
                                    image: featuredRoom['image'],
                                    description: featuredRoom['description'],
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        featuredRoom['image'],
                                      ),
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
                                  top: 20,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap:
                                        () => _toggleFavorite(
                                          featuredRoom['name'],
                                        ),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        _favoriteRooms.contains(
                                              featuredRoom['name'],
                                            )
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            _favoriteRooms.contains(
                                                  featuredRoom['name'],
                                                )
                                                ? Colors.red
                                                : Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        featuredRoom['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        featuredRoom['type'],
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),

                  Text(
                    'Available Rooms',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A3E),
                    ),
                  ),
                  SizedBox(height: 15),

                  Builder(
                    builder: (context) {
                      final filteredRooms = _getFilteredRooms();
                      if (filteredRooms.isEmpty) {
                        return Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                          ),
                          child: Center(
                            child: Text(
                              'No rooms match your criteria',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }

                      // Show remaining rooms (skip the first one as it's featured)
                      final remainingRooms =
                          filteredRooms.skip(1).take(2).toList();

                      if (remainingRooms.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return Row(
                        children:
                            remainingRooms.map((room) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right:
                                        remainingRooms.indexOf(room) == 0
                                            ? 15
                                            : 0,
                                  ),
                                  child: RoomCard(
                                    name: room['name'],
                                    image: room['image'],
                                    type: room['type'],
                                    description: room['description'],
                                    location: 'Main Building',
                                    isFavorite: _favoriteRooms.contains(
                                      room['name'],
                                    ),
                                    onFavoriteToggle:
                                        () => _toggleFavorite(room['name']),
                                  ),
                                ),
                              );
                            }).toList(),
                      );
                    },
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

class RoomCard extends StatelessWidget {
  final String name;
  final String image;
  final String? type;
  final String description;
  final String location;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const RoomCard({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.location,
    this.type,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RoomInfoPage(
                  roomName: name,
                  location: location,
                  roomType: type ?? 'Room',
                  price: '', // Empty price since we removed pricing
                  image: image,
                  description: description,
                ),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
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
                    image: NetworkImage(image),
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
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    if (onFavoriteToggle != null) {
                      onFavoriteToggle!();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (type != null) ...[
                      SizedBox(height: 2),
                      Text(
                        type!,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
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
