// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/constants/route_constants.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/amount_formatter.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/contact_avatar.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/search_text_field.dart';

class TransferHomeScreen extends StatefulWidget {
  const TransferHomeScreen({super.key});

  @override
  State<TransferHomeScreen> createState() => _TransferHomeScreenState();
}

class _TransferHomeScreenState extends State<TransferHomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedSelfBank = '';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showSelfTransferSheet(BuildContext context) {
    _amountController.clear();
    final walletState = context.read<WalletBloc>().state;
    final List<Map<String, dynamic>> linkedBanks =
        walletState is WalletLoaded ? walletState.linkedBanks : <Map<String, dynamic>>[];

    if (linkedBanks.isEmpty) {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: CustomText.header('No Bank Account Linked', fontSize: 18),
          content: CustomText.body(
            'Self Transfer requires linked bank accounts. Please link your bank account first to transfer money.',
            fontSize: 13,
            color: AppColors.grayFont,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: CustomText.title('Cancel', color: AppColors.grayFont, fontSize: 13),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushNamed(context, RouteConstants.linkBank, arguments: false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: CustomText.title('Link Bank', color: AppColors.white, fontSize: 13),
            ),
          ],
        ),
      );
      return;
    }

    if (linkedBanks.length < 2) {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: CustomText.header('Link Another Bank', fontSize: 18),
          content: CustomText.body(
            'You currently have only 1 bank account linked (${linkedBanks.first['bankName']}). Self transfer moves funds between your own accounts, so you need at least 2 linked accounts.',
            fontSize: 13,
            color: AppColors.grayFont,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: CustomText.title('Cancel', color: AppColors.grayFont, fontSize: 13),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushNamed(context, RouteConstants.linkBank, arguments: false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: CustomText.title('+ Link Another Bank', color: AppColors.white, fontSize: 13),
            ),
          ],
        ),
      );
      return;
    }

    final bankNames = linkedBanks
        .map((b) => '${b['bankName']} (${b['accountNumber']})')
        .toList();
    _selectedSelfBank = bankNames.length > 1 ? bankNames[1] : bankNames[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (builderContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(sheetContext).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: EdgeInsets.all(Responsive.w(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText.header('Self Transfer', fontSize: 18),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(16)),
                    // Bank Selection
                    CustomText.title('Select Destination Bank', fontSize: 13),
                    SizedBox(height: Responsive.h(8)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(4)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : AppColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: bankNames.contains(_selectedSelfBank) ? _selectedSelfBank : bankNames.first,
                          isExpanded: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          items: bankNames.map((String bank) {
                            return DropdownMenuItem<String>(
                              value: bank,
                              child: Text(bank),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setSheetState(() {
                                _selectedSelfBank = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(18)),
                    // Amount Input
                    CustomText.title('Amount to Transfer', fontSize: 13),
                    SizedBox(height: Responsive.h(8)),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: const [
                        MaxAmountTextInputFormatter(max: 100000.0),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter amount (max Rs 1,00,000)',
                        hintStyle: const TextStyle(color: AppColors.grayFont, fontSize: 13),
                        filled: true,
                        fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : AppColors.lightGray,
                        prefixText: 'Rs ',
                        prefixStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(14)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    // Proceed button
                    SizedBox(
                      width: double.infinity,
                      height: Responsive.h(52),
                      child: ElevatedButton(
                        onPressed: () {
                          final amountText = _amountController.text.trim();
                          final amountVal = double.tryParse(amountText);

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
                                content: Text('Maximum self-transfer limit is Rs 1,00,000 (1 Lakh)'),
                                backgroundColor: AppColors.errorRed,
                              ),
                            );
                            return;
                          }

                          // Verify wallet balance is sufficient
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

                          // Execute transaction state updates via BLoCs
                          context.read<WalletBloc>().add(DeductWalletBalanceEvent(amountVal));
                          context.read<TransactionBloc>().add(AddTransactionEvent(
                                title: _selectedSelfBank,
                                amountVal: amountVal,
                                type: 'Self Transfer',
                                isPositive: false,
                                isSuccess: true,
                                icon: Icons.person_outline,
                                iconBackground: AppColors.tintBlue,
                                iconColor: AppColors.primary,
                              ));

                          Navigator.pop(sheetContext); // Close sheet
                          
                          // Push Success screen
                          Navigator.pushNamed(
                            context,
                            RouteConstants.transactionSuccess,
                            arguments: {
                              'isWithdrawal': true,
                              'amount': amountVal.toStringAsFixed(2),
                              'destinationName': _selectedSelfBank,
                              'destinationIcon': Icons.account_balance,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: CustomText.title(
                          'Transfer Money',
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Map<String, String>> recents = const [
      {'name': 'Mike Ross', 'detail': 'mikeross@paynow', 'date': 'Today, 10:45 AM'},
      {'name': 'Sarah Jenkins', 'detail': 'HDFC Bank •••• 8829', 'date': 'Yesterday'},
      {'name': 'Harvey Specter', 'detail': 'harvey@okhdfc', 'date': '12 Oct, 2023'},
      {'name': 'Donna Paulsen', 'detail': 'donna@paynow', 'date': '10 Oct, 2023'},
      {'name': 'Rachel Zane', 'detail': 'Chase Bank •••• 1102', 'date': '08 Oct, 2023'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  CustomText.header('Transfer Money', fontSize: 20),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
              child: SearchTextField(
                hintText: 'Enter mobile number, name, bank or UPI ID',
              ),
            ),
            SizedBox(height: Responsive.h(24)),
            
            // Transfer Channels row (PhonePe Style grid)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildChannelItem(
                    context,
                    icon: Icons.phone_android,
                    label: 'To Mobile\nNumber',
                    onTap: () => Navigator.pushNamed(context, RouteConstants.toMobileNumber),
                  ),
                  _buildChannelItem(
                    context,
                    icon: Icons.account_balance,
                    label: 'To Bank /\nUPI ID',
                    onTap: () => Navigator.pushNamed(context, RouteConstants.bankTransfer),
                  ),
                  _buildChannelItem(
                    context,
                    icon: Icons.person_outline,
                    label: 'To Self\nAccount',
                    onTap: () => _showSelfTransferSheet(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(28)),
            
            // Recent Transfers Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
              child: CustomText.header('Recent Transfers', fontSize: 16, color: AppColors.grayFont),
            ),
            SizedBox(height: Responsive.h(12)),
            
            // Recent Recipient List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                itemCount: recents.length,
                separatorBuilder: (context, index) => SizedBox(height: Responsive.h(12)),
                itemBuilder: (context, index) {
                  final contact = recents[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteConstants.contactTransfer,
                      arguments: {
                        'contactName': contact['name']!,
                        'contactDetail': contact['detail']!,
                      },
                    ),
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
                                CustomText.subtitle(contact['detail']!, fontSize: 12),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.grayFont,
                                size: 16,
                              ),
                              SizedBox(height: Responsive.h(4)),
                              CustomText.subtitle(contact['date']!, fontSize: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Responsive.w(100),
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(16)),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.w(10)),
              decoration: const BoxDecoration(
                color: AppColors.tintBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            SizedBox(height: Responsive.h(12)),
            CustomText.body(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
