// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/constants/route_constants.dart';

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
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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

  void _showServicePaymentDialog(BuildContext context, Map<String, dynamic> item) {
    final String label = item['label'] as String;
    final IconData icon = item['icon'] as IconData;
    final idController = TextEditingController();
    final amountController = TextEditingController(text: '150.00');

    String hintText = 'Account / Consumer Number';
    if (label.contains('FASTag') || label.contains('Challan') || label.contains('Insurance')) {
      hintText = 'Vehicle Reg Number (e.g. DL 01 AB 1234)';
    } else if (label.contains('DTH') || label.contains('Cable')) {
      hintText = 'Subscriber / Smart Card ID';
    } else if (label.contains('Broadband')) {
      hintText = 'Broadband Account ID';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: Responsive.w(20),
            right: Responsive.w(20),
            top: Responsive.h(20),
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + Responsive.h(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayFont.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(label, fontSize: 16, fontWeight: FontWeight.bold),
                        CustomText.body('Bill Payment & Recharge', fontSize: 12, color: AppColors.grayFont),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.grayFont),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const Divider(height: 24),
              CustomText.title('Consumer / Account ID', fontSize: 13),
              SizedBox(height: Responsive.h(8)),
              TextField(
                controller: idController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.grayFont),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(12)),
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              CustomText.title('Bill Amount', fontSize: 13),
              SizedBox(height: Responsive.h(8)),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixText: 'Rs ',
                  prefixStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(12)),
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              SizedBox(
                width: double.infinity,
                height: Responsive.h(48),
                child: ElevatedButton(
                  onPressed: () {
                    final idText = idController.text.trim();
                    final amountText = amountController.text.trim();
                    final double parsedPrice = double.tryParse(amountText) ?? 150.0;
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(
                      context,
                      RouteConstants.rechargeSummary,
                      arguments: {
                        'recipient': idText.isNotEmpty ? '$label ($idText)' : '$label Service',
                        'operatorName': label,
                        'planDetails': '$label Bill Payment',
                        'price': parsedPrice,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: CustomText.title('Proceed to Pay', color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
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
                  Navigator.pushNamed(context, RouteConstants.mobileRecharge);
                } else {
                  _showServicePaymentDialog(context, item);
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
                      width: Responsive.w(34),
                      height: Responsive.h(34),
                      decoration: const BoxDecoration(
                        color: AppColors.tintBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    SizedBox(height: Responsive.h(6)),
                    Expanded(
                      child: Center(
                        child: Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
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


