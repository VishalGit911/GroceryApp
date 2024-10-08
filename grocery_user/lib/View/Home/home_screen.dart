import 'package:flutter/material.dart';
import 'Screens/Account/account_screen.dart';
import 'Screens/Cart/cart_screen.dart';
import 'Screens/Favorite/favorite_screen.dart';
import 'Screens/Shop/shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List screenList = [
    ShopScreen(),
    CartScreen(),
    FavoriteScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[currentIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //     onTap: (value) {
      //       setState(() {
      //         currentIndex = value;
      //       });
      //     },
      //     currentIndex: currentIndex,
      //     selectedItemColor: Colors.green.shade800,
      //     unselectedItemColor: Colors.black,
      //     selectedIconTheme: IconThemeData(size: 30),
      //     items: [
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.shopping_bag_outlined), label: "Shop"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.favorite_border), label: "Favorite"),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      //     ]),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.favorite_border)),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   height: 75,
      //
      //   animationCurve: Curves.easeInOut,
      //   backgroundColor: Colors.white,
      //   buttonBackgroundColor: Colors.black,
      //   color: Colors.blue.shade200,
      //   animationDuration: const Duration(milliseconds: 100),
      //   onTap: (index) {
      //     setState(() {
      //       currentIndex = index;
      //     });
      //   },
      //   index: 1,
      //   items: const [
      //     Icon(Icons.home, size: 20, color: Colors.black),
      //     Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.black),
      //     Icon(Icons.favorite_border, size: 20, color: Colors.black),
      //     Icon(Icons.person, size: 20, color: Colors.black),
      //   ],
      // ),
    );
  }
}
