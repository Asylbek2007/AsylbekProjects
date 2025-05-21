import 'package:flutter/material.dart';

// Different pages for navigation
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoomBookingScreen();
  }
}

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Booking> bookings = [];

  void _addBooking(String location, String room, String time) {
    setState(() {
      bookings.add(Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        location: location,
        room: room,
        time: time,
        date: DateTime.now(),
      ));
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
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
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
                    rooms: ['Basketball Court', 'Tennis Court', 'Gym Area', 'Swimming Pool'],
                    onBookRoom: _addBooking,
                  ),
                  SizedBox(height: 15),
                  
                  // Eating Joint
                  LocationCard(
                    title: 'Eating Joint',
                    icon: Icons.restaurant,
                    color: Color(0xFFFF9800),
                    rooms: ['Main Dining', 'Private Dining', 'Coffee Corner', 'Outdoor Terrace'],
                    onBookRoom: _addBooking,
                  ),
                  SizedBox(height: 15),
                  
                  // Rooms for Activities
                  LocationCard(
                    title: 'Activity Rooms',
                    icon: Icons.meeting_room,
                    color: Color(0xFF9C27B0),
                    rooms: ['Conference Room A', 'Conference Room B', 'Study Room', 'Workshop Space'],
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
                      children: bookings.take(3).map((booking) => 
                        BookingTile(
                          booking: booking,
                          onDelete: () => _deleteBooking(booking.id),
                        )
                      ).toList(),
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

// Booking model
class Booking {
  final String id;
  final String location;
  final String room;
  final String time;
  final DateTime date;

  Booking({
    required this.id,
    required this.location,
    required this.room,
    required this.time,
    required this.date,
  });
}

// Location Card Widget
class LocationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> rooms;
  final Function(String location, String room, String time) onBookRoom;

  const LocationCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.rooms,
    required this.onBookRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A3E),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Available Rooms:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rooms.map((room) => 
                RoomChip(
                  room: room,
                  color: color,
                  onTap: () => _showBookingDialog(context, title, room),
                )
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, String location, String room) {
    List<String> timeSlots = [
      '09:00 - 10:00',
      '10:00 - 11:00',
      '11:00 - 12:00',
      '14:00 - 15:00',
      '15:00 - 16:00',
      '16:00 - 17:00',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Book $room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select a time slot:'),
              SizedBox(height: 15),
              ...timeSlots.map((time) => 
                ListTile(
                  onTap: () {
                    onBookRoom(location, room, time);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booked $room for $time'),
                        backgroundColor: color,
                      ),
                    );
                  },
                  leading: Icon(Icons.access_time, color: color),
                  title: Text(time),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Room Chip Widget
class RoomChip extends StatelessWidget {
  final String room;
  final Color color;
  final VoidCallback onTap;

  const RoomChip({
    Key? key,
    required this.room,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              room,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.add_circle_outline,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Booking Tile Widget
class BookingTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback onDelete;

  const BookingTile({
    super.key,
    required this.booking,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF4A6CF7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.event,
            color: Color(0xFF4A6CF7),
          ),
        ),
        title: Text(
          booking.room,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A2A3E),
          ),
        ),
        subtitle: Text('${booking.location} • ${booking.time}'),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Cancel Booking'),
                content: Text('Are you sure you want to cancel this booking?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      onDelete();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking cancelled')),
                      );
                    },
                    child: Text('Yes', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.delete_outline, color: Colors.red),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Color(0xFF2A2A3E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Favorites Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A2A3E),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your favorite rooms will appear here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2A2A3E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),
            CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF4A6CF7),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Асылбек',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A2A3E),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'asylbek@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    _buildProfileOption('Edit Profile', Icons.edit),
                    _buildProfileOption('Settings', Icons.settings),
                    _buildProfileOption('Help & Support', Icons.help),
                    _buildProfileOption('Logout', Icons.logout),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF4A6CF7),
            size: 24,
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2A2A3E),
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
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

class RoomBookingScreen extends StatelessWidget {
  const RoomBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section with dark background
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
                // Status bar simulation
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
                        Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Icon(Icons.wifi, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Icon(Icons.battery_full, color: Colors.white, size: 16),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                
                // Greeting and location
                Text(
                  'Hi Асылбек, you\'re at',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
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
                
                // Search bar and filter button
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
                          decoration: InputDecoration(
                            hintText: 'Looking for room',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                      child: Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter chips
                  Row(
                    children: [
                      FilterChip(
                        label: Text('All', style: TextStyle(color: Colors.white)),
                        selected: true,
                        onSelected: (value) {},
                        selectedColor: Color(0xFF4A6CF7),
                        backgroundColor: Colors.grey[200],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Featured room card
                  Container(
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
                                image: NetworkImage('https://images.unsplash.com/photo-1501436513145-30f24e19fcc4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
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
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 24,
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
                                  'Тапчан',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '2000KZ / 1 hour',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  // Picked for you section
                  Text(
                    'Picked for you',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A3E),
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  // Room cards grid
                  Row(
                    children: [
                      Expanded(
                        child: RoomCard(
                          image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                          price: '103 каб',
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: RoomCard(
                          image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                          price: '105 каб',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Note: Bottom navigation is now handled by MainNavigationWrapper
        ],
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final String image;
  final String price;

  const RoomCard({
    super.key,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                price,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}