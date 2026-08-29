import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  const LoadTransactionsEvent();
}

class AddTransactionEvent extends TransactionEvent {
  final String title;
  final double amountVal;
  final String type;
  final bool isPositive;
  final bool isSuccess;
  final IconData? icon;
  final Color? iconBackground;
  final Color? iconColor;
  final String? initialText;

  const AddTransactionEvent({
    required this.title,
    required this.amountVal,
    required this.type,
    required this.isPositive,
    required this.isSuccess,
    this.icon,
    this.iconBackground,
    this.iconColor,
    this.initialText,
  });

  @override
  List<Object?> get props => [
        title,
        amountVal,
        type,
        isPositive,
        isSuccess,
        icon,
        iconBackground,
        iconColor,
        initialText,
      ];
}

class FilterTransactionsEvent extends TransactionEvent {
  final String filter; // 'All', 'Sent', 'Received', 'Failed'

  const FilterTransactionsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchTransactionsEvent extends TransactionEvent {
  final String query;

  const SearchTransactionsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddBankRecipientEvent extends TransactionEvent {
  final String name;
  final String detail;
  final String bank;

  const AddBankRecipientEvent({
    required this.name,
    required this.detail,
    required this.bank,
  });

  @override
  List<Object?> get props => [name, detail, bank];
}

class AddUpiRecipientEvent extends TransactionEvent {
  final String name;
  final String detail;

  const AddUpiRecipientEvent({
    required this.name,
    required this.detail,
  });

  @override
  List<Object?> get props => [name, detail];
}
