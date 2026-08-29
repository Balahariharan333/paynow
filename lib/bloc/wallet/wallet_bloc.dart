import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc()
      : super(const WalletLoaded(
          balance: 12450.85,
          linkedBanks: [
            {
              'bankName': 'Chase Bank Platinum',
              'accountNumber': 'Ending in •••• 4829',
              'icon': Icons.account_balance,
              'mockBalance': 'Rs 34,250.00',
            },
            {
              'bankName': 'HSBC Savings',
              'accountNumber': 'Ending in •••• 1102',
              'icon': Icons.savings_outlined,
              'mockBalance': 'Rs 8,920.00',
            },
          ],
          isCardFrozen: false,
          dailyLimit: 50000.00,
        )) {
    on<LoadWalletEvent>(_onLoadWallet);
    on<ToggleFreezeCardEvent>(_onToggleFreezeCard);
    on<UpdateDailyLimitEvent>(_onUpdateDailyLimit);
    on<AddMoneyEvent>(_onAddMoney);
    on<WithdrawMoneyEvent>(_onWithdrawMoney);
    on<DeductWalletBalanceEvent>(_onDeductWalletBalance);
    on<CreditWalletBalanceEvent>(_onCreditWalletBalance);
    on<StartLinkBankEvent>(_onStartLinkBank);
    on<AddLinkedBankDirectEvent>(_onAddLinkedBankDirect);
    on<ResetLinkBankEvent>(_onResetLinkBank);
  }

  void _onLoadWallet(LoadWalletEvent event, Emitter<WalletState> emit) {
    if (state is! WalletLoaded) {
      emit(const WalletLoaded(
        balance: 12450.85,
        linkedBanks: [
          {
            'bankName': 'Chase Bank Platinum',
            'accountNumber': 'Ending in •••• 4829',
            'icon': Icons.account_balance,
            'mockBalance': 'Rs 34,250.00',
          },
          {
            'bankName': 'HSBC Savings',
            'accountNumber': 'Ending in •••• 1102',
            'icon': Icons.savings_outlined,
            'mockBalance': 'Rs 8,920.00',
          },
        ],
        isCardFrozen: false,
        dailyLimit: 50000.00,
      ));
    }
  }

  void _onToggleFreezeCard(ToggleFreezeCardEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(isCardFrozen: event.isFrozen));
    }
  }

  void _onUpdateDailyLimit(UpdateDailyLimitEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(dailyLimit: event.limit));
    }
  }

  void _onAddMoney(AddMoneyEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(balance: current.balance + event.amount));
    }
  }

  void _onWithdrawMoney(WithdrawMoneyEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(balance: current.balance - event.amount));
    }
  }

  void _onDeductWalletBalance(DeductWalletBalanceEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(balance: current.balance - event.amount));
    }
  }

  void _onCreditWalletBalance(CreditWalletBalanceEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(balance: current.balance + event.amount));
    }
  }

  Future<void> _onStartLinkBank(StartLinkBankEvent event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;
    var current = state as WalletLoaded;
    final bank = event.bank;

    emit(current.copyWith(
      isLinkingBank: true,
      linkBankSuccess: false,
      linkingBank: bank,
      linkingStep: 0,
      linkingProgressText: 'Sending secure SMS to ${bank['name']}...',
    ));

    // Step 1
    await Future.delayed(const Duration(milliseconds: 1000));
    if (state is! WalletLoaded) return;
    current = state as WalletLoaded;
    emit(current.copyWith(
      linkingStep: 1,
      linkingProgressText: 'Verifying mobile number linked to bank...',
    ));

    // Step 2
    await Future.delayed(const Duration(milliseconds: 1200));
    if (state is! WalletLoaded) return;
    current = state as WalletLoaded;
    final bankName = bank['name'] as String;
    emit(current.copyWith(
      linkingStep: 2,
      linkingProgressText: 'Found account ending in •••• ${1000 + (bankName.hashCode % 9000)}',
    ));

    // Step 3 (Success)
    await Future.delayed(const Duration(milliseconds: 1300));
    if (state is! WalletLoaded) return;
    current = state as WalletLoaded;
    final mockNumber = 'Ending in •••• ${1000 + (bankName.hashCode % 9000)}';
    final icon = bank['icon'] as IconData;
    final initialBalance = 5000.0 + (bankName.hashCode % 45000);

    final Map<String, dynamic> newBank = {
      'bankName': bankName,
      'accountNumber': mockNumber,
      'icon': icon,
      'mockBalance': 'Rs ${initialBalance.toStringAsFixed(2)}',
    };

    emit(current.copyWith(
      linkedBanks: [...current.linkedBanks, newBank],
      linkingStep: 3,
      isLinkingBank: false,
      linkBankSuccess: true,
    ));
  }

  void _onAddLinkedBankDirect(AddLinkedBankDirectEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      final String lastFour = event.accountNumber.length >= 4
          ? event.accountNumber.substring(event.accountNumber.length - 4)
          : event.accountNumber;
      final Map<String, dynamic> newBank = {
        'bankName': event.bankName,
        'accountNumber': 'Ending in •••• $lastFour',
        'icon': event.icon,
        'mockBalance': 'Rs ${event.initialBalance.toStringAsFixed(2)}',
      };
      emit(current.copyWith(linkedBanks: [...current.linkedBanks, newBank]));
    }
  }

  void _onResetLinkBank(ResetLinkBankEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(
        isLinkingBank: false,
        linkBankSuccess: false,
        linkingBank: null,
        linkingProgressText: '',
        linkingStep: 0,
      ));
    }
  }
}
