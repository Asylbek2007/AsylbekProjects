import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/models/booking.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback onDelete;

  const BookingTile({super.key, required this.booking, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF4A6CF7).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.event, color: Color(0xFF4A6CF7)),
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
              builder:
                  (context) => AlertDialog(
                    title: Text('Cancel Booking'),
                    content: Text(
                      'Are you sure you want to cancel this booking?',
                    ),
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
