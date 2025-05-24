import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample notification data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Order #12345 Confirmed',
        'message': 'Your order has been confirmed and is being processed.',
        'time': '2 hours ago',
        'isRead': false,
        'icon': Icons.shopping_bag,
        'color': Colors.green,
      },
      {
        'title': 'Special Discount!',
        'message': 'Get 20% off on all products this weekend!',
        'time': '1 day ago',
        'isRead': true,
        'icon': Icons.local_offer,
        'color': Colors.orange,
      },
      {
        'title': 'New Product Available',
        'message': 'Check out our new collection of summer clothes!',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.new_releases,
        'color': Colors.blue,
      },
      {
        'title': 'Payment Successful',
        'message': 'Your payment for order #12340 has been received.',
        'time': '3 days ago',
        'isRead': true,
        'icon': Icons.payment,
        'color': Colors.purple,
      },
      {
        'title': 'Delivery Update',
        'message': 'Your order #12339 has been delivered.',
        'time': '5 days ago',
        'isRead': true,
        'icon': Icons.local_shipping,
        'color': Colors.teal,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                ),
              );
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Remove notification
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification removed'),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notification['color'],
                        child: Icon(notification['icon'], color: Colors.white),
                      ),
                      title: Text(
                        notification['title'],
                        style: TextStyle(
                          fontWeight: notification['isRead']
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification['message']),
                          const SizedBox(height: 4),
                          Text(
                            notification['time'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: notification['isRead']
                          ? null
                          : Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                      onTap: () {
                        // View notification details
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}