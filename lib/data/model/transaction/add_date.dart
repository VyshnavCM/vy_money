import 'package:hive/hive.dart';
part 'add_date.g.dart';

@HiveType(typeId: 1)
class AddData extends HiveObject {
  @HiveField(0)
  String type;
  @HiveField(1)
  String category;
  @HiveField(2)
  String mode;
  @HiveField(3)
  String heading;
  @HiveField(4)
  String amount;
  @HiveField(5)
  DateTime datetime;
  

  AddData(
    this.type,
    this.category,
    this.mode,
    this.heading,
    this.amount,
    this.datetime,
  );
}
