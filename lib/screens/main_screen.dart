import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

// The screen that holds the bottom navigation bar.
// It is a StatefulWidget because the selected tab CHANGES.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 0 = Home, 1 = Search, 2 = Favorites
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // The 3 screens, in the same order as the tabs.
    final screens = [
      const HomeScreen(),
      const SearchScreen(),
      const FavoritesScreen(),
    ];

    return Scaffold(
      // Show the screen that matches the selected tab.
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // which tab is highlighted
        onTap: (index) {
          // The user tapped a tab: save its number and redraw.
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}