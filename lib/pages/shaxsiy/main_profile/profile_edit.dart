import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/main_profile/widgets/profile_edit_avatar.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _picker = ImagePicker();

  UserInfo? currentUser;
  File? selectedImage;
  String? _pickedNeighborhoodLabel;
  bool isLoading = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
    try {
      currentUser = await ref.read(profileServiceProvider).getUserInfo();
      _usernameController.text = currentUser!.username;
    } catch (e) {
      _showError('Failed to load profile data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) setState(() => selectedImage = File(image.path));
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _navigateToPickLocation() async {
    await context.push('/change-city');
    if (!mounted) return;
    final activeNbhd = ref.read(activeNeighborhoodProvider);
    if (activeNbhd != null) {
      final n = activeNbhd.neighborhood;
      final parts = [n.city, n.region].where((s) => s.isNotEmpty).toList();
      setState(() {
        _pickedNeighborhoodLabel = parts.isNotEmpty ? parts.join(', ') : n.name;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || currentUser == null) return;
    setState(() => isSaving = true);
    try {
      await ref.read(profileServiceProvider).updateUserInfo(
            username: _usernameController.text.trim(),
            locationId: null,
            profileImage: selectedImage,
          );
      ref.read(productsServiceProvider).clearCache();
      ref.invalidate(servicesProvider);
      ref.invalidate(myProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Failed to update profile: $e');
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _resolveLocationLabel() {
    if (_pickedNeighborhoodLabel != null) return _pickedNeighborhoodLabel!;
    final activeNbhd = ref.watch(activeNeighborhoodProvider);
    if (activeNbhd != null) {
      final n = activeNbhd.neighborhood;
      final parts = [n.city, n.region].where((s) => s.isNotEmpty).toList();
      return parts.isNotEmpty ? parts.join(', ') : n.name;
    }
    if (currentUser != null) {
      final parts = [currentUser!.location.district, currentUser!.location.region]
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) return parts.join(', ');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        ),
        body: Center(
          child: Text(localizations?.errorMessage ?? 'Failed to load profile data'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _saveProfile,
            child: isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : Text(
                    localizations?.saveLabel ?? 'Save',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileEditAvatar(
                user: currentUser,
                selectedImage: selectedImage,
                onTap: _pickImage,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: localizations?.username ?? 'Username',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.username_required ??
                        'Username is required';
                  }
                  if (value.trim().length < 2) {
                    return localizations?.username_min_length ??
                        'Username must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: currentUser!.phoneNumber,
                decoration: InputDecoration(
                  labelText: localizations?.phoneNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  filled: true,
                ),
                enabled: false,
              ),
              const SizedBox(height: 20),
              _LocationCard(
                locationLabel: _resolveLocationLabel(),
                onTap: _navigateToPickLocation,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.locationLabel,
    required this.onTap,
  });

  final String locationLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: localizations?.location_settings ?? 'My Neighborhood',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.location_on),
          suffixIcon: Icon(Icons.map_outlined, color: colorScheme.primary),
        ),
        child: Text(
          locationLabel.isNotEmpty
              ? locationLabel
              : (localizations?.selectRegion ?? 'Tap to set your area'),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: locationLabel.isNotEmpty
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
