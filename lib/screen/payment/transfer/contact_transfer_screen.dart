// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/payment/payment_bloc.dart';
import 'package:paynow/bloc/payment/payment_event.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/screen/payment/wallet/transaction_success_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/contact_avatar.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/payment_bubble.dart';

class ContactTransferScreen extends StatefulWidget {
  final String contactName;
  final String contactDetail;

  const ContactTransferScreen({
    super.key,
    required this.contactName,
    required this.contactDetail,
  });

  @override
  State<ContactTransferScreen> createState() => _ContactTransferScreenState();
}

class _ContactTransferScreenState extends State<ContactTransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'amount': 'Rs 120.00',
      'isSent': false,
      'date': 'Yesterday, 4:32 PM',
      'isSuccess': true,
      'txId': 'TXN8834912',
    },
    {
      'amount': 'Rs 50.00',
      'isSent': true,
      'date': 'Today, 10:15 AM',
      'isSuccess': true,
      'txId': 'TXN9912048',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _sendPayment() {
    final typedAmount = _amountController.text.trim();
    if (typedAmount.isEmpty) return;

    final amountVal = double.tryParse(typedAmount);
    if (amountVal == null || amountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final walletState = context.read<WalletBloc>().state;
    final currentBalance = walletState is WalletLoaded ? walletState.balance : 0.0;
    if (currentBalance < amountVal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient Wallet Balance'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();
    _amountController.clear();

    // Call state manager to deduct balance and log transaction
    context.read<WalletBloc>().add(DeductWalletBalanceEvent(amountVal));
    context.read<TransactionBloc>().add(AddTransactionEvent(
          title: widget.contactName,
          amountVal: amountVal,
          type: 'Sent',
          isPositive: false,
          isSuccess: true,
          initialText: widget.contactName.isNotEmpty ? widget.contactName.substring(0, 1) : 'C',
        ));
    context.read<PaymentBloc>().add(ProcessTransferPaymentEvent(
          recipientName: widget.contactName,
          recipientDetail: widget.contactDetail,
          amount: amountVal,
          type: 'Sent',
        ));

    // Push Success Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSuccessScreen(
          isWithdrawal: true, // Reuse success screen layout
          amount: amountVal.toStringAsFixed(2),
          destinationName: widget.contactName,
          destinationIcon: Icons.person_outline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(8.0)),
                      child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  ContactAvatar(name: widget.contactName, radius: 20),
                  SizedBox(width: Responsive.w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(widget.contactName, fontSize: 14),
                        SizedBox(height: Responsive.h(2)),
                        CustomText.subtitle(widget.contactDetail, fontSize: 11),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(Responsive.w(8)),
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            // Payment Log Chat List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: Responsive.h(12.0)),
                reverse: true, // Newest transactions at the bottom
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
                  return PaymentBubble(
                    amount: msg['amount'] as String? ?? 'Rs 0.00',
                    date: (msg['date'] ?? msg['time']) as String? ?? 'Today',
                    isSent: msg['isSent'] as bool? ?? true,
                    isSuccess: msg['isSuccess'] as bool? ?? true,
                    transactionId: msg['txId'] as String? ?? 'TXN${DateTime.now().millisecondsSinceEpoch}',
                  );
                },
              ),
            ),
            
            // Bottom Payment Send Input Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter amount to transfer...',
                          hintStyle: TextStyle(
                            color: AppColors.grayFont,
                            fontSize: 13,
                          ),
                          prefixText: 'Rs ',
                          prefixStyle: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  GestureDetector(
                    onTap: _sendPayment,
                    child: Container(
                      width: Responsive.w(48),
                      height: Responsive.h(48),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.white,
                        size: 20,
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
}
