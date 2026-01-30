import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/schedule.dart';

class ApiService {
  // URL MockAPI (Pastikan Resource 'schedules' sudah ada kolom 'userId')
  static const String baseUrl = 'https://696e21e0d7bacd2dd715ddc5.mockapi.io/schedules';

  // 1. READ (Ambil Data - Filter by User ID)
  Future<List<Schedule>> getSchedules() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return []; 

    // Filter data hanya milik user yang sedang login
    final response = await http.get(Uri.parse('$baseUrl?userId=${user.uid}'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Schedule.fromJson(e)).toList();
    } else {
      // Jika error 404 (Data kosong/Endpoint salah), kembalikan list kosong agar aplikasi tidak crash
      if (response.statusCode == 404) return [];
      throw Exception("Gagal ambil data: ${response.statusCode}");
    }
  }

  // 2. CREATE (Tambah Data - Sertakan User ID)
  Future<void> addSchedule(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User belum login");

    data['userId'] = user.uid; // [PENTING] Tandai data ini milik user

    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // 3. UPDATE (Edit Data Full)
  Future<void> updateSchedule(String id, Map<String, dynamic> data) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // 4. DELETE (Hapus Data)
  Future<void> deleteSchedule(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }

  // 5. TOGGLE COMPLETION (Aman dengan PATCH)
  Future<void> toggleCompletion(String id, bool currentStatus) async {
    final newStatus = !currentStatus;

    // [PERBAIKAN] Gunakan PATCH, bukan PUT. 
    // PUT akan menimpa seluruh data (judul bisa hilang). PATCH hanya update yang dikirim.
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'isCompleted': newStatus,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update status checkbox');
    }
  }
}