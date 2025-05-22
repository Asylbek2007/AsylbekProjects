import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/models/booking.dart';
import 'package:petprojectsbookingapp/models/booking_tile.dart';
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
  // ignore: library_private_types_in_public_api
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Booking> bookings = [];

  void _addBooking(String location, String room, String time) {
    setState(() {
      bookings.add(
        Booking(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          location: location,
          room: room,
          time: time,
          date: DateTime.now(),
        ),
      );
    });
  }

  void _deleteBooking(String id) {
    setState(() {
      bookings.removeWhere((booking) => booking.id == id);
    });
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
                      if (bookings.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => BookingDetailsPage(
                            //       bookings: bookings,
                            //       onDeleteBooking: _deleteBooking,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(color: Color(0xFF4A6CF7)),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Bookings List or Empty State
                  if (bookings.isEmpty)
                    Container(
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
                    )
                  else
                    Column(
                      children:
                          bookings
                              .take(3)
                              .map(
                                (booking) => BookingTile(
                                  booking: booking,
                                  onDelete: () => _deleteBooking(booking.id),
                                ),
                              )
                              .toList(),
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

// }

// Main wrapper with bottom navigation
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
