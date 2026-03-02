import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';
import 'package:dairymart/core/services/image/profile_image_service.dart';
import 'package:dairymart/core/services/storage/user_session_service.dart';
import 'package:dairymart/features/profile/presentation/providers/profile_provider.dart';
import 'package:dairymart/core/api/api_endpoints.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  
  final ProfileImageService _imageService = ProfileImageService();
  bool _isUploadingImage = false;
  bool _showTokenWarning = false;
  bool _hasInitializedControllers = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    
    Future.microtask(() => 
      ref.read(profileUpdateProvider.notifier).fetchProfile()
    );
    
    _checkTokenStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _checkTokenStatus() async {
    final userSessionService = UserSessionService();
    final token = await userSessionService.getToken();
    if (token == null) {
      setState(() {
        _showTokenWarning = true;
      });
    } else {
      setState(() {
        _showTokenWarning = false;
      });
    }
  }

  Future<void> _showImagePickerDialog() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary.withOpacity(0.15), colorScheme.primary.withOpacity(0.05)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt_rounded, size: 32, color: colorScheme.primary),
                ),
                const SizedBox(height: 20),
                Text(
                  "Select Profile Picture",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose an option",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 28),
                
                _buildDialogButton(
                  icon: Icons.camera_alt_rounded,
                  label: "Camera",
                  color: colorScheme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                const SizedBox(height: 12),
                
                _buildDialogButton(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  color: colorScheme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isUploadingImage = true);
      final imageFile = await _imageService.pickImageFromCamera();
      if (imageFile != null) {
        await _uploadProfileImage(imageFile);
      }
    } catch (e) {
      if (mounted) SnackBarHelper.showError(context, "Failed to capture image");
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isUploadingImage = true);
      final imageFile = await _imageService.pickImageFromGallery();
      if (imageFile != null) {
        await _uploadProfileImage(imageFile);
      }
    } catch (e) {
      if (mounted) SnackBarHelper.showError(context, "Failed to select image");
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      await ref.read(profileUpdateProvider.notifier).uploadProfileImage(imageFile);
      if (mounted) SnackBarHelper.showSuccess(context, "Profile picture updated!");
    } catch (e) {
      if (mounted) SnackBarHelper.showError(context, "Upload failed");
    }
  }

  ImageProvider<Object>? _getBackgroundImage(dynamic image) {
    if (image is File) {
      return FileImage(image);
    } else if (image is String && image.isNotEmpty) {
      return NetworkImage(image.startsWith('http') 
        ? image 
        : 'http://${ApiEndpoints.ipAddress}:5000$image');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    ref.listen(userNameProvider, (previous, next) {
      if (next != null && !_hasInitializedControllers) {
        _nameController.text = next;
      }
    });

    ref.listen(userPhoneProvider, (previous, next) {
      if (next != null && !_hasInitializedControllers) {
        _phoneController.text = next;
      }
    });

    final currentName = ref.read(userNameProvider);
    final currentPhone = ref.read(userPhoneProvider);
    final currentEmail = ref.watch(userEmailProvider) ?? "Loading...";

    if (!_hasInitializedControllers && currentName != null && currentPhone != null) {
      _nameController.text = currentName;
      _phoneController.text = currentPhone;
      _hasInitializedControllers = true;
    }
    
    final currentImage = ref.watch(currentProfileImageProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_showTokenWarning)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please login first to upload profile pictures',
                        style: GoogleFonts.poppins(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.white10,
                    backgroundImage: _getBackgroundImage(currentImage),
                    child: currentImage == null
                      ? Icon(Icons.person, size: 50, color: theme.hintColor)
                      : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isUploadingImage ? null : _showImagePickerDialog,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.scaffoldBackgroundColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _isUploadingImage
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
 
            _buildTextField(context, "Full Name", _nameController, Icons.person_outline),
            const SizedBox(height: 20),
            _buildReadOnlyField(context, "Email Address", currentEmail, Icons.email_outlined),
            const SizedBox(height: 20),
            _buildTextField(context, "Phone Number", _phoneController, Icons.phone_outlined),
            
            const SizedBox(height: 50),

            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isUploadingImage ? null : () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Done",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: theme.hintColor)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: theme.hintColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            filled: true,
            fillColor: theme.brightness == Brightness.light ? Colors.grey[50] : theme.colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: theme.hintColor)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.black26,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.hintColor),
              const SizedBox(width: 12),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: theme.hintColor,
                ),
              ),
              const Spacer(),
              Icon(Icons.lock_outline, size: 18, color: theme.hintColor),
            ],
          ),
        ),
      ],
    );
  }
}

