import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const profileRepositoryTemplate =
    '''import 'package:{{project_name}}/core/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

class ProfileRepository extends FirestoreRepository<ProfileModel> {
  ProfileRepository() : super(collectionName: 'profiles');

  @override
  ProfileModel assignId(ProfileModel entity, String id) {
    return entity.copyWith(id: id);
  }

  @override
  ProfileModel fromDocument(FirestoreDocument document) {
    return ProfileModel.fromMap(document.data, id: document.id);
  }

  @override
  String? getId(ProfileModel entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toMap(ProfileModel entity) {
    return entity.toMap();
  }
}''';

String generateProfileRepository(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return profileRepositoryTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
