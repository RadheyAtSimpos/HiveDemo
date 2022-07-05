import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_demo/helper/SharedPreferencesHelper.dart';
import 'package:hive_demo/to_do_model.dart';
import 'package:hive_demo/utils/StatusBarColorUtils.dart';
import 'package:hive_demo/utils/globleVariables/GlobalValues.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

final SharedPreferencesHelper sharedPreferencesUtils =
    SharedPreferencesHelper();

class HiveAddNotesScreen extends StatefulWidget {
  String strNotes;
  String strCreatedDate;
  String strEditedDate;
  int index;

  HiveAddNotesScreen(
      {required this.strNotes,
      required this.strCreatedDate,
      required this.strEditedDate,
      required this.index});

  @override
  HiveAddNotesScreenState createState() => HiveAddNotesScreenState();
}

class HiveAddNotesScreenState extends State<HiveAddNotesScreen> {
  final FocusNode focusNodeArrayValue = FocusNode();
  final controllerAddNotes = TextEditingController();
  Box<TodoModel> hiveBox = Hive.box<TodoModel>("HiveBoxAddNotes");

  String? strAddedNotes;
  String? strAddedCreatedDate;
  String? strAddedEditedDate;
  int? index;
  bool? boolIsDataChanged = false;

  @override
  void initState() {
    const StatusBarColorUtils();
    strAddedNotes = widget.strNotes;
    strAddedCreatedDate = widget.strCreatedDate;
    strAddedEditedDate = widget.strEditedDate;
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            backgroundColor: Colors.pink,
            title: const Text(
              "Add Notes",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          body: Column(children: [
            Flexible(
              flex: 25,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: double.infinity,
                color: Colors.white,
                child: TextField(
                  cursorColor: Colors.black,
                  // focusNode: focusNodeArrayValue,
                  controller: controllerAddNotes..text = strAddedNotes!,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Please add notes",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    boolIsDataChanged = true;
                    print('Is changed: ' + text);
                  },
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  color: Colors.black12,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Text("Created At: ${strAddedCreatedDate ?? ""}"),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Text("Edited At:  ${strAddedEditedDate ?? ""}"),
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ),
        onWillPop: () =>
            _onWillPop(strAddedCreatedDate!, index!, boolIsDataChanged!));
  }

  Future<bool> _onWillPop(
      String strAddedCreatedDate, int index, bool boolIsDataChanged) async {
    print("After clicking the Android Back Button");
    if (controllerAddNotes.text.toString().isNotEmpty &&
        GlobalValues.isExistingTask) {
      if (boolIsDataChanged) {
        onEditDataToHiveClicked(strAddedCreatedDate, index);
      } else {
        print('You change nothing');
        Navigator.of(context).pop(true);
      }
    } else if (controllerAddNotes.text.toString().isNotEmpty &&
        !GlobalValues.isExistingTask) {
      onAddDataToHiveClicked();
    } else {
      print('Please enter value');
      Navigator.of(context).pop(true);
    }

    return false;
  }

  void onAddDataToHiveClicked() {
    setState(() async {
      DateTime now = DateTime.now();
      String strCurrentDate = DateFormat('dd-MM-yyyy HH:mm').format(now);
      await sharedPreferencesUtils.setString(prefCreatedDate, strCurrentDate);

      String strCreatedDateTime =
          await sharedPreferencesUtils.getString(prefCreatedDate, "");

      TodoModel todoModel = TodoModel(
          strNotes: controllerAddNotes.text.toString(),
          strCreatedDate: strCreatedDateTime,
          strUpdatedDate: '');

      hiveBox.add(todoModel);

      Navigator.of(context).pop(true);
    });
  }

  void onEditDataToHiveClicked(String strAddedCreatedDate, int index) {
    setState(() async {
      DateTime now = DateTime.now();
      String strCurrentDate = DateFormat('dd-MM-yyyy HH:mm').format(now);

      TodoModel todoModel = TodoModel(
          strNotes: controllerAddNotes.text.toString(),
          strCreatedDate: strAddedCreatedDate,
          strUpdatedDate: strCurrentDate);

      hiveBox.putAt(index, todoModel);

      Navigator.of(context).pop(true);
    });
  }
}
