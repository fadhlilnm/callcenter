import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import your ApiService class
import 'TicketDetailScreen.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _tickets = [];
  List<dynamic> _filteredTickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
    _searchController.addListener(() {
      _filterTickets();
    });
  }

  Future<void> _fetchTickets() async {
    try {
      final tickets = await _apiService.fetchTicketData();
      setState(() {
        _tickets = tickets
            .where((ticket) => ticket['jenis_tiket'] == 'Emergency')
            .toList();
        _filteredTickets = _tickets;
      });
    } catch (e) {
      // Handle error
      print('Error fetching tickets: $e');
    }
  }

  void _filterTickets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTickets = _tickets
          .where(
              (ticket) => ticket['ticket_code']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF111517)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Emergency Tickets',
          style: TextStyle(
            color: Color(0xFF111517),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'Last 3 days',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF111517),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ticket code',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTickets.length,
              itemBuilder: (context, index) {
                final ticket = _filteredTickets[index];
                return TicketItem(
                  title: ticket['kategori_tiket']!,
                  date: ticket['tanggal']!,
                  count: ticket['ticket_code']!,
                  address: ticket['alamat'] ?? 'No address available',
                  description:
                      ticket['deskripsi'] ?? 'No description available',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetailScreen(
                          title: ticket['kategori_tiket']!,
                          date: ticket['tanggal']!,
                          count: ticket['ticket_code']!,
                          address: ticket['alamat'] ?? 'No address available',
                          description:
                              ticket['deskripsi'] ?? 'No description available',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final String title;
  final String date;
  final String count;
  final String description;
  final String address;
  final VoidCallback onTap;

  const TicketItem({
    required this.title,
    required this.date,
    required this.count,
    required this.description,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_activity,
                color: Color(0xFF111517),
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111517),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF647787),
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF647787),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF647787),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
