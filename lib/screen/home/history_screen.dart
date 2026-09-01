// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/transaction/transaction_state.dart';
import 'package:paynow/screen/transaction/transaction_details_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/filter_chips.dart';
import 'package:paynow/widget/history_transaction_item.dart';
import 'package:paynow/widget/search_text_field.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _filterOptions = const ['All', 'Sent', 'Received', 'Failed'];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar with Left Title & Back Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0), vertical: Responsive.h(12.0)),
              child: Row(
                children: [
                 
                  CustomText.header('History', fontSize: 22),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
              child: SearchTextField(
                hintText: 'Name, Number or UPI ID',
                onChanged: (val) {
                  context.read<TransactionBloc>().add(SearchTransactionsEvent(val));
                },
              ),
            ),
            SizedBox(height: Responsive.h(16)),
            
            // Filter Tabs
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                final String selectedFilter = state is TransactionLoaded ? state.selectedFilter : 'All';
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: FilterChips(
                    options: _filterOptions,
                    selectedOption: selectedFilter,
                    onSelected: (option) {
                      context.read<TransactionBloc>().add(FilterTransactionsEvent(option));
                    },
                  ),
                );
              },
            ),
            SizedBox(height: Responsive.h(20)),
            
            // Transactions Grouped List
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  final filteredList = state is TransactionLoaded ? state.filteredTransactions : <Map<String, dynamic>>[];

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: Responsive.w(48), color: AppColors.grayFont),
                          SizedBox(height: Responsive.h(12)),
                          CustomText.title('No matching transactions', color: AppColors.grayFont),
                        ],
                      ),
                    );
                  }

                  // Group by Date groups ("Today", "Yesterday", "Last Week", "Older")
                  final Map<String, List<Map<String, dynamic>>> grouped = {};
                  for (var tx in filteredList) {
                    final dateKey = tx['date'] as String? ?? 'Older';
                    if (!grouped.containsKey(dateKey)) {
                      grouped[dateKey] = [];
                    }
                    grouped[dateKey]!.add(tx);
                  }

                  final dateHeaders = ['Today', 'Yesterday', 'Last Week', 'Older']
                      .where((key) => grouped.containsKey(key))
                      .toList();

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: EdgeInsets.only(
                      left: Responsive.w(20.0),
                      right: Responsive.w(20.0),
                      top: Responsive.h(4.0),
                      bottom: Responsive.h(110.0),
                    ),
                    itemCount: dateHeaders.length,
                    itemBuilder: (context, dateIndex) {
                      final header = dateHeaders[dateIndex];
                      final items = grouped[header]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.header(
                            header,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grayFont,
                          ),
                          SizedBox(height: Responsive.h(8)),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (context, index) => SizedBox(height: Responsive.h(8)),
                            itemBuilder: (context, index) {
                              final tx = items[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransactionDetailsScreen(transaction: tx),
                                    ),
                                  );
                                },
                                child: HistoryTransactionItem(
                                  title: tx['title'] as String,
                                  time: tx['time'] as String,
                                  type: tx['type'] as String,
                                  amount: (tx['isPositive'] ? '+ ' : '- ') + (tx['amount'] as String),
                                  status: tx['status'] as String,
                                  isPositive: tx['isPositive'] as bool,
                                  isSuccess: tx['isSuccess'] as bool,
                                  initialText: tx['initialText'] as String?,
                                  icon: tx['icon'] as IconData?,
                                  iconBackground: tx['iconBackground'] as Color? ?? AppColors.lightGray,
                                  iconColor: tx['iconColor'] as Color? ?? AppColors.black,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: Responsive.h(14)),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
