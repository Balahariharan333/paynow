// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/notification/notification_bloc.dart';
import 'package:paynow/bloc/notification/notification_event.dart';
import 'package:paynow/bloc/notification/notification_state.dart';
import 'package:paynow/screen/payment/rewards/rewards_home_screen.dart';
import 'package:paynow/screen/payment/transfer/contact_transfer_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _handleAction(BuildContext context, Map<String, dynamic> notification) {
    final route = notification['route'] as String?;
    if (route == 'chat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactTransferScreen(
            contactName: notification['contactName'] ?? 'Contact',
            contactDetail: notification['contactDetail'] ?? '',
          ),
        ),
      );
    } else if (route == 'rewards') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RewardsHomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action detail: ${notification['title']} details'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _deleteNotification(BuildContext context, int index, Map<String, dynamic> item) {
    context.read<NotificationBloc>().add(DismissNotificationEvent(item['id'] as String));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification dismissed'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            context.read<NotificationBloc>().add(RestoreNotificationEvent(
                  index: index,
                  notification: item,
                ));
          },
        ),
      ),
    );
  }

  void _clearAll(BuildContext context) {
    context.read<NotificationBloc>().add(const ClearAllNotificationsEvent());
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final loadedState = state is NotificationLoaded
                ? state
                : const NotificationLoaded(notifications: [], filteredNotifications: []);
            final filteredList = loadedState.filteredNotifications;
            final String selectedTab = loadedState.selectedCategory;
            final bool hasNotifications = loadedState.notifications.isNotEmpty;

            return Column(
              children: [
                _buildAppBar(context, hasNotifications),
                _buildTabSelector(context, selectedTab),
                Expanded(
                  child: filteredList.isEmpty
                      ? _buildEmptyState()
                      : _buildNotificationList(context, loadedState.notifications, filteredList),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool hasNotifications) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Responsive.w(8.0)),
                  child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: Responsive.w(8)),
              CustomText.header('Notifications', fontSize: 20),
            ],
          ),
          if (hasNotifications)
            TextButton(
              onPressed: () => _clearAll(context),
              child: CustomText.body(
                'Clear All',
                color: AppColors.primaryGradientStart,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context, String selectedTab) {
    final tabs = const ['All', 'Transactions', 'Offers', 'Alerts'];
    return Container(
      height: Responsive.h(48),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(16)),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = selectedTab == tab;
          return GestureDetector(
            onTap: () {
              context.read<NotificationBloc>().add(FilterNotificationsEvent(tab));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(8)),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomText.body(
                  tab,
                  color: isSelected ? AppColors.white : AppColors.grayFont,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<Map<String, dynamic>> allNotifications,
    List<Map<String, dynamic>> filteredList,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(8)),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        final originalIndex = allNotifications.indexWhere((n) => n['id'] == item['id']);

        return Dismissible(
          key: Key(item['id'] as String),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: EdgeInsets.symmetric(vertical: Responsive.h(8)),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: AppColors.errorRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          onDismissed: (direction) {
            _deleteNotification(context, originalIndex, item);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: Responsive.h(8)),
            padding: EdgeInsets.all(Responsive.w(16)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Responsive.w(48),
                  height: Responsive.h(48),
                  decoration: BoxDecoration(
                    color: item['bgColor'] as Color? ?? AppColors.lightGray,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 22,
                  ),
                ),
                SizedBox(width: Responsive.w(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomText.title(
                              item['title'] as String,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          CustomText.subtitle(
                            item['time'] as String,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(6)),
                      CustomText.body(
                        item['body'] as String,
                        color: AppColors.grayFont,
                        fontSize: 12.5,
                      ),
                      SizedBox(height: Responsive.h(12)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _handleAction(context, item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomText.body(
                                item['actionText'] as String,
                                color: AppColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(24)),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_outlined,
              size: 48,
              color: AppColors.grayFont,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          CustomText.header(
            'All Clear!',
            fontSize: 18,
          ),
          SizedBox(height: Responsive.h(8)),
          CustomText.subtitle(
            'No notifications in this category.',
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
