class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
