import 'dart:convert';
import 'dart:math';
import 'dart:developer' hide log;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/model/request/register_rq.dart';
import 'package:login/model/response/res_.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var  _userCTr = TextEditingController();
  var  _passCTr = TextEditingController();
  var  _passwordConfiremCTr = TextEditingController();
  var  _emailCtr = TextEditingController();
  var  _phoneCTr_ = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register New"),
      
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  "ชื่อ-นามสกุล ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _userCTr,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText:("ชื่อ-นามสกุล"),
                    labelText: 'ชื่อ-นามสกุล',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "หมายเลขโทรศัพท์ ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneCTr_,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText:("หมายเลขโทรศัพท์"),
                    labelText: 'หมายเลขโทรศัพท์',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "อีเมล์ ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailCtr,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText:("อีเมล์"),
                    labelText: 'อีเมล์',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                
                const SizedBox(height: 12),
                Text(
                  "รหัสผ่าน ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passCTr,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText:("รหัสผ่าน"),
                    labelText: 'รหัสผ่าน',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                
                const SizedBox(height: 12),
                Text(
                  "ยืนยันรหัสผ่าน ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordConfiremCTr,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText:("ยืนยันรหัสผ่าน"),
                    labelText: 'ยืนยันรหัสผ่าน',
                    prefixIcon: Icon(Icons.lock),
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
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: Registeration,
                           child: const Text("Register"),
                          
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(onPressed: ReadyAcc,
                       child: const Text("Login"),),
                    ],
                  ),
                )
              ],
            ),
          ),
          
        ),
      ),
      
    );
    
  }

  void Registeration(){
    String user = _userCTr.text.trim().toString();
    String phone = _phoneCTr_.text.trim().toString();
    String email = _emailCtr.text.trim().toString();
    String pass = _passCTr.text.trim().toString();
    String passConfirem = _passwordConfiremCTr.text.trim().toString();
    if(pass == passConfirem){
      RegisterRq rq = RegisterRq(fullname: user, phone: phone, email: email, image:"", password: pass);
      http.post(Uri.parse("/customers/register"),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode(rq))
      .then((value) {
        
        RegisterRes res = resFromJson(value.body);
        
        
        Navigator.pop(context);
      });
    }

  }
  
  void ReadyAcc(){
    Navigator.pop(context);
  }

  void ShowMessage(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg),)
      );
  }

}