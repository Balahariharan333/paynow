import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWalletEvent extends WalletEvent {
  const LoadWalletEvent();
}

class ToggleFreezeCardEvent extends WalletEvent {
  final bool isFrozen;

  const ToggleFreezeCardEvent(this.isFrozen);

  @override
  List<Object?> get props => [isFrozen];
}

class UpdateDailyLimitEvent extends WalletEvent {
  final double limit;

  const UpdateDailyLimitEvent(this.limit);

  @override
  List<Object?> get props => [limit];
}

class AddMoneyEvent extends WalletEvent {
  final double amount;
  final String sourceName;

  const AddMoneyEvent({required this.amount, required this.sourceName});

  @override
  List<Object?> get props => [amount, sourceName];
}

class WithdrawMoneyEvent extends WalletEvent {
  final double amount;
  final Map<String, dynamic> destinationBank;

  const WithdrawMoneyEvent({required this.amount, required this.destinationBank});

  @override
  List<Object?> get props => [amount, destinationBank];
}

class DeductWalletBalanceEvent extends WalletEvent {
  final double amount;

  const DeductWalletBalanceEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class CreditWalletBalanceEvent extends WalletEvent {
  final double amount;

  const CreditWalletBalanceEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class StartLinkBankEvent extends WalletEvent {
  final Map<String, dynamic> bank;

  const StartLinkBankEvent(this.bank);

  @override
  List<Object?> get props => [bank];
}

class AddLinkedBankDirectEvent extends WalletEvent {
  final String bankName;
  final String accountNumber;
  final IconData icon;
  final double initialBalance;

  const AddLinkedBankDirectEvent({
    required this.bankName,
    required this.accountNumber,
    required this.icon,
    this.initialBalance = 5000.0,
  });

  @override
  List<Object?> get props => [bankName, accountNumber, icon, initialBalance];
}

class ResetLinkBankEvent extends WalletEvent {
  const ResetLinkBankEvent();
}
