// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:flutter/services.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    const String referralCode = 'PNREWRD24';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
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
                  CustomText.header('Refer & Earn', fontSize: 20),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                child: Column(
                  children: [
                    SizedBox(height: Responsive.h(16)),
                    
                    // Large Banner Illustration Placeholder
                    Container(
                      width: double.infinity,
                      height: Responsive.h(160),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE0E7FF), Color(0xFFC7D2FE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.people_outline,
                          color: AppColors.primary,
                          size: 64,
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Titles
                    CustomText.header('Invite Friends, Earn Together', fontSize: 20, textAlign: TextAlign.center),
                    SizedBox(height: Responsive.h(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                      child: CustomText.subtitle(
                        'Get ₹10 for every friend who joins and makes their first payment.',
                        color: AppColors.grayFont,
                        fontSize: 13,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Referral Code Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Responsive.w(20)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: Responsive.w(1.5)),
                      ),
                      child: Column(
                        children: [
                          CustomText.body(
                            'YOUR REFERRAL CODE',
                            color: AppColors.grayFont,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: Responsive.h(12)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: Responsive.w(24)), // Offset for spacing
                                Expanded(
                                  child: Text(
                                    referralCode,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(const ClipboardData(text: referralCode));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Referral code copied to clipboard!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Social Sharing Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          icon: Icons.chat_bubble_outline,
                          label: 'WhatsApp',
                          color: const Color(0xFFE8F5E9),
                          iconColor: Colors.green,
                          onTap: () => _shareToWhatsApp(context, referralCode),
                        ),
                        _buildShareButton(
                          icon: Icons.sms_outlined,
                          label: 'SMS',
                          color: const Color(0xFFECEFF1),
                          iconColor: Colors.blueGrey,
                          onTap: () => _shareToSms(context, referralCode),
                        ),
                        _buildShareButton(
                          icon: Icons.mail_outline,
                          label: 'Email',
                          color: const Color(0xFFF3E8FF),
                          iconColor: Colors.purple,
                          onTap: () => _shareToEmail(context, referralCode),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(28)),
                    
                    // How it Works Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Responsive.w(20)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF5B21B6), // Deep violet
                            Color(0xFF7C3AED), // Purple
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.title('How it works', color: AppColors.white, fontSize: 16),
                          SizedBox(height: Responsive.h(16)),
                          _buildStepRow(
                            stepNumber: '1',
                            text: "Share your unique code with friends who haven't joined PayNow yet.",
                          ),
                          SizedBox(height: Responsive.h(12)),
                          _buildStepRow(
                            stepNumber: '2',
                            text: 'Your friend signs up and completes their first \$20+ payment.',
                          ),
                          SizedBox(height: Responsive.h(12)),
                          _buildStepRow(
                            stepNumber: '3',
                            text: 'You both get rewarded! The \$10 bonus will be added to your wallets.',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(40)),
                  ],
                ),
              ),
            ),
            
            // Bottom Referral Status Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(16)),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.group_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: Responsive.w(8)),
                        Expanded(
                          child: CustomText.title(
                            '3 Friends Joined  •  \$30 Earned',
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  GestureDetector(
                    onTap: () => _showReferralHistorySheet(context),
                    child: CustomText.title(
                      'View History',
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
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

  void _showReferralHistorySheet(BuildContext context) {
    final List<Map<String, String>> historyList = [
      {'name': 'Mike Ross', 'detail': 'mikeross@paynow', 'date': '24 Oct, 2023', 'status': 'Completed', 'amount': '\$10'},
      {'name': 'Sarah Jenkins', 'detail': 'sarahj@paynow', 'date': '18 Oct, 2023', 'status': 'Completed', 'amount': '\$10'},
      {'name': 'Harvey Specter', 'detail': 'harvey@paynow', 'date': '12 Oct, 2023', 'status': 'Completed', 'amount': '\$10'},
      {'name': 'Rachel Zane', 'detail': 'rachel@paynow', 'date': '05 Oct, 2023', 'status': 'Pending', 'amount': '\$0'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
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
                  CustomText.header('Referral History', fontSize: 18),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(16)),
              
              // Summary Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Responsive.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.tintBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText.title('Total Referral Earnings', fontSize: 13, color: AppColors.primary),
                    CustomText.header('\$30.00', fontSize: 18, color: AppColors.primary),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(20)),
              
              // List of Referrals
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historyList.length,
                  separatorBuilder: (context, index) => const Divider(color: Color(0xFFF3F4F6), height: 16),
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    final isCompleted = item['status'] == 'Completed';
                    return Row(
                      children: [
                        Container(
                          width: Responsive.w(40),
                          height: Responsive.h(40),
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCompleted ? Icons.check_circle_outline : Icons.pending_actions,
                            color: isCompleted ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: Responsive.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.title(item['name']!, fontSize: 13),
                              SizedBox(height: Responsive.h(2)),
                              CustomText.subtitle(item['detail']!, fontSize: 11),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText.title(
                              isCompleted ? '+${item['amount']}' : 'Pending',
                              fontSize: 13,
                              color: isCompleted ? Colors.green : Colors.orange,
                            ),
                            SizedBox(height: Responsive.h(2)),
                            CustomText.subtitle(item['date']!, fontSize: 10),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: Responsive.h(16)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareToWhatsApp(BuildContext context, String code) async {
    final message = Uri.encodeComponent("Hey! Join PayNow using my referral code: $code and earn rewards!");
    final url = Uri.parse("https://wa.me/?text=$message");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }

  Future<void> _shareToSms(BuildContext context, String code) async {
    final message = Uri.encodeComponent("Hey! Join PayNow using my referral code: $code and earn rewards!");
    final url = Uri.parse("sms:?body=$message");
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch SMS app')),
        );
      }
    }
  }

  Future<void> _shareToEmail(BuildContext context, String code) async {
    final subject = Uri.encodeComponent("Join PayNow!");
    final body = Uri.encodeComponent("Hey! Join PayNow using my referral code: $code and earn rewards!");
    final url = Uri.parse("mailto:?subject=$subject&body=$body");
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Email app')),
        );
      }
    }
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: Responsive.w(50),
            height: Responsive.h(50),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: Responsive.w(22)),
          ),
          SizedBox(height: Responsive.h(8)),
          CustomText.body(
            label,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({required String stepNumber, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Responsive.w(20),
          height: Responsive.h(20),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: Responsive.w(12)),
        Expanded(
          child: CustomText.body(
            text,
            color: AppColors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


