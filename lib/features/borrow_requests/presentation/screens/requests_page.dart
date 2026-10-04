import 'package:flutter/material.dart';
import '../widgets/incoming_requests_tab.dart';
import '../widgets/outgoing_requests_tab.dart';
import '../widgets/request_history_tab.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Incoming'),
            Tab(text: 'Outgoing'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          IncomingRequestsTab(),
          OutgoingRequestsTab(),
          RequestHistoryTab(),
        ],
      ),
    ),
  );
}
