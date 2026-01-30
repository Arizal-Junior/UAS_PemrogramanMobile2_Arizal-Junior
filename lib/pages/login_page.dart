import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  
  final FirebaseService auth = FirebaseService();
  bool _isLoading = false;
  bool _isObscure = true; 

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // Fungsi Login Email Biasa
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await auth.login(emailCtrl.text, passCtrl.text);
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      } catch (e) {
        if (mounted) {
          // [UPDATED] Logika pesan error yang lebih rapi & spesifik
          String message = "Gagal masuk. Silakan coba lagi.";
          String errorRaw = e.toString().toLowerCase();

          if (errorRaw.contains("user-not-found")) {
            message = "Akun tidak ditemukan. Silakan daftar dulu.";
          } else if (errorRaw.contains("wrong-password")) {
            message = "Password salah.";
          } else if (errorRaw.contains("invalid-credential")) {
            message = "Email atau password salah.";
          } else if (errorRaw.contains("user-disabled")) {
            message = "Akun ini telah dinonaktifkan.";
          } else if (errorRaw.contains("too-many-requests")) {
            message = "Terlalu banyak percobaan. Coba lagi nanti.";
          } else if (errorRaw.contains("network")) {
            message = "Koneksi bermasalah. Cek internet kamu.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // Fungsi Login Google
  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final user = await auth.loginWithGoogle();
      
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        // [UPDATED] Logika pesan error Google yang rapi
        String message = "Gagal masuk dengan Google.";
        String errorRaw = e.toString().toLowerCase();

        if (errorRaw.contains("network")) {
          message = "Koneksi bermasalah. Cek internet kamu.";
        } else if (errorRaw.contains("canceled") || errorRaw.contains("closed") || errorRaw.contains("aborted")) {
          message = "Login dibatalkan.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // [THEME] Warna & Gaya Konsisten
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFd99de9);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: bgColor,
      // [FIX] Menggunakan SafeArea agar tidak menembus status bar (Sama seperti Register)
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // [ANIMASI 1] LOGO & HEADER (Scale + Fade)
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 70, height: 70, // Ukuran disamakan dengan Register (lebih kecil dari awal)
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.calendar_today_rounded, size: 35, color: primaryColor),
                      ),
                      const SizedBox(height: 20),
                      
                      Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          fontSize: 22, // Font size disamakan
                          fontWeight: FontWeight.w900, 
                          color: isDarkMode ? Colors.white : const Color(0xFF2D3142)
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Masuk untuk mengelola jadwalmu",
                        style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey.shade600, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // [ANIMASI 2] KARTU LOGIN (Slide Up)
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)), // Naik dari bawah 50px
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30), // Padding internal disamakan
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24), 
                      boxShadow: [
                        if (!isDarkMode)
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // INPUT EMAIL
                          _buildTextField(
                            controller: emailCtrl,
                            hint: 'Email',
                            icon: Icons.email_rounded,
                            isDarkMode: isDarkMode,
                            primaryColor: primaryColor,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Email wajib diisi";
                              if (!value.contains('@')) return "Format email salah";
                              return null;
                            },
                          ),
                          const SizedBox(height: 14), // Jarak disamakan
                          
                          // INPUT PASSWORD
                          _buildTextField(
                            controller: passCtrl,
                            hint: 'Password',
                            icon: Icons.lock_rounded,
                            isDarkMode: isDarkMode,
                            primaryColor: primaryColor,
                            isObscure: _isObscure,
                            hasSuffix: true,
                            onToggle: () => setState(() => _isObscure = !_isObscure),
                            validator: (value) => value!.isEmpty ? "Password wajib diisi" : null,
                          ),
                          const SizedBox(height: 24),
                          
                          // TOMBOL MASUK (EMAIL)
                          SizedBox(
                            width: double.infinity,
                            height: 50, // Tinggi tombol disamakan
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                shadowColor: primaryColor.withOpacity(0.4),
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Masuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),

                          const SizedBox(height: 20),
                          
                          // DIVIDER "ATAU"
                          Row(
                            children: [
                              Expanded(child: Divider(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text("ATAU", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                              ),
                              Expanded(child: Divider(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // TOMBOL GOOGLE
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleGoogleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                                foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: isDarkMode ? Colors.transparent : Colors.grey.shade200),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // LOGO GOOGLE
                                  Image.asset(
                                    'assets/google_logo.png', 
                                    height: 22,
                                    errorBuilder: (context, error, stackTrace) => 
                                      const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.red),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Masuk dengan Google",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Roboto', 
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // [ANIMASI 3] LINK REGISTER (Fade In Akhir)
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) => Opacity(opacity: value, child: child),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum punya akun? ", style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey.shade600, fontSize: 13)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            color: primaryColor, 
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    required Color primaryColor,
    bool isObscure = false,
    bool hasSuffix = false,
    VoidCallback? onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w500, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.grey.shade500 : primaryColor.withOpacity(0.6), size: 20),
        suffixIcon: hasSuffix 
          ? IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: Colors.grey.shade400,
                size: 18,
              ),
              onPressed: onToggle,
            )
          : null,
        
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF5F7FA), 
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding internal dikecilkan
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: validator,
    );
  }
}