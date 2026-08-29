// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_bottom_nav_bar.dart';
import 'package:paynow/screen/home/home_screen.dart';
import 'package:paynow/screen/home/history_screen.dart';
import 'package:paynow/screen/payment/wallet/wallet_balance_screen.dart';
import 'package:paynow/screen/payment/rewards/rewards_home_screen.dart';
import 'package:paynow/screen/payment/transfer/qr_scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RewardsHomeScreen(),
    const HistoryScreen(),
    const WalletBalanceScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true, // Important for BottomAppBar with notch
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrScannerScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 0,
        highlightElevation: 0,
        child: Icon(
          Icons.qr_code_scanner,
          color: AppColors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}


