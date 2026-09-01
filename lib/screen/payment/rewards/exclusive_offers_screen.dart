// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/offer_card_tile.dart';

class ExclusiveOffersScreen extends StatelessWidget {
  const ExclusiveOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Map<String, String>> offers = [
      {
        'brand': 'Brew & Co.',
        'desc': '20% off on all beverages',
        'validity': 'Expires in 2 days',
        'badge': 'ACTIVE'
      },
      {
        'brand': 'Urban Threads',
        'desc': '\$15 Cash back on \$50 min spend',
        'validity': 'Using PayNow QR',
        'badge': 'LIMITED'
      },
      {
        'brand': 'FastFuel Gas',
        'desc': 'Get 5% cashback on fuel purchases',
        'validity': 'Valid till end of month',
        'badge': 'ACTIVE'
      },
      {
        'brand': 'MovieMax',
        'desc': 'Buy 1 Get 1 Free movie tickets',
        'validity': 'Expires in 5 days',
        'badge': 'LIMITED'
      },
      {
        'brand': 'MegaMart Groceries',
        'desc': 'Flat Rs 100 off on Rs 1000 spend',
        'validity': 'Using PayNow Wallet',
        'badge': 'ACTIVE'
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(8.0)),
                      child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header('Exclusive Offers', fontSize: 20),
                ],
              ),
            ),
            
            // Offers Scrollable List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.all(Responsive.w(20.0)),
                itemCount: offers.length,
                separatorBuilder: (context, index) => SizedBox(height: Responsive.h(12)),
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return OfferCardTile(
                    brandName: offer['brand']!,
                    description: offer['desc']!,
                    validityText: offer['validity']!,
                    badgeText: offer['badge']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


