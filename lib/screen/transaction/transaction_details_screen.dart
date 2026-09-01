// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/screen/payment/transfer/contact_transfer_screen.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isSuccess = transaction['isSuccess'] ?? true;
    final bool isPositive = transaction['isPositive'] ?? false;
    final String title = transaction['title'] ?? 'Contact';
    final String amount = transaction['amount'] ?? 'Rs 0.00';
    final String time = transaction['time'] ?? '';
    final String date = transaction['date'] ?? 'Today';
    final String type = transaction['type'] ?? 'Transfer';
    final String utr = transaction['utr'] ?? 'UTR99238491823';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24.0), vertical: Responsive.h(12.0)),
                child: Column(
                  children: [
                    _buildReceiptCard(context, isSuccess, isPositive, title, amount, time, date, type, utr),
                    SizedBox(height: Responsive.h(28)),
                    _buildActionButtons(context, isSuccess, title),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
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
          CustomText.header('Transaction Receipt', fontSize: 20),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(
    BuildContext context,
    bool isSuccess,
    bool isPositive,
    String title,
    String amount,
    String time,
    String date,
    String type,
    String utr,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(24)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status Icon
          Container(
            width: Responsive.w(64),
            height: Responsive.h(64),
            decoration: BoxDecoration(
              color: isSuccess ? AppColors.tintGreen : AppColors.tintRed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_circle : Icons.cancel,
              color: isSuccess ? AppColors.successGreen : AppColors.errorRed,
              size: 36,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          // Status Text
          CustomText.header(
            isSuccess ? 'Transaction Success' : 'Transaction Failed',
            fontSize: 18,
            color: isSuccess ? AppColors.successGreen : AppColors.errorRed,
          ),
          SizedBox(height: Responsive.h(6)),
          CustomText.subtitle(
            '$date, $time',
            fontSize: 12,
          ),
          SizedBox(height: Responsive.h(16)),
          Divider(height: Responsive.h(32), thickness: 1.2),
          // Amount
          CustomText.body('AMOUNT', fontSize: 11, color: AppColors.grayFont, fontWeight: FontWeight.w600),
          SizedBox(height: Responsive.h(6)),
          CustomText.header(
            amount,
            fontSize: 32,
            color: isPositive ? AppColors.successGreen : Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: Responsive.h(24)),
          // Details rows
          _buildDetailRow('Recipient', title),
          SizedBox(height: Responsive.h(14)),
          _buildDetailRow('Transfer Type', type),
          SizedBox(height: Responsive.h(14)),
          _buildDetailRow('Reference UTR', utr),
          SizedBox(height: Responsive.h(14)),
          _buildDetailRow('Payment Source', 'PayNow Wallet Card'),
          SizedBox(height: Responsive.h(20)),
          _buildDottedSeparator(context),
          SizedBox(height: Responsive.h(16)),
          // Secure indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: AppColors.successGreen, size: Responsive.w(16)),
              SizedBox(width: Responsive.w(6)),
              CustomText.body(
                'Secured by PayNow UPI system',
                color: AppColors.grayFont,
                fontSize: 11.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(label, color: AppColors.grayFont, fontSize: 13),
        SizedBox(width: Responsive.w(16)),
        Flexible(
          child: CustomText.title(
            value,
            fontSize: 13.5,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDottedSeparator(BuildContext context) {
    return Row(
      children: List.generate(
        150 ~/ 4,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
            height: Responsive.h(1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isSuccess, String title) {
    return Column(
      children: [
        // Primary Button (Pay Again or Retry)
        SizedBox(
          width: double.infinity,
          height: Responsive.h(52),
          child: ElevatedButton(
            onPressed: () {
              if (isSuccess) {
                // Navigate back to transfer screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactTransferScreen(
                      contactName: title,
                      contactDetail: 'Recipient',
                    ),
                  ),
                );
              } else {
                // Retry transfer
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: CustomText.title(
              isSuccess ? 'Pay Again' : 'Retry Payment',
              color: AppColors.white,
              fontSize: 14.5,
            ),
          ),
        ),
        SizedBox(height: Responsive.h(12)),
        // Secondary Action (Share Receipt)
        SizedBox(
          width: double.infinity,
          height: Responsive.h(52),
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipt image saved to gallery'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.share, color: AppColors.primary, size: Responsive.w(18)),
            label: CustomText.title(
              'Share Receipt',
              color: AppColors.primary,
              fontSize: 14,
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              side: BorderSide(color: AppColors.primary, width: Responsive.w(1.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


