import 'package:flutter/material.dart';

class DropCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF8F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1B0E0E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Dropped Calls',
                style: TextStyle(
                  color: Color(0xFF1B0E0E),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Hari ini, 9:00 - 17.00',
                style: TextStyle(
                  color: Color(0xFF1B0E0E),
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  DroppedCallCard(
                    title: 'Darurat',
                    details: '2 panggilan terputus',
                    icon: Icons.phone,
                  ),
                  DroppedCallCard(
                    title: 'Non-Darurat',
                    details: '3 panggilan terputus',
                    icon: Icons.phone,
                  ),
                ],
              ),
            ),
            DroppedCallDetail(
              title: 'Tingkat Penyelesaian',
              detail: '50%',
            ),
            DroppedCallDetail(
              title: 'Rata-rata Waktu Panggilan',
              detail: '2m 15s',
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class DroppedCallCard extends StatelessWidget {
  final String title;
  final String details;
  final IconData icon;

  DroppedCallCard({
    required this.title,
    required this.details,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFCF8F8),
        border: Border.all(color: Color(0xFFE7D0D0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF1B0E0E)),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF1B0E0E),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            details,
            style: TextStyle(
              color: Color(0xFF974E4E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class DroppedCallDetail extends StatelessWidget {
  final String title;
  final String detail;

  DroppedCallDetail({
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF1B0E0E),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              detail,
              style: TextStyle(
                color: Color(0xFF974E4E),
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
