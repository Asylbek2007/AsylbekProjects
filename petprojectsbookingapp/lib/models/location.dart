import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/models/room_chip.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/room_info_page.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
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
              children:
                  rooms
                      .map(
                        (room) => RoomChip(
                          room: room,
                          color: color,
                          onTap:
                              () => _navigateToRoomInfo(context, title, room),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRoomInfo(BuildContext context, String location, String room) {
    // Define room details based on location and room
    Map<String, dynamic> roomDetails = _getRoomDetails(location, room);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RoomInfoPage(
              roomName: roomDetails['name'],
              location: location,
              roomType: roomDetails['type'],
              price: '', // Empty price since we removed pricing
              image: roomDetails['image'],
              description: roomDetails['description'],
            ),
      ),
    );
  }

  Map<String, dynamic> _getRoomDetails(String location, String room) {
    // Define room details for each location
    switch (location) {
      case 'Sport Hall':
        switch (room) {
          case 'Tennis Court':
            return {
              'name': room,
              'type': 'Sports Facility',
              'image':
                  'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Professional tennis court with modern facilities. Perfect for recreational and competitive play. Includes equipment rental and changing rooms.',
            };
          case 'Basketball Court':
            return {
              'name': room,
              'type': 'Sports Facility',
              'image':
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Full-size basketball court with professional flooring and equipment. Perfect for games, practice, and tournaments.',
            };
          case 'Gymnasium':
            return {
              'name': room,
              'type': 'Fitness Center',
              'image':
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Modern gymnasium with state-of-the-art fitness equipment, weights, and cardio machines. Perfect for individual and group workouts.',
            };
          case 'Swimming Pool':
            return {
              'name': room,
              'type': 'Aquatic Facility',
              'image':
                  'https://images.unsplash.com/photo-1530549387789-4c1017266635?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Olympic-size swimming pool with modern filtration system. Perfect for swimming, water aerobics, and recreational activities.',
            };
          default:
            return {
              'name': room,
              'type': 'Sports Facility',
              'price': '\$20/hour',
              'image':
                  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Professional sports facility with modern amenities.',
            };
        }
      case 'Eating Joint':
        switch (room) {
          case 'Main Dining':
            return {
              'name': room,
              'type': 'Dining Facility',
              'image':
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Spacious main dining area perfect for group meals, events, and gatherings. Features modern kitchen facilities and comfortable seating.',
            };
          case 'Private Dining Room':
            return {
              'name': room,
              'type': 'Private Dining',
              'image':
                  'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Elegant private dining room perfect for intimate gatherings, business meetings, and special occasions. Includes exclusive service.',
            };
          case 'Cafeteria':
            return {
              'name': room,
              'type': 'Casual Dining',
              'image':
                  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Casual cafeteria setting perfect for quick meals, coffee breaks, and informal gatherings. Features self-service options.',
            };
          case 'Outdoor Terrace':
            return {
              'name': room,
              'type': 'Outdoor Dining',
              'image':
                  'https://images.unsplash.com/photo-1551218808-94e220e084d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Beautiful outdoor terrace with scenic views. Perfect for outdoor dining, events, and enjoying good weather.',
            };
          default:
            return {
              'name': room,
              'type': 'Dining Facility',
              'price': '\$15/hour',
              'image':
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Comfortable dining facility with modern amenities.',
            };
        }
      case 'Activity Rooms':
        switch (room) {
          case 'Conference Room A':
            return {
              'name': room,
              'type': 'Conference Room',
              'image':
                  'https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Professional conference room equipped with modern presentation technology, comfortable seating, and excellent acoustics for meetings and presentations.',
            };
          case 'Conference Room B':
            return {
              'name': room,
              'type': 'Conference Room',
              'image':
                  'https://images.unsplash.com/photo-1556761175-4b46a572b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Spacious conference room with advanced AV equipment, whiteboards, and comfortable seating for large meetings and presentations.',
            };
          case 'Seminar Hall':
            return {
              'name': room,
              'type': 'Seminar Facility',
              'image':
                  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Large seminar hall with theater-style seating, professional sound system, and projection capabilities. Perfect for workshops and presentations.',
            };
          case 'Training Room':
            return {
              'name': room,
              'type': 'Training Facility',
              'image':
                  'https://images.unsplash.com/photo-1521737711867-e3b97375f902?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Interactive training room with flexible seating arrangements, modern technology, and collaborative tools for effective learning sessions.',
            };
          default:
            return {
              'name': room,
              'type': 'Conference Room',
              'price': '\$30/hour',
              'image':
                  'https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              'description':
                  'Professional meeting space with modern amenities.',
            };
        }
      default:
        return {
          'name': room,
          'type': 'General Room',
          'price': '\$20/hour',
          'image':
              'https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          'description':
              'Versatile room suitable for various activities and events.',
        };
    }
  }
}
