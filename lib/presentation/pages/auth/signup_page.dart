import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../controllers/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            _buildHeader(context),
            const SizedBox(height: 60),
            _buildSignupForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(48),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              _buildHeader(context),
              const SizedBox(height: 80),
              _buildSignupForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: Center(
              child: FadeInLeft(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.local_movies, size: 100, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    const Text('CineHub', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    const Text('Film dünyasına katılın', style: TextStyle(fontSize: 20, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(64),
              child: SingleChildScrollView(
                child: FadeInRight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, showLogo: false),
                      const SizedBox(height: 60),
                      _buildSignupForm(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, {bool showLogo = true}) {
    return Column(
      children: [
        if (showLogo) ...[
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.local_movies, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
        ],
        FadeInDown(delay: const Duration(milliseconds: 200), child: const Text('Kayıt Ol', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), textAlign: TextAlign.center)),
        const SizedBox(height: 8),
        FadeInDown(delay: const Duration(milliseconds: 300), child: const Text('Hemen hesap oluşturun', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary), textAlign: TextAlign.center)),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final usernameController = TextEditingController();
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final obscurePassword = true.obs;
    final obscureConfirmPassword = true.obs;

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Username Field
            TextFormField(
              controller: usernameController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(labelText: 'Kullanıcı Adı', hintText: 'username123', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Kullanıcı adı gerekli';
                if (value.length < 3) return 'En az 3 karakter olmalı';
                if (value.length > 20) return 'En fazla 20 karakter olmalı';
                if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) return 'Sadece küçük harf, rakam ve _ kullanılabilir';
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Full Name Field
            TextFormField(
              controller: fullNameController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(labelText: 'Ad Soyad (Opsiyonel)', hintText: 'Ahmet Yılmaz', prefixIcon: const Icon(Icons.badge_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            // Email Field
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(labelText: 'Email', hintText: 'email@example.com', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              validator: (value) => value == null || value.isEmpty ? 'Email gerekli' : !GetUtils.isEmail(value) ? 'Geçerli bir email girin' : null,
            ),
            const SizedBox(height: 16),
            // Password Field
            Obx(() => TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(labelText: 'Şifre', hintText: '••••••••', prefixIcon: const Icon(Icons.lock_outlined), suffixIcon: IconButton(icon: Icon(obscurePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => obscurePassword.toggle()), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Şifre gerekli';
                    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
                    return null;
                  },
                )),
            const SizedBox(height: 16),
            // Confirm Password Field
            Obx(() => TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword.value,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(labelText: 'Şifre Tekrar', hintText: '••••••••', prefixIcon: const Icon(Icons.lock_outlined), suffixIcon: IconButton(icon: Icon(obscureConfirmPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => obscureConfirmPassword.toggle()), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Şifre tekrarı gerekli';
                    if (value != passwordController.text) return 'Şifreler eşleşmiyor';
                    return null;
                  },
                )),
            const SizedBox(height: 24),
            // Signup Button
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final success = await controller.signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                              username: usernameController.text.trim().toLowerCase(),
                              fullName: fullNameController.text.trim().isEmpty ? null : fullNameController.text.trim(),
                            );
                            if (success) {
                              Get.offAllNamed('/auth/login');
                              Get.snackbar('Başarılı', 'Hesabınız oluşturuldu! Giriş yapabilirsiniz.', snackPosition: SnackPosition.BOTTOM);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: controller.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white))) : const Text('Kayıt Ol', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                )),
            const SizedBox(height: 24),
            // Login Link
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Zaten hesabınız var mı? ', style: TextStyle(color: AppTheme.textSecondary)), TextButton(onPressed: () => Get.back(), child: const Text('Giriş Yap', style: TextStyle(fontWeight: FontWeight.w600)))]),
          ],
        ),
      ),
    );
  }
}
