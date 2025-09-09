import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/config/config.dart';
import 'package:login/model/response/trip_get_res.dart';
import 'package:login/page/profile.dart';
import 'package:login/page/trlp.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetrespone> allTrips = [];
  List<TripGetrespone> filteredTrips = [];
  String selectedZone = 'ทั้งหมด';
  late Future<void> loadData = getTrips();
  final List<String> zones = [
    'ทั้งหมด',
    'เอเชีย',
    'ยุโรป',
    'อาเซียน',
    'ไทย',
    'ลาว',
    'กัมพูชา',
    'เวียดนาม',
    'อินโดนีเซีย',
  ];

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  Future<void> getTrips() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    try {
      final res = await http.get(Uri.parse('$url/trips'));
      if (res.statusCode == 200) {
        final trips = tripGetresponeFromJson(res.body);
        setState(() {
          allTrips = trips;
          filteredTrips = trips;
        });
      }
    } catch (e) {
      debugPrint('โหลดทริปล้มเหลว: $e');
    }
  }

  void filterTrips(String zone) {
    setState(() {
      selectedZone = zone;
      if (zone == 'ทั้งหมด') {
        filteredTrips = allTrips;
      } else {
        filteredTrips = allTrips
            .where(
              (trip) =>
                  trip.destinationZone.toLowerCase().contains(
                    zone.toLowerCase(),
                  ) ||
                  trip.country.toLowerCase().contains(zone.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "ปลายทาง",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: zones.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final zone = zones[index];
                    final isSelected = selectedZone == zone;
                    return ChoiceChip(
                      label: Text(zone),
                      selected: isSelected,
                      selectedColor: Colors.purple,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) => filterTrips(zone),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredTrips.isEmpty
                    ? const Center(child: Text("ไม่พบข้อมูลทริป"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredTrips.length,
                        itemBuilder: (context, index) {
                          final trip = filteredTrips[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      trip.coverimage,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text("Cannot load image"),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("ประเทศ${trip.country}"),
                                  Text("ระยะเวลา ${trip.duration} วัน"),
                                  Text("ราคา ${trip.price} บาท"),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FilledButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TripPage(idx: trip.idx),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text("รายละเอียดเพิ่มเติม"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
