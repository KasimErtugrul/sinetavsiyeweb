import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/common_widgets.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Obx(() {
        if (controller.viewState == ProfileViewState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.viewState == ProfileViewState.error) {
          return ErrorState(
            message: controller.errorMessage,
            onRetry: controller.loadProfile,
          );
        }

        if (controller.profile == null) {
          return const Center(child: Text('Profil bulunamadı'));
        }

        return CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: ResponsiveLayout(
                mobile: _buildMobileLayout(context),
                tablet: _buildTabletLayout(context),
                desktop: _buildDesktopLayout(context),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.darkBackground.withOpacity(0.95),
      title: const Text('Profil'),
      actions: [
        if (controller.isOwnProfile)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authController = Get.find<AuthController>();
              authController.signOut();
            },
          ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildStats(context),
          const SizedBox(height: 24),
          if (controller.profile!.bio != null) _buildBio(context),
          const SizedBox(height: 24),
          if (controller.isOwnProfile) _buildEditButton(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 32),
            _buildStats(context),
            const SizedBox(height: 32),
            if (controller.profile!.bio != null) _buildBio(context),
            const SizedBox(height: 32),
            if (controller.isOwnProfile) _buildEditButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.all(48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: 32),
                  if (controller.isOwnProfile) _buildEditButton(context),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStats(context),
                  const SizedBox(height: 32),
                  if (controller.profile!.bio != null) _buildBio(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final profile = controller.profile!;
    return FadeInDown(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.darkCard,
              backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
              child: profile.avatarUrl == null ? Icon(Icons.person, size: 60, color: AppTheme.textSecondary) : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.username,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          if (profile.fullName != null) ...[
            const SizedBox(height: 4),
            Text(
              profile.fullName!,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Üyelik: ${_formatDate(profile.createdAt)}',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final profile = controller.profile!;
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.textTertiary.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Takipçi', profile.followersCount),
            _buildStatItem('Takip', profile.followingCount),
            _buildStatItem('Liste', profile.listsCount),
            _buildStatItem('Yorum', profile.commentsCount),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBio(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.textTertiary.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hakkında',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.profile!.bio!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: ElevatedButton.icon(
        onPressed: () => _showEditDialog(context),
        icon: const Icon(Icons.edit),
        label: const Text('Profili Düzenle'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final fullNameController = TextEditingController(text: controller.profile?.fullName);
    final bioController = TextEditingController(text: controller.profile?.bio);

    Get.dialog(
      AlertDialog(
        title: const Text('Profili Düzenle'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                maxLines: 4,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Hakkında',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.updateProfile(
                fullName: fullNameController.text.trim().isEmpty ? null : fullNameController.text.trim(),
                bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
              );
              if (success) Get.back();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return '${months[date.month - 1]} ${date.year}';
  }
}
