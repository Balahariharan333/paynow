import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/notification/notification_event.dart';
import 'package:paynow/bloc/notification/notification_state.dart';
import 'package:paynow/utils/app_colors.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static const List<Map<String, dynamic>> _initialNotifications = [
    {
      'id': '1',
      'title': 'Payment Received',
      'body': 'You received Rs 1,500.00 from Sarah Jenkins.',
      'time': '10m ago',
      'category': 'Transactions',
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColors.successGreen,
      'bgColor': AppColors.tintGreen,
      'actionText': 'View Chat',
      'route': 'chat',
      'contactName': 'Sarah Jenkins',
      'contactDetail': 'HDFC Bank •••• 8829',
    },
    {
      'id': '2',
      'title': 'Transfer Successful',
      'body': 'Rs 250.00 successfully sent to Mike Ross.',
      'time': '2h ago',
      'category': 'Transactions',
      'icon': Icons.check_circle_outline,
      'color': AppColors.successGreen,
      'bgColor': AppColors.tintGreen,
      'actionText': 'View Chat',
      'route': 'chat',
      'contactName': 'Mike Ross',
      'contactDetail': 'mikeross@paynow',
    },
    {
      'id': '3',
      'title': 'Super Scratch Card Unlocked!',
      'body': 'Get up to Rs 500 cashback on your next electricity bill payment.',
      'time': '4h ago',
      'category': 'Offers',
      'icon': Icons.card_giftcard,
      'color': AppColors.primaryGradientEnd,
      'bgColor': AppColors.tintPurple,
      'actionText': 'Scratch Now',
      'route': 'rewards',
    },
    {
      'id': '4',
      'title': 'Referral Reward Available',
      'body': 'Earn Rs 100 for every friend who signs up using your code.',
      'time': '1d ago',
      'category': 'Offers',
      'icon': Icons.stars_outlined,
      'color': AppColors.orangeReward,
      'bgColor': AppColors.tintPurple,
      'actionText': 'Invite Friends',
      'route': 'rewards',
    },
    {
      'id': '5',
      'title': 'Security Update',
      'body': 'A new login was detected on device V2334.',
      'time': 'Yesterday',
      'category': 'Alerts',
      'icon': Icons.security_outlined,
      'color': AppColors.errorRed,
      'bgColor': AppColors.tintRed,
      'actionText': 'Review',
      'route': 'alert',
    },
  ];

  NotificationBloc()
      : super(const NotificationLoaded(
          notifications: _initialNotifications,
          filteredNotifications: _initialNotifications,
          selectedCategory: 'All',
        )) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<FilterNotificationsEvent>(_onFilterNotifications);
    on<DismissNotificationEvent>(_onDismissNotification);
    on<RestoreNotificationEvent>(_onRestoreNotification);
    on<ClearAllNotificationsEvent>(_onClearAllNotifications);
  }

  void _onLoadNotifications(LoadNotificationsEvent event, Emitter<NotificationState> emit) {
    if (state is! NotificationLoaded) {
      emit(const NotificationLoaded(
        notifications: _initialNotifications,
        filteredNotifications: _initialNotifications,
      ));
    }
  }

  void _onFilterNotifications(FilterNotificationsEvent event, Emitter<NotificationState> emit) {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;
    final filtered = _filterList(current.notifications, event.category);
    emit(current.copyWith(
      selectedCategory: event.category,
      filteredNotifications: filtered,
    ));
  }

  void _onDismissNotification(DismissNotificationEvent event, Emitter<NotificationState> emit) {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;
    final updatedList = current.notifications.where((n) => n['id'] != event.id).toList();
    final updatedFiltered = _filterList(updatedList, current.selectedCategory);
    emit(current.copyWith(
      notifications: updatedList,
      filteredNotifications: updatedFiltered,
    ));
  }

  void _onRestoreNotification(RestoreNotificationEvent event, Emitter<NotificationState> emit) {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;
    final updatedList = List<Map<String, dynamic>>.from(current.notifications);
    final int safeIndex = event.index.clamp(0, updatedList.length);
    updatedList.insert(safeIndex, event.notification);
    final updatedFiltered = _filterList(updatedList, current.selectedCategory);
    emit(current.copyWith(
      notifications: updatedList,
      filteredNotifications: updatedFiltered,
    ));
  }

  void _onClearAllNotifications(ClearAllNotificationsEvent event, Emitter<NotificationState> emit) {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;
    emit(current.copyWith(
      notifications: const [],
      filteredNotifications: const [],
    ));
  }

  List<Map<String, dynamic>> _filterList(List<Map<String, dynamic>> list, String category) {
    if (category == 'All') return list;
    return list.where((n) => n['category'] == category).toList();
  }
}
