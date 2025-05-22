import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/models/room_chip.dart';
import 'package:petprojectsbookingapp/src/features/auth/presentation/pages/user_scree.dart';

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
                    color: color.withOpacity(0.1),
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
                          onTap: () => _showBookingDialog(context, title, room),
                        ),
                      )
                      .toList(),
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
              ...timeSlots.map(
                (time) => ListTile(
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
