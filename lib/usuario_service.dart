import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String url = 'http://192.168.100.113:8000/api/usuario/';
  final String urlLogin = 'http://192.168.100.113:8000/api/login/';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, String> bodyData = {'usu_correo': email, 'usu_contrasenia': password};
    final String encodedBody = jsonEncode(bodyData);
    print('Request: $encodedBody'); // Imprime los datos que estás enviando

    try {
      final response = await http.post(
        Uri.parse(urlLogin),
        headers: {'Content-Type': 'application/json'},
        body: encodedBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to login due to an error');
    }
  }

  Future<List<dynamic>> loadUsuarios() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load users due to an error');
    }
  }

// Otros métodos para loadUsuariosCedula, addUsuario, etc., siguiendo el mismo patrón
}
