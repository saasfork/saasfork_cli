import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const profileServiceTemplate =
    '''import 'package:{{project_name}}/core/exceptions/profile_service_exception.dart';
import 'package:{{project_name}}/core/models/profile_model.dart';
import 'package:{{project_name}}/core/repositories/profile_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileService {
  final ProfileRepository _profileRepository;

  ProfileService({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  /// Récupère tous les profils associés à un utilisateur spécifique
  Future<List<ProfileModel>> fetchProfiles(String userId) async {
    try {
      final result = await _profileRepository.findWhere(
        field: 'userId',
        isEqualTo: userId,
      );
      return result;
    } catch (e) {
      throw ProfileServiceException(
        'find_profiles_failed',
        'Failed to fetch profiles: \$e',
      );
    }
  }

  /// Récupère un profil par son identifiant unique
  Future<ProfileModel?> fetchProfileById(String id) async {
    try {
      return await _profileRepository.findById(id);
    } catch (e) {
      throw ProfileServiceException(
        'find_profile_by_id_failed',
        'Failed to fetch profile by ID: \$e',
      );
    }
  }

  Future<ProfileModel?> fetchActiveProfileByUserId(String userId) async {
    try {
      final result = await _profileRepository.query(
        equals: <String, dynamic>{'userId': userId, 'isActive': true},
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      throw ProfileServiceException(
        'fetch_active_profile_failed',
        'Failed to fetch active profile by user ID: \$e',
      );
    }
  }

  /// Vérifie si un nom d'utilisateur existe déjà dans la base de données
  Future<bool> usernameExists(String username) async {
    try {
      final profile = await fetchProfileByUsername(username);
      return profile != null;
    } catch (e) {
      throw ProfileServiceException(
        'username_check_failed',
        'Failed to check username existence: \$e',
      );
    }
  }

  /// Crée un nouveau profil à partir d'un nom d'utilisateur et d'un ID utilisateur
  Future<ProfileModel> createProfileFromUsername(
    String username,
    String userId,
  ) async {
    try {
      return await _profileRepository.save(
        ProfileModel(
          id: username,
          username: username,
          userId: userId,
          isActive: true,
        ),
      );
    } catch (e) {
      throw ProfileServiceException(
        'create_profile_failed',
        'Failed to create profile: \$e',
      );
    }
  }

  /// Récupère un profil par son nom d'utilisateur
  Future<ProfileModel?> fetchProfileByUsername(String username) async {
    try {
      final result = await _profileRepository.findById(username);
      return result;
    } catch (e) {
      throw ProfileServiceException(
        'find_profile_by_username_failed',
        'Failed to fetch profile by username: \$e',
      );
    }
  }

  /// Met à jour un profil existant
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      return await _profileRepository.save(profile);
    } catch (e) {
      throw ProfileServiceException(
        'update_profile_failed',
        'Failed to update profile: \$e',
      );
    }
  }
}

final profileServiceProvider = Provider<ProfileService>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileService(profileRepository: repository);
});

@visibleForTesting
final mockableProfileServiceProvider =
    Provider.family<ProfileService, ProfileService?>((ref, mockService) {
  return mockService ?? ref.watch(profileServiceProvider);
});''';

String generateProfileService(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Correction du nom du fichier repository (profile_resporitory -> profile_repository)
  return profileServiceTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
