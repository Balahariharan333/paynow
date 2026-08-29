import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';

class WalletState {
  // Private Constructor
  WalletState._();

  // Singleton instance
  static final WalletState instance = WalletState._();

  // Balance Notifier
  final ValueNotifier<double> balanceNotifier = ValueNotifier<double>(12450.85);

  // User's own linked banks list
  final ValueNotifier<List<Map<String, dynamic>>> linkedBanksNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([
    {
      'bankName': 'Chase Bank Platinum',
      'accountNumber': 'Ending in •••• 4829',
      'icon': Icons.account_balance,
      'mockBalance': 'Rs 34,250.00',
    },
    {
      'bankName': 'HSBC Savings',
      'accountNumber': 'Ending in •••• 1102',
      'icon': Icons.savings_outlined,
      'mockBalance': 'Rs 8,920.00',
    },
  ]);

  // Card status & Limits Notifier
  final ValueNotifier<bool> isCardFrozenNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<double> dailyLimitNotifier = ValueNotifier<double>(50000.00);

  // Bank Recipients List Notifier
  final ValueNotifier<List<Map<String, String>>> bankRecipientsNotifier =
      ValueNotifier<List<Map<String, String>>>([
    {'name': 'Harvey Specter', 'detail': 'HDFC Bank •••• 8829', 'bank': 'HDFC Bank'},
    {'name': 'Rachel Zane', 'detail': 'Chase Bank •••• 1102', 'bank': 'Chase Bank'},
    {'name': 'Louis Litt', 'detail': 'Axis Bank •••• 5678', 'bank': 'Axis Bank'},
  ]);

  // UPI Recipients List Notifier
  final ValueNotifier<List<Map<String, String>>> upiRecipientsNotifier =
      ValueNotifier<List<Map<String, String>>>([
    {'name': 'Mike Ross', 'detail': 'mikeross@paynow'},
    {'name': 'Sarah Jenkins', 'detail': 'sarah@okaxis'},
    {'name': 'Jessica Pearson', 'detail': 'jessica@paytm'},
  ]);

  // Preloaded Transaction list Notifier
  final ValueNotifier<List<Map<String, dynamic>>> transactionsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([
    {
      'id': 'TXN_001',
      'title': 'Sarah Jenkins',
      'time': '10:42 AM',
      'date': 'Today',
      'type': 'Sent',
      'amount': 'Rs 120.00',
      'status': 'Success',
      'isPositive': false,
      'isSuccess': true,
      'initialText': 'S',
      'iconBackground': Color(0xFFE5E7EB),
      'iconColor': AppColors.grayFont,
      'utr': 'UTR88349129849',
    },
    {
      'id': 'TXN_002',
      'title': 'Stripe Inc.',
      'time': '09:15 AM',
      'date': 'Today',
      'type': 'Payout',
      'amount': 'Rs 850.50',
      'status': 'Success',
      'isPositive': true,
      'isSuccess': true,
      'icon': Icons.card_giftcard,
      'iconBackground': AppColors.tintPurple,
      'iconColor': AppColors.primaryGradientEnd,
      'utr': 'UTR99837482910',
    },
    {
      'id': 'TXN_003',
      'title': 'Mike Ross',
      'time': '08:30 PM',
      'date': 'Yesterday',
      'type': 'Failed',
      'amount': 'Rs 45.00',
      'status': 'Declined',
      'isPositive': false,
      'isSuccess': false,
      'initialText': 'M',
      'iconBackground': Color(0xFFE5E7EB),
      'iconColor': AppColors.grayFont,
      'utr': 'UTR12837498112',
    },
    {
      'id': 'TXN_004',
      'title': 'City Power & Light',
      'time': '02:10 PM',
      'date': 'Yesterday',
      'type': 'Utility',
      'amount': 'Rs 132.80',
      'status': 'Success',
      'isPositive': false,
      'isSuccess': true,
      'icon': Icons.flash_on,
      'iconBackground': AppColors.tintBlue,
      'iconColor': AppColors.primary,
      'utr': 'UTR55492348123',
    },
    {
      'id': 'TXN_005',
      'title': 'Whole Foods Market',
      'time': '5:45 PM',
      'date': 'Last Week',
      'type': 'Scan & Pay',
      'amount': 'Rs 84.20',
      'status': 'Success',
      'isPositive': false,
      'isSuccess': true,
      'icon': Icons.storefront,
      'iconBackground': Color(0xFFE5E7EB),
      'iconColor': AppColors.grayFont,
      'utr': 'UTR44923749234',
    },
  ]);

  // Methods to manipulate state
  void addTransaction({
    required String title,
    required double amountVal,
    required String type,
    required bool isPositive,
    required bool isSuccess,
    IconData? icon,
    Color? iconBackground,
    Color? iconColor,
    String? initialText,
  }) {
    // Generate mock ID and UTR
    final String id = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    final String utr = 'UTR${(100000000000 + DateTime.now().millisecondsSinceEpoch % 100000000000)}';

    // 1. Deduct or Add to Wallet Balance
    if (isSuccess) {
      if (isPositive) {
        balanceNotifier.value += amountVal;
      } else {
        balanceNotifier.value -= amountVal;
      }
    }

    // 2. Format Display Amount
    final String formattedAmount = 'Rs ${amountVal.toStringAsFixed(2)}';

    // 3. Create Transaction Map
    final Map<String, dynamic> newTx = {
      'id': id,
      'title': title,
      'time': _formatCurrentTime(),
      'date': 'Today',
      'type': type,
      'amount': formattedAmount,
      'status': isSuccess ? 'Success' : 'Failed',
      'isPositive': isPositive,
      'isSuccess': isSuccess,
      'utr': utr,
    };

    if (icon != null) newTx['icon'] = icon;
    if (iconBackground != null) newTx['iconBackground'] = iconBackground;
    if (iconColor != null) newTx['iconColor'] = iconColor;
    if (initialText != null) newTx['initialText'] = initialText;

    // 4. Update transactions list
    transactionsNotifier.value = [newTx, ...transactionsNotifier.value];
  }

  void addBankRecipient({
    required String name,
    required String detail,
    required String bank,
  }) {
    final Map<String, String> newBank = {
      'name': name,
      'detail': detail,
      'bank': bank,
    };
    bankRecipientsNotifier.value = [...bankRecipientsNotifier.value, newBank];
  }

  void addUpiRecipient({
    required String name,
    required String detail,
  }) {
    final Map<String, String> newUpi = {
      'name': name,
      'detail': detail,
    };
    upiRecipientsNotifier.value = [...upiRecipientsNotifier.value, newUpi];
  }

  void addLinkedBank({
    required String bankName,
    required String accountNumber,
    required IconData icon,
    double initialBalance = 5000.0,
  }) {
    final String lastFour = accountNumber.length >= 4 
        ? accountNumber.substring(accountNumber.length - 4) 
        : accountNumber;
    final Map<String, dynamic> newBank = {
      'bankName': bankName,
      'accountNumber': 'Ending in •••• $lastFour',
      'icon': icon,
      'mockBalance': 'Rs ${initialBalance.toStringAsFixed(2)}',
    };
    linkedBanksNotifier.value = [...linkedBanksNotifier.value, newBank];
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
