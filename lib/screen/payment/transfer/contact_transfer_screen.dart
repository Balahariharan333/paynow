// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/payment/payment_bloc.dart';
import 'package:paynow/bloc/payment/payment_event.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/transaction/transaction_state.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/constants/route_constants.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/amount_formatter.dart';
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

    if (amountVal > 100000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum transfer limit is Rs 1,00,000 (1 Lakh) per transaction'),
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

    // Call state manager to deduct balance and log transaction (which persists into Hive)
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

    Navigator.pushNamed(
      context,
      RouteConstants.transactionSuccess,
      arguments: {
        'isWithdrawal': false,
        'isFromChat': true,
        'amount': amountVal.toStringAsFixed(2),
        'destinationName': widget.contactName,
        'destinationIcon': Icons.person_outline,
      },
    );
  }

  List<Map<String, dynamic>> _getContactMessages(List<Map<String, dynamic>> allTxns) {
    final cleanContact = widget.contactName.trim().toLowerCase();
    final cleanDetail = widget.contactDetail.trim().toLowerCase();

    final matched = allTxns.where((tx) {
      final title = (tx['title'] as String? ?? '').trim().toLowerCase();
      final detail = (tx['detail'] as String? ?? '').trim().toLowerCase();
      return title == cleanContact ||
          (cleanDetail.isNotEmpty && detail.contains(cleanDetail)) ||
          (cleanDetail.isNotEmpty && cleanDetail.contains(title));
    }).toList();

    final List<Map<String, dynamic>> bubbles = [];
    for (final tx in matched) {
      final bool isSent = !(tx['isPositive'] as bool? ?? false);
      final String timeStr = tx['time'] as String? ?? '';
      final String dateStr = tx['date'] as String? ?? 'Today';
      final String formattedDate = timeStr.isNotEmpty ? '$dateStr, $timeStr' : dateStr;

      bubbles.add({
        'amount': tx['amount'] as String? ?? 'Rs 0.00',
        'date': formattedDate,
        'isSent': isSent,
        'isSuccess': tx['isSuccess'] as bool? ?? true,
        'txId': tx['utr'] ?? tx['id'] ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      });
    }

    return bubbles;
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
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onSurface,
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
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            // Payment Log Chat List (Dynamically updated from TransactionBloc & Hive)
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  final allTxns = state is TransactionLoaded ? state.allTransactions : <Map<String, dynamic>>[];
                  final messages = _getContactMessages(allTxns);

                  if (messages.isEmpty) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(24.0)),
                      child: Column(
                        children: [
                          SizedBox(height: Responsive.h(10)),
                          // Contact Avatar Card
                          ContactAvatar(name: widget.contactName, radius: 34),
                          SizedBox(height: Responsive.h(12)),
                          CustomText.header(widget.contactName, fontSize: 17),
                          SizedBox(height: Responsive.h(4)),
                          CustomText.subtitle(widget.contactDetail, fontSize: 12),
                          SizedBox(height: Responsive.h(24)),

                          // Quick Preset Suggestions
                          CustomText.subtitle('Quick Pay', fontSize: 11, color: AppColors.grayFont),
                          SizedBox(height: Responsive.h(8)),
                          Wrap(
                            spacing: Responsive.w(8),
                            runSpacing: Responsive.h(8),
                            alignment: WrapAlignment.center,
                            children: ['100', '500', '1000', '2000'].map((amt) {
                              return GestureDetector(
                                onTap: () {
                                  _amountController.text = amt;
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(8)),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: CustomText.title('+ ₹$amt', fontSize: 12, color: AppColors.primary),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.symmetric(vertical: Responsive.h(12.0)),
                    reverse: true, // Index 0 is positioned at the bottom near the input bar
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return PaymentBubble(
                        amount: msg['amount'] as String? ?? 'Rs 0.00',
                        date: msg['date'] as String? ?? 'Today',
                        isSent: msg['isSent'] as bool? ?? true,
                        isSuccess: msg['isSuccess'] as bool? ?? true,
                        transactionId: msg['txId'] as String? ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
                      );
                    },
                  );
                },
              ),
            ),
            
            // Bottom Payment Send Input Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).scaffoldBackgroundColor
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: const [
                          MaxAmountTextInputFormatter(max: 100000.0),
                        ],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter amount to transfer...',
                          hintStyle: const TextStyle(
                            color: AppColors.grayFont,
                            fontSize: 13,
                          ),
                          prefixText: 'Rs ',
                          prefixStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
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
