import 'package:flutter/material.dart';

class PrankCallScreen extends StatelessWidget {
  final List<String> phoneNumbers = [
    '0812345678910',
    '0812345678910',
    '0812345678910',
    '0812345678910',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Atur warna latar belakang utama
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Pastikan container utama berwarna putih
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panggilan Prank',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total panggilan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '20',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Riwayat Penelpon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: phoneNumbers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        color: Colors
                            .white, // Pastikan item dalam ListView berwarna putih
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Nomor Penelepon: ${phoneNumbers[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(), // Menambahkan garis pemisah antara item
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
