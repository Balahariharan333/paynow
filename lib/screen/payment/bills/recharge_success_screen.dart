// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class RechargeSuccessScreen extends StatelessWidget {
  final String amount;
  final String recipientNumber;

  const RechargeSuccessScreen({
    super.key,
    required this.amount,
    required this.recipientNumber,
  });

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
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(8.0)),
                      child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header('Recharge Successful', fontSize: 20),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Concentric success check circles
                    Container(
                      width: Responsive.w(110),
                      height: Responsive.h(110),
                      decoration: BoxDecoration(
                        color: Color(0xFFECEFFC),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFFD4DAF8),
                          width: Responsive.w(8),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: Responsive.w(70),
                          height: Responsive.h(70),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 38,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(32)),
                    
                    // Success messages
                    CustomText.header('Recharge Successful', fontSize: 22),
                    SizedBox(height: Responsive.h(12)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0)),
                      child: CustomText.subtitle(
                        recipientNumber.contains('AC')
                            ? 'Successfully paid bill of $amount for electricity customer $recipientNumber'
                            : 'Successfully recharged $amount for mobile $recipientNumber',
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: Responsive.h(40)),
                    
                    // Details Card
                    Container(
                      padding: EdgeInsets.all(Responsive.w(20)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Order ID', 'PN-8273941029'),
                          SizedBox(height: Responsive.h(16)),
                          _buildDetailRow('Date & Time', '24 Oct 2023, 14:22 PM'),
                          SizedBox(height: Responsive.h(16)),
                          _buildDetailRow('Payment Method', 'PayNow Wallet'),
                          SizedBox(height: Responsive.h(16)),
                          _buildDetailRow('Status', 'COMPLETED', isStatus: true),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(40)),
                  ],
                ),
              ),
            ),
            
            // Bottom Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(12.0)),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.h(54),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: CustomText.title(
                        'Done',
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.h(54),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: 'PayNow Payment Receipt\nAmount: $amount\nRecipient: $recipientNumber\nStatus: SUCCESSFUL\nDate: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}\nRef ID: TXN${DateTime.now().millisecondsSinceEpoch}',
                        ));
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Receipt copied to clipboard!'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.share, color: AppColors.primary, size: Responsive.w(20)),
                      label: CustomText.title(
                        'Share Receipt',
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary, width: Responsive.w(1.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.body(label, color: AppColors.grayFont, fontSize: 13),
        isStatus
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(2)),
                decoration: BoxDecoration(
                  color: Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : CustomText.title(value, fontSize: 13),
      ],
    );
  }
}


