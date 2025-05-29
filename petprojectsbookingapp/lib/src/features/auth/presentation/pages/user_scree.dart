import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petprojectsbookingapp/models/favarite.dart';
import 'package:petprojectsbookingapp/models/location.dart';
import 'package:petprojectsbookingapp/models/profile.dart';
import 'package:petprojectsbookingapp/models/roombooking.dart';

// Different pages for navigation
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomBookingScreen();
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addBooking(String location, String room, String time) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showMessage('Please log in to make a booking');
        return;
      }

      // Check if room is already booked
      final existingBooking =
          await _firestore
              .collection('bookings')
              .where('location', isEqualTo: location)
              .where('room', isEqualTo: room)
              .where('time', isEqualTo: time)
              .where('date', isEqualTo: _getTodayDate())
              .get();

      if (existingBooking.docs.isNotEmpty) {
        _showMessage('This room is already booked for this time');
        return;
      }

      // Add booking to Firestore
      await _firestore.collection('bookings').add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'location': location,
        'room': room,
        'time': time,
        'date': _getTodayDate(),
        'userId': user.uid,
        'userEmail': user.email ?? 'Unknown User',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showMessage('Booking successful!');
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }
  }

  Future<void> _deleteBooking(String docId) async {
    try {
      await _firestore.collection('bookings').doc(docId).delete();
      _showMessage('Booking cancelled');
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section
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
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Locations Section
                  Text(
                    'Available Locations',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A3E),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Sport Hall
                  LocationCard(
                    title: 'Sport Hall',
                    icon: Icons.sports_basketball,
                    color: Color(0xFF4CAF50),
                    rooms: [
                      'Basketball Court',
                      'Tennis Court',
                      'Gym Area',
                      'Swimming Pool',
                    ],
                    onBookRoom: _addBooking,
                  ),
                  SizedBox(height: 15),

                  // Eating Joint
                  LocationCard(
                    title: 'Eating Joint',
                    icon: Icons.restaurant,
                    color: Color(0xFFFF9800),
                    rooms: [
                      'Main Dining',
                      'Private Dining',
                      'Coffee Corner',
                      'Outdoor Terrace',
                    ],
                    onBookRoom: _addBooking,
                  ),
                  SizedBox(height: 15),

                  // Rooms for Activities
                  LocationCard(
                    title: 'Activity Rooms',
                    icon: Icons.meeting_room,
                    color: Color(0xFF9C27B0),
                    rooms: [
                      'Conference Room A',
                      'Conference Room B',
                      'Study Room',
                      'Workshop Space',
                    ],
                    onBookRoom: _addBooking,
                  ),
                  SizedBox(height: 30),

                  // My Bookings Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Bookings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A2A3E),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllBookingsPage(),
                            ),
                          );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(color: Color(0xFF4A6CF7)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Real-time Bookings from Firestore
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        _firestore
                            .collection('bookings')
                            .where(
                              'userId',
                              isEqualTo: _auth.currentUser?.uid ?? '',
                            )
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'No bookings yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Book a location above to get started',
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

                      final bookingDocs = snapshot.data!.docs.take(3).toList();

                      return Column(
                        children:
                            bookingDocs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['location'] ?? '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2A2A3E),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            data['room'] ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            data['time'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteBooking(doc.id),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      );
                    },
                  ),

                  SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// All Bookings Page to see everyone's bookings
class AllBookingsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _deleteMyBooking(
    BuildContext context,
    String docId,
    String userId,
  ) async {
    if (_auth.currentUser?.uid == userId) {
      try {
        await _firestore.collection('bookings').doc(docId).delete();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Booking cancelled')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Bookings'),
        backgroundColor: Color(0xFF2A2A3E),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection('bookings')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No bookings found',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final isMyBooking = _auth.currentUser?.uid == data['userId'];

              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border:
                      isMyBooking
                          ? Border.all(color: Color(0xFF4A6CF7), width: 2)
                          : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['location'] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A2A3E),
                          ),
                        ),
                        if (isMyBooking)
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4A6CF7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Mine',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () => _deleteMyBooking(
                                      context,
                                      doc.id,
                                      data['userId'],
                                    ),
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      data['room'] ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      data['time'] ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    if (!isMyBooking) ...[
                      SizedBox(height: 8),
                      Text(
                        'Booked by: ${data['userEmail'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Main wrapper with bottom navigation
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  _MainNavigationWrapperState createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SchedulePage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A3E),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.access_time, 1),
                  _buildNavItem(Icons.favorite_border, 2),
                  _buildNavItem(Icons.person_outline, 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4A6CF7) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white54,
          size: 28,
        ),
      ),
    );
  }
}
