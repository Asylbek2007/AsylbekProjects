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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'room': room,
      'time': time,
      'date': date.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      location: map['location'],
      room: map['room'],
      time: map['time'],
      date: DateTime.parse(map['date']),
    );
  }
}
