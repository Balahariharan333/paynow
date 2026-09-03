// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/search_text_field.dart';
import 'package:paynow/constants/route_constants.dart';

class SelectPlanScreen extends StatelessWidget {
  final String contactName;
  final String phoneNumber;
  final String operatorName;

  const SelectPlanScreen({
    super.key,
    required this.contactName,
    required this.phoneNumber,
    required this.operatorName,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Map<String, dynamic>> plans = [
      {
        'price': 'Rs 299',
        'validity': '28 Days',
        'data': '1.5 GB / Day',
        'calls': 'Unlimited',
        'desc': '100 SMS/Day. Free Disney+ Hotstar Mobile subscription included.',
        'tag': 'BEST SELLER',
        'rawPrice': 299.0
      },
      {
        'price': 'Rs 749',
        'validity': '84 Days',
        'data': '2 GB / Day',
        'calls': 'Unlimited',
        'desc': 'Includes JioTV, JioCinema, and JioCloud access.',
        'tag': 'POPULAR',
        'rawPrice': 749.0
      },
      {
        'price': 'Rs 155',
        'validity': '24 Days',
        'data': '2 GB Total',
        'calls': 'Unlimited',
        'desc': 'Budget friendly plan for users with low data usage.',
        'tag': 'BUDGET VALUE',
        'rawPrice': 155.0
      },
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                    CustomText.header('Select Plan', fontSize: 20),
                  ],
                ),
              ),
              
              // Recipient Details Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.title(
                            '$operatorName � $phoneNumber',
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                          SizedBox(height: Responsive.h(2)),
                          CustomText.body(
                            contactName,
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(6)),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText.title(
                          'Edit',
                          color: AppColors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Segmented TabBar
              Container(
                margin: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.grayFont,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Recommended'),
                    Tab(text: 'Unlimited'),
                    Tab(text: 'Data'),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Plan search textfield
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                child: SearchTextField(
                  hintText: 'Search plan details or amount',
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Tab Bar View content
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPlansList(context, plans),
                    _buildPlansList(context, plans),
                    _buildPlansList(context, plans),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansList(BuildContext context, List<Map<String, dynamic>> plansList) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(8)),
      itemCount: plansList.length,
      separatorBuilder: (context, index) => SizedBox(height: Responsive.h(16)),
      itemBuilder: (context, index) {
        final plan = plansList[index];
        return Container(
          padding: EdgeInsets.all(Responsive.w(16)),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.header(plan['price']!, fontSize: 22, color: AppColors.primary),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(2)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      plan['tag']!,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              
              // Data, Validity details row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPlanSpecTile(label: 'VALIDITY', value: plan['validity']!),
                  _buildPlanSpecTile(label: 'DATA', value: plan['data']!),
                  _buildPlanSpecTile(label: 'CALLS', value: plan['calls']!),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              
              // Description
              CustomText.body(
                plan['desc']!,
                color: AppColors.grayFont,
                fontSize: 12,
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Select Plan Button
              SizedBox(
                width: double.infinity,
                height: Responsive.h(44),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteConstants.rechargeSummary,
                    arguments: {
                      'recipient': phoneNumber,
                      'operatorName': operatorName,
                      'planDetails': '${plan['price']} - ${plan['validity']} Plan',
                      'price': plan['rawPrice']!,
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: CustomText.title(
                    'Select Plan',
                    color: AppColors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanSpecTile({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          label,
          color: AppColors.grayFont,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: Responsive.h(2)),
        CustomText.title(
          value,
          fontSize: 13,
        ),
      ],
    );
  }
}


