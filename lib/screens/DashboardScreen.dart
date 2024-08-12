import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/api_service.dart';
import 'NewsDetailScreen.dart';
import 'dart:async';

class ChartData {
  ChartData(this.date, this.type, this.count);

  final DateTime date;
  final String type;
  final int count;
}

class AnimatedCounter extends ImplicitlyAnimatedWidget {
  final int value;
  final TextStyle style;

  AnimatedCounter({
    required this.value,
    required this.style,
    required Duration duration,
  }) : super(duration: duration);

  @override
  AnimatedWidgetBaseState<AnimatedCounter> createState() =>
      _AnimatedCounterState();
}

class _AnimatedCounterState extends AnimatedWidgetBaseState<AnimatedCounter> {
  IntTween? _valueTween;

  @override
  void forEachTween(visitor) {
    _valueTween = visitor(
      _valueTween,
      widget.value,
      (dynamic value) => IntTween(begin: value),
    ) as IntTween?;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _valueTween?.evaluate(animation).toString() ?? '0',
      style: widget.style,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> imgList = []; // Store image URLs here
  final ApiService apiService = ApiService();
  Map<String, Map<String, String>> stats = {
    'Total Tickets': {'data': 'Loading...', 'error': ''},
    'Emergency': {'data': 'Loading...', 'error': ''},
    'Non-Emergency': {'data': 'Loading...', 'error': ''},
    'Prank': {'data': 'Loading...', 'error': ''},
    'Dropped Calls': {'data': 'Loading...', 'error': ''},
  };

  List<ChartData> combinedChartData = [];
  Map<String, int> pieChartData = {
    'Emergency': 0,
    'Non-Emergency': 0,
    'Prank Call': 0,
    'Drop Call': 0
  };

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _refreshTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      final data = await apiService.fetchCallData();
      print('API Response: $data'); // Debug print

      if (data.isNotEmpty) {
        setState(() {
          combinedChartData = [];
          pieChartData = {
            'Emergency': 0,
            'Non-Emergency': 0,
            'Prank Call': 0,
            'Drop Call': 0
          };
          for (var dayData in data) {
            final date = DateTime.parse(dayData['date']);
            stats['Total Tickets'] = {
              'data': dayData['total'].toString(),
              'error': ''
            };
            for (var item in dayData['data']) {
              final count = int.parse(item['total']);
              combinedChartData.add(ChartData(date, item['tipe'], count));
              if (item['tipe'] == 'Non Emergency') {
                pieChartData['Non-Emergency'] =
                    (pieChartData['Non-Emergency'] ?? 0) + count;
              } else {
                pieChartData[item['tipe']] =
                    (pieChartData[item['tipe']] ?? 0) + count;
              }
              switch (item['tipe']) {
                case 'Emergency':
                  stats['Emergency'] = {'data': item['total'], 'error': ''};
                  break;
                case 'Non Emergency':
                  stats['Non-Emergency'] = {'data': item['total'], 'error': ''};
                  break;
                case 'Prank Call':
                  stats['Prank'] = {'data': item['total'], 'error': ''};
                  break;
                case 'Drop Call':
                  stats['Dropped Calls'] = {'data': item['total'], 'error': ''};
                  break;
              }
            }
          }
        });
      } else {
        print('No data available'); // Debug print
      }
    } catch (e) {
      print('Error: $e'); // Debug print
      setState(() {
        stats = {
          'Total Tickets': {'data': 'Error', 'error': 'Network error: $e'},
          'Emergency': {'data': 'Error', 'error': 'Network error: $e'},
          'Non-Emergency': {'data': 'Error', 'error': 'Network error: $e'},
          'Prank': {'data': 'Error', 'error': 'Network error: $e'},
          'Dropped Calls': {'data': 'Error', 'error': 'Network error: $e'},
        };
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Image.asset(
                      'assets/siaga112logo.png',
                      height: 40.0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Call Center 112',
                      style: GoogleFonts.publicSans(
                        textStyle: const TextStyle(
                          color: Color(0xFF111517),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Total Tickets Over Last 3 Days" text
                  Text(
                    'Total Tickets Over Last 3 Days',
                    style: GoogleFonts.publicSans(
                      textStyle: const TextStyle(
                        color: Color(0xFF111517),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total Tickets card
                  _buildFullWidthCard(
                      context, 'Total Tickets', stats['Total Tickets']!),
                  const SizedBox(height: 16),

                  // Add "Call Over Last 3 Days" text
                  Text(
                    'Call Over Last 3 Days',
                    style: GoogleFonts.publicSans(
                      textStyle: const TextStyle(
                        color: Color(0xFF111517),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Row for Non-Emergency and Emergency cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildCard(
                            context, 'Non-Emergency', stats['Non-Emergency']!,
                            icon: Icons.warning),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCard(
                            context, 'Emergency', stats['Emergency']!,
                            icon: Icons.local_fire_department),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row for Drop Call and Prank Call cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildCard(
                            context, 'Drop Call', stats['Dropped Calls']!,
                            icon: Icons.phone_disabled),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCard(
                            context, 'Prank Call', stats['Prank']!,
                            icon: Icons.face),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height:
                          24), // Space between Prank Call card and News container

                  // News section with red background and rounded corners
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE74C3C),
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.new_releases, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'News',
                          style: GoogleFonts.publicSans(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Slider
                  _buildImageSlider(),
                  const SizedBox(height: 24),

                  // Combined Chart
                  _buildCombinedChart('Call Statistics', combinedChartData),
                  const SizedBox(height: 24),

                  // Pie Chart
                  _buildPieChart('Call Distribution', pieChartData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchNews(), // Fetch the news data to get images
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No images available'));
        } else {
          final newsList = snapshot.data!;

          return CarouselSlider(
            options: CarouselOptions(
              height: 180.0, // Adjust height as needed
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              scrollDirection: Axis.horizontal,
            ),
            items: newsList.map((newsItem) {
              final imageUrl = newsItem['image_thumb'];
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailScreen(newsItem: newsItem),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Set the border radius here
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<List<dynamic>> _fetchNews() async {
    try {
      final response = await apiService.fetchNews();
      return response; // Return the full list of news items
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    Map<String, String> data, {
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white, // Set the card color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, // Ensure inner container color is white
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Icon(icon, color: Color(0xFFE74C3C)),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.publicSans(
                    textStyle: const TextStyle(
                      color: Color(0xFF111517),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.015,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedCounter(
              value: int.tryParse(data['data'] ?? '0') ?? 0,
              style: GoogleFonts.publicSans(
                textStyle: const TextStyle(
                  color: Color(0xFF111517),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015,
                ),
              ),
              duration: Duration(seconds: 2),
            ),
          ),
          if (title == 'Emergency' || title == 'Non-Emergency')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (title == 'Emergency') {
                    Navigator.pushNamed(context, '/emergency');
                  } else if (title == 'Non-Emergency') {
                    Navigator.pushNamed(context, '/non-emergency');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFE74C3C), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
                child: Text('View Details'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullWidthCard(
      BuildContext context, String title, Map<String, String> data) {
    return Container(
      width: double.infinity, // Full width of its parent
      child: _buildCard(context, title, data, icon: Icons.list),
    );
  }

  Widget _buildCombinedChart(String title, List<ChartData> data) {
    return ElevatedButton(
      onPressed: () {
        // Define your onPressed action here if needed
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 4,
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.publicSans(
                textStyle: const TextStyle(
                  color: Color(0xFF111517),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                title: ChartTitle(text: '$title Over Last 3 Days'),
                legend: const Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<ChartData, DateTime>>[
                  ColumnSeries<ChartData, DateTime>(
                    dataSource:
                        data.where((d) => d.type == 'Emergency').toList(),
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.count,
                    name: 'Emergency',
                    color: Colors.red,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  ColumnSeries<ChartData, DateTime>(
                    dataSource:
                        data.where((d) => d.type == 'Non Emergency').toList(),
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.count,
                    name: 'Non-Emergency',
                    color: Colors.blue,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  ColumnSeries<ChartData, DateTime>(
                    dataSource:
                        data.where((d) => d.type == 'Prank Call').toList(),
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.count,
                    name: 'Prank Call',
                    color: Colors.green,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  ColumnSeries<ChartData, DateTime>(
                    dataSource:
                        data.where((d) => d.type == 'Drop Call').toList(),
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.count,
                    name: 'Drop Call',
                    color: Colors.orange,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(String title, Map<String, int> data) {
    int totalCalls = data.values.fold(0, (sum, item) => sum + item);

    return ElevatedButton(
      onPressed: () {
        // Define your onPressed action here if needed
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 4,
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.publicSans(
                textStyle: const TextStyle(
                  color: Color(0xFF111517),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SfCircularChart(
              legend: Legend(isVisible: true),
              series: <CircularSeries>[
                PieSeries<MapEntry<String, int>, String>(
                  dataSource: data.entries.toList(),
                  xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
                  yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
                  dataLabelMapper: (MapEntry<String, int> entry, _) {
                    final percentage =
                        (entry.value / totalCalls * 100).toStringAsFixed(1);
                    return '$percentage%';
                  },
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
