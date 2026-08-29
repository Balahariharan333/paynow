import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoaded extends NotificationState {
  final List<Map<String, dynamic>> notifications;
  final List<Map<String, dynamic>> filteredNotifications;
  final String selectedCategory;

  const NotificationLoaded({
    required this.notifications,
    required this.filteredNotifications,
    this.selectedCategory = 'All',
  });

  NotificationLoaded copyWith({
    List<Map<String, dynamic>>? notifications,
    List<Map<String, dynamic>>? filteredNotifications,
    String? selectedCategory,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      filteredNotifications: filteredNotifications ?? this.filteredNotifications,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [notifications, filteredNotifications, selectedCategory];
}
