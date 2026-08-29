# PayNow BLoC State Management Documentation

This document provides a comprehensive guide to the **BLoC (Business Logic Component)** state management architecture implemented across the **PayNow** Flutter application.

---

## Table of Contents
1. [Architecture Overview](#1-architecture-overview)
2. [Global MultiBlocProvider Setup](#2-global-multiblocprovider-setup)
3. [BLoC Domains & State Machines](#3-bloc-domains--state-machines)
   - [Auth BLoC](#31-auth-bloc)
   - [Wallet BLoC](#32-wallet-bloc)
   - [Transaction BLoC](#33-transaction-bloc)
   - [Payment BLoC](#34-payment-bloc)
   - [Profile BLoC](#35-profile-bloc)
   - [Notification BLoC](#36-notification-bloc)
4. [Screen Integration & User Flows](#4-screen-integration--user-flows)
   - [1. Authentication & Onboarding Flow](#1-authentication--onboarding-flow)
   - [2. Home Dashboard & Quick Actions Flow](#2-home-dashboard--quick-actions-flow)
   - [3. Card Controls & Security Flow](#3-card-controls--security-flow)
   - [4. Add Money & Withdraw Funds Flow](#4-add-money--withdraw-funds-flow)
   - [5. Transfers & Payment Channels Flow](#5-transfers--payment-channels-flow)
   - [6. Transactions History & Live Search Flow](#6-transactions-history--live-search-flow)
   - [7. Bills & Recharges Flow](#7-bills--recharges-flow)
   - [8. Rewards & Cashback Flow](#8-rewards--cashback-flow)
   - [9. Notifications & Category Filter Flow](#9-notifications--category-filter-flow)
   - [10. Profile Settings & App Preferences Flow](#10-profile-settings--app-preferences-flow)
5. [BLoC Usage Patterns Guide](#5-bloc-usage-patterns-guide)
6. [Verification & Quality Checklist](#6-verification--quality-checklist)

---

## 1. Architecture Overview

PayNow adheres to a clean, decoupled architecture:
- **Presentation Layer**: Widgets and Screens consume immutable states via `BlocBuilder`, `BlocConsumer`, and `BlocListener`.
- **BLoC Layer**: Pure Dart classes extending `Bloc<Event, State>`, listening to strongly-typed events and emitting new states extending `Equatable`.
- **Data & Model Layer**: State models and immutable collections.

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Screens, Custom Widgets, Dialogs, BottomSheets)     │
└──────────────┬───────────────────────────▲─────────────┘
               │                           │
         Dispatches Events            Emits States
               │                           │
┌──────────────▼───────────────────────────┴─────────────┐
│                       BLoC Layer                       │
│    (AuthBloc, WalletBloc, TransactionBloc, etc.)       │
└──────────────┬───────────────────────────▲─────────────┘
               │                           │
         Data Mutations               Data Streams
               │                           │
┌──────────────▼───────────────────────────┴─────────────┐
│                    Data & State Layer                  │
│       (Balance, Transactions, Banks, Profiles)         │
└────────────────────────────────────────────────────────┘
```

---

## 2. Global MultiBlocProvider Setup

Configured in `lib/main.dart` above `MaterialApp` to guarantee global availability without state reset on tab changes or screen navigation:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
    BlocProvider<WalletBloc>(create: (_) => WalletBloc()),
    BlocProvider<TransactionBloc>(create: (_) => TransactionBloc()),
    BlocProvider<PaymentBloc>(create: (_) => PaymentBloc()),
    BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
    BlocProvider<NotificationBloc>(create: (_) => NotificationBloc()),
  ],
  child: MaterialApp(
    title: 'PayNow',
    home: const LoginScreen(),
  ),
)
```

---

## 3. BLoC Domains & State Machines

### 3.1. Auth BLoC
- **Path**: `lib/bloc/auth/`
- **Purpose**: Manages mobile phone number verification, OTP dispatch, validation simulation, error messages, and authenticated routing.

| Events | States |
|---|---|
| `SendOtpEvent(phoneNumber)` | `AuthInitial()` |
| `VerifyOtpEvent(otpCode)` | `AuthLoading({isVerifyingOtp})` |
| `BackToPhoneStageEvent()` | `AuthOtpSent(phoneNumber)` |
| `ResetAuthEvent()` | `AuthSuccess(token, userId)` |
| `LogoutEvent()` | `AuthError(message, isOtpStage)` |

---

### 3.2. Wallet BLoC
- **Path**: `lib/bloc/wallet/`
- **Purpose**: Controls wallet balance, freeze card toggle, daily spending limit slider, linked bank accounts list, and multi-step SMS bank linking progress.

| Events | States |
|---|---|
| `LoadWalletEvent()` | `WalletInitial()` |
| `ToggleFreezeCardEvent(isFrozen)` | `WalletLoading()` |
| `UpdateDailyLimitEvent(newLimit)` | `WalletLoaded(...)` |
| `AddMoneyEvent(amount, sourceName)` | `WalletError(message)` |
| `WithdrawMoneyEvent(amount, destinationBank)` | |
| `DeductWalletBalanceEvent(amount)` | |
| `CreditWalletBalanceEvent(amount)` | |
| `StartLinkBankEvent(bank)` | |
| `AddLinkedBankDirectEvent(...)` | |
| `ResetLinkBankEvent()` | |

---

### 3.3. Transaction BLoC
- **Path**: `lib/bloc/transaction/`
- **Purpose**: Powers real-time search filtering by recipient/UTR, category chip filtering (`All`, `Sent`, `Received`, `Failed`), date grouping (`Today`, `Yesterday`, `Last Week`, `Older`), and Bank/UPI recipient management.

| Events | States |
|---|---|
| `LoadTransactionsEvent()` | `TransactionInitial()` |
| `AddTransactionEvent(...)` | `TransactionLoading()` |
| `FilterTransactionsEvent(filter)` | `TransactionLoaded(...)` |
| `SearchTransactionsEvent(query)` | `TransactionError(message)` |
| `AddBankRecipientEvent(name, detail, bank)` | |
| `AddUpiRecipientEvent(name, detail)` | |

---

### 3.4. Payment BLoC
- **Path**: `lib/bloc/payment/`
- **Purpose**: Coordinates transaction submission for contact transfers, self transfers, QR scanning, bill payments, and reward scratch card claims.

| Events | States |
|---|---|
| `ProcessTransferPaymentEvent(...)` | `PaymentInitial()` |
| `ProcessBillPaymentEvent(...)` | `PaymentProcessing()` |
| `ClaimScratchCardEvent(...)` | `PaymentSuccess(...)` |
| `ResetPaymentStateEvent()` | `PaymentError(message)` |

---

### 3.5. Profile BLoC
- **Path**: `lib/bloc/profile/`
- **Purpose**: Stores profile details (Name, Phone, UPI ID) and user preferences (Push Notifications, Biometrics, Dark Mode toggle).

| Events | States |
|---|---|
| `LoadProfileEvent()` | `ProfileInitial()` |
| `ToggleNotificationsEvent(enabled)` | `ProfileLoaded(...)` |
| `ToggleBiometricsEvent(enabled)` | |
| `ToggleDarkModeEvent(enabled)` | |

---

### 3.6. Notification BLoC
- **Path**: `lib/bloc/notification/`
- **Purpose**: Handles in-app notifications feed, category tabs (`All`, `Transactions`, `Offers`, `Alerts`), swipe-to-dismiss with SnackBar UNDO restoration, and clear-all actions.

| Events | States |
|---|---|
| `LoadNotificationsEvent()` | `NotificationInitial()` |
| `FilterNotificationsEvent(category)` | `NotificationLoaded(...)` |
| `DismissNotificationEvent(id)` | |
| `RestoreNotificationEvent(index, notification)`| |
| `ClearAllNotificationsEvent()` | |

---

## 4. Screen Integration & User Flows

### 1. Authentication & Onboarding Flow
1. User enters 10-digit phone number in `LoginScreen`.
2. Tapping **Get OTP** dispatches `SendOtpEvent(phone)`.
3. `AuthBloc` transitions to `AuthOtpSent`.
4. User inputs 4-digit code $\rightarrow$ dispatches `VerifyOtpEvent(otp)`.
5. `AuthBloc` validates code $\rightarrow$ emits `AuthSuccess`.
6. `BlocListener` triggers animated transition to `LinkBankScreen`.

### 2. Home Dashboard & Quick Actions Flow
1. `HomeScreen` listens to `WalletBloc` to render the interactive credit card:
   - If `isCardFrozen == true`, applies frozen slate gradient and lock badge.
   - If `isCardFrozen == false`, renders vibrant purple gradient with "PREMIUM" status.
2. Balance text dynamically reflects `WalletLoaded.balance`.
3. Displays 3 latest transactions from `TransactionBloc.allTransactions`.
4. Quick actions route seamlessly to Add Money, Transfer, Withdraw, Bills, and Card Controls.

### 3. Card Controls & Security Flow
1. `CardDetailsScreen` renders virtual card with credentials toggle.
2. Switching **Freeze Card** dispatches `ToggleFreezeCardEvent(val)`, instantly applying a glassmorphic frost blur overlay over the card.
3. Dragging the **Monthly Spending Limit** slider dispatches `UpdateDailyLimitEvent(val)`.

### 4. Add Money & Withdraw Funds Flow
1. **Add Money (`AddMoneyScreen`)**:
   - User enters amount or selects preset chips (₹1,000, ₹2,000, ₹5,000, ₹10,000).
   - Selects payment instrument (HDFC Bank / Visa Card).
   - Tapping Proceed dispatches `AddMoneyEvent` to `WalletBloc` and `AddTransactionEvent` (`Wallet Load`) to `TransactionBloc`.
2. **Withdraw Funds (`WithdrawScreen`)**:
   - Checks balance against `WalletLoaded.balance`.
   - Selecting a destination bank and clicking Continue dispatches `WithdrawMoneyEvent` and logs a `Withdrawal` transaction.

### 5. Transfers & Payment Channels Flow
1. **Transfer Home (`TransferHomeScreen`)**:
   - Channels: **To Mobile Number**, **To Bank / UPI ID**, **To Self Account**.
   - Self Transfer Modal: Deducts balance via `DeductWalletBalanceEvent` and records `Self Transfer` transaction.
2. **Contact Chat Transfer (`ContactTransferScreen`)**:
   - Real-time payment bubble interface.
   - Sending money verifies sufficient balance $\rightarrow$ dispatches `DeductWalletBalanceEvent` $\rightarrow$ dispatches `AddTransactionEvent` (`Sent`) $\rightarrow$ dispatches `ProcessTransferPaymentEvent`.
3. **Bank & UPI Directory (`BankTransferScreen`)**:
   - Dual-tab list powered by `TransactionLoaded.bankRecipients` and `TransactionLoaded.upiRecipients`.
   - Adding a new bank or UPI handle dispatches `AddBankRecipientEvent` or `AddUpiRecipientEvent`.
4. **QR Scanner (`QrScannerScreen`)**:
   - Scan viewfinder, gallery upload, or manual UPI entry modal opens direct payment flow.

### 6. Transactions History & Live Search Flow
1. `HistoryScreen` uses `BlocBuilder<TransactionBloc, TransactionState>`.
2. Typing into the search field dispatches `SearchTransactionsEvent(query)`, instantly filtering across recipient titles and UTR numbers.
3. Tapping filter chips dispatches `FilterTransactionsEvent(option)` (`All`, `Sent`, `Received`, `Failed`).
4. Automatically grouped under date headers: **Today**, **Yesterday**, **Last Week**, **Older**.
5. Tapping any transaction opens `TransactionDetailsScreen` with full receipt breakdown.

### 7. Bills & Recharges Flow
1. `BillsDashboardScreen` $\rightarrow$ category selection (Mobile, Electricity, DTH, Fastag).
2. Select plan in `RechargePlansScreen` $\rightarrow$ proceed to `RechargeSummaryScreen`.
3. On payment confirmation $\rightarrow$ dispatches `DeductWalletBalanceEvent` $\rightarrow$ dispatches `AddTransactionEvent` (`Bill Payment`) $\rightarrow$ dispatches `ProcessBillPaymentEvent` $\rightarrow$ displays `RechargeSuccessScreen`.

### 8. Rewards & Cashback Flow
1. `RewardsHomeScreen` displays unlocked scratch cards and reward coins.
2. Tapping a card opens `ScratchCardDetailScreen`.
3. Scratching gesture reveals prize $\rightarrow$ dispatches `CreditWalletBalanceEvent` $\rightarrow$ dispatches `AddTransactionEvent` (`Cashback`) $\rightarrow$ updates wallet balance immediately.

### 9. Notifications & Category Filter Flow
1. `NotificationsScreen` reads `NotificationBloc`.
2. Category selector (`All`, `Transactions`, `Offers`, `Alerts`) dispatches `FilterNotificationsEvent`.
3. Swipe-to-dismiss dispatches `DismissNotificationEvent`.
4. SnackBar with **UNDO** action dispatches `RestoreNotificationEvent`.
5. **Clear All** action dispatches `ClearAllNotificationsEvent`.

### 10. Profile Settings & App Preferences Flow
1. `ProfileSettingsScreen` reads `ProfileLoaded` state.
2. Toggling Push Notifications, Biometrics, or Dark Mode dispatches their respective events.
3. Confirming **Log Out** dispatches `LogoutEvent` to `AuthBloc` and navigates back to `LoginScreen`.

---

## 5. BLoC Usage Patterns Guide

### How to Read State
```dart
// Option A: Inside build methods via BlocBuilder
BlocBuilder<WalletBloc, WalletState>(
  builder: (context, state) {
    final double balance = state is WalletLoaded ? state.balance : 0.0;
    return Text('Rs ${balance.toStringAsFixed(2)}');
  },
);

// Option B: One-off reading in event handlers / callbacks
final currentBalance = context.read<WalletBloc>().state is WalletLoaded
    ? (context.read<WalletBloc>().state as WalletLoaded).balance
    : 0.0;
```

### How to Dispatch Events
```dart
// Dispatching an event
context.read<WalletBloc>().add(AddMoneyEvent(
  amount: 2000.00,
  sourceName: 'HDFC Bank (•••• 8829)',
));
```

### How to Handle Side Effects (Navigation, SnackBars)
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  },
  child: ...,
)
```

---

## 6. Verification & Quality Checklist

- [x] **0 Errors, 0 Warnings**: Verified via `flutter analyze`.
- [x] **Pixel-Perfect UI**: All paddings, margins, colors, custom widgets, borders, and responsive sizing helpers (`Responsive.w()`, `Responsive.h()`) are 100% preserved.
- [x] **State Immutability**: All states and events extend `Equatable` with copyWith support.
- [x] **No Memory Leaks**: Controllers and focus nodes properly disposed, with mounted checks.
- [x] **Global Scope**: All 6 BLoCs registered in `MultiBlocProvider` above `MaterialApp`.
