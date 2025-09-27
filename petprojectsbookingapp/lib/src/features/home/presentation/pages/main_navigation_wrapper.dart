import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/home_page.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/schedule_page.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/all_bookings_page.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/calendar_page.dart';
import 'package:petprojectsbookingapp/models/favarite.dart';
import 'package:petprojectsbookingapp/models/profile.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return SchedulePage();
      case 2:
        return AllBookingsPage();
      case 3:
        return CalendarPage();
      case 4:
        return FavoritesPage();
      case 5:
        return ProfilePage();
      default:
        return HomePage();
    }
  }

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
          _getPage(_selectedIndex),
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
                  _buildNavItem(Icons.calendar_today, 2),
                  _buildNavItem(Icons.event_note, 3),
                  _buildNavItem(Icons.favorite_border, 4),
                  _buildNavItem(Icons.person_outline, 5),
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
