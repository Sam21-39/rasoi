import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Edit Profile View
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: const Center(child: Text('Edit profile form coming soon...')),
    );
  }
}
