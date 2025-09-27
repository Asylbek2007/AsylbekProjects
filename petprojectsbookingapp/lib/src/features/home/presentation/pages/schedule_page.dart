import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/models/location.dart';
import 'package:petprojectsbookingapp/src/core/services/user_status_service.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserStatusService _userStatusService = UserStatusService.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addBooking(String location, String room, String time) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          _showMessage('Please log in to make a booking');
        }
        return;
      }

      final existingBooking =
          await _firestore
              .collection('bookings')
              .where('location', isEqualTo: location)
              .where('room', isEqualTo: room)
              .where('time', isEqualTo: time)
              .where('date', isEqualTo: _getTodayDate())
              .get();

      if (existingBooking.docs.isNotEmpty) {
        if (mounted) {
          _showMessage('This room is already booked for this time');
        }
        return;
      }

      final userStatus = await _userStatusService.getUserStatus();

      await _firestore.collection('bookings').add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'location': location,
        'room': room,
        'time': time,
        'date': _getTodayDate(),
        'userId': user.uid,
        'userEmail': user.email ?? 'Unknown User',
        'userStatus': _userStatusService.getStatusDisplayName(userStatus),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        _showMessage('Booking successful!');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Error: ${e.toString()}');
      }
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
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
                Text(
                  'Schedule & Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Book your favorite locations',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 20),
                Container(
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
                      hintText: 'Search locations and rooms...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      suffixIcon:
                          _searchQuery.isNotEmpty
                              ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                              : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Locations',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A3E),
                    ),
                  ),
                  SizedBox(height: 15),
                  Builder(
                    builder: (context) {
                      final locations = [
                        {
                          'title': 'Sport Hall',
                          'icon': Icons.sports_basketball,
                          'color': Color(0xFF4CAF50),
                          'rooms': [
                            'Tennis Court',
                            'Basketball Court',
                            'Gymnasium',
                            'Swimming Pool',
                          ],
                        },
                        {
                          'title': 'Eating Joint',
                          'icon': Icons.restaurant,
                          'color': Color(0xFFFF9800),
                          'rooms': [
                            'Main Dining',
                            'Private Dining Room',
                            'Cafeteria',
                            'Outdoor Terrace',
                          ],
                        },
                        {
                          'title': 'Activity Rooms',
                          'icon': Icons.meeting_room,
                          'color': Color(0xFF9C27B0),
                          'rooms': [
                            'Conference Room A',
                            'Conference Room B',
                            'Seminar Hall',
                            'Training Room',
                          ],
                        },
                      ];

                      final filteredLocations =
                          locations.where((location) {
                            if (_searchQuery.isEmpty) return true;

                            final title =
                                location['title'].toString().toLowerCase();
                            final rooms = location['rooms'] as List<String>;
                            final roomNames = rooms.join(' ').toLowerCase();

                            return title.contains(_searchQuery) ||
                                roomNames.contains(_searchQuery);
                          }).toList();

                      if (filteredLocations.isEmpty &&
                          _searchQuery.isNotEmpty) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
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
                                  'No locations found for "$_searchQuery"',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Try searching with different keywords',
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

                      return Column(
                        children:
                            filteredLocations.map((location) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: LocationCard(
                                  title: location['title'] as String,
                                  icon: location['icon'] as IconData,
                                  color: location['color'] as Color,
                                  rooms: location['rooms'] as List<String>,
                                  onBookRoom: _addBooking,
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
