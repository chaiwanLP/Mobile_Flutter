import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/config/config.dart';
import 'package:login/model/response/customer_idx_get_res.dart';

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({Key? key, required this.idx});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> loadData;
  late CustomeridxGetrespone customerIdxGetResponse;
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'ยืนยันการยกเลิกสมาชิก?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('ปิด'),
                        ),
                        FilledButton(
                          onPressed: () {},
                          child: const Text('ยืนยัน'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'delete', child: Text('ลบข้อมูล')),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: Image.network(
                      customerIdxGetResponse.image,
                      width: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ชื่อ-นามสกุล'),
                        TextField(controller: nameCtl),
                        const Text('เบอร์โทรศัพท์'),
                        TextField(controller: phoneCtl),
                        const Text('อีเมล'),
                        TextField(controller: emailCtl),
                        const Text('รูปโปรไฟล์'),
                        TextField(controller: imageCtl),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: update,
                                child: const Text('บันทึก'),
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
      ),
    );
  }

  void update() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var json = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
    };
    try {
      var res = await http.put(
        Uri.parse('$url/customers/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(json),
      );
      print(res.body);
      var result = jsonDecode(res.body);
      print(result['message']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: const Text('ไม่สามารถบันทึกข้อมูลได้'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    customerIdxGetResponse = customeridxGetresponeFromJson(res.body);
    nameCtl.text = customerIdxGetResponse.fullname;
    phoneCtl.text = customerIdxGetResponse.phone;
    emailCtl.text = customerIdxGetResponse.email;
    imageCtl.text = customerIdxGetResponse.image;
  }
}
