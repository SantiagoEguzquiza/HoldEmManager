class Usuario {
  int? id;
  String email;
  String password;

  Usuario({
    this.id,
    required this.email,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}
