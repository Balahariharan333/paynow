import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

Future<bool?> showUpiPinSheet({
  required BuildContext context,
  required String bankName,
  required String accountNumber,
  required String balance,
  IconData icon = Icons.account_balance,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => UpiPinSheet(
      bankName: bankName,
      accountNumber: accountNumber,
      balance: balance,
      icon: icon,
    ),
  );
}

class UpiPinSheet extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final String balance;
  final IconData icon;

  const UpiPinSheet({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.balance,
    this.icon = Icons.account_balance,
  });

  @override
  State<UpiPinSheet> createState() => _UpiPinSheetState();
}

enum _UpiState { enterPin, loading, success }

class _UpiPinSheetState extends State<UpiPinSheet> {
  String _pin = '';
  _UpiState _state = _UpiState.enterPin;

  void _onKeyTap(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin += value;
      });
      if (_pin.length == 4) {
        _verifyAndFetchBalance();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Future<void> _verifyAndFetchBalance() async {
    setState(() {
      _state = _UpiState.loading;
    });

    // Simulate contacting bank
    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      setState(() {
        _state = _UpiState.success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: Responsive.h(16),
        left: Responsive.w(20),
        right: Responsive.w(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + Responsive.h(24),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentStateView(),
      ),
    );
  }

  Widget _buildCurrentStateView() {
    switch (_state) {
      case _UpiState.enterPin:
        return _buildPinEntryView();
      case _UpiState.loading:
        return _buildLoadingView();
      case _UpiState.success:
        return _buildSuccessView();
    }
  }

  Widget _buildPinEntryView() {
    return Column(
      key: const ValueKey('pinEntry'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grayFont.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        SizedBox(height: Responsive.h(16)),

        // Bank header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.title(widget.bankName, fontSize: 14, fontWeight: FontWeight.bold),
                  CustomText.body(widget.accountNumber, fontSize: 12, color: AppColors.grayFont),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: AppColors.grayFont),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),

        const Divider(height: 24, thickness: 0.8),

        CustomText.title(
          'ENTER 4-DIGIT UPI PIN',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: Responsive.h(6)),
        CustomText.body(
          'To fetch and display your bank balance',
          fontSize: 12,
          color: AppColors.grayFont,
        ),
        SizedBox(height: Responsive.h(24)),

        // 4 PIN Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final bool isFilled = index < _pin.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isFilled ? AppColors.primary : AppColors.grayFont.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
            );
          }),
        ),

        SizedBox(height: Responsive.h(28)),

        // Keypad
        _buildKeypad(),

        SizedBox(height: Responsive.h(12)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 13, color: AppColors.grayFont),
            const SizedBox(width: 4),
            CustomText.body(
              'UPI PIN is protected with bank-grade security',
              fontSize: 11,
              color: AppColors.grayFont,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypad() {
    final List<List<String>> keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'backspace'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Responsive.h(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key.isEmpty) {
                return SizedBox(width: Responsive.w(80), height: Responsive.h(52));
              }
              if (key == 'backspace') {
                return SizedBox(
                  width: Responsive.w(80),
                  height: Responsive.h(52),
                  child: IconButton(
                    onPressed: _onBackspace,
                    icon: const Icon(Icons.backspace_outlined, size: 22, color: AppColors.grayFont),
                  ),
                );
              }
              return SizedBox(
                width: Responsive.w(80),
                height: Responsive.h(52),
                child: TextButton(
                  onPressed: () => _onKeyTap(key),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: CustomText.title(key, fontSize: 22, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingView() {
    return Padding(
      key: const ValueKey('loading'),
      padding: EdgeInsets.symmetric(vertical: Responsive.h(40)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          CustomText.title('Contacting ${widget.bankName}...', fontSize: 16, fontWeight: FontWeight.bold),
          SizedBox(height: Responsive.h(8)),
          CustomText.body('Securely fetching real-time balance via UPI', fontSize: 12, color: AppColors.grayFont),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      key: const ValueKey('success'),
      padding: EdgeInsets.symmetric(vertical: Responsive.h(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 42,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          CustomText.body(
            'Available Bank Balance',
            fontSize: 13,
            color: AppColors.grayFont,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: Responsive.h(6)),
          CustomText.header(
            widget.balance,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          SizedBox(height: Responsive.h(8)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grayFont.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: AppColors.grayFont),
                const SizedBox(width: 6),
                CustomText.body(
                  '${widget.bankName} (${widget.accountNumber})',
                  fontSize: 11,
                  color: AppColors.grayFont,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(28)),
          SizedBox(
            width: double.infinity,
            height: Responsive.h(48),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: CustomText.title(
                'Done',
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
