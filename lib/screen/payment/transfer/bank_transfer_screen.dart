// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/transaction/transaction_state.dart';
import 'package:paynow/screen/payment/transfer/contact_transfer_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  // Input Controllers for Bank Modal Sheet
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  void _showAddRecipientSheet(BuildContext context, bool isBank) {
    _nameController.clear();
    _detailController.clear();
    _bankController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
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
                    CustomText.header(
                      isBank ? 'Add Bank Recipient' : 'Add UPI Recipient',
                      fontSize: 18,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(16)),
                // Recipient Name
                _buildTextField(_nameController, 'Recipient Name', 'e.g. John Doe'),
                SizedBox(height: Responsive.h(14)),
                // Account details
                _buildTextField(
                  _detailController,
                  isBank ? 'Account Number / Details' : 'UPI ID / Handle',
                  isBank ? 'e.g. 1029384756' : 'e.g. johndoe@paynow',
                ),
                if (isBank) ...[
                  SizedBox(height: Responsive.h(14)),
                  _buildTextField(_bankController, 'Bank Name', 'e.g. HDFC Bank'),
                ],
                SizedBox(height: Responsive.h(24)),
                // Action buttons
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(52),
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final detail = _detailController.text.trim();
                      final bank = _bankController.text.trim();

                      if (name.isEmpty || detail.isEmpty || (isBank && bank.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                            backgroundColor: AppColors.errorRed,
                          ),
                        );
                        return;
                      }

                      if (isBank) {
                        final formattedDetail = '$bank •••• ${detail.length > 4 ? detail.substring(detail.length - 4) : detail}';
                        context.read<TransactionBloc>().add(AddBankRecipientEvent(
                              name: name,
                              detail: formattedDetail,
                              bank: bank,
                            ));
                      } else {
                        context.read<TransactionBloc>().add(AddUpiRecipientEvent(
                              name: name,
                              detail: detail,
                            ));
                      }

                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isBank ? 'Bank account added' : 'UPI ID added'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: CustomText.title(
                      'Save Recipient',
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
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.title(label, fontSize: 13),
        SizedBox(height: Responsive.h(6)),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.grayFont, fontSize: 13),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : AppColors.lightGray,
            contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(14)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom App Bar
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
                    CustomText.header('To Bank / UPI ID', fontSize: 20),
                  ],
                ),
              ),
              
              // Custom TabBar
              Container(
                margin: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.grayFont,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Bank Accounts'),
                    Tab(text: 'UPI IDs'),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Tab Bar View content
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Bank Accounts
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        final bankAccounts = state is TransactionLoaded ? state.bankRecipients : <Map<String, String>>[];
                        return _buildAccountsList(
                          context,
                          accounts: bankAccounts,
                          isBank: true,
                        );
                      },
                    ),
                    
                    // Tab 2: UPI IDs
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        final upiIds = state is TransactionLoaded ? state.upiRecipients : <Map<String, String>>[];
                        return _buildAccountsList(
                          context,
                          accounts: upiIds,
                          isBank: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountsList(
    BuildContext context, {
    required List<Map<String, String>> accounts,
    required bool isBank,
  }) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(8)),
            itemCount: accounts.length,
            separatorBuilder: (context, index) => SizedBox(height: Responsive.h(12)),
            itemBuilder: (context, index) {
              final account = accounts[index];
              final leadingIcon = isBank ? Icons.account_balance : Icons.alternate_email;
              
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactTransferScreen(
                        contactName: account['name']!,
                        contactDetail: account['detail']!,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(Responsive.w(16)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: Responsive.w(44),
                        height: Responsive.h(44),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          leadingIcon,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: Responsive.w(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.title(account['name']!, fontSize: 14),
                            SizedBox(height: Responsive.h(2)),
                            CustomText.subtitle(account['detail']!, fontSize: 12),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.grayFont,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Add Recipient Button at bottom
        Padding(
          padding: EdgeInsets.all(Responsive.w(20.0)),
          child: SizedBox(
            width: double.infinity,
            height: Responsive.h(54),
            child: OutlinedButton.icon(
              onPressed: () => _showAddRecipientSheet(context, isBank),
              icon: Icon(Icons.add, color: AppColors.primary, size: Responsive.w(20)),
              label: CustomText.title(
                isBank ? 'Add Recipient Bank' : 'Add Recipient UPI ID',
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
        ),
      ],
    );
  }
}
