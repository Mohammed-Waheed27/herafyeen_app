import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import 'pages/home_page/home_page.dart';
import 'pages/chat_page/chats_page.dart';
import 'pages/history_page/history_page.dart';
import 'pages/profile_page/profile_page.dart';

class WorkerMainScreen extends StatefulWidget {
  const WorkerMainScreen({Key? key}) : super(key: key);

  @override
  State<WorkerMainScreen> createState() => _WorkerMainScreenState();
}

class _WorkerMainScreenState extends State<WorkerMainScreen> {
  int _selectedIndex = 0;

  // List of pages to be displayed in the bottom navigation bar
  final List<Widget> _pages = [
    const WorkerHomePage(),
    const WorkerHistoryPage(),
    const WorkerChatsPage(),
    const WorkerProfilePage(),
  ];

  // Bottom navigation bar items
  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: "الرئيسية",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history_outlined),
      activeIcon: Icon(Icons.history),
      label: "السجل",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      activeIcon: Icon(Icons.chat),
      label: "المحادثات",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: "الملف الشخصي",
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: lightColorScheme.onSecondary,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _bottomNavBarItems,
          selectedItemColor: lightColorScheme.primary,
          unselectedItemColor: lightColorScheme.surface,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11.sp,
          ),
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
