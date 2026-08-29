// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/search_text_field.dart';
import 'package:paynow/screen/payment/bills/recharge_directory_screen.dart';
import 'package:paynow/screen/payment/bills/mobile_recharge_screen.dart';
import 'package:paynow/screen/payment/bills/recharge_summary_screen.dart';

class BillsDashboardScreen extends StatelessWidget {
  const BillsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
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
              // Custom Header
              Row(
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
                  CustomText.header('Bills', fontSize: 20),
                ],
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Search Input
              SearchTextField(
                hintText: 'Search by biller name, number or UPI ID',
              ),
              SizedBox(height: Responsive.h(20)),
              
              // Gradient Cashback Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Responsive.w(16)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(2)),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: CustomText.body(
                        'LIMITED OFFER',
                        color: AppColors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.h(8)),
                    CustomText.title(
                      'Get 5% Cashback',
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                    SizedBox(height: Responsive.h(4)),
                    CustomText.subtitle(
                      'On your first electricity bill payment this month.',
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                    SizedBox(height: Responsive.h(12)),
                    CustomText.body(
                      'CODE: BILLPAY5',
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Due Bills Header
              CustomText.header('Due Bills', fontSize: 16, color: AppColors.grayFont),
              SizedBox(height: Responsive.h(12)),
              
              // Due Bills Horizontal List
              SizedBox(
                height: Responsive.h(130),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildDueBillCard(
                      context,
                      title: 'Electricity',
                      sub: 'AC 9283 4810',
                      due: 'DUE IN 2 DAYS',
                      amount: 'Rs 142.50',
                      isActive: true,
                      onPayTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RechargeSummaryScreen(
                              recipient: 'Electricity (AC 9283 4810)',
                              operatorName: 'State Electricity Board',
                              planDetails: 'Electricity Bill Payment',
                              price: 142.50,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: Responsive.w(12)),
                    _buildDueBillCard(
                      context,
                      title: 'Broadband',
                      sub: 'AC 9283 1102',
                      due: 'PAID - SEP 01',
                      amount: 'Rs 142.50',
                      isActive: false,
                      onPayTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Recharge & Bills Directory Grid Group
              _buildCategoryGroup(
                context,
                title: 'Recharge & Bills',
                items: [
                  {'label': 'Mobile Recharge', 'icon': Icons.phone_android, 'action': 'mobile_recharge'},
                  {'label': 'Electricity', 'icon': Icons.lightbulb_outline, 'action': 'electricity'},
                  {'label': 'Water Bill', 'icon': Icons.water_drop_outlined, 'action': 'water'},
                  {'label': 'Broadband', 'icon': Icons.router_outlined, 'action': 'broadband'},
                ],
              ),
              SizedBox(height: Responsive.h(20)),
              
              // Loans Grid Group
              _buildCategoryGroup(
                context,
                title: 'Loans',
                items: [
                  {'label': 'Personal Loan', 'icon': Icons.person_outline},
                  {'label': 'Mutual Funds', 'icon': Icons.trending_up},
                  {'label': 'Gold Loan', 'icon': Icons.stars_outlined},
                  {'label': 'Credit Score', 'icon': Icons.speed},
                ],
              ),
              SizedBox(height: Responsive.h(20)),
              
              // Insurance Grid Group
              _buildCategoryGroup(
                context,
                title: 'Insurance',
                items: [
                  {'label': 'Bike', 'icon': Icons.directions_bike},
                  {'label': 'Car', 'icon': Icons.directions_car},
                  {'label': 'Health', 'icon': Icons.favorite_border},
                  {'label': 'LIC / Life', 'icon': Icons.family_restroom},
                ],
              ),
              SizedBox(height: Responsive.h(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDueBillCard(
    BuildContext context, {
    required String title,
    required String sub,
    required String due,
    required String amount,
    required bool isActive,
    required VoidCallback onPayTap,
  }) {
    return Container(
      width: Responsive.w(170),
      padding: EdgeInsets.all(Responsive.w(12)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.title(title, fontSize: 13),
              CustomText.body(
                due,
                color: isActive ? AppColors.errorRed : AppColors.grayFont,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: Responsive.h(4)),
          CustomText.subtitle(sub, fontSize: 11),
          Spacer(),
          CustomText.header(amount, fontSize: 16),
          SizedBox(height: Responsive.h(8)),
          SizedBox(
            width: double.infinity,
            height: Responsive.h(32),
            child: ElevatedButton(
              onPressed: isActive ? onPayTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? AppColors.primary : Theme.of(context).cardColor,
                foregroundColor: isActive ? AppColors.white : AppColors.primary,
                side: isActive ? BorderSide.none : BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: CustomText.title(
                isActive ? 'Pay Now' : 'Receipt',
                color: isActive ? AppColors.white : AppColors.primary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGroup(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.header(title, fontSize: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RechargeDirectoryScreen()),
                );
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grayFont,
                size: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return GestureDetector(
              onTap: () {
                if (item['action'] == 'mobile_recharge') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MobileRechargeScreen()),
                  );
                } else if (item['action'] == 'electricity') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RechargeSummaryScreen(
                        recipient: 'Electricity (AC 9283 4810)',
                        operatorName: 'State Electricity Board',
                        planDetails: 'Electricity Bill Payment',
                        price: 142.50,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RechargeDirectoryScreen()),
                  );
                }
              },
              child: Container(
                width: Responsive.w(76),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(4), vertical: Responsive.h(12)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Responsive.w(8)),
                      decoration: BoxDecoration(
                        color: AppColors.tintBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(height: Responsive.h(8)),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


