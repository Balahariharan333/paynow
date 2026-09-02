import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paynow/hive/hive_boxes.dart';
import 'package:paynow/model/beneficiary_model.dart';
import 'package:paynow/model/transaction_model.dart';
import 'package:paynow/model/user_profile_model.dart';
import 'package:paynow/model/wallet_model.dart';

class HiveService {
  HiveService._();

  static late Box _userBox;
  static late Box _walletBox;
  static late Box _transactionBox;
  static late Box _beneficiaryBox;
  static late Box _appSettingsBox;

  static Box get userBox => _userBox;
  static Box get walletBox => _walletBox;
  static Box get transactionBox => _transactionBox;
  static Box get beneficiaryBox => _beneficiaryBox;
  static Box get appSettingsBox => _appSettingsBox;

  /// Helper to safely open a Hive box with automatic cleanup of legacy binary data
  static Future<Box> _openBoxSafe(
    String boxName, {
    HiveCipher? encryptionCipher,
  }) async {
    try {
      return await Hive.openBox(boxName, encryptionCipher: encryptionCipher);
    } catch (_) {
      // In case of schema migration from legacy TypeAdapter to Map/JSON format,
      // or corrupted binary frames on disk, safely delete old box from disk and reopen cleanly.
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (_) {}
      return await Hive.openBox(boxName, encryptionCipher: encryptionCipher);
    }
  }

  /// Initialize Hive, setup AES-256 encryption key, and open Map/JSON boxes.
  static Future<void> init() async {
    await Hive.initFlutter();

    // Retrieve or generate AES-256 encryption key from FlutterSecureStorage
    const secureStorage = FlutterSecureStorage();
    List<int> encryptionKey;
    try {
      final keyString = await secureStorage.read(key: 'hive_encryption_key');
      if (keyString == null) {
        encryptionKey = Hive.generateSecureKey();
        await secureStorage.write(
          key: 'hive_encryption_key',
          value: base64UrlEncode(encryptionKey),
        );
      } else {
        encryptionKey = base64Url.decode(keyString);
      }
    } catch (_) {
      // Fallback key if secure storage is unavailable on certain desktop test environments
      encryptionKey = Hive.generateSecureKey();
    }

    final cipher = HiveAesCipher(encryptionKey);

    // Open encrypted boxes for sensitive user profile and wallet data
    _userBox = await _openBoxSafe(
      HiveBoxes.userBox,
      encryptionCipher: cipher,
    );
    _walletBox = await _openBoxSafe(
      HiveBoxes.walletBox,
      encryptionCipher: cipher,
    );

    // Open standard boxes for transactions, beneficiaries, and settings
    _transactionBox = await _openBoxSafe(HiveBoxes.transactionBox);
    _beneficiaryBox = await _openBoxSafe(HiveBoxes.beneficiaryBox);
    _appSettingsBox = await _openBoxSafe(HiveBoxes.appSettingsBox);

    // Seed default data on fresh install or after legacy wipe
    await _seedInitialDataIfNeeded();
  }

  static Future<void> _seedInitialDataIfNeeded() async {
    // 1. Seed User Profile
    if (_userBox.isEmpty || !_userBox.containsKey(HiveBoxes.userProfileKey)) {
      await _userBox.put(HiveBoxes.userProfileKey, UserProfileModel().toMap());
    }

    // 2. Seed Wallet Data
    if (_walletBox.isEmpty || !_walletBox.containsKey(HiveBoxes.walletDataKey)) {
      await _walletBox.put(HiveBoxes.walletDataKey, WalletModel().toMap());
    }

    // 3. Seed Initial Transactions
    if (_transactionBox.isEmpty) {
      final initialTxns = [
        TransactionModel(
          id: 'TXN_001',
          title: 'Sarah Jenkins',
          time: '10:42 AM',
          date: 'Today',
          type: 'Sent',
          amount: 'Rs 120.00',
          amountValue: 120.0,
          status: 'Success',
          isPositive: false,
          isSuccess: true,
          initialText: 'S',
          utr: 'UTR88349129849',
        ),
        TransactionModel(
          id: 'TXN_002',
          title: 'Stripe Inc.',
          time: '09:15 AM',
          date: 'Today',
          type: 'Payout',
          amount: 'Rs 850.50',
          amountValue: 850.5,
          status: 'Success',
          isPositive: true,
          isSuccess: true,
          initialText: 'S',
          iconCode: 0xe13b, // Icons.card_giftcard
          utr: 'UTR99837482910',
        ),
        TransactionModel(
          id: 'TXN_003',
          title: 'Mike Ross',
          time: '08:30 PM',
          date: 'Yesterday',
          type: 'Failed',
          amount: 'Rs 45.00',
          amountValue: 45.0,
          status: 'Declined',
          isPositive: false,
          isSuccess: false,
          initialText: 'M',
          utr: 'UTR12837498112',
        ),
        TransactionModel(
          id: 'TXN_004',
          title: 'City Power & Light',
          time: '02:10 PM',
          date: 'Yesterday',
          type: 'Utility',
          amount: 'Rs 132.80',
          amountValue: 132.8,
          status: 'Success',
          isPositive: false,
          isSuccess: true,
          initialText: 'C',
          iconCode: 0xe292, // Icons.flash_on
          utr: 'UTR55492348123',
        ),
        TransactionModel(
          id: 'TXN_005',
          title: 'Whole Foods Market',
          time: '5:45 PM',
          date: 'Last Week',
          type: 'Scan & Pay',
          amount: 'Rs 84.20',
          amountValue: 84.2,
          status: 'Success',
          isPositive: false,
          isSuccess: true,
          initialText: 'W',
          iconCode: 0xe5f9, // Icons.storefront
          utr: 'UTR44923749234',
        ),
      ];

      for (final tx in initialTxns) {
        await _transactionBox.add(tx.toMap());
      }
    }

    // 4. Seed Initial Beneficiaries
    if (_beneficiaryBox.isEmpty) {
      final initialBeneficiaries = [
        BeneficiaryModel(
          name: 'Harvey Specter',
          detail: 'HDFC Bank •••• 8829',
          isBank: true,
          bank: 'HDFC Bank',
        ),
        BeneficiaryModel(
          name: 'Rachel Zane',
          detail: 'Chase Bank •••• 1102',
          isBank: true,
          bank: 'Chase Bank',
        ),
        BeneficiaryModel(
          name: 'Louis Litt',
          detail: 'Axis Bank •••• 5678',
          isBank: true,
          bank: 'Axis Bank',
        ),
        BeneficiaryModel(
          name: 'Mike Ross',
          detail: 'mikeross@paynow',
          isBank: false,
        ),
        BeneficiaryModel(
          name: 'Sarah Jenkins',
          detail: 'sarah@okaxis',
          isBank: false,
        ),
        BeneficiaryModel(
          name: 'Jessica Pearson',
          detail: 'jessica@paytm',
          isBank: false,
        ),
      ];

      for (final b in initialBeneficiaries) {
        await _beneficiaryBox.add(b.toMap());
      }
    }

    await _appSettingsBox.put(HiveBoxes.isAppSeededKey, true);
  }

  // --- Profile Methods ---
  static UserProfileModel getUserProfile() {
    final data = _userBox.get(HiveBoxes.userProfileKey);
    if (data is Map) {
      return UserProfileModel.fromMap(data);
    }
    return UserProfileModel();
  }

  static Future<void> saveUserProfile(UserProfileModel profile) async {
    await _userBox.put(HiveBoxes.userProfileKey, profile.toMap());
  }

  // --- Wallet Methods ---
  static WalletModel getWalletData() {
    final data = _walletBox.get(HiveBoxes.walletDataKey);
    if (data is Map) {
      return WalletModel.fromMap(data);
    }
    return WalletModel();
  }

  static Future<void> saveWalletData(WalletModel wallet) async {
    await _walletBox.put(HiveBoxes.walletDataKey, wallet.toMap());
  }

  // --- Transactions Methods ---
  static List<TransactionModel> getTransactions() {
    final List<TransactionModel> list = [];
    for (final item in _transactionBox.values) {
      if (item is Map) {
        list.add(TransactionModel.fromMap(item));
      }
    }
    return list;
  }

  static Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.add(transaction.toMap());
  }

  // --- Beneficiaries Methods ---
  static List<BeneficiaryModel> getBeneficiaries({bool? isBank}) {
    final List<BeneficiaryModel> list = [];
    for (final item in _beneficiaryBox.values) {
      if (item is Map) {
        final b = BeneficiaryModel.fromMap(item);
        if (isBank == null || b.isBank == isBank) {
          list.add(b);
        }
      }
    }
    return list;
  }

  static Future<void> addBeneficiary(BeneficiaryModel beneficiary) async {
    await _beneficiaryBox.add(beneficiary.toMap());
  }

  // --- Theme Mode Methods ---
  static bool getDarkMode() {
    return _appSettingsBox.get(HiveBoxes.themeModeKey, defaultValue: false);
  }

  static Future<void> saveDarkMode(bool isDark) async {
    await _appSettingsBox.put(HiveBoxes.themeModeKey, isDark);
  }

  // --- Persistent Login Session Methods ---
  static bool isLoggedIn() {
    return _appSettingsBox.get(HiveBoxes.isLoggedInKey, defaultValue: false);
  }

  static String getLoggedInPhone() {
    return _appSettingsBox.get(HiveBoxes.loggedInPhoneKey, defaultValue: '+91 98765 43210');
  }

  static String _formatPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    } else if (digits.length > 10 && digits.startsWith('91')) {
      final sub = digits.substring(2);
      if (sub.length == 10) {
        return '+91 ${sub.substring(0, 5)} ${sub.substring(5)}';
      }
    }
    return raw.startsWith('+') ? raw : '+91 $raw';
  }

  static Future<void> saveLoginSession(String phone) async {
    final formatted = _formatPhone(phone);
    await _appSettingsBox.put(HiveBoxes.isLoggedInKey, true);
    await _appSettingsBox.put(HiveBoxes.loggedInPhoneKey, formatted);

    // Sync directly into UserProfileModel so profile and all screens reflect login number
    final profile = getUserProfile();
    final cleanDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final updated = profile.copyWith(
      phone: formatted,
      upiId: cleanDigits.isNotEmpty ? '$cleanDigits@paynow' : profile.upiId,
    );
    await saveUserProfile(updated);
  }

  static Future<void> clearLoginSession() async {
    await _appSettingsBox.put(HiveBoxes.isLoggedInKey, false);
    await _appSettingsBox.put(HiveBoxes.loggedInPhoneKey, '');
  }
}
