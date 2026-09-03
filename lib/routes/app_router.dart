import 'package:flutter/material.dart';
import 'package:paynow/constants/route_constants.dart';

// Screens
import 'package:paynow/screen/auth/login_screen.dart';
import 'package:paynow/screen/home/history_screen.dart';
import 'package:paynow/screen/home/home_screen.dart';
import 'package:paynow/screen/home/main_screen.dart';
import 'package:paynow/screen/home/notifications_screen.dart';
import 'package:paynow/screen/onboarding/link_bank_screen.dart';
import 'package:paynow/screen/payment/bills/bills_dashboard_screen.dart';
import 'package:paynow/screen/payment/bills/mobile_recharge_screen.dart';
import 'package:paynow/screen/payment/bills/recharge_directory_screen.dart';
import 'package:paynow/screen/payment/bills/recharge_success_screen.dart';
import 'package:paynow/screen/payment/bills/recharge_summary_screen.dart';
import 'package:paynow/screen/payment/bills/select_plan_screen.dart';
import 'package:paynow/screen/payment/rewards/active_scratch_cards_screen.dart';
import 'package:paynow/screen/payment/rewards/exclusive_offers_screen.dart';
import 'package:paynow/screen/payment/rewards/refer_and_earn_screen.dart';
import 'package:paynow/screen/payment/rewards/rewards_home_screen.dart';
import 'package:paynow/screen/payment/rewards/scratch_card_detail_screen.dart';
import 'package:paynow/screen/payment/transfer/bank_transfer_screen.dart';
import 'package:paynow/screen/payment/transfer/contact_transfer_screen.dart';
import 'package:paynow/screen/payment/transfer/qr_scanner_screen.dart';
import 'package:paynow/screen/payment/transfer/to_mobile_number_screen.dart';
import 'package:paynow/screen/payment/transfer/transfer_home_screen.dart';
import 'package:paynow/screen/payment/wallet/add_money_screen.dart';
import 'package:paynow/screen/payment/wallet/transaction_success_screen.dart';
import 'package:paynow/screen/payment/wallet/wallet_balance_screen.dart';
import 'package:paynow/screen/payment/wallet/withdraw_screen.dart';
import 'package:paynow/screen/profile/bank_accounts_screen.dart';
import 'package:paynow/screen/profile/profile_settings_screen.dart';
import 'package:paynow/screen/settings/card_details_screen.dart';
import 'package:paynow/screen/transaction/transaction_details_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Auth & Onboarding
      case RouteConstants.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case RouteConstants.linkBank:
        final isFromOnboarding = args is bool ? args : false;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LinkBankScreen(isFromOnboarding: isFromOnboarding),
        );

      // Home & Core
      case RouteConstants.main:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainScreen(),
        );
      case RouteConstants.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case RouteConstants.notifications:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NotificationsScreen(),
        );
      case RouteConstants.history:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HistoryScreen(),
        );

      // Payment & Transfer
      case RouteConstants.transferHome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TransferHomeScreen(),
        );
      case RouteConstants.bankTransfer:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const BankTransferScreen(),
        );
      case RouteConstants.contactTransfer:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ContactTransferScreen(
              contactName: args['contactName']?.toString() ?? 'Contact',
              contactDetail: args['contactDetail']?.toString() ?? '',
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing contact arguments');

      case RouteConstants.toMobileNumber:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ToMobileNumberScreen(),
        );
      case RouteConstants.qrScanner:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const QrScannerScreen(),
        );

      // Wallet
      case RouteConstants.walletBalance:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WalletBalanceScreen(),
        );
      case RouteConstants.addMoney:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AddMoneyScreen(),
        );
      case RouteConstants.withdraw:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WithdrawScreen(),
        );
      case RouteConstants.transactionSuccess:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TransactionSuccessScreen(
              isWithdrawal: args['isWithdrawal'] == true,
              isFromChat: args['isFromChat'] == true,
              amount: args['amount']?.toString() ?? '',
              destinationName: args['destinationName']?.toString() ?? '',
              destinationIcon: args['destinationIcon'] is IconData
                  ? args['destinationIcon'] as IconData
                  : Icons.account_balance_wallet,
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing transaction success arguments');

      // Transaction
      case RouteConstants.transactionDetails:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TransactionDetailsScreen(
              transaction: Map<String, dynamic>.from(args),
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing transaction details arguments');

      // Rewards
      case RouteConstants.rewardsHome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RewardsHomeScreen(),
        );
      case RouteConstants.activeScratchCards:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ActiveScratchCardsScreen(),
        );
      case RouteConstants.scratchCardDetail:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ScratchCardDetailScreen(
              amount: args['amount']?.toString() ?? '',
              type: args['type']?.toString() ?? '',
              subtitle: args['subtitle']?.toString() ?? '',
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing scratch card arguments');

      case RouteConstants.exclusiveOffers:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ExclusiveOffersScreen(),
        );
      case RouteConstants.referAndEarn:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ReferAndEarnScreen(),
        );

      // Bills & Recharge
      case RouteConstants.billsDashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const BillsDashboardScreen(),
        );
      case RouteConstants.rechargeDirectory:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RechargeDirectoryScreen(),
        );
      case RouteConstants.mobileRecharge:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MobileRechargeScreen(),
        );
      case RouteConstants.selectPlan:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => SelectPlanScreen(
              contactName: args['contactName']?.toString() ?? '',
              phoneNumber: args['phoneNumber']?.toString() ?? '',
              operatorName: args['operatorName']?.toString() ?? '',
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing select plan arguments');

      case RouteConstants.rechargeSummary:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => RechargeSummaryScreen(
              recipient: args['recipient']?.toString() ?? '',
              operatorName: args['operatorName']?.toString() ?? '',
              planDetails: args['planDetails']?.toString() ?? '',
              price: (args['price'] as num?)?.toDouble() ?? 0.0,
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing recharge summary arguments');

      case RouteConstants.rechargeSuccess:
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => RechargeSuccessScreen(
              amount: args['amount']?.toString() ?? '',
              recipientNumber: args['recipientNumber']?.toString() ?? '',
            ),
          );
        }
        return _errorRoute(settings.name, 'Missing recharge success arguments');

      // Profile & Settings
      case RouteConstants.profileSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileSettingsScreen(),
        );
      case RouteConstants.cardDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CardDetailsScreen(),
        );
      case RouteConstants.bankAccounts:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const BankAccountsScreen(),
        );

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName, [String? detail]) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              detail != null
                  ? 'Error for route "$routeName": $detail'
                  : 'No route defined for "$routeName"',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
