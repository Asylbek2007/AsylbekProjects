import 'package:flutter/material.dart';

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
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            Icon(Icons.add_circle_outline, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
