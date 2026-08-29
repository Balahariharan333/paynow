import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  final String title;
  final double amount;
  final String transactionId;
  final String destinationName;

  const PaymentSuccess({
    required this.title,
    required this.amount,
    required this.transactionId,
    required this.destinationName,
  });

  @override
  List<Object?> get props => [title, amount, transactionId, destinationName];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
