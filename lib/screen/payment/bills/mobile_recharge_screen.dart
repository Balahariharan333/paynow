// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/search_text_field.dart';
import 'package:paynow/widget/contact_avatar.dart';
import 'package:paynow/screen/payment/bills/select_plan_screen.dart';

class MobileRechargeScreen extends StatelessWidget {
  const MobileRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Map<String, String>> recents = [
      {'name': 'Ananya', 'phone': '+91 98765 43210'},
      {'name': 'Rahul', 'phone': '+91 91234 56789'},
      {'name': 'Priya', 'phone': '+91 88888 88888'},
      {'name': 'Amit', 'phone': '+91 77777 77777'},
    ];

    final List<Map<String, String>> operators = [
      {'name': 'Jio', 'logo': 'JIO'},
      {'name': 'Airtel', 'logo': 'AIRTEL'},
      {'name': 'BSNL', 'logo': 'BSNL'},
      {'name': 'VI', 'logo': 'VI'},
    ];

    final List<Map<String, String>> contacts = [
      {'name': 'My Number', 'phone': '+91 98765 56789'},
      {'name': 'MOM', 'phone': '+91 98765 12345'},
      {'name': 'DAD', 'phone': '+91 98765 54321'},
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
                  CustomText.header('Mobile Recharge', fontSize: 20),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
              child: SearchTextField(
                hintText: 'Search mobile number or name',
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                children: [
                  // Recent Recharges row
                  CustomText.header('Recent Recharges', fontSize: 15, color: AppColors.grayFont),
                  SizedBox(height: Responsive.h(12)),
                  SizedBox(
                    height: Responsive.h(80),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      itemCount: recents.length,
                      separatorBuilder: (context, index) => SizedBox(width: Responsive.w(16)),
                      itemBuilder: (context, index) {
                        final recent = recents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectPlanScreen(
                                  contactName: recent['name']!,
                                  phoneNumber: recent['phone']!,
                                  operatorName: 'Jio Prepaid',
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              ContactAvatar(name: recent['name']!, radius: 20),
                              SizedBox(height: Responsive.h(6)),
                              CustomText.body(recent['name']!, fontSize: 11),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Responsive.h(20)),
                  
                  // Select Operator grid
                  CustomText.header('Select Operator', fontSize: 15, color: AppColors.grayFont),
                  SizedBox(height: Responsive.h(12)),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width >= 500 ? 6 : 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: operators.length,
                    itemBuilder: (context, index) {
                      final op = operators[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectPlanScreen(
                                contactName: 'New Recharge',
                                phoneNumber: '+91 98765 43210',
                                operatorName: op['name']!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: CustomText.title(
                              op['logo']!,
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Responsive.h(24)),
                  
                  // All Contacts list
                  CustomText.header('All Contacts', fontSize: 15, color: AppColors.grayFont),
                  SizedBox(height: Responsive.h(12)),
                  ...contacts.map((contact) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectPlanScreen(
                                contactName: contact['name']!,
                                phoneNumber: contact['phone']!,
                                operatorName: 'Jio Prepaid',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(Responsive.w(12)),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ContactAvatar(name: contact['name']!),
                              SizedBox(width: Responsive.w(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.title(contact['name']!, fontSize: 14),
                                    SizedBox(height: Responsive.h(2)),
                                    CustomText.subtitle(contact['phone']!, fontSize: 12),
                                  ],
                                ),
                              ),
                              Icon(
                               Icons.chevron_right,
                               color: AppColors.grayFont,
                               size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


