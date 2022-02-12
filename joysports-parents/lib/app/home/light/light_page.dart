import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joysports/constants/strings.dart';

class Post {
  final dynamic userId;
  final dynamic id;
  final dynamic title;
  final dynamic body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class lightPage extends StatefulWidget {
  @override
  _lightPageState createState() => _lightPageState();
}

class _lightPageState extends State<lightPage> {
  Future<Post>? post;

  Future<String> getHtml() async {
    var headers = {
      'Authorization': 'Bearer 3d446c0b-9ef9-43f0-a017-c264e8dfefdf'
    };
    var request =
        http.Request('GET', Uri.parse('https://goqual.io/openapi/devices'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return await response.stream.bytesToString();
  }

  @override
  void initState() {
    super.initState();
    getHtml();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        elevation: 2.0,
        title: Text(Strings.light),
        actions: [
          TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[300]),
                  shape: MaterialStateProperty.resolveWith((states) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
              onPressed: () {

              },
              child: Text(
                Strings.light,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ))
        ],
      ),
    );
  }
}
