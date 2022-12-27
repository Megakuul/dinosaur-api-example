import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/apiConnector.dart';
import 'package:frontend/ext.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

final String GET_DINOSAURS = "https://${dotenv.env['API_URL']}/dinosaurs";
final String GET_DINOSAUR = "https://${dotenv.env['API_URL']}/dinosaur?name=";
final String POST_DINOSAUR = "https://${dotenv.env['API_URL']}/dinosaur";
final String DELETE_DINOSAUR = "https://${dotenv.env['API_URL']}/dinosaur?name=";

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

  TextEditingController remDinosaurContr = TextEditingController();
  TextEditingController addDinosaurNameContr = TextEditingController();
  TextEditingController addDinosaurDescContr = TextEditingController();
  TextEditingController addDinosaurCreatorContr = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    dinosaurs = fetchDinosaurs(GET_DINOSAURS);
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
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey)
                ),
                onSubmitted: (String text) => {
                  setState(() {
                    if (text == "")
                      dinosaurs = fetchDinosaurs(GET_DINOSAURS);
                    else
                      dinosaurs = fetchDinosaurs(GET_DINOSAUR + text);
                  })
                },
            ),
          ),
          IconButton(
              padding: const EdgeInsets.only(left: 20, right: 20),
              icon: const Icon(Icons.refresh_outlined, color: Color.fromRGBO(255, 255, 255, 0.9), size: 30),
              tooltip: "Refresh",
              onPressed: () => {
                setState(() {
                  dinosaurs = fetchDinosaurs(GET_DINOSAURS);
                })
              },
              mouseCursor: SystemMouseCursors.click,
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 20, right: 20),
            icon: const Icon(Icons.add_box_outlined, color: Color.fromRGBO(255, 255, 255, 0.9), size: 30),
            tooltip: "Add Dinosaur",
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Add Dinosaur"),
                  content: Container(
                    height: 150,
                    child: Column(
                      children: [
                        TextField(
                          controller: addDinosaurNameContr,
                          decoration: const InputDecoration(hintText: "Name"),
                        ),
                        TextField(
                          controller: addDinosaurDescContr,
                          decoration: const InputDecoration(hintText: "Description"),
                        ),
                        TextField(
                          controller: addDinosaurCreatorContr,
                          decoration: const InputDecoration(hintText: "Creator"),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")
                    ),
                    TextButton(
                        onPressed: () async => {
                          if (await postDinosaur(POST_DINOSAUR, {
                            "name": addDinosaurNameContr.text,
                            "description": addDinosaurDescContr.text,
                            "creator": addDinosaurCreatorContr.text
                          })){
                            setState(() => {
                              dinosaurs = fetchDinosaurs(GET_DINOSAURS)
                            }),
                            addDinosaurNameContr.text = "",
                            addDinosaurDescContr.text = "",
                            addDinosaurCreatorContr.text = "",
                            Navigator.pop(context)
                          },
                        },
                        child: const Text("OK")
                    )
                  ],
                )
            ),
            mouseCursor: SystemMouseCursors.click,
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 20, right: 20),
            icon: const Icon(Icons.indeterminate_check_box_outlined, color: Color.fromRGBO(255, 255, 255, 0.9), size: 30),
            tooltip: "Remove Dinosaur",
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Delete Dinosaur"),
                  content: TextField(
                    decoration: const InputDecoration(hintText: "Name"),
                    controller: remDinosaurContr,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")
                    ),
                    TextButton(
                        onPressed: () async => {
                          if (await deleteDinosaur(DELETE_DINOSAUR + remDinosaurContr.text)) {
                            setState(() => {
                              dinosaurs = fetchDinosaurs(GET_DINOSAURS)
                            }),
                            remDinosaurContr.text = ""
                          },
                          Navigator.pop(context)
                        },
                        child: const Text("OK")
                    )
                  ],
                )
            ),
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
