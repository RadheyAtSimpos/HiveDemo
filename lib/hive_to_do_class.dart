import 'package:flutter/material.dart';
import 'package:hive_demo/utils/StatusBarColorUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toast/toast.dart';

class HiveToDoDemo extends StatefulWidget {
  const HiveToDoDemo({Key? key}) : super(key: key);

  @override
  HiveToDoDemoScreenState createState() => HiveToDoDemoScreenState();
}

class HiveToDoDemoScreenState extends State<HiveToDoDemo> {
  var strArrInput = <String>[];
  final FocusNode focusNodeArrayValue = FocusNode();
  final FocusNode focusNodeUpdateValue = FocusNode();
  final controllerArrayValue = TextEditingController();
  final controllerUpdateValue = TextEditingController();
  final controllerAddValueFromDialog = TextEditingController();
  Box hiveBox = Hive.box("HiveTextBox");
  int intIncrementCount = 0;

  @override
  void initState() {
    const StatusBarColorUtils();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: Colors.pink,
          title: const Text(
            "Hive ToDo List",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        body: Column(children: [
          Flexible(
            flex: 10,
            child: ColoredBox(
              color: Colors.white,
              child: ValueListenableBuilder(
                valueListenable: hiveBox.listenable(),
                builder: (context, Box hiveBoxValue, _) {
                  print("Hellooo: " +
                      hiveBoxValue.keys.toList().length.toString());
                  return ListView.builder(
                    itemCount: hiveBoxValue.keys.toList().length,
                    itemBuilder: (context, index) {
                      print('Values: ' + hiveBoxValue.get(index).toString());
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(7, 3, 7, 2),
                        child: Card(
                          color: const Color(0xFFFCE4EC),
                          shadowColor: Colors.blueGrey,
                          child: ListTile(
                              onTap: () {},
                              title: Text(
                                  hiveBoxValue
                                      .get(index)
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                                  // hiveBoxValue.get(index).toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.black)),
                              trailing: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.black),
                                        onPressed: () async {
                                          hiveBox.delete(index);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.black),
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Are you sure you want to edit " +
                                                        hiveBoxValue
                                                            .get(index)
                                                            .toString()
                                                            .replaceAll("[", "")
                                                            .replaceAll(
                                                                "]", "") +
                                                        "?",
                                                    style: const TextStyle(
                                                        fontSize: 16.0)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('CANCEL',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (controllerUpdateValue
                                                          .text.isNotEmpty) {
                                                        onUpdateItemClicked(
                                                            index,
                                                            controllerUpdateValue
                                                                .text
                                                                .toString());
                                                        Navigator.pop(context);
                                                      } else {
                                                        showToast(
                                                            "Please enter value",
                                                            duration: Toast
                                                                .lengthShort,
                                                            gravity:
                                                                Toast.bottom);
                                                      }
                                                    },
                                                    child: const Text('YES',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ],
                                                content: TextField(
                                                  cursorColor: Colors.black,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  // focusNode: focusNodeUpdateValue,
                                                  controller:
                                                      controllerUpdateValue
                                                        ..text = hiveBoxValue
                                                            .get(index)
                                                            .toString()
                                                            .replaceAll("[", "")
                                                            .replaceAll(
                                                                "]", ""),
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Please enter new value",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ))),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: ColoredBox(
                color: Colors.black12,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            cursorColor: Colors.black,
                            // focusNode: focusNodeArrayValue,
                            controller: controllerArrayValue,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Please enter value",
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0, 10.0, 10.0, 10.0),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.pink),
                            onPressed: () async {
                              if (controllerArrayValue.text.isNotEmpty) {
                                onAddItemClicked();
                              } else {
                                showToast("Please enter value",
                                    duration: Toast.lengthShort,
                                    gravity: Toast.bottom);
                              }
                            },
                          ),
                        ))
                  ],
                ),
              )),
        ]),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            dialogAddValue();
          },
          backgroundColor: Colors.pink,
          child: const Icon(Icons.add),
        ),
        bottomSheet: const Padding(padding: EdgeInsets.only(bottom: 100.0)),*/
      ),
    );
  }

  void onAddItemClicked() {
    setState(() {
      print(
          'controllerArrayValue.text.toString(): ${controllerArrayValue.text.toString()}');
      hiveBox.add(controllerArrayValue.text.toString());
    });
    controllerArrayValue.clear();
  }

  void onUpdateItemClicked(int index, String strNewValue) {
    setState(() {
      hiveBox.putAt(index, strNewValue);
    });
    controllerUpdateValue.clear();
  }

  /*void onRemoveItemClicked(String index) {
    setState(() {
      hiveBox.deleteAll(index);
    });
  }*/

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }
}
