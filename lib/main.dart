import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MaterialApp(home: MyWidget(prefs: prefs)));
}

class MyWidget extends StatefulWidget {
  final SharedPreferences prefs;
  MyWidget({super.key, required this.prefs});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();
  List<Map<String, dynamic>> todos = [];
  @override
  Widget build(BuildContext context) {
    final data = widget.prefs.getStringList("des");
    if (data != null) {
      todos = data
          .map((e) => {
                "des": jsonDecode(e)["des"],
                "dt": DateTime.parse(jsonDecode(e)["dt"]),
              })
          .toList();
    }
    return SafeArea(child: Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: TextField(
                      cursorColor: Color(0xff2c7Da0), 
                      controller: controller,
                      style: TextStyle(color: Colors.white,decorationColor: Colors.amberAccent),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color:  Color(0xff2c7Da0,
                            ),
                            ),
                            
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color:  Color(0xff2c7Da0,
                            ),
                            ),
                            
                          ),
                          hintText: "   List",
                          hintStyle:
                              TextStyle(color: Color(0xff00b4d8), fontSize: 18),
                              ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 60,
                    width: 60,
                    child: TextButton(
                      onPressed: () {
                        final now = DateTime.now();
                        if (controller.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("empty tab can't be added!!"),
                              duration: Duration(seconds: 5),
                              action: SnackBarAction(
                                  label: "OK", onPressed: () {})));
                          return;
                        }
                        setState(() {
                          todos.add({"des": controller.text, "dt": now});
                        });
                        widget.prefs.setStringList("des", [
                          ...todos.map((e) => jsonEncode({
                                "des": e["des"],
                                "dt": e["dt"].toString(),
                              }))
                        ]);
                        controller.clear();
                      },
                      child: const Text(
                        "+",
                        style: TextStyle(color: Color(0xff00b4d8), fontSize: 30),
                      ),
                    ))
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ...todos.map(
                    (e) => Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xff1b1b1b),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Text(
                            (todos.indexOf(e) + 1).toString(),
                            style: const TextStyle(
                                color: Color(0xff00b4d8), fontSize: 20),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e["des"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(e["dt"].toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.text = e["des"];
                              final index = todos.indexOf(e);
                              setState(() {
                                todos.removeAt(index);
                              });
                              widget.prefs.setStringList("des", [
                                ...todos.map((e) => jsonEncode({
                                      "des": e["des"],
                                      "dt": e["dt"].toString(),
                                    }))
                              ]);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xff00b4d8),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final index = todos.indexOf(e);
                              setState(() {
                                todos.removeAt(index);
                              });
                              widget.prefs.setStringList("des", [
                                ...todos.map((e) => jsonEncode({
                                      "des": e["des"],
                                      "dt": e["dt"].toString(),
                                    }))
                              ]);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xff00b4d8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
