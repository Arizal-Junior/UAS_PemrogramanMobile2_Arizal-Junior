class TodoItem {
  String id;
  String title;
  bool isCompleted;

  TodoItem({
    required this.id, 
    required this.title, 
    this.isCompleted = false
  });

  // Convert dari Map (JSON) ke Object
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] ?? DateTime.now().toString(),
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Convert dari Object ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

class TodoCategory {
  String id;
  String userId; // [PENTING] Penanda milik siapa
  String title;
  List<TodoItem> items;
  bool isExpanded; // Ini hanya untuk UI, tidak perlu disimpan di DB

  TodoCategory({
    required this.id,
    required this.userId,
    required this.title,
    required this.items,
    this.isExpanded = true,
  });

  // Convert dari API (JSON) ke Object Dart
  factory TodoCategory.fromJson(Map<String, dynamic> json) {
    // items disimpan sebagai Object/List di MockAPI, kita perlu parsing manual
    List<TodoItem> parsedItems = [];
    if (json['items'] != null) {
      // MockAPI mungkin mengembalikan items sebagai List dynamic
      try {
        List<dynamic> list = json['items'];
        parsedItems = list.map((i) => TodoItem.fromJson(i)).toList();
      } catch (e) {
        print("Error parsing items: $e");
      }
    }

    return TodoCategory(
      id: json['id'].toString(),
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      items: parsedItems,
      isExpanded: true, // Default terbuka saat diload
    );
  }

  // Convert Object Dart ke JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'items': items.map((i) => i.toJson()).toList(), // Kirim items sebagai List of Map
    };
  }
}