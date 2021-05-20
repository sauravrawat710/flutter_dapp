import 'package:hive/hive.dart';

part 'add_response_model.g.dart';

@HiveType(typeId: 1)
class AppResponseModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String fileType;

  @HiveField(2)
  String contentId;

  @HiveField(3)
  String size;

  AppResponseModel({
    this.name,
    this.fileType,
    this.contentId,
    this.size,
  });
}
