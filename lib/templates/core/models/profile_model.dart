const profileModelTemplate =
    '''import 'package:saasfork_core/saasfork_core.dart';

class ProfileModel implements AbstractModel<ProfileModel> {
  final String? id;
  final String username;
  final String userId;
  final bool isActive;
  final ProfileSettingsModel settings;

  ProfileModel({
    this.id,
    required this.username,
    required this.userId,
    required this.isActive,
    this.settings = const ProfileSettingsModel(),
  });

  @override
  factory ProfileModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return ProfileModel(
      id: id ?? data['uid'],
      username: data['username'],
      userId: data['userId'],
      isActive: data['isActive'],
      settings: data['settings'] != null
          ? ProfileSettingsModel.fromMap(data['settings'])
          : const ProfileSettingsModel(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'username': username,
      'userId': userId,
      'isActive': isActive,
      'settings': settings.toMap(),
    };
  }

  @override
  ProfileModel copyWith({
    String? id,
    String? username,
    String? userId,
    bool? isActive,
    ProfileSettingsModel? settings,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return {...toMap(), 'settings': settings.toDebugMap()};
  }
}''';

String generateProfileModel(String projectName) {
  // Dans ce cas, il n'y a pas d'import spécifique au projet à remplacer
  return profileModelTemplate;
}
