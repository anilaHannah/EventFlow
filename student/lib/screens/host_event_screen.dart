import 'package:flutter/material.dart';

import '../widgets/HostScreen/detail_tab.dart';
import '../widgets/HostScreen/approval_tab.dart';

class HostEventScreen extends StatefulWidget {
  const HostEventScreen({Key? key}) : super(key: key);

  @override
  State<HostEventScreen> createState() => _HostEventScreenState();
}

class _HostEventScreenState extends State<HostEventScreen> {
  String _selectedDate = '';
  String _selectedTime = '';
  int _selectedCapacity = 0;

  void _bookVenue() {
    // Book venue
  }

  void _openModalBottomSheet(String title, Widget content) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300.0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVenueTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Date',
            ),
            onChanged: (value) {
              _selectedDate = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Time',
            ),
            onChanged: (value) {
              _selectedTime = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Capacity',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _selectedCapacity = int.tryParse(value) ?? 0;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _openModalBottomSheet(
              'Select a Venue',
              ListView(
                children: [
                  ListTile(
                    title: const Text('Venue 1'),
                    subtitle: const Text('Capacity: 100'),
                    onTap: _bookVenue,
                  ),
                  ListTile(
                    title: const Text('Venue 2'),
                    subtitle: const Text('Capacity: 200'),
                    onTap: _bookVenue,
                  ),
                  ListTile(
                    title: const Text('Venue 3'),
                    subtitle: const Text('Capacity: 300'),
                    onTap: _bookVenue,
                  ),
                ],
              ),
            ),
            child: const Text('Select Venue'),
          ),
          const SizedBox(height: 16.0),
          const Center(
              child: Text('Previously Booked Venues',
                  style:
                      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16.0),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: _previousBookedVenues.length,
          //   itemBuilder: (context, index) {
          //     var bookedVenue = _previousBookedVenues[index];
          //     return Card(
          //       child: Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text('Venue Name: ${bookedVenue.name}',
          //                 style: const TextStyle(
          //                     fontSize: 18.0, fontWeight: FontWeight.bold)),
          //             const SizedBox(height: 8.0),
          //             Text('Date: ${bookedVenue.date}'),
          //             const SizedBox(height: 8.0),
          //             Text('Time: ${bookedVenue.time}'),
          //             const SizedBox(height: 8.0),
          //             Text('Capacity: ${bookedVenue.capacity}'),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Event Name',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Approval'),
              Tab(text: 'Venue'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const DetailTab(),
            const ApprovalTab(),
            _buildVenueTab(),
          ],
        ),
      ),
    );
  }
}
