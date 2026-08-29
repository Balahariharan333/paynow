// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/screen/onboarding/link_bank_screen.dart';
import 'package:paynow/screen/payment/wallet/transaction_success_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/payment_method_tile.dart';
import 'package:paynow/widget/preset_amount_chips.dart';
import 'package:paynow/widget/transaction_details_card.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  String _selectedAmount = '2000.00';
  int _selectedBankIndex = 0;
  late final TextEditingController _amountController;

  final List<String> _presets = const ['1,000', '2,000', '5,000', 'Max'];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _selectedAmount);
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
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            final double availableBalance = state is WalletLoaded ? state.balance : 12450.80;
            final linkedBanks = state is WalletLoaded ? state.linkedBanks : <Map<String, dynamic>>[];

            return Column(
              children: [
                // Header: Good Morning, Alex & Notification Icon
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.body(
                                'Good Morning,',
                                color: AppColors.grayFont,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText.title(
                                'Alex',
                                fontSize: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: Responsive.w(40),
                        height: Responsive.h(40),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Screen Main Title
                        CustomText.header('Withdraw to Bank', fontSize: 20),
                        SizedBox(height: Responsive.h(4)),
                        CustomText.subtitle('Move funds from your wallet to a linked bank account.'),
                        SizedBox(height: Responsive.h(20)),
                        
                        // Available Balance Gradient Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(Responsive.w(20)),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF5B21B6), // Deep violet
                                Color(0xFF8B5CF6), // Purple
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: AppColors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: Responsive.w(8)),
                                  CustomText.body(
                                    'AVAILABLE BALANCE',
                                    color: AppColors.white.withValues(alpha: 0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              SizedBox(height: Responsive.h(12)),
                              CustomText.header(
                                'Rs ${availableBalance.toStringAsFixed(2)}',
                                color: AppColors.white,
                                fontSize: 30,
                              ),
                              SizedBox(height: Responsive.h(16)),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(6)),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: Responsive.w(6)),
                                    CustomText.body(
                                      'Instantly withdrawable',
                                      color: AppColors.white,
                                      fontSize: 11,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.h(24)),
                        
                        // Enter Amount card
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
                                    fontSize: 32,
                                  ),
                                  IntrinsicWidth(
                                    child: TextField(
                                      controller: _amountController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 32,
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
                                selectedAmount: '\$${_selectedAmount.split('.')[0]}',
                                onSelected: (amount) {
                                  setState(() {
                                    if (amount == 'Max') {
                                      _selectedAmount = availableBalance.toStringAsFixed(2);
                                    } else {
                                      _selectedAmount = '${amount.replaceAll(r'$', '').replaceAll(',', '')}.00';
                                    }
                                    _amountController.text = _selectedAmount;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.h(24)),
                        
                        // Destination header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText.title('Destination', fontSize: 14),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LinkBankScreen(isFromOnboarding: false),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                                color: Colors.transparent,
                                child: CustomText.body('+ Add Bank', color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(16)),
                        
                        // Bank Accounts list
                        if (linkedBanks.isEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Responsive.h(8.0)),
                            child: CustomText.body('No linked bank accounts', color: AppColors.grayFont),
                          ),
                        ] else ...[
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: linkedBanks.length,
                            separatorBuilder: (context, index) => SizedBox(height: Responsive.h(12)),
                            itemBuilder: (context, index) {
                              final bank = linkedBanks[index];
                              final selectedIdx = _selectedBankIndex < linkedBanks.length ? _selectedBankIndex : 0;
                              final isSelected = selectedIdx == index;
                              return PaymentMethodTile(
                                title: bank['bankName'] as String,
                                subtitle: bank['accountNumber'] as String,
                                icon: bank['icon'] as IconData,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedBankIndex = index;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                        SizedBox(height: Responsive.h(24)),
                        
                        // Transaction details card
                        TransactionDetailsCard(
                          transferFee: r'$0.00 (Free)',
                          estimatedArrival: 'Instant',
                          totalDeduction: 'Rs $_selectedAmount',
                        ),
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
                      onPressed: linkedBanks.isEmpty
                          ? null
                          : () {
                              final selectedIdx = _selectedBankIndex < linkedBanks.length ? _selectedBankIndex : 0;
                              final selectedBank = linkedBanks[selectedIdx];
                              final double amountVal = double.tryParse(_selectedAmount) ?? 0.0;

                              if (amountVal <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a valid amount'),
                                    backgroundColor: AppColors.errorRed,
                                  ),
                                );
                                return;
                              }

                              if (amountVal > availableBalance) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Insufficient Wallet Balance'),
                                    backgroundColor: AppColors.errorRed,
                                  ),
                                );
                                return;
                              }
                              
                              // Deduct balance and add transaction via BLoC
                              context.read<WalletBloc>().add(WithdrawMoneyEvent(
                                    amount: amountVal,
                                    destinationBank: selectedBank,
                                  ));

                              context.read<TransactionBloc>().add(AddTransactionEvent(
                                    title: 'Withdrawal to ${selectedBank['bankName']}',
                                    amountVal: amountVal,
                                    type: 'Withdrawal',
                                    isPositive: false,
                                    isSuccess: true,
                                    icon: selectedBank['icon'] as IconData,
                                    iconBackground: AppColors.tintRed,
                                    iconColor: AppColors.errorRed,
                                  ));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionSuccessScreen(
                                    isWithdrawal: true,
                                    amount: _selectedAmount,
                                    destinationName: '${selectedBank['bankName']} (${selectedBank['accountNumber']})',
                                    destinationIcon: selectedBank['icon'] as IconData,
                                  ),
                                ),
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
                        'Continue',
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
