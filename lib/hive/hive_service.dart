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

  static late Box<UserProfileModel> _userBox;
  static late Box<WalletModel> _walletBox;
  static late Box<TransactionModel> _transactionBox;
  static late Box<BeneficiaryModel> _beneficiaryBox;
  static late Box _appSettingsBox;

  static Box<UserProfileModel> get userBox => _userBox;
  static Box<WalletModel> get walletBox => _walletBox;
  static Box<TransactionModel> get transactionBox => _transactionBox;
  static Box<BeneficiaryModel> get beneficiaryBox => _beneficiaryBox;
  static Box get appSettingsBox => _appSettingsBox;

  /// Initialize Hive, register adapters, setup AES-256 encryption key, and open boxes.
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Hive Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WalletModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(BeneficiaryModelAdapter());
    }

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
    _userBox = await Hive.openBox<UserProfileModel>(
      HiveBoxes.userBox,
      encryptionCipher: cipher,
    );
    _walletBox = await Hive.openBox<WalletModel>(
      HiveBoxes.walletBox,
      encryptionCipher: cipher,
    );

    // Open standard boxes for transactions, beneficiaries, and settings
    _transactionBox = await Hive.openBox<TransactionModel>(HiveBoxes.transactionBox);
    _beneficiaryBox = await Hive.openBox<BeneficiaryModel>(HiveBoxes.beneficiaryBox);
    _appSettingsBox = await Hive.openBox(HiveBoxes.appSettingsBox);

    // Seed default data on fresh install
    await _seedInitialDataIfNeeded();
  }

  static Future<void> _seedInitialDataIfNeeded() async {
    final bool isSeeded = _appSettingsBox.get(HiveBoxes.isAppSeededKey, defaultValue: false);
    if (!isSeeded) {
      // 1. Seed User Profile
      if (_userBox.isEmpty) {
        await _userBox.put(HiveBoxes.userProfileKey, UserProfileModel());
      }

      // 2. Seed Wallet Data
      if (_walletBox.isEmpty) {
        await _walletBox.put(HiveBoxes.walletDataKey, WalletModel());
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
          await _transactionBox.add(tx);
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
          await _beneficiaryBox.add(b);
        }
      }

      await _appSettingsBox.put(HiveBoxes.isAppSeededKey, true);
    }
  }

  // --- Profile Methods ---
  static UserProfileModel getUserProfile() {
    return _userBox.get(HiveBoxes.userProfileKey, defaultValue: UserProfileModel()) ??
        UserProfileModel();
  }

  static Future<void> saveUserProfile(UserProfileModel profile) async {
    await _userBox.put(HiveBoxes.userProfileKey, profile);
  }

  // --- Wallet Methods ---
  static WalletModel getWalletData() {
    return _walletBox.get(HiveBoxes.walletDataKey, defaultValue: WalletModel()) ??
        WalletModel();
  }

  static Future<void> saveWalletData(WalletModel wallet) async {
    await _walletBox.put(HiveBoxes.walletDataKey, wallet);
  }

  // --- Transactions Methods ---
  static List<TransactionModel> getTransactions() {
    return _transactionBox.values.toList();
  }

  static Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.add(transaction);
  }

  // --- Beneficiaries Methods ---
  static List<BeneficiaryModel> getBeneficiaries({bool? isBank}) {
    final all = _beneficiaryBox.values.toList();
    if (isBank == null) return all;
    return all.where((b) => b.isBank == isBank).toList();
  }

  static Future<void> addBeneficiary(BeneficiaryModel beneficiary) async {
    await _beneficiaryBox.add(beneficiary);
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
