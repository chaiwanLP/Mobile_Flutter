import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login/config/config.dart';
import 'package:login/model/request/customer_login_post_req.dart';
import 'package:login/model/response/customer_login_post_res.dart';
import 'package:login/page/register.dart';
import 'package:login/page/shotrip.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneCTr = TextEditingController();
  TextEditingController _passwordCTr = TextEditingController();
  String txt = "This is my Text";
  int num = 0;
  bool _obscurePassword = true;
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  void dispose() {
    _phoneCTr.dispose();
    _passwordCTr.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "หมายเลขโทรศัพท์ :",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneCTr,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: "Enter Your Phone Number",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "รหัสผ่าน :",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordCTr,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: "Enter Your Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),

                          onPressed: register,
                          child: const Text("Register"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: _login,
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _login() async {
    String phone = _phoneCTr.text.trim();
    String password = _passwordCTr.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")));
      return;
    }

    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phone,
      password: password,
    );

    try {
      final response = await http.post(
        Uri.parse("$url/customers/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(req),
      );

      log(response.body);

      if (response.statusCode == 200) {
        final customerLoginPostResponse = customerLoginPostResponseFromJson(
          response.body,
        );

        log(customerLoginPostResponse.customer.fullname);
        log(customerLoginPostResponse.customer.email);
        log(customerLoginPostResponse.customer.idx.toString());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowTripPage(cid: customerLoginPostResponse.customer.idx,)),
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final errorMsg = errorData['error'] ?? 'เข้าสู่ระบบไม่สำเร็จ';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      log("Login error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
    }
  }
}
