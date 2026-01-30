import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // --- 1. LOGIN (Email & Password) ---
  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Email tidak terdaftar.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password salah.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Format email salah.');
      } else {
        throw Exception(e.message ?? 'Terjadi kesalahan login.');
      }
    } catch (e) {
      throw Exception('Gagal Login: $e');
    }
  }

  // --- 2. REGISTER (Dengan Nama) ---
  Future<User?> register(String email, String password, String name) async {
    try {
      // Buat Akun
      final result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Simpan Nama Pengguna (Display Name)
      if (result.user != null) {
        await result.user!.updateDisplayName(name);
        await result.user!.reload(); // Refresh data user agar nama langsung muncul
      }

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Email ini sudah terdaftar.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Format email salah.');
      } else {
        throw Exception(e.message ?? 'Gagal mendaftar.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // --- 3. LOGIN DENGAN GOOGLE (FITUR UTAMA) ---
  Future<User?> loginWithGoogle() async {
    try {
      // A. Memicu jendela login Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Jika user menekan tombol 'Back' / Batal login
      if (googleUser == null) return null; 

      // B. Ambil token otentikasi dari Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // C. Buat kredensial baru untuk Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // D. Masuk ke Firebase pakai kredensial itu
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential.user;
    } catch (e) {
      // Print error di debug console agar mudah dicek jika ada masalah SHA-1
      print("Error Google Sign In: $e"); 
      throw Exception('Gagal Login Google. Cek koneksi atau konfigurasi SHA-1.');
    }
  }

  // --- 4. UPDATE NAMA ---
  Future<void> updateUserName(String newName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload(); 
      }
    } catch (e) {
      throw Exception('Gagal update nama: $e');
    }
  }

  // --- 5. LOGOUT ---
  Future<void> logout() async {
    await _googleSignIn.signOut(); // Wajib logout dari Google agar bisa ganti akun
    await _auth.signOut();         // Logout dari Firebase
  }
  
  // Helper: Cek User Login
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}