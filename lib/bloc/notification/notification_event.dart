import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

class FilterNotificationsEvent extends NotificationEvent {
  final String category;

  const FilterNotificationsEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class DismissNotificationEvent extends NotificationEvent {
  final String id;

  const DismissNotificationEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RestoreNotificationEvent extends NotificationEvent {
  final int index;
  final Map<String, dynamic> notification;

  const RestoreNotificationEvent({
    required this.index,
    required this.notification,
  });

  @override
  List<Object?> get props => [index, notification];
}

class ClearAllNotificationsEvent extends NotificationEvent {
  const ClearAllNotificationsEvent();
}
