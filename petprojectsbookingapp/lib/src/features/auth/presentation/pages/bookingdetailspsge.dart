import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/models/booking.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key, required List<Booking> bookings, required void Function(String id) onDeleteBooking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
