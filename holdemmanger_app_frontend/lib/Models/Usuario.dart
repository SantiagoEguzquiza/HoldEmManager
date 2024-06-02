class Usuario {
  int id;
  String nombreUsuario;
  String password;

  Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.password,
  });

  // Método para crear una instancia de Usuario a partir de un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombreUsuario: json['nombreUsuario'],
      password: json['password'],
    );
  }

  // Método para convertir una instancia de Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreUsuario': nombreUsuario,
      'password': password,
    };
  }
}