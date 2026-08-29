import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/payment/payment_event.dart';
import 'package:paynow/bloc/payment/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentInitial()) {
    on<ProcessTransferPaymentEvent>(_onProcessTransferPayment);
    on<ProcessBillPaymentEvent>(_onProcessBillPayment);
    on<ClaimScratchCardEvent>(_onClaimScratchCard);
    on<ResetPaymentStateEvent>(_onResetPaymentState);
  }

  Future<void> _onProcessTransferPayment(
    ProcessTransferPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (event.amount <= 0) {
      emit(const PaymentError('Please enter a valid amount'));
      return;
    }

    emit(const PaymentProcessing());
    await Future.delayed(const Duration(milliseconds: 600));

    final txnId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    emit(PaymentSuccess(
      title: event.recipientName,
      amount: event.amount,
      transactionId: txnId,
      destinationName: event.recipientName,
    ));
  }

  Future<void> _onProcessBillPayment(
    ProcessBillPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());
    await Future.delayed(const Duration(milliseconds: 600));

    final txnId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    emit(PaymentSuccess(
      title: '${event.operatorName} Bill Payment',
      amount: event.price,
      transactionId: txnId,
      destinationName: event.recipient,
    ));
  }

  Future<void> _onClaimScratchCard(
    ClaimScratchCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    final double amountVal =
        double.tryParse(event.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    final txnId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    emit(PaymentSuccess(
      title: 'Scratch Card Cashback',
      amount: amountVal,
      transactionId: txnId,
      destinationName: 'Main Wallet',
    ));
  }

  void _onResetPaymentState(
    ResetPaymentStateEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}
