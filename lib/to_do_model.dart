import 'package:hive/hive.dart';

part 'to_do_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String strNotes;
  @HiveField(1)
  final String strCreatedDate;
  @HiveField(2)
  final String strUpdatedDate;

  TodoModel(
      {required this.strNotes,
      required this.strCreatedDate,
      required this.strUpdatedDate});
}
