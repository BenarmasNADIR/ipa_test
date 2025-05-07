class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? token; // Added token field

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.token, // Optional token parameter
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('Parsing user from JSON: $json'); // Debug
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      token: json['token'] as String?, // Parse token if present
    );
  }

  // Added method to convert User to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'role': role,
        if (token != null) 'token': token,
      };

  // Added method to create a copy of User with optional new token
  User copyWith({String? token}) {
    return User(
      id: id,
      username: username,
      email: email,
      role: role,
      token: token ?? this.token,
    );
  }
}
