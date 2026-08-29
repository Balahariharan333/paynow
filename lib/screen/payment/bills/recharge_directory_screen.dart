// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/screen/payment/bills/mobile_recharge_screen.dart';
import 'package:paynow/screen/payment/bills/recharge_summary_screen.dart';

class RechargeDirectoryScreen extends StatelessWidget {
  const RechargeDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
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
                  CustomText.header('Recharge & Bills', fontSize: 20),
                ],
              ),
            ),
            
            // Directory Categories List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(8)),
                children: [
                  _buildCategoryDirectory(
                    context,
                    title: 'Telecom & Recharges',
                    items: [
                      {'label': 'Mobile Recharge', 'icon': Icons.phone_android, 'action': 'mobile'},
                      {'label': 'DTH Connection', 'icon': Icons.tv},
                      {'label': 'Mobile Postpaid', 'icon': Icons.phone_android},
                      {'label': 'Google Play', 'icon': Icons.play_arrow},
                      {'label': 'Cable TV', 'icon': Icons.settings_input_hdmi},
                      {'label': 'Roaming Pack', 'icon': Icons.language},
                    ],
                  ),
                  SizedBox(height: Responsive.h(24)),
                  _buildCategoryDirectory(
                    context,
                    title: 'Utilities',
                    items: [
                      {'label': 'Electricity Bill', 'icon': Icons.lightbulb_outline, 'action': 'electricity'},
                      {'label': 'Credit Card Bill', 'icon': Icons.credit_card},
                      {'label': 'Loan Repayment', 'icon': Icons.monetization_on_outlined},
                      {'label': 'Book Cylinder', 'icon': Icons.propane_tank_outlined},
                      {'label': 'Broadband', 'icon': Icons.router_outlined},
                      {'label': 'Water Bill', 'icon': Icons.water_drop_outlined},
                    ],
                  ),
                  SizedBox(height: Responsive.h(24)),
                  _buildCategoryDirectory(
                    context,
                    title: 'Vehicle Payments',
                    items: [
                      {'label': 'FASTag Recharge', 'icon': Icons.directions_car_filled},
                      {'label': 'eChallan', 'icon': Icons.receipt_outlined},
                      {'label': 'Bike Insurance', 'icon': Icons.directions_bike},
                      {'label': 'Car Insurance', 'icon': Icons.directions_car},
                    ],
                  ),
                  SizedBox(height: Responsive.h(40)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDirectory(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.header(title, fontSize: 15, color: AppColors.grayFont),
        SizedBox(height: Responsive.h(12)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width >= 500 ? 6 : 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                if (item['action'] == 'mobile') {
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
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(4), vertical: Responsive.h(8)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Responsive.w(6)),
                      decoration: BoxDecoration(
                        color: AppColors.tintBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    SizedBox(height: Responsive.h(8)),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


