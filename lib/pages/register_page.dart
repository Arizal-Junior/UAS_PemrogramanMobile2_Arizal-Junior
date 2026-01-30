import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'home_page.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  
  final FirebaseService auth = FirebaseService();
  bool _isLoading = false;

  // Variabel Mata (Lihat Password)
  bool _isPasswordHidden = true;
  bool _isConfirmHidden = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  // --- FUNGSI REGISTER EMAIL BIASA ---
  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await auth.register(emailCtrl.text, passCtrl.text, nameCtrl.text);
        
        // Logout Paksa agar user login manual (Optional)
        await FirebaseAuth.instance.signOut(); 
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun berhasil dibuat! Silakan Login.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context); // Kembali ke Login
        }
      } catch (e) {
        if (mounted) {
          // [UPDATED] Logika pesan error yang lebih rapi
          String message = "Gagal mendaftar. Silakan coba lagi.";
          String errorRaw = e.toString().toLowerCase();

          if (errorRaw.contains("email-already-in-use")) {
            message = "Email sudah terdaftar. Gunakan email lain.";
          } else if (errorRaw.contains("weak-password")) {
            message = "Password terlalu lemah.";
          } else if (errorRaw.contains("network")) {
            message = "Koneksi bermasalah. Cek internet kamu.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message), // Teks pendek & jelas
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

  // --- FUNGSI DAFTAR DENGAN GOOGLE ---
  void _handleGoogleRegister() async {
    setState(() => _isLoading = true);
    try {
      final user = await auth.loginWithGoogle();
      
      if (user != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false, 
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
            content: Text(message), // Tidak lagi menampilkan pesan error panjang
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
      // [FIX] Menggunakan SafeArea agar tidak menembus status bar
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // [ANIMASI 1] HEADER (Scale + Fade)
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
                        width: 70, height: 70, // Sedikit diperkecil agar proporsional
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_add_alt_1_rounded, size: 35, color: primaryColor),
                      ),
                      const SizedBox(height: 20),
                      
                      Text(
                        "Bergabung Sekarang",
                        style: TextStyle(
                          fontSize: 22, // Ukuran font disesuaikan
                          fontWeight: FontWeight.w900, 
                          color: isDarkMode ? Colors.white : const Color(0xFF2D3142)
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Buat akun untuk mulai mengatur jadwalmu",
                        style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey.shade600, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // [ANIMASI 2] KARTU FORM (Slide Up)
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30), // Padding internal disesuaikan
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
                          // INPUT NAMA
                          _buildTextField(
                            controller: nameCtrl,
                            hint: 'Nama Lengkap',
                            icon: Icons.badge_rounded,
                            isDarkMode: isDarkMode,
                            primaryColor: primaryColor,
                            validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
                            capitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 14), // Jarak antar field sedikit dirapatkan

                          // INPUT EMAIL
                          _buildTextField(
                            controller: emailCtrl,
                            hint: 'Email',
                            icon: Icons.email_rounded,
                            isDarkMode: isDarkMode,
                            primaryColor: primaryColor,
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Email wajib diisi";
                              if (!val.contains('@')) return "Format email salah";
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          
                          // INPUT PASSWORD
                          _buildTextField(
                            controller: passCtrl,
                            hint: 'Password',
                            icon: Icons.lock_rounded,
                            isDarkMode: isDarkMode,
                            primaryColor: primaryColor,
                            isObscure: _isPasswordHidden,
                            hasSuffix: true,
                            onToggle: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                            validator: (val) => val!.length < 6 ? "Minimal 6 karakter" : null,
                          ),
                          const SizedBox(height: 14),

                          // INPUT KONFIRMASI PASSWORD
                          _buildTextField(
                            controller: confirmPassCtrl,
                            hint: 'Konfirmasi Password',
                            icon: Icons.lock_outline_rounded,
                            isDarkMode: isDarkMode,
                            primaryColor: primaryColor,
                            isObscure: _isConfirmHidden,
                            hasSuffix: true,
                            onToggle: () => setState(() => _isConfirmHidden = !_isConfirmHidden),
                            validator: (val) {
                              if (val != passCtrl.text) return "Password tidak sama!";
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // TOMBOL DAFTAR
                          SizedBox(
                            width: double.infinity,
                            height: 50, // Tinggi tombol disesuaikan
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                shadowColor: primaryColor.withOpacity(0.4),
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Daftar Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                              onPressed: _isLoading ? null : _handleGoogleRegister,
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
                                  Image.asset(
                                    'assets/google_logo.png', 
                                    height: 22,
                                    errorBuilder: (context, error, stackTrace) => 
                                      const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.red),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Daftar dengan Google",
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
                
                // [ANIMASI 3] LINK KE LOGIN (Fade In)
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) => Opacity(opacity: value, child: child),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun? ", style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey.shade600, fontSize: 13)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Masuk disini",
                          style: TextStyle(
                            color: primaryColor, 
                            fontWeight: FontWeight.bold,
                            fontSize: 13
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
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      textCapitalization: capitalization,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding internal field dikecilkan
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: validator,
    );
  }
}