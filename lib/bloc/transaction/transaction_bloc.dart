import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/transaction/transaction_state.dart';
import 'package:paynow/utils/app_colors.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  static const List<Map<String, dynamic>> _initialTransactions = [
    {
      'id': 'TXN_001',
      'title': 'Sarah Jenkins',
      'time': '10:42 AM',
      'date': 'Today',
      'type': 'Sent',
      'amount': 'Rs 120.00',
      'status': 'Success',
      'isPositive': false,
      'isSuccess': true,
      'initialText': 'S',
      'iconBackground': Color(0xFFE5E7EB),
      'iconColor': AppColors.grayFont,
      'utr': 'UTR88349129849',
    },
    {
      'id': 'TXN_002',
      'title': 'Stripe Inc.',
      'time': '09:15 AM',
      'date': 'Today',
      'type': 'Payout',
      'amount': 'Rs 850.50',
      'status': 'Success',
      'isPositive': true,
      'isSuccess': true,
      'icon': Icons.card_giftcard,
      'iconBackground': AppColors.tintPurple,
      'iconColor': AppColors.primaryGradientEnd,
      'utr': 'UTR99837482910',
    },
    {
      'id': 'TXN_003',
      'title': 'Mike Ross',
      'time': '08:30 PM',
      'date': 'Yesterday',
      'type': 'Failed',
      'amount': 'Rs 45.00',
      'status': 'Declined',
      'isPositive': false,
      'isSuccess': false,
      'initialText': 'M',
      'iconBackground': Color(0xFFE5E7EB),
      'iconColor': AppColors.grayFont,
      'utr': 'UTR12837498112',
    },
    {
      'id': 'TXN_004',
      'title': 'City Power & Light',
      'time': '02:10 PM',
      'date': 'Yesterday',
      'type': 'Utility',
      'amount': 'Rs 132.80',
      'status': 'Success',
      'isPositive': false,
      'isSuccess': true,
      'icon': Icons.flash_on,
      'iconBackground': AppColors.tintBlue,
      'iconColor': AppColors.primary,
      'utr': 'UTR55492348123',
    },
    {
      'id': 'TXN_005',
      'title': 'Whole Foods Market',
      'time': '5:45 PM',
      'date': 'Last Week',
      'type': 'Scan & Pay',
      'amount': 'Rs 84.20',
      'status': 'Success',
      'isPositive': false,
      'isSuccess': true,
      'icon': Icons.storefront,
      'iconBackground': Color(0xFFE5E7EB),
      'iconColor': AppColors.grayFont,
      'utr': 'UTR44923749234',
    },
  ];

  static const List<Map<String, String>> _initialBankRecipients = [
    {'name': 'Harvey Specter', 'detail': 'HDFC Bank •••• 8829', 'bank': 'HDFC Bank'},
    {'name': 'Rachel Zane', 'detail': 'Chase Bank •••• 1102', 'bank': 'Chase Bank'},
    {'name': 'Louis Litt', 'detail': 'Axis Bank •••• 5678', 'bank': 'Axis Bank'},
  ];

  static const List<Map<String, String>> _initialUpiRecipients = [
    {'name': 'Mike Ross', 'detail': 'mikeross@paynow'},
    {'name': 'Sarah Jenkins', 'detail': 'sarah@okaxis'},
    {'name': 'Jessica Pearson', 'detail': 'jessica@paytm'},
  ];

  TransactionBloc()
      : super(const TransactionLoaded(
          allTransactions: _initialTransactions,
          filteredTransactions: _initialTransactions,
          bankRecipients: _initialBankRecipients,
          upiRecipients: _initialUpiRecipients,
          selectedFilter: 'All',
          searchQuery: '',
        )) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<FilterTransactionsEvent>(_onFilterTransactions);
    on<SearchTransactionsEvent>(_onSearchTransactions);
    on<AddBankRecipientEvent>(_onAddBankRecipient);
    on<AddUpiRecipientEvent>(_onAddUpiRecipient);
  }

  void _onLoadTransactions(LoadTransactionsEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) {
      emit(const TransactionLoaded(
        allTransactions: _initialTransactions,
        filteredTransactions: _initialTransactions,
        bankRecipients: _initialBankRecipients,
        upiRecipients: _initialUpiRecipients,
      ));
    }
  }

  void _onAddTransaction(AddTransactionEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) return;
    final current = state as TransactionLoaded;

    final String id = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    final String utr = 'UTR${(100000000000 + DateTime.now().millisecondsSinceEpoch % 100000000000)}';
    final String formattedAmount = 'Rs ${event.amountVal.toStringAsFixed(2)}';

    final Map<String, dynamic> newTx = {
      'id': id,
      'title': event.title,
      'time': _formatCurrentTime(),
      'date': 'Today',
      'type': event.type,
      'amount': formattedAmount,
      'status': event.isSuccess ? 'Success' : 'Failed',
      'isPositive': event.isPositive,
      'isSuccess': event.isSuccess,
      'utr': utr,
    };

    if (event.icon != null) newTx['icon'] = event.icon;
    if (event.iconBackground != null) newTx['iconBackground'] = event.iconBackground;
    if (event.iconColor != null) newTx['iconColor'] = event.iconColor;
    if (event.initialText != null) newTx['initialText'] = event.initialText;

    final updatedAll = [newTx, ...current.allTransactions];
    final updatedFiltered = _applyFilter(updatedAll, current.selectedFilter, current.searchQuery);

    emit(current.copyWith(
      allTransactions: updatedAll,
      filteredTransactions: updatedFiltered,
    ));
  }

  void _onFilterTransactions(FilterTransactionsEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) return;
    final current = state as TransactionLoaded;
    final filtered = _applyFilter(current.allTransactions, event.filter, current.searchQuery);
    emit(current.copyWith(
      selectedFilter: event.filter,
      filteredTransactions: filtered,
    ));
  }

  void _onSearchTransactions(SearchTransactionsEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) return;
    final current = state as TransactionLoaded;
    final filtered = _applyFilter(current.allTransactions, current.selectedFilter, event.query);
    emit(current.copyWith(
      searchQuery: event.query,
      filteredTransactions: filtered,
    ));
  }

  void _onAddBankRecipient(AddBankRecipientEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) return;
    final current = state as TransactionLoaded;
    final newBank = {
      'name': event.name,
      'detail': event.detail,
      'bank': event.bank,
    };
    emit(current.copyWith(
      bankRecipients: [...current.bankRecipients, newBank],
    ));
  }

  void _onAddUpiRecipient(AddUpiRecipientEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) return;
    final current = state as TransactionLoaded;
    final newUpi = {
      'name': event.name,
      'detail': event.detail,
    };
    emit(current.copyWith(
      upiRecipients: [...current.upiRecipients, newUpi],
    ));
  }

  List<Map<String, dynamic>> _applyFilter(
    List<Map<String, dynamic>> list,
    String filter,
    String query,
  ) {
    final cleanQuery = query.toLowerCase().trim();
    return list.where((tx) {
      // 1. Search filter
      final title = (tx['title'] as String? ?? '').toLowerCase();
      final utr = (tx['utr'] as String? ?? '').toLowerCase();
      if (cleanQuery.isNotEmpty && !title.contains(cleanQuery) && !utr.contains(cleanQuery)) {
        return false;
      }

      // 2. Category filter
      if (filter == 'All') return true;
      if (filter == 'Sent') {
        return !(tx['isPositive'] as bool? ?? false) && (tx['isSuccess'] as bool? ?? true);
      }
      if (filter == 'Received') {
        return (tx['isPositive'] as bool? ?? false) && (tx['isSuccess'] as bool? ?? true);
      }
      if (filter == 'Failed') {
        return !(tx['isSuccess'] as bool? ?? true);
      }
      return true;
    }).toList();
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
