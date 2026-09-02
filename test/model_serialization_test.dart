import 'package:flutter_test/flutter_test.dart';
import 'package:paynow/model/beneficiary_model.dart';
import 'package:paynow/model/transaction_model.dart';
import 'package:paynow/model/user_profile_model.dart';
import 'package:paynow/model/wallet_model.dart';

void main() {
  group('UserProfileModel Serialization Tests', () {
    test('Roundtrip toMap and fromMap works seamlessly', () {
      final profile = UserProfileModel(
        name: 'John Doe',
        phone: '+91 99887 76655',
        upiId: 'johndoe@paynow',
        mpin: '4321',
        notificationsEnabled: false,
        biometricsEnabled: true,
        darkModeEnabled: true,
      );

      final map = profile.toMap();
      final restored = UserProfileModel.fromMap(map);

      expect(restored.name, 'John Doe');
      expect(restored.phone, '+91 99887 76655');
      expect(restored.upiId, 'johndoe@paynow');
      expect(restored.mpin, '4321');
      expect(restored.notificationsEnabled, false);
      expect(restored.biometricsEnabled, true);
      expect(restored.darkModeEnabled, true);
    });

    test('JSON string serialization roundtrip works', () {
      final profile = UserProfileModel(name: 'Alice');
      final jsonStr = profile.toRawJson();
      final restored = UserProfileModel.fromRawJson(jsonStr);

      expect(restored.name, 'Alice');
      expect(restored.phone, '+91 98765 43210');
    });

    test('Handles fallback for empty map gracefully', () {
      final restored = UserProfileModel.fromMap({});
      expect(restored.name, 'Alex');
      expect(restored.phone, '+91 98765 43210');
      expect(restored.upiId, 'alex@paynow');
      expect(restored.mpin, '1234');
      expect(restored.notificationsEnabled, true);
      expect(restored.biometricsEnabled, true);
      expect(restored.darkModeEnabled, false);
    });
  });

  group('WalletModel Serialization Tests', () {
    test('Roundtrip toMap and fromMap preserves linkedBanks and balance', () {
      final wallet = WalletModel(
        balance: 45000.50,
        isCardFrozen: true,
        dailyLimit: 25000.0,
        monthlyLimit: 100000.0,
        linkedBanks: [
          {'bankName': 'Citi Bank', 'accountNumber': '•••• 9988', 'isPrimary': 'true'},
        ],
      );

      final map = wallet.toMap();
      final restored = WalletModel.fromMap(map);

      expect(restored.balance, 45000.50);
      expect(restored.isCardFrozen, true);
      expect(restored.dailyLimit, 25000.0);
      expect(restored.monthlyLimit, 100000.0);
      expect(restored.linkedBanks.length, 1);
      expect(restored.linkedBanks.first['bankName'], 'Citi Bank');
    });

    test('JSON string serialization works correctly', () {
      final wallet = WalletModel();
      final jsonStr = wallet.toRawJson();
      final restored = WalletModel.fromRawJson(jsonStr);

      expect(restored.balance, 12450.75);
      expect(restored.linkedBanks.length, 2);
    });
  });

  group('TransactionModel Serialization Tests', () {
    test('Roundtrip toMap and fromMap preserves all transaction fields', () {
      final txn = TransactionModel(
        id: 'TXN_TEST_101',
        title: 'Netflix Subscription',
        time: '04:15 PM',
        date: 'Today',
        type: 'Subscription',
        amount: 'Rs 649.00',
        amountValue: 649.0,
        status: 'Success',
        isPositive: false,
        isSuccess: true,
        initialText: 'N',
        utr: 'UTR998877665544',
        iconCode: 0xe13b,
      );

      final map = txn.toMap();
      final restored = TransactionModel.fromMap(map);

      expect(restored.id, 'TXN_TEST_101');
      expect(restored.title, 'Netflix Subscription');
      expect(restored.amountValue, 649.0);
      expect(restored.status, 'Success');
      expect(restored.isPositive, false);
      expect(restored.isSuccess, true);
      expect(restored.initialText, 'N');
      expect(restored.utr, 'UTR998877665544');
      expect(restored.iconCode, 0xe13b);
    });

    test('fromMap handles both amountVal and amountValue keys', () {
      final fromVal = TransactionModel.fromMap({
        'title': 'Test Val',
        'amountVal': 250.0,
        'isPositive': true,
      });
      expect(fromVal.amountValue, 250.0);

      final fromValue = TransactionModel.fromMap({
        'title': 'Test Value',
        'amountValue': 350.0,
        'isPositive': true,
      });
      expect(fromValue.amountValue, 350.0);
    });
  });

  group('BeneficiaryModel Serialization Tests', () {
    test('Roundtrip toMap and fromMap works for bank beneficiary', () {
      final beneficiary = BeneficiaryModel(
        name: 'John Miller',
        detail: 'HDFC Bank •••• 1234',
        isBank: true,
        bank: 'HDFC Bank',
      );

      final map = beneficiary.toMap();
      final restored = BeneficiaryModel.fromMap(map);

      expect(restored.name, 'John Miller');
      expect(restored.detail, 'HDFC Bank •••• 1234');
      expect(restored.isBank, true);
      expect(restored.bank, 'HDFC Bank');
    });

    test('Roundtrip toRecipientMap works for UPI beneficiary', () {
      final upi = BeneficiaryModel(
        name: 'Sarah Connor',
        detail: 'sarah@okaxis',
        isBank: false,
      );

      final recipientMap = upi.toRecipientMap();
      expect(recipientMap['name'], 'Sarah Connor');
      expect(recipientMap['detail'], 'sarah@okaxis');
      expect(recipientMap.containsKey('bank'), false);
    });
  });
}
