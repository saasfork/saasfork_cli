import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const profileSettingsModelTemplate =
    '''import 'package:{{project_name}}/app_config.dart';
import 'package:saasfork_core/saasfork_core.dart';

class ProfileSettingsModel implements AbstractModel<ProfileSettingsModel> {
  final bool showPromoBadge;

  const ProfileSettingsModel({this.showPromoBadge = true});

  @override
  factory ProfileSettingsModel.fromMap(
    Map<String, dynamic> data, {
    String? id,
  }) {
    return ProfileSettingsModel(
      showPromoBadge:
          data['showPromoBadge'] ??
          AppConfig.get<bool>(
            'defaultUserSettings.showPromoBadge',
            defaultValue: true,
          ),
    );
  }

  @override
  ProfileSettingsModel copyWith({String? id, bool? showPromoBadge}) {
    return ProfileSettingsModel(
      showPromoBadge: showPromoBadge ?? this.showPromoBadge,
    );
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return toMap();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'showPromoBadge': showPromoBadge};
  }
}''';

String generateProfileSettingsModel(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return profileSettingsModelTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
