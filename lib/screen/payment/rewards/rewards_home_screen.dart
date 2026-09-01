// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/offer_card_tile.dart';
import 'package:paynow/screen/payment/rewards/active_scratch_cards_screen.dart';
import 'package:paynow/screen/payment/rewards/exclusive_offers_screen.dart';
import 'package:paynow/screen/payment/rewards/refer_and_earn_screen.dart';

class RewardsHomeScreen extends StatelessWidget {
  const RewardsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: EdgeInsets.only(
            left: Responsive.w(20.0),
            right: Responsive.w(20.0),
            top: MediaQuery.of(context).padding.top + Responsive.h(12.0),
            bottom: Responsive.w(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title header
              Padding(
                padding: EdgeInsets.symmetric(vertical: Responsive.h(8.0)),
                child: CustomText.header('PayNow Rewards', fontSize: 22),
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Active Scratch Cards header section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.header('Active Scratch Cards', fontSize: 16, color: AppColors.grayFont),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ActiveScratchCardsScreen()),
                      );
                    },
                    child: CustomText.body('View All', color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              
              // Scratch Cards horizontal list
              SizedBox(
                height: Responsive.h(120),
                child: ListView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildScratchCardShortcut(
                      context,
                      icon: Icons.flash_on,
                      label: 'Win up to \$50',
                      gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                    SizedBox(width: Responsive.w(12)),
                    _buildScratchCardShortcut(
                      context,
                      icon: Icons.shopping_bag,
                      label: 'Shopping Spree',
                      gradient: const [Color(0xFFEC4899), Color(0xFFBE185D)],
                    ),
                    SizedBox(width: Responsive.w(12)),
                    _buildScratchCardShortcut(
                      context,
                      icon: Icons.stars,
                      label: 'Flash Win',
                      gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Explore Missions section
              CustomText.header('Explore Missions', fontSize: 16, color: AppColors.grayFont),
              SizedBox(height: Responsive.h(12)),
              
              // Step Challenge card
              Container(
                padding: EdgeInsets.all(Responsive.w(16)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Responsive.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.tintBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.directions_walk,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    SizedBox(width: Responsive.w(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.title('Daily Step Challenge', fontSize: 14),
                          SizedBox(height: Responsive.h(2)),
                          CustomText.subtitle('Walk 5k steps to earn 50 pts', fontSize: 12),
                        ],
                      ),
                    ),
                    // Circular Percentage indicator
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(6)),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomText.title('70%', color: AppColors.primary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(12)),
              
              // Double cards row (Pay Bills & Add Friends)
              Row(
                children: [
                  Expanded(
                    child: _buildMissionTile(
                      context,
                      icon: Icons.receipt_long,
                      title: 'Pay 3 Bills',
                      reward: '+100 Points',
                      iconBg: Color(0xFFF3E8FF),
                      iconColor: Colors.purple,
                    ),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  Expanded(
                    child: _buildMissionTile(
                      context,
                      icon: Icons.person_add_alt_1,
                      title: 'Add Friends',
                      reward: '+20 Points',
                      iconBg: Color(0xFFFEF3C7),
                      iconColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Exclusive Offers summary section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.header('Exclusive Offers', fontSize: 16, color: AppColors.grayFont),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExclusiveOffersScreen()),
                      );
                    },
                    child: CustomText.body('Explore All', color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              
              // Summarized offers
              const OfferCardTile(
                brandName: 'Brew & Co.',
                description: '20% off on all beverages',
                validityText: 'Expires in 2 days',
                badgeText: 'ACTIVE',
              ),
              SizedBox(height: Responsive.h(12)),
              const OfferCardTile(
                brandName: 'Urban Threads',
                description: '\$15 Cash back on \$50 min spend',
                validityText: 'Using PayNow QR',
                badgeText: 'LIMITED',
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Invite friends box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Responsive.w(20)),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : const Color(0xFFECEFF8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.header('Invite a friend, get \$20', fontSize: 16),
                    SizedBox(height: Responsive.h(6)),
                    CustomText.subtitle(
                      'They get a welcome bonus and you earn instantly when they make their first payment.',
                      color: AppColors.grayFont,
                      fontSize: 12,
                    ),
                    SizedBox(height: Responsive.h(16)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReferAndEarnScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: CustomText.title('Invite Now', color: AppColors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScratchCardShortcut(
    BuildContext context, {
    required IconData icon,
    required String label,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ActiveScratchCardsScreen()),
        );
      },
      child: Container(
        width: Responsive.w(100),
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.white,
              size: 28,
            ),
            SizedBox(height: Responsive.h(12)),
            CustomText.body(
              label,
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String reward,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(8)),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: Responsive.w(20)),
          ),
          SizedBox(height: Responsive.h(16)),
          CustomText.title(title, fontSize: 13),
          SizedBox(height: Responsive.h(4)),
          CustomText.subtitle(reward, color: AppColors.primary, fontSize: 12),
        ],
      ),
    );
  }
}


