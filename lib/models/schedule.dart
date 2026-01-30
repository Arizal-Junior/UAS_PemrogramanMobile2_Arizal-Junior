class Schedule {
  final String id;
  final String userId; // [BARU] Penanda pemilik data
  final String title;
  final String date;
  final String time;
  final String description;
  final String category;
  final bool isCompleted;

  Schedule({
    required this.id,
    required this.userId, // Wajib diisi
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'].toString(),
      userId: json['userId'] ?? '', // Ambil dari JSON
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Umum',
      isCompleted: json['isCompleted'] == true || json['isCompleted'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId, // Sertakan saat convert ke JSON
      'title': title,
      'date': date,
      'time': time,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
    };
  }
}