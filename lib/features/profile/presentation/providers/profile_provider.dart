import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:dairymart/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:dairymart/features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/profile/data/repositories/profile_repository.dart';

// ========== USE CASE PROVIDERS ==========
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.read(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.read(profileRepositoryProvider));
});

final uploadProfileImageUseCaseProvider = Provider<UploadProfileImageUseCase>((ref) {
  return UploadProfileImageUseCase(ref.read(profileRepositoryProvider));
});

// ========== PROFILE IMAGE PROVIDER ==========
// Stores the current profile image (local or from backend)
final selectedProfileImageProvider = StateProvider<File?>((ref) => null);

// Current profile image URL from backend
final profileImageUrlProvider = StateProvider<String?>((ref) => null);

// Current user full name from backend
final userNameProvider = StateProvider<String?>((ref) => null);

// Current user email from backend
final userEmailProvider = StateProvider<String?>((ref) => null);

// Current user phone number from backend
final userPhoneProvider = StateProvider<String?>((ref) => null);

// Current user address from backend
final userAddressProvider = StateProvider<String?>((ref) => null);

// Current user ID from backend
final userIdProvider = StateProvider<String?>((ref) => null);

// ========== PROFILE UPDATE NOTIFIER ==========
class ProfileUpdateNotifier extends StateNotifier<AsyncValue<void>> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final Ref _ref;

  ProfileUpdateNotifier({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required Ref ref,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _uploadProfileImageUseCase = uploadProfileImageUseCase,
        _ref = ref,
        super(const AsyncValue.data(null));

  /// Upload and update profile image
  Future<void> uploadProfileImage(File imageFile) async {
    state = const AsyncValue.loading();
    final result = await _uploadProfileImageUseCase(imageFile);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        Future.delayed(const Duration(seconds: 2), () => state = const AsyncValue.data(null));
      },
      (imageUrl) {
        _ref.read(profileImageUrlProvider.notifier).state = imageUrl;
        _ref.read(selectedProfileImageProvider.notifier).state = imageFile;
        state = const AsyncValue.data(null);
      },
    );
  }

  /// Update full profile
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    state = const AsyncValue.loading();
    final result = await _updateProfileUseCase(UpdateProfileParams(profileData: profileData));
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        Future.delayed(const Duration(seconds: 2), () => state = const AsyncValue.data(null));
      },
      (user) {
        state = const AsyncValue.data(null);
      },
    );
  }

  /// Fetch user profile
  Future<void> fetchProfile() async {
    final result = await _getProfileUseCase(NoParams());
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) {
        _ref.read(profileImageUrlProvider.notifier).state = user.profilePicture;
        _ref.read(userNameProvider.notifier).state = user.fullName;
        _ref.read(userEmailProvider.notifier).state = user.email;
        _ref.read(userPhoneProvider.notifier).state = user.phone;
        _ref.read(userAddressProvider.notifier).state = user.address;
        _ref.read(userIdProvider.notifier).state = user.userId;
        state = const AsyncValue.data(null);
      },
    );
  }

  /// Clear error by resetting state
  void clearError() {
    state = const AsyncValue.data(null);
  }
}

final profileUpdateProvider = StateNotifierProvider<ProfileUpdateNotifier, AsyncValue<void>>((ref) {
  return ProfileUpdateNotifier(
    getProfileUseCase: ref.read(getProfileUseCaseProvider),
    updateProfileUseCase: ref.read(updateProfileUseCaseProvider),
    uploadProfileImageUseCase: ref.read(uploadProfileImageUseCaseProvider),
    ref: ref,
  );
});

// ========== GET CURRENT PROFILE IMAGE ==========
// Returns either the selected local image or the URL from backend
// This provider watches both sources and always returns the latest image
final currentProfileImageProvider = Provider<dynamic>((ref) {
  final localImage = ref.watch(selectedProfileImageProvider);
  final imageUrl = ref.watch(profileImageUrlProvider);
  
  print('ðŸ” currentProfileImageProvider: localImage=$localImage, imageUrl=$imageUrl');
  
  // Prefer local selected image (immediate display), then URL (from backend), then null
  if (localImage != null) {
    print('ðŸ” Returning localImage');
    return localImage;
  }
  if (imageUrl != null && imageUrl.isNotEmpty) {
    print('ðŸ” Returning imageUrl');
    return imageUrl;
  }
  print('ðŸ” Returning null');
  return null;
});


