import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessTransferPaymentEvent extends PaymentEvent {
  final String recipientName;
  final String recipientDetail;
  final double amount;
  final String type;
  final IconData? icon;

  const ProcessTransferPaymentEvent({
    required this.recipientName,
    required this.recipientDetail,
    required this.amount,
    this.type = 'Sent',
    this.icon,
  });

  @override
  List<Object?> get props => [recipientName, recipientDetail, amount, type, icon];
}

class ProcessBillPaymentEvent extends PaymentEvent {
  final String recipient;
  final String operatorName;
  final String planDetails;
  final double price;

  const ProcessBillPaymentEvent({
    required this.recipient,
    required this.operatorName,
    required this.planDetails,
    required this.price,
  });

  @override
  List<Object?> get props => [recipient, operatorName, planDetails, price];
}

class ClaimScratchCardEvent extends PaymentEvent {
  final String amount;
  final String type;
  final String subtitle;

  const ClaimScratchCardEvent({
    required this.amount,
    required this.type,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [amount, type, subtitle];
}

class ResetPaymentStateEvent extends PaymentEvent {
  const ResetPaymentStateEvent();
}
