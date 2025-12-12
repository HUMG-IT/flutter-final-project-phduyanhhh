class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
  };
}
