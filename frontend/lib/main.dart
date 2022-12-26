import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/apiConnector.dart';
import 'package:frontend/ext.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

TextEditingController _searchControlr = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinosaur API',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const mainPage(title: 'Dinosaur API'),
    );
  }
}

class mainPage extends StatefulWidget {
  const mainPage({super.key, required this.title});

  final String title;

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  late Future<List<dynamic>> dinosaurs;
  
  @override
  void initState() {
    super.initState();
    dinosaurs = fetchDinosaurs("https://api.gehege.ch/dinosaurs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.6),
        leading: const Icon(Icons.api_rounded, color: Color.fromRGBO(255, 255, 255, 0.9)),
        actions: [
          SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width / 4,
            child: TextField(
                controller: _searchControlr,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey)
                ),
                onSubmitted: (String text) => {

                },
            ),
          ),
          IconButton(
              padding: const EdgeInsets.only(left: 20, right: 20),
              icon: const Icon(Icons.refresh_outlined, color: Color.fromRGBO(255, 255, 255, 0.9), size: 30),
              tooltip: "refresh",
              onPressed: () => {

              },
              mouseCursor: SystemMouseCursors.click,
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 20, right: 20),
            icon: const Icon(Icons.add_box_outlined, color: Color.fromRGBO(255, 255, 255, 0.9), size: 30),
            tooltip: "Add Dinosaur",
            onPressed: () => {

            },
            mouseCursor: SystemMouseCursors.click,
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 20, right: 20),
            icon: const Icon(Icons.indeterminate_check_box_outlined, color: Color.fromRGBO(255, 255, 255, 0.9), size: 30),
            tooltip: "Remove Dinosaur",
            onPressed: () => {

            },
            mouseCursor: SystemMouseCursors.click,
          ),
        ],
        title: AdvText(
          text: widget.title,
          fontWeight: FontWeight.w900,
          fontSize: 30,
          gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.9),
                Color.fromRGBO(255, 255, 255, 0.4)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
          ),
        )
      ),
      body: Center(
        child: FutureBuilder(
          future: dinosaurs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return dinosaurList(list: snapshot.data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
