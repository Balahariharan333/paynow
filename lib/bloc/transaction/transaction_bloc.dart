import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/transaction/transaction_state.dart';
import 'package:paynow/hive/hive_service.dart';
import 'package:paynow/model/beneficiary_model.dart';
import 'package:paynow/model/transaction_model.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(_getInitialState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<FilterTransactionsEvent>(_onFilterTransactions);
    on<SearchTransactionsEvent>(_onSearchTransactions);
    on<AddBankRecipientEvent>(_onAddBankRecipient);
    on<AddUpiRecipientEvent>(_onAddUpiRecipient);
  }

  static IconData? _resolveIcon(int? code) {
    if (code == null) return null;
    if (code == 0xe13b) return Icons.card_giftcard;
    if (code == 0xe292) return Icons.flash_on;
    if (code == 0xe5f9) return Icons.storefront;
    if (code == 0xe040) return Icons.account_balance;
    if (code == 0xe19f) return Icons.credit_card;
    return Icons.payment;
  }

  static TransactionLoaded _getInitialState() {
    final hiveTxns = HiveService.getTransactions().reversed.toList();
    final List<Map<String, dynamic>> txList = [];

    for (final tx in hiveTxns) {
      final map = tx.toMap();
      if (tx.iconCode != null) {
        map['icon'] = _resolveIcon(tx.iconCode);
      }
      txList.add(map);
    }

    final bankBeneficiaries = HiveService.getBeneficiaries(isBank: true)
        .map((b) => b.toMap())
        .toList();

    final upiBeneficiaries = HiveService.getBeneficiaries(isBank: false)
        .map((b) => b.toMap())
        .toList();

    return TransactionLoaded(
      allTransactions: txList,
      filteredTransactions: txList,
      bankRecipients: bankBeneficiaries.isNotEmpty
          ? bankBeneficiaries
          : [
              {'name': 'Harvey Specter', 'detail': 'HDFC Bank •••• 8829', 'bank': 'HDFC Bank'},
              {'name': 'Rachel Zane', 'detail': 'Chase Bank •••• 1102', 'bank': 'Chase Bank'},
              {'name': 'Louis Litt', 'detail': 'Axis Bank •••• 5678', 'bank': 'Axis Bank'},
            ],
      upiRecipients: upiBeneficiaries.isNotEmpty
          ? upiBeneficiaries
          : [
              {'name': 'Mike Ross', 'detail': 'mikeross@paynow'},
              {'name': 'Sarah Jenkins', 'detail': 'sarah@okaxis'},
              {'name': 'Jessica Pearson', 'detail': 'jessica@paytm'},
            ],
      selectedFilter: 'All',
      searchQuery: '',
    );
  }

  void _onLoadTransactions(LoadTransactionsEvent event, Emitter<TransactionState> emit) {
    emit(_getInitialState());
  }

  void _onAddTransaction(AddTransactionEvent event, Emitter<TransactionState> emit) {
    if (state is! TransactionLoaded) return;
    final current = state as TransactionLoaded;

    final String id = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    final String utr = 'UTR${(100000000000 + DateTime.now().millisecondsSinceEpoch % 100000000000)}';
    final String formattedAmount = 'Rs ${event.amountVal.toStringAsFixed(2)}';
    final String currentTime = _formatCurrentTime();

    final Map<String, dynamic> newTx = {
      'id': id,
      'title': event.title,
      'time': currentTime,
      'date': 'Today',
      'type': event.type,
      'amount': formattedAmount,
      'amountVal': event.amountVal,
      'status': event.isSuccess ? 'Success' : 'Failed',
      'isPositive': event.isPositive,
      'isSuccess': event.isSuccess,
      'utr': utr,
    };

    if (event.icon != null) {
      newTx['icon'] = event.icon;
      newTx['iconCode'] = event.icon!.codePoint;
    }
    if (event.iconBackground != null) newTx['iconBackground'] = event.iconBackground;
    if (event.iconColor != null) newTx['iconColor'] = event.iconColor;
    if (event.initialText != null) newTx['initialText'] = event.initialText;

    // Persist into Hive
    final txModel = TransactionModel(
      id: id,
      title: event.title,
      time: currentTime,
      date: 'Today',
      type: event.type,
      amount: formattedAmount,
      amountValue: event.amountVal,
      status: event.isSuccess ? 'Success' : 'Failed',
      isPositive: event.isPositive,
      isSuccess: event.isSuccess,
      initialText: event.initialText ?? (event.title.isNotEmpty ? event.title.substring(0, 1) : 'P'),
      utr: utr,
      iconCode: event.icon?.codePoint,
    );
    HiveService.addTransaction(txModel);

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

    // Persist into Hive
    HiveService.addBeneficiary(BeneficiaryModel(
      name: event.name,
      detail: event.detail,
      isBank: true,
      bank: event.bank,
    ));

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

    // Persist into Hive
    HiveService.addBeneficiary(BeneficiaryModel(
      name: event.name,
      detail: event.detail,
      isBank: false,
    ));

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
      final title = (tx['title'] as String? ?? '').toLowerCase();
      final utr = (tx['utr'] as String? ?? '').toLowerCase();
      if (cleanQuery.isNotEmpty && !title.contains(cleanQuery) && !utr.contains(cleanQuery)) {
        return false;
      }

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
