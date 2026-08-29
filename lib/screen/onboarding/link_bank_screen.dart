// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/screen/home/main_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/search_text_field.dart';

class LinkBankScreen extends StatefulWidget {
  final bool isFromOnboarding;

  const LinkBankScreen({
    super.key,
    required this.isFromOnboarding,
  });

  @override
  State<LinkBankScreen> createState() => _LinkBankScreenState();
}

class _LinkBankScreenState extends State<LinkBankScreen> {
  final List<Map<String, dynamic>> _allBanks = const [
    {
      'name': 'Chase Bank',
      'logoColor': Color(0xFF1E3A8A),
      'textColor': AppColors.white,
      'shortName': 'Chase',
      'icon': Icons.account_balance,
    },
    {
      'name': 'HDFC Bank',
      'logoColor': Color(0xFF1D4ED8),
      'textColor': AppColors.white,
      'shortName': 'HDFC',
      'icon': Icons.account_balance,
    },
    {
      'name': 'HSBC Bank',
      'logoColor': Color(0xFFDC2626),
      'textColor': AppColors.white,
      'shortName': 'HSBC',
      'icon': Icons.savings_outlined,
    },
    {
      'name': 'State Bank of India',
      'logoColor': Color(0xFF0EA5E9),
      'textColor': AppColors.white,
      'shortName': 'SBI',
      'icon': Icons.account_balance_outlined,
    },
    {
      'name': 'ICICI Bank',
      'logoColor': Color(0xFFEA580C),
      'textColor': AppColors.white,
      'shortName': 'ICICI',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Axis Bank',
      'logoColor': Color(0xFF800020),
      'textColor': AppColors.white,
      'shortName': 'Axis',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Citibank',
      'logoColor': Color(0xFF0284C7),
      'textColor': AppColors.white,
      'shortName': 'Citi',
      'icon': Icons.account_balance_outlined,
    },
    {
      'name': 'Bank of America',
      'logoColor': Color(0xFFE11D48),
      'textColor': AppColors.white,
      'shortName': 'BofA',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Wells Fargo',
      'logoColor': Color(0xFFD97706),
      'textColor': AppColors.white,
      'shortName': 'Wells',
      'icon': Icons.savings_outlined,
    },
  ];

  List<Map<String, dynamic>> _filteredBanks = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredBanks = List.from(_allBanks);
  }

  void _filterBanks(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredBanks = _allBanks.where((bank) {
        final name = (bank['name'] as String).toLowerCase();
        final short = (bank['shortName'] as String).toLowerCase();
        return name.contains(_searchQuery) || short.contains(_searchQuery);
      }).toList();
    });
  }

  void _startLinking(Map<String, dynamic> bank) {
    context.read<WalletBloc>().add(StartLinkBankEvent(bank));
  }

  void _finish() {
    context.read<WalletBloc>().add(const ResetLinkBankEvent());
    if (widget.isFromOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final bool isLinking = state is WalletLoaded ? state.isLinkingBank : false;
        final bool linkSuccess = state is WalletLoaded ? state.linkBankSuccess : false;
        final selectedBank = state is WalletLoaded ? state.linkingBank : null;
        final int progressStep = state is WalletLoaded ? state.linkingStep : 0;
        final String linkingProgressText = state is WalletLoaded ? state.linkingProgressText : '';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: linkSuccess
                  ? _buildSuccessView(selectedBank)
                  : isLinking
                      ? _buildLinkingProgressView(selectedBank, progressStep, linkingProgressText)
                      : _buildBankSelectionView(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankSelectionView() {
    return Column(
      key: const ValueKey('bankSelection'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom App Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (!widget.isFromOnboarding)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Responsive.w(8.0)),
                        color: Colors.transparent,
                        child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header(
                    widget.isFromOnboarding ? 'Link Bank Account' : 'Add Bank Account',
                    fontSize: 22,
                  ),
                ],
              ),
              if (widget.isFromOnboarding)
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  },
                  child: CustomText.body(
                    'Skip',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),

        // Hint Text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(8.0)),
          child: CustomText.subtitle(
            'We will send a secure SMS to verify your mobile number with your bank account.',
            fontSize: 13,
          ),
        ),

        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(8.0)),
          child: SearchTextField(
            hintText: 'Search your bank...',
            onChanged: _filterBanks,
            fillColor: Theme.of(context).cardColor,
            borderColor: AppColors.primary.withValues(alpha: 0.15),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.h(16)),

        // Bank Grid/List
        Expanded(
          child: _filteredBanks.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width >= 500 ? 4 : 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _filteredBanks.length,
                  itemBuilder: (context, index) {
                    final bank = _filteredBanks[index];
                    return GestureDetector(
                      onTap: () => _startLinking(bank),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Responsive.w(48),
                              height: Responsive.h(48),
                              decoration: BoxDecoration(
                                color: bank['logoColor'] as Color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                bank['icon'] as IconData,
                                color: bank['textColor'] as Color,
                                size: 24,
                              ),
                            ),
                            SizedBox(height: Responsive.h(8)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Responsive.w(4.0)),
                              child: CustomText.title(
                                bank['shortName'] as String,
                                fontSize: 13,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLinkingProgressView(
    Map<String, dynamic>? selectedBank,
    int progressStep,
    String linkingProgressText,
  ) {
    return Center(
      key: const ValueKey('linkingProgress'),
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(32.0)),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsets.all(Responsive.w(32.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Responsive.w(60),
                  height: Responsive.h(60),
                  decoration: BoxDecoration(
                    color: selectedBank?['logoColor'] as Color? ?? AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    selectedBank?['icon'] as IconData? ?? Icons.account_balance,
                    color: AppColors.white,
                    size: 30,
                  ),
                ),
                SizedBox(height: Responsive.h(24)),
                CustomText.header(
                  'Linking ${selectedBank?['name'] ?? 'Bank'}',
                  fontSize: 18,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.h(32)),
                
                // Animating Loader
                SizedBox(
                  width: Responsive.w(56),
                  height: Responsive.h(56),
                  child: CircularProgressIndicator(
                    color: selectedBank?['logoColor'] as Color? ?? AppColors.primary,
                    strokeWidth: 3.5,
                  ),
                ),
                SizedBox(height: Responsive.h(32)),
                
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    key: ValueKey(progressStep),
                    child: CustomText.body(
                      linkingProgressText,
                      textAlign: TextAlign.center,
                      color: AppColors.grayFont,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(Map<String, dynamic>? selectedBank) {
    return Center(
      key: const ValueKey('linkSuccess'),
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(24.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Responsive.w(100),
              height: Responsive.h(100),
              decoration: const BoxDecoration(
                color: AppColors.tintGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.successGreen,
                size: 72,
              ),
            ),
            SizedBox(height: Responsive.h(24)),
            CustomText.header(
              'Account Linked Successfully!',
              fontSize: 22,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.h(8)),
            CustomText.subtitle(
              'Your ${selectedBank?['name'] ?? 'Bank'} account has been successfully linked to PayNow.',
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
            SizedBox(height: Responsive.h(48)),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  widget.isFromOnboarding ? 'Get Started' : 'Done',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_balance_outlined,
            size: 48,
            color: AppColors.grayFont,
          ),
          SizedBox(height: Responsive.h(12)),
          CustomText.title('No banks match "$_searchQuery"', color: AppColors.grayFont),
        ],
      ),
    );
  }
}
