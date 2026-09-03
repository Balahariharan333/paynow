// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/constants/route_constants.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/amount_formatter.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/payment_method_tile.dart';
import 'package:paynow/widget/preset_amount_chips.dart';
import 'package:paynow/widget/secure_transaction_banner.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<String> _presets = const ['1,000', '2,000', '5,000', '10,000'];
  String _selectedAmount = '2000.00';
  int _selectedMethodIndex = 0; // Default selection

  @override
  void initState() {
    super.initState();
    _amountController.text = _selectedAmount;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
                  CustomText.header('Add Money', fontSize: 20),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.h(12)),
                    
                    // Amount Selection Card
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
                            'ENTER AMOUNT',
                            color: AppColors.grayFont,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: Responsive.h(16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText.header(
                                'Rs ',
                                color: AppColors.primary,
                                fontSize: 36,
                              ),
                              IntrinsicWidth(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: const [
                                    MaxAmountTextInputFormatter(max: 100000.0),
                                  ],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAmount = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.h(24)),
                          PresetAmountChips(
                            amounts: _presets,
                            selectedAmount: 'Rs ${_selectedAmount.split('.')[0]}',
                            onSelected: (amount) {
                              setState(() {
                                _selectedAmount = '${amount.replaceAll(r'Rs ', '').replaceAll(',', '')}.00';
                                _amountController.text = _selectedAmount;
                              });
                            },
                          ),
                          SizedBox(height: Responsive.h(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline, size: 12, color: AppColors.grayFont),
                              SizedBox(width: Responsive.w(4)),
                              CustomText.subtitle(
                                'Max limit: Rs 1,00,000 (1 Lakh) / transaction',
                                fontSize: 11,
                                color: AppColors.grayFont,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Payment Method header
                    CustomText.title('Select Payment Method', fontSize: 14),
                    SizedBox(height: Responsive.h(16)),
                    
                    // Payment Methods list
                    PaymentMethodTile(
                      title: 'HDFC Bank',
                      subtitle: 'Ending in •••• 8829',
                      icon: Icons.account_balance,
                      isSelected: _selectedMethodIndex == 0,
                      onTap: () {
                        setState(() {
                          _selectedMethodIndex = 0;
                        });
                      },
                    ),
                    SizedBox(height: Responsive.h(12)),
                    PaymentMethodTile(
                      title: 'Visa Platinum Debit Card',
                      subtitle: 'Ending in •••• 1234',
                      icon: Icons.credit_card,
                      isSelected: _selectedMethodIndex == 1,
                      onTap: () {
                        setState(() {
                          _selectedMethodIndex = 1;
                        });
                      },
                    ),
                    SizedBox(height: Responsive.h(12)),
                    Container(
                      padding: EdgeInsets.all(Responsive.w(16)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: Responsive.w(1.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: Responsive.w(32),
                            height: Responsive.h(32),
                            decoration: const BoxDecoration(
                              color: AppColors.tintBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: Responsive.w(12)),
                          Expanded(
                            child: CustomText.title('Add New Payment Method', fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Guard / Secure transaction card
                    const SecureTransactionBanner(),
                    SizedBox(height: Responsive.h(32)),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Button
            Padding(
              padding: EdgeInsets.all(Responsive.w(20.0)),
              child: SizedBox(
                width: double.infinity,
                height: Responsive.h(56),
                child: ElevatedButton(
                  onPressed: () {
                    final amountText = _selectedAmount.trim().replaceAll(',', '');
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

                    final destinationName = _selectedMethodIndex == 0
                        ? 'HDFC Bank (•••• 8829)'
                        : 'Visa Card (•••• 1234)';

                    // Update wallet balance and transaction history via BLoC
                    context.read<WalletBloc>().add(AddMoneyEvent(
                          amount: amountVal,
                          sourceName: destinationName,
                        ));

                    context.read<TransactionBloc>().add(AddTransactionEvent(
                          title: destinationName,
                          amountVal: amountVal,
                          type: 'Wallet Load',
                          isPositive: true,
                          isSuccess: true,
                          icon: _selectedMethodIndex == 0 ? Icons.account_balance : Icons.credit_card,
                          iconBackground: AppColors.tintBlue,
                          iconColor: AppColors.primary,
                        ));

                    Navigator.pushNamed(
                      context,
                      RouteConstants.transactionSuccess,
                      arguments: {
                        'isWithdrawal': false,
                        'amount': amountVal.toStringAsFixed(2),
                        'destinationName': destinationName,
                        'destinationIcon': _selectedMethodIndex == 0
                            ? Icons.account_balance
                            : Icons.credit_card,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: CustomText.title(
                    'Proceed to Add',
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
