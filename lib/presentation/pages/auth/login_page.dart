import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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
            _buildLoginForm(context),
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
              _buildLoginForm(context),
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
                    const Text('Film dünyasına hoş geldiniz', style: TextStyle(fontSize: 20, color: Colors.white70)),
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
                      _buildLoginForm(context),
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
        FadeInDown(delay: const Duration(milliseconds: 200), child: const Text('Giriş Yap', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), textAlign: TextAlign.center)),
        const SizedBox(height: 8),
        FadeInDown(delay: const Duration(milliseconds: 300), child: const Text('Film keşfetmeye devam edin', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary), textAlign: TextAlign.center)),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final obscurePassword = true.obs;

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(labelText: 'Email', hintText: 'email@example.com', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              validator: (value) => value == null || value.isEmpty ? 'Email gerekli' : !GetUtils.isEmail(value) ? 'Geçerli bir email girin' : null,
            ),
            const SizedBox(height: 20),
            Obx(() => TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(labelText: 'Şifre', hintText: '••••••••', prefixIcon: const Icon(Icons.lock_outlined), suffixIcon: IconButton(icon: Icon(obscurePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => obscurePassword.toggle()), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (value) => value == null || value.isEmpty ? 'Şifre gerekli' : value.length < 6 ? 'Şifre en az 6 karakter olmalı' : null,
                )),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => _showForgotPasswordDialog(context, emailController.text), child: const Text('Şifremi Unuttum'))),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      final success = await controller.signIn(email: emailController.text.trim(), password: passwordController.text);
                      if (success) {
                        Get.offAllNamed('/'); // Ana sayfaya git ve tüm route stack'i temizle
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: controller.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white))) : const Text('Giriş Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                )),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Hesabınız yok mu? ', style: TextStyle(color: AppTheme.textSecondary)), TextButton(onPressed: () => Get.toNamed('/auth/signup'), child: const Text('Kayıt Ol', style: TextStyle(fontWeight: FontWeight.w600)))]),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context, String prefillEmail) {
    final emailController = TextEditingController(text: prefillEmail);
    Get.dialog(AlertDialog(title: const Text('Şifre Sıfırlama'), content: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Email adresinize şifre sıfırlama linki gönderilecek.'), const SizedBox(height: 16), TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()))]), actions: [TextButton(onPressed: () => Get.back(), child: const Text('İptal')), ElevatedButton(onPressed: () async {
      if (emailController.text.isNotEmpty) {
        Get.back();
        await controller.resetPassword(email: emailController.text.trim());
      }
    }, child: const Text('Gönder'))]));
  }
}
