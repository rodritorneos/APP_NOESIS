class Usuario {
  final String email;
  final String password;

  // Constructor de la clase Usuario
  Usuario({required this.email, required this.password});

  // Metodo factory para crear una instancia de Usuario desde un mapa JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      email: json['email'],
      password: json['password'],
    );
  }
}