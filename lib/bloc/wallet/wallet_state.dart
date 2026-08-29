import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final double balance;
  final List<Map<String, dynamic>> linkedBanks;
  final bool isCardFrozen;
  final double dailyLimit;

  // Linking bank state progression properties
  final bool isLinkingBank;
  final bool linkBankSuccess;
  final Map<String, dynamic>? linkingBank;
  final String linkingProgressText;
  final int linkingStep;

  const WalletLoaded({
    required this.balance,
    required this.linkedBanks,
    this.isCardFrozen = false,
    this.dailyLimit = 50000.0,
    this.isLinkingBank = false,
    this.linkBankSuccess = false,
    this.linkingBank,
    this.linkingProgressText = '',
    this.linkingStep = 0,
  });

  WalletLoaded copyWith({
    double? balance,
    List<Map<String, dynamic>>? linkedBanks,
    bool? isCardFrozen,
    double? dailyLimit,
    bool? isLinkingBank,
    bool? linkBankSuccess,
    Map<String, dynamic>? linkingBank,
    String? linkingProgressText,
    int? linkingStep,
  }) {
    return WalletLoaded(
      balance: balance ?? this.balance,
      linkedBanks: linkedBanks ?? this.linkedBanks,
      isCardFrozen: isCardFrozen ?? this.isCardFrozen,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      isLinkingBank: isLinkingBank ?? this.isLinkingBank,
      linkBankSuccess: linkBankSuccess ?? this.linkBankSuccess,
      linkingBank: linkingBank ?? this.linkingBank,
      linkingProgressText: linkingProgressText ?? this.linkingProgressText,
      linkingStep: linkingStep ?? this.linkingStep,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        linkedBanks,
        isCardFrozen,
        dailyLimit,
        isLinkingBank,
        linkBankSuccess,
        linkingBank,
        linkingProgressText,
        linkingStep,
      ];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
