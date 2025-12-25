import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/rasoi_text_field.dart';
import '../../../../core/widgets/rasoi_chip.dart';

/// Edit Profile View
/// Screen for editing user profile information
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _bioController;

  File? _newProfileImage;
  List<String> _selectedDietaryPrefs = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().currentUser.value;
    _nameController = TextEditingController(text: user.displayName);
    _bioController = TextEditingController(text: user.bio);
    _selectedDietaryPrefs = List.from(user.dietaryPreferences);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              _buildProfileImagePicker(),
              const SizedBox(height: 24),

              // Name
              RasoiTextField(
                label: 'Display Name',
                hint: 'Enter your name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.length > AppConstants.maxDisplayNameLength) {
                    return 'Name is too long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bio
              RasoiTextField(
                label: 'Bio',
                hint: 'Tell us about yourself...',
                controller: _bioController,
                maxLines: 3,
                maxLength: AppConstants.maxBioLength,
              ),
              const SizedBox(height: 24),

              // Dietary Preferences
              const Text(
                'Dietary Preferences',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Select your dietary preferences to personalize your feed',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.dietaryTypes.map((type) {
                  final isSelected = _selectedDietaryPrefs.contains(type);
                  return RasoiChip(
                    label: type,
                    isSelected: isSelected,
                    showCheckIcon: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDietaryPrefs.remove(type);
                        } else {
                          _selectedDietaryPrefs.add(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Delete Account
              Center(
                child: TextButton(
                  onPressed: _showDeleteAccountDialog,
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Delete Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    final user = Get.find<AuthController>().currentUser.value;

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.surface,
            backgroundImage: _newProfileImage != null
                ? FileImage(_newProfileImage!)
                : (user.photoUrl.isNotEmpty ? CachedNetworkImageProvider(user.photoUrl) : null)
                      as ImageProvider?,
            child: _newProfileImage == null && user.photoUrl.isEmpty
                ? const Icon(Icons.person, size: 60)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImagePickerOptions,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Get.back();
                final picked = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 512,
                  maxHeight: 512,
                );
                if (picked != null) {
                  setState(() => _newProfileImage = File(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Get.back();
                final picked = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 512,
                  maxHeight: 512,
                );
                if (picked != null) {
                  setState(() => _newProfileImage = File(picked.path));
                }
              },
            ),
            if (_newProfileImage != null ||
                Get.find<AuthController>().currentUser.value.photoUrl.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text('Remove Photo', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Get.back();
                  setState(() => _newProfileImage = null);
                  // Also remove from server
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final authController = Get.find<AuthController>();

      await authController.updateUserProfile(
        displayName: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        dietaryPreferences: _selectedDietaryPrefs,
      );

      Get.back();
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This will permanently delete your account and all your recipes. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              // Show second confirmation
              Get.dialog(
                AlertDialog(
                  title: const Text('Are you absolutely sure?'),
                  content: const Text('Type "DELETE" to confirm account deletion.'),
                  actions: [
                    TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await Get.find<AuthController>().deleteAccount();
                      },
                      style: TextButton.styleFrom(foregroundColor: AppColors.error),
                      child: const Text('Delete Forever'),
                    ),
                  ],
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
