import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/hive/hive_service.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(_getInitialState()) {
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

  static WalletLoaded _getInitialState() {
    final wallet = HiveService.getWalletData();
    final List<Map<String, dynamic>> banks = [];

    for (final b in wallet.linkedBanks) {
      banks.add({
        'bankName': b['bankName'] ?? 'Bank Account',
        'accountNumber': b['accountNumber']?.startsWith('Ending in') == true
            ? b['accountNumber']
            : 'Ending in ${b['accountNumber'] ?? '•••• 8829'}',
        'icon': (b['bankName']?.contains('Savings') == true)
            ? Icons.savings_outlined
            : Icons.account_balance,
        'mockBalance': 'Rs 24,500.00',
      });
    }

    return WalletLoaded(
      balance: wallet.balance,
      linkedBanks: banks.isNotEmpty
          ? banks
          : [
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
      isCardFrozen: wallet.isCardFrozen,
      dailyLimit: wallet.dailyLimit,
    );
  }

  void _persistWallet({
    double? balance,
    bool? isCardFrozen,
    double? dailyLimit,
    List<Map<String, dynamic>>? linkedBanks,
  }) {
    final currentModel = HiveService.getWalletData();
    List<Map<String, String>>? bankMaps;
    if (linkedBanks != null) {
      bankMaps = linkedBanks.map((b) {
        return {
          'bankName': b['bankName']?.toString() ?? '',
          'accountNumber': b['accountNumber']?.toString() ?? '',
        };
      }).toList();
    }

    final updated = currentModel.copyWith(
      balance: balance,
      isCardFrozen: isCardFrozen,
      dailyLimit: dailyLimit,
      linkedBanks: bankMaps,
    );
    HiveService.saveWalletData(updated);
  }

  void _onLoadWallet(LoadWalletEvent event, Emitter<WalletState> emit) {
    emit(_getInitialState());
  }

  void _onToggleFreezeCard(ToggleFreezeCardEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(isCardFrozen: event.isFrozen));
      _persistWallet(isCardFrozen: event.isFrozen);
    }
  }

  void _onUpdateDailyLimit(UpdateDailyLimitEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      emit(current.copyWith(dailyLimit: event.limit));
      _persistWallet(dailyLimit: event.limit);
    }
  }

  void _onAddMoney(AddMoneyEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      final newBalance = current.balance + event.amount;
      emit(current.copyWith(balance: newBalance));
      _persistWallet(balance: newBalance);
    }
  }

  void _onWithdrawMoney(WithdrawMoneyEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      final newBalance = (current.balance - event.amount).clamp(0.0, double.infinity);
      emit(current.copyWith(balance: newBalance));
      _persistWallet(balance: newBalance);
    }
  }

  void _onDeductWalletBalance(DeductWalletBalanceEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      final newBalance = (current.balance - event.amount).clamp(0.0, double.infinity);
      emit(current.copyWith(balance: newBalance));
      _persistWallet(balance: newBalance);
    }
  }

  void _onCreditWalletBalance(CreditWalletBalanceEvent event, Emitter<WalletState> emit) {
    if (state is WalletLoaded) {
      final current = state as WalletLoaded;
      final newBalance = current.balance + event.amount;
      emit(current.copyWith(balance: newBalance));
      _persistWallet(balance: newBalance);
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
    await Future.delayed(const Duration(milliseconds: 800));
    if (state is! WalletLoaded) return;
    current = state as WalletLoaded;
    emit(current.copyWith(
      linkingStep: 1,
      linkingProgressText: 'Verifying mobile number linked to bank...',
    ));

    // Step 2
    await Future.delayed(const Duration(milliseconds: 900));
    if (state is! WalletLoaded) return;
    current = state as WalletLoaded;
    final bankName = bank['name'] as String;
    emit(current.copyWith(
      linkingStep: 2,
      linkingProgressText: 'Found account ending in •••• ${1000 + (bankName.hashCode.abs() % 9000)}',
    ));

    // Step 3 (Success)
    await Future.delayed(const Duration(milliseconds: 900));
    if (state is! WalletLoaded) return;
    current = state as WalletLoaded;
    final mockNumber = 'Ending in •••• ${1000 + (bankName.hashCode.abs() % 9000)}';
    final icon = bank['icon'] as IconData? ?? Icons.account_balance;
    final initialBalance = 5000.0 + (bankName.hashCode.abs() % 45000);

    final Map<String, dynamic> newBank = {
      'bankName': bankName,
      'accountNumber': mockNumber,
      'icon': icon,
      'mockBalance': 'Rs ${initialBalance.toStringAsFixed(2)}',
    };

    final updatedBanks = [...current.linkedBanks, newBank];
    emit(current.copyWith(
      linkedBanks: updatedBanks,
      linkingStep: 3,
      isLinkingBank: false,
      linkBankSuccess: true,
    ));

    _persistWallet(linkedBanks: updatedBanks);
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
      final updatedBanks = [...current.linkedBanks, newBank];
      emit(current.copyWith(linkedBanks: updatedBanks));
      _persistWallet(linkedBanks: updatedBanks);
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
