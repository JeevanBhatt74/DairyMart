import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileImageService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request storage permission (for gallery)
  Future<bool> requestStoragePermission() async {
    // For Android 13+, use READ_MEDIA_IMAGES
    // For older Android, use READ_EXTERNAL_STORAGE
    const permission = Permission.photos; // This handles both cases
    final status = await permission.request();
    
    if (status.isDenied) {
      // Permission denied
      return false;
    } else if (status.isGranted) {
      // Permission granted
      return true;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open settings
      openAppSettings();
      return false;
    }
    return false;
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied. Please grant permission in Settings.');
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }
}
