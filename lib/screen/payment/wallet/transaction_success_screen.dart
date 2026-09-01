// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final bool isWithdrawal;
  final bool isFromChat;
  final String amount;
  final String destinationName;
  final IconData destinationIcon;

  const TransactionSuccessScreen({
    super.key,
    required this.isWithdrawal,
    this.isFromChat = false,
    required this.amount,
    required this.destinationName,
    required this.destinationIcon,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    final String title = isFromChat
        ? 'Payment Successful'
        : (isWithdrawal ? 'Withdrawal Successful' : 'Add Money Successful');
        
    final String subtitle = isFromChat
        ? 'Rs $amount has been successfully transferred to $destinationName.'
        : (isWithdrawal
            ? 'The amount has been transferred to your $destinationName.'
            : 'The amount has been successfully added from your $destinationName to your Main Wallet.');
            
    final String amountHeader = isFromChat
        ? 'PAID AMOUNT'
        : (isWithdrawal ? 'WITHDRAWN AMOUNT' : 'ADDED AMOUNT');
    
    // Formatting date and time
    final dateStr = 'Today • Just now'; 
    final txId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isFromChat) {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(8.0)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header(
                    isFromChat ? 'Payment Receipt' : (isWithdrawal ? 'Withdrawal' : 'Add Money'),
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                child: Column(
                  children: [
                    SizedBox(height: Responsive.h(24)),
                    
                    // Success Checked Circle
                    Center(
                      child: Container(
                        width: Responsive.w(130),
                        height: Responsive.h(130),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD1FAE5), // Soft green background ring
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: Responsive.w(90),
                            height: Responsive.h(90),
                            decoration: const BoxDecoration(
                              color: Color(0xFF34D399), // Bright success green
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Success Messages
                    CustomText.header(title, fontSize: 24, textAlign: TextAlign.center),
                    SizedBox(height: Responsive.h(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0)),
                      child: CustomText.subtitle(
                        subtitle,
                        color: AppColors.grayFont,
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: Responsive.h(32)),
                    
                    // Transaction Details Sheet Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Responsive.w(24)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          CustomText.body(
                            amountHeader,
                            color: AppColors.grayFont,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: Responsive.h(12)),
                          CustomText.header(
                            'Rs $amount',
                            color: AppColors.primary,
                            fontSize: 32,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Responsive.h(20.0)),
                            child: Divider(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE5E7EB),
                              height: Responsive.h(1),
                            ),
                          ),
                          
                          // Details Rows
                          _buildDetailRow(
                            label: 'Transaction ID',
                            valueWidget: CustomText.title(txId, fontSize: 13),
                          ),
                          SizedBox(height: Responsive.h(16)),
                          _buildDetailRow(
                            label: 'Date & Time',
                            valueWidget: CustomText.title(dateStr, fontSize: 13),
                          ),
                          SizedBox(height: Responsive.h(16)),
                          _buildDetailRow(
                            label: isFromChat ? 'Transferred To' : (isWithdrawal ? 'Destination' : 'Payment Source'),
                            valueWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(Responsive.w(4)),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    destinationIcon,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: Responsive.w(6)),
                                Flexible(
                                  child: CustomText.title(
                                    destinationName,
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Responsive.h(16)),
                          _buildDetailRow(
                            label: 'Status',
                            valueWidget: Container(
                              padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(4)),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'COMPLETED',
                                style: TextStyle(
                                  color: Color(0xFF065F46),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(32)),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(12.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.h(54),
                    child: ElevatedButton(
                      onPressed: () {
                        if (isFromChat) {
                          // Return directly back to contact chat
                          Navigator.pop(context);
                        } else {
                          // Pop all the way back to main screen / dashboard
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: CustomText.title(
                        isFromChat ? 'Back to Chat' : 'View Wallet',
                        color: AppColors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.h(54),
                    child: OutlinedButton(
                      onPressed: () {
                        // Pop all the way back to main screen
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE5E7EB),
                          width: Responsive.w(1.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: CustomText.title(
                        isFromChat ? 'Go to Home' : 'Done',
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
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

  Widget _buildDetailRow({required String label, required Widget valueWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.body(label, color: AppColors.grayFont, fontSize: 13),
        const SizedBox(width: 12),
        Flexible(
          child: valueWidget,
        ),
      ],
    );
  }
}
