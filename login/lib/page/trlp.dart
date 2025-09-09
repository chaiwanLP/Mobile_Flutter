import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/config/config.dart';
import 'package:login/model/response/trip_idx_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = "";
  late TripGetrespone tripIdxGetResponse;
  late Future<void> loadData;

  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loadData,
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncsnapshot.hasError) {
            return Center(
              child: Text('เกิดข้อผิดพลาด: ${asyncsnapshot.error}'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tripIdxGetResponse.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Image.network(
                  tripIdxGetResponse.coverimage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Text("โหลดรูปภาพไม่ได้"),
                ),
                const SizedBox(height: 12),
                Text('ประเทศ: ${tripIdxGetResponse.country}'),
                Text('ระยะเวลา: ${tripIdxGetResponse.duration} วัน'),
                Text('ราคา: ${tripIdxGetResponse.price} บาท'),
                const SizedBox(height: 12),
                Text('รายละเอียด: ${tripIdxGetResponse.detail}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('สั่งซื้อ'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('สั่งซื้อเรียบร้อย'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    tripIdxGetResponse = tripGetresponeFromJson(res.body);
  }
}
