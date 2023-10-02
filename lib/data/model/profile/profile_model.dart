import 'package:hive/hive.dart';
part 'profile_model.g.dart';

@HiveType(typeId: 4)
class UserProfile {
  @HiveField(0)
  String name;

  @HiveField(1)
  int avatarIndex;

  UserProfile(this.name, this.avatarIndex);
}

@HiveType(typeId: 5)
class PresetAvatar {
  @HiveField(0)
  String imageUrl;

  PresetAvatar(this.imageUrl);
}
