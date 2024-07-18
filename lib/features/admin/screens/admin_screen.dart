import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/posts_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _pageIndex = 0;
  final double itemWidth = 42;
  final double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const PostsScreen(),
    const Text('blabla'),
    const AnalyticsScreen()
  ];
  void updatePage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Text(
                    'Admin',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          selectedItemColor: GlobalVariables.selectedNavBarColor,
          unselectedItemColor: GlobalVariables.unselectedNavBarColor,
          backgroundColor: GlobalVariables.backgroundColor,
          iconSize: 28,
          onTap: updatePage,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: _pageIndex == 0
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor))),
                  child: const Icon(Icons.home_outlined),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: _pageIndex == 1
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor))),
                  child: const Badge(
                      label: Text('2'), child: Icon(Icons.analytics)),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: _pageIndex == 2
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor))),
                  child: const Icon(Icons.all_inbox_outlined),
                ),
                label: ''),
          ]),
    );
  }
}
