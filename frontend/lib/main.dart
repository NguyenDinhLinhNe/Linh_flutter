import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // body : deBug
    return const MaterialApp(
      title : "Web full-stack easy",
      debugShowCheckedModeBanner: false,
      home : MyHomePage());
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>{
final nameController = TextEditingController();
final ageController = TextEditingController();
final addressController = TextEditingController();
final phoneController = TextEditingController();
final sexController = TextEditingController();
// final TextEdittingController second = TextEditingController();
final _header = {'Content-Type' : 'application/json'};

String responseMessage = '';

// String getBackendUrl() {
//     if (kIsWeb) {
//       return 'http://localhost:8080'; // hoặc sử dụng IP LAN nếu cần
//     } else if (Platform.isAndroid) {
//       return 'http://10.0.2.2:8080'; // cho emulator
//       // return 'http://192.168.1.x:8080'; // cho thiết bị thật khi truy cập qua LAN
//     } else {
//       return 'http://localhost:8080';
//     }
//   }

Future<void> sendName() async{
  final name = nameController.text;

  nameController.clear();

  // final backendUrl = getBackendUrl();

  final url1 = Uri.parse('http://localhost:8080/api/v1/sendName');

  try{
    final response =  await http
    .post(
      url1,
      headers : _header,
      body : json.encode({'name' : name}),
    )
    .timeout(const Duration(seconds : 10));

    if(response.body.isNotEmpty){
      final data = json.decode(response.body);

      setState(() {
        responseMessage = data['message'];
      });
    }
    else{
      setState(() {
        responseMessage = 'Không nhận được phản hồi từ server';
      });
    }
  } catch(e){
      setState(() {
        responseMessage = 'Đã xảy ra lỗi ${e.toString()}';
      });
    }
}

Future<void> sendAge() async {
  final age = ageController.text;

  ageController.clear();

  responseMessage = '';

  final url2 = Uri.parse('http://localhost:8080/api/v1/sendAge');

  try{
    final response = await http
    .post(
      url2,
      headers: _header,
      body : json.encode({'age' : age}),
    );

    if(response.body.isNotEmpty){
      final data = json.decode(response.body);

      setState(() {
        responseMessage = data['message'];
      });
    }
    else{
      setState(() {
        responseMessage = 'Khong nhan duoc phan hoi tu server';
      });
    }
  } catch(e){
    setState(() {
      responseMessage = 'Đã xảy ra lỗi tại ${e.toString()}';
    });
  }
}

Future<void> sendAddress() async {
  final address = addressController.text;

  addressController.clear();

  final url = Uri.parse('http://localhost:8080/api/v1/sendAddress');

  try{
    final response = await http
    .post(
      url,
      headers: _header,
      body : json.encode({'address' : address}),
    );

    if(response.body.isNotEmpty){
      final data = json.decode(response.body);

      setState(() {
        responseMessage = data['message'];
      });
    }
    else{
      setState(() {
        responseMessage = 'Server khong nhan duoc dia chi cua ban';
      });
    }
  } catch(e){
    setState(() {
      responseMessage = 'Da xay ra loi ${e.toString()}';
    });
  }
}

Future<void> sendPhone() async{
  final phone = phoneController.text;

  phoneController.clear();

  final url = Uri.parse('http://localhost:8080/api/v1/sendPhone');
  try{
    final response = await http
    .post(
      url,
      headers: _header,
      body : json.encode({'phone' : phone}),
    );

    if(response.body.isNotEmpty){
      final data = json.decode(response.body);

      setState(() {
        responseMessage = data['message'];
      });
    }
    else{
      setState(() {
        responseMessage = 'Server khong nhan duoc so cua ban';
      });
    }
  } catch(e){
    setState(() {
      responseMessage = 'Da xay ra loi ${e.toString()}';
    });
  }
}

Future<void> sendSex() async{
  final sex = sexController.text;

  sexController.clear();

  final url = Uri.parse('http://localhost:8080/api/v1/sendSex');

  try{
    final response = await http
    .post(
      url,
      headers: _header,
      body : json.encode({'sex' : sex}),
    );

    if(response.body.isNotEmpty){
      final data = json.decode(response.body);

      setState(() {
        responseMessage = data['message'];
      });
    }
    else{
      setState(() {
        responseMessage = 'Server khong nhan duoc gioi tinh cua ban';
      });
    }
  } catch(e){
    setState(() {
      responseMessage = 'Da xay ra loi ${e.toString()}';
    });
  }
}
List<String> responseM = [];

Future<void> sendAll() async{
  final name = nameController.text,
  age = ageController.text,
  address = addressController.text,
  phone = phoneController.text,
  sex = sexController.text;

  nameController.clear();
  ageController.clear();
  addressController.clear();
  phoneController.clear();
  sexController.clear();

  final url = Uri.parse('http://localhost:8080/api/v1/sendAll');

  try{
    final response = await http
    .post(
      url,
      headers : _header,
      body : json.encode({
        'name' : name,
        'age' : age,
        'address' : address,
        'phone' : phone,
        'sex' : sex,  
      })
    );

    if(response.body.isNotEmpty){
      final data = json.decode(response.body);

      setState(() {
        responseMessage = data['message'];
      });
    }
    else{
      setState(() {
        responseMessage = 'Không nhận được phản hồi từ server';
      });
    }
  } catch(e){
    setState(() {
      responseMessage = 'Đã xảy ra lỗi ${e.toString()}';
    });
  }
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(
        title : const Text('Ứng dụng'),
        centerTitle: true,
      ),
      body : Center(
        child : Padding(
          padding : const EdgeInsets.all(18.0),
          child : Column(
            children : [
              TextField(
                controller : nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller : ageController,
                decoration: const InputDecoration(labelText: 'Ngày sinh'),
                // check xem bạn thuộc vào năm gì , ví dụ nhâm tí , giáp thân ...
              ),
              TextField(
                controller : addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextField(
                controller : phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                // check xem sim của bạn là sim nào ( viettel or mobile or vinaphone )
              ),
              TextField(
                controller : sexController,
                decoration: const InputDecoration(labelText: 'Giới tính'),
              ),
              const SizedBox(height : 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: sendName,
                    child : const Text('Lấy tên'),
                  ),
                  const SizedBox(width : 20),
                  FilledButton(
                    onPressed: sendAge,
                    child: const Text('Lấy tuổi'),
                  ),
                  const SizedBox(width : 20),
                ],
              ),
              const SizedBox(height : 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: sendAddress,
                    child: const Text('Lấy địa chỉ'),
                  ),
                  const SizedBox(width : 20),
                  FilledButton(
                    onPressed: sendPhone,
                    child: const Text('Lấy số điện thoại'),
                  ),
                  const SizedBox(width : 20),
                  FilledButton(
                    onPressed: sendSex,
                    child: const Text('Lấy giới tính'),
                  ),
                ],
              ),
              const SizedBox(height : 20),
              FilledButton(
                onPressed: sendAll,
                child : const Text('Lấy tất cả thông tin'),
              ),
              const SizedBox(height : 20),
              Text(
                responseMessage,
                style : Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),  
        )
      )
    );
  }
}