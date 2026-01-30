import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';

class TodoService {
  // [GANTI INI] URL MockAPI kamu (Resource 'todos')
  final String baseUrl = "https://696e21e0d7bacd2dd715ddc5.mockapi.io/todos";

  // 1. GET ALL (Hanya milik user yang sedang login)
  Future<List<TodoCategory>> getCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return []; // Kalau belum login, kembalikan kosong

    try {
      // Filter by userId dari URL MockAPI
      final response = await http.get(Uri.parse('$baseUrl?userId=${user.uid}'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((e) => TodoCategory.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching todos: $e");
      return [];
    }
  }

  // 2. CREATE KATEGORI BARU
  Future<bool> addCategory(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final newCategory = TodoCategory(
      id: '', // ID akan digenerate otomatis oleh MockAPI
      userId: user.uid, // [PENTING] Set pemiliknya
      title: title,
      items: [], // Awalnya kosong
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newCategory.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 3. DELETE KATEGORI
  Future<bool> deleteCategory(String categoryId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$categoryId'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 4. UPDATE ITEM (Tambah/Hapus/Checklist Item)
  // Karena MockAPI tidak support update partial di dalam array JSON,
  // Kita harus kirim ulang SELURUH objek kategori tersebut dengan items yang baru.
  Future<bool> updateCategory(TodoCategory category) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${category.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(category.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}