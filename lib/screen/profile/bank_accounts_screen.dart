import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/constants/route_constants.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/upi_pin_sheet.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final Set<String> _revealedAccounts = {};

  void _showUnlinkDialog(BuildContext context, int index, String bankName) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.errorRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomText.title(
                  'Unlink Account?',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: CustomText.body(
            'Are you sure you want to unlink $bankName? You will not be able to use it for instant UPI payments or withdrawals until you link it again.',
            fontSize: 13,
            color: AppColors.grayFont,
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: Responsive.w(16),
            vertical: Responsive.h(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: CustomText.title(
                'Cancel',
                color: AppColors.grayFont,
                fontSize: 13,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<WalletBloc>().add(UnlinkBankEvent(index));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$bankName has been unlinked.'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: CustomText.title(
                'Unlink',
                color: AppColors.white,
                fontSize: 13,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onCheckBalanceTapped(
    BuildContext context,
    String bankName,
    String accountNumber,
    String balance,
    IconData icon,
  ) async {
    final success = await showUpiPinSheet(
      context: context,
      bankName: bankName,
      accountNumber: accountNumber,
      balance: balance,
      icon: icon,
    );

    if (success == true && mounted) {
      setState(() {
        _revealedAccounts.add(accountNumber);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText.title(
          'Bank Accounts',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              final hasBanks = state is WalletLoaded && state.linkedBanks.isNotEmpty;
              if (!hasBanks) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  RouteConstants.linkBank,
                  arguments: false,
                ),
                icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                label: CustomText.body(
                  'Add',
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          final linkedBanks =
              state is WalletLoaded ? state.linkedBanks : <Map<String, dynamic>>[];

          if (linkedBanks.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildBankList(context, linkedBanks);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(28.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Responsive.w(110),
              height: Responsive.w(110),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.account_balance_outlined,
                  size: Responsive.w(52),
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: Responsive.h(24)),
            CustomText.header(
              'No Bank Accounts Linked',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: Responsive.h(10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0)),
              child: CustomText.body(
                'Link your bank account to send and receive payments directly via UPI, check real-time account balances, and withdraw funds.',
                color: AppColors.grayFont,
                fontSize: 13,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Responsive.h(32)),
            SizedBox(
              width: double.infinity,
              height: Responsive.h(52),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  RouteConstants.linkBank,
                  arguments: false,
                ),
                icon: const Icon(Icons.add, color: AppColors.white),
                label: CustomText.title(
                  'Link Bank Account',
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.successGreen),
                const SizedBox(width: 6),
                CustomText.body(
                  '100% Secure UPI Banking with 256-Bit Encryption',
                  fontSize: 11,
                  color: AppColors.grayFont,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankList(BuildContext context, List<Map<String, dynamic>> banks) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(20.0),
        vertical: Responsive.h(16.0),
      ),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.header(
              'Linked Accounts (${banks.length})',
              fontSize: 15,
              color: AppColors.grayFont,
            ),
            Row(
              children: [
                const Icon(Icons.lock_outline, size: 14, color: AppColors.grayFont),
                const SizedBox(width: 4),
                CustomText.body(
                  'Encrypted',
                  fontSize: 11,
                  color: AppColors.grayFont,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: Responsive.h(12)),
        ...List.generate(banks.length, (index) {
          final bank = banks[index];
          final bool isPrimary = bank['isPrimary'] == true;
          final String bankName = bank['bankName']?.toString() ?? 'Bank Account';
          final String accountNumber = bank['accountNumber']?.toString() ?? '•••• 0000';
          final IconData icon = bank['icon'] is IconData
              ? bank['icon'] as IconData
              : Icons.account_balance;
          final String balance = bank['mockBalance']?.toString() ?? 'Rs 24,500.00';
          final bool isBalanceRevealed = _revealedAccounts.contains(accountNumber);

          return Container(
            margin: EdgeInsets.only(bottom: Responsive.h(14)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: isPrimary
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.35), width: 1.5)
                  : Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(Responsive.w(16)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: Responsive.w(46),
                        height: Responsive.h(46),
                        decoration: BoxDecoration(
                          color: isPrimary
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white10
                                  : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          icon,
                          color: isPrimary ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: Responsive.w(14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: CustomText.title(
                                    bankName,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (isPrimary) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.successGreen.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          size: 10,
                                          color: AppColors.successGreen,
                                        ),
                                        const SizedBox(width: 3),
                                        CustomText.body(
                                          'PRIMARY',
                                          fontSize: 9,
                                          color: AppColors.successGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: Responsive.h(4)),
                            CustomText.body(
                              accountNumber,
                              fontSize: 12,
                              color: AppColors.grayFont,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.grayFont,
                          size: 20,
                        ),
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onSelected: (value) {
                          if (value == 'primary') {
                            context.read<WalletBloc>().add(SetPrimaryBankEvent(index));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$bankName set as primary account.'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } else if (value == 'unlink') {
                            _showUnlinkDialog(context, index, bankName);
                          }
                        },
                        itemBuilder: (context) => [
                          if (!isPrimary)
                            const PopupMenuItem(
                              value: 'primary',
                              child: Row(
                                children: [
                                  Icon(Icons.star_outline, size: 18),
                                  SizedBox(width: 10),
                                  Text('Set as Primary'),
                                ],
                              ),
                            ),
                          const PopupMenuItem(
                            value: 'unlink',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 18, color: AppColors.errorRed),
                                SizedBox(width: 10),
                                Text(
                                  'Unlink Account',
                                  style: TextStyle(color: AppColors.errorRed),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(12)),
                  const Divider(height: 1, thickness: 0.6),
                  SizedBox(height: Responsive.h(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: AppColors.successGreen,
                          ),
                          const SizedBox(width: 4),
                          CustomText.body(
                            'UPI Enabled',
                            fontSize: 11,
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      // Check Balance action like Google Pay / PhonePe
                      if (isBalanceRevealed)
                        Row(
                          children: [
                            CustomText.body(
                              balance,
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _revealedAccounts.remove(accountNumber);
                                });
                              },
                              child: const Icon(
                                Icons.visibility_off_outlined,
                                size: 16,
                                color: AppColors.grayFont,
                              ),
                            ),
                          ],
                        )
                      else
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _onCheckBalanceTapped(
                            context,
                            bankName,
                            accountNumber,
                            balance,
                            icon,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Row(
                              children: [
                                CustomText.title(
                                  'Check Balance',
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: Responsive.h(16)),
        SizedBox(
          width: double.infinity,
          height: Responsive.h(50),
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              RouteConstants.linkBank,
              arguments: false,
            ),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: CustomText.title(
              'Link Another Bank Account',
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        SizedBox(height: Responsive.h(24)),
      ],
    );
  }
}
