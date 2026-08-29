// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/search_text_field.dart';
import 'package:paynow/widget/contact_avatar.dart';
import 'package:paynow/screen/payment/transfer/contact_transfer_screen.dart';

class ToMobileNumberScreen extends StatefulWidget {
  const ToMobileNumberScreen({super.key});

  @override
  State<ToMobileNumberScreen> createState() => _ToMobileNumberScreenState();
}

class _ToMobileNumberScreenState extends State<ToMobileNumberScreen> {
  String _searchQuery = '';
  
  final List<Map<String, String>> _allContacts = [
    {'name': 'Mike Ross', 'phone': '+91 98765 43210'},
    {'name': 'Harvey Specter', 'phone': '+91 91234 56789'},
    {'name': 'Sarah Jenkins', 'phone': '+91 88888 88888'},
    {'name': 'Donna Paulsen', 'phone': '+91 77777 77777'},
    {'name': 'Louis Litt', 'phone': '+91 66666 66666'},
    {'name': 'Rachel Zane', 'phone': '+91 55555 55555'},
  ];

  List<Map<String, String>> _getFilteredContacts() {
    if (_searchQuery.trim().isEmpty) {
      return _allContacts;
    }
    final q = _searchQuery.toLowerCase().trim();
    return _allContacts.where((contact) {
      final nameMatches = contact['name']!.toLowerCase().contains(q);
      final phoneMatches = contact['phone']!.replaceAll(' ', '').contains(q);
      return nameMatches || phoneMatches;
    }).toList();
  }

  bool _isInputNumeric(String text) {
    if (text.isEmpty) return false;
    final digits = text.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 4; // Treat as potential phone number if it has at least 4 digits
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final filteredContacts = _getFilteredContacts();
    final isSearchingNumber = _isInputNumeric(_searchQuery);

    return Scaffold(
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
                  CustomText.header('Send Money', fontSize: 20),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
              child: SearchTextField(
                hintText: 'Enter mobile number or name',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            
            // Contacts List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                children: [
                  // Option to pay to new typed number if searching by number
                  if (isSearchingNumber) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactTransferScreen(
                              contactName: _searchQuery,
                              contactDetail: 'Mobile Transfer',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(Responsive.w(16)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: Responsive.w(1.5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: Responsive.w(44),
                              height: Responsive.h(44),
                              decoration: BoxDecoration(
                                color: AppColors.tintBlue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: Responsive.w(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText.title('Pay to New Number', fontSize: 14),
                                  SizedBox(height: Responsive.h(2)),
                                  CustomText.subtitle(_searchQuery, fontSize: 12),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(20)),
                  ],

                  CustomText.header(
                    _searchQuery.isEmpty ? 'All Contacts' : 'Search Results',
                    fontSize: 16,
                    color: AppColors.grayFont,
                  ),
                  SizedBox(height: Responsive.h(12)),
                  
                  if (filteredContacts.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Responsive.h(40.0)),
                        child: CustomText.subtitle('No contacts found matching "$_searchQuery"'),
                      ),
                    ),
                  ] else ...[
                    ...filteredContacts.map((contact) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactTransferScreen(
                                  contactName: contact['name']!,
                                  contactDetail: contact['phone']!,
                                ),
                              ),
                            );
                          },
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
                                      CustomText.subtitle(contact['phone']!, fontSize: 12),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.grayFont,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


