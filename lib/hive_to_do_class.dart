import 'package:flutter/material.dart';
import 'package:hive_demo/hive_add_notes.dart';
import 'package:hive_demo/to_do_model.dart';
import 'package:hive_demo/utils/StatusBarColorUtils.dart';
import 'package:hive_demo/utils/globleVariables/GlobalValues.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toast/toast.dart';

class HiveToDoDemo extends StatefulWidget {
  const HiveToDoDemo({Key? key}) : super(key: key);

  @override
  HiveToDoDemoScreenState createState() => HiveToDoDemoScreenState();
}

class HiveToDoDemoScreenState extends State<HiveToDoDemo> {
  final controllerArrayValue = TextEditingController();
  final controllerUpdateValue = TextEditingController();
  final controllerAddValueFromDialog = TextEditingController();
  Box<TodoModel> hiveBox = Hive.box<TodoModel>("HiveBoxAddNotes");

  @override
  void initState() {
    const StatusBarColorUtils();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
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
              builder: (context, Box<TodoModel> hiveBoxValue, _) {
                print(
                    "Hellooo: " + hiveBoxValue.keys.toList().length.toString());
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
                            onTap: () {
                              GlobalValues.isExistingTask = true;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HiveAddNotesScreen(
                                    strNotes: hiveBoxValue
                                        .get(index)!
                                        .strNotes
                                        .toString(),
                                    strCreatedDate: hiveBoxValue
                                        .get(index)!
                                        .strCreatedDate
                                        .toString(),
                                    strEditedDate: hiveBoxValue
                                        .get(index)!
                                        .strUpdatedDate
                                        .toString(),
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            title: Text(
                                (hiveBoxValue.get(index)?.strNotes) ?? '',
                                // hiveBoxValue.get(index).toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                (hiveBoxValue.get(index)?.strCreatedDate) ?? '',
                                // hiveBoxValue.get(index).toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.black)),
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
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Floating button clicked');
          GlobalValues.isExistingTask = false;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HiveAddNotesScreen(
                    strNotes: '',
                    strCreatedDate: '',
                    strEditedDate: '',
                    index: 0)),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }
}
