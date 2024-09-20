import 'dart:convert';

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
    return const MaterialApp(home : MyHomePage());
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>{
final controller = TextEditingController();

String responseMessage = '';

Future<void> sendName() async{
  final name = controller.text;

  controller.clear();

  final url = Uri.parse('http://localhost:8080:api/v1/submit');

  try{
    final response =  await http.post(
      url,
      headers : {'Content-Type' : 'application/json'},
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

  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(title : Text('Ứng dụng')),
      body : Padding(
        padding : const EdgeInsets.all(18.0),
        child : Column(
          children : [
            TextField(
              controller : controller,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            const SizedBox(height : 20),
            FilledButton(
              onPressed: sendName,
              child : const Text('Gửi'),
            ),
            Text(
              responseMessage,
              style : Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),  
      )
    );
  }
}