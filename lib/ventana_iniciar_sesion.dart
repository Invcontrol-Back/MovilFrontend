import 'dart:convert';
import 'package:flutter/material.dart';
import 'usuario_service.dart';
import 'ventana_principal.dart'; // Importa la ventana principal aquí

class VentanaIniciarSesion extends StatefulWidget {
  const VentanaIniciarSesion({Key? key}) : super(key: key);

  @override
  _VentanaIniciarSesionState createState() => _VentanaIniciarSesionState();
}

class _VentanaIniciarSesionState extends State<VentanaIniciarSesion> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true; // Variable para controlar la visibilidad de la contraseña

  final UsuarioService _usuarioService = UsuarioService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      _showLoadingDialog();

      try {
        // Enviar la contraseña sin encriptar
        final data = await _usuarioService.login(email, password);

        print('Login successful: $data');

        Navigator.of(context).pop(); // Cerrar el cuadro de diálogo

        if (data.containsKey('usu_habilitado') && data['usu_habilitado'] == 'ACTIVO') {
          // Credenciales válidas y usuario activo
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VentanaPrincipal(
                nombre: data['usu_nombres'],
                apellido: data['usu_apellidos'],
                correo: data['usu_correo'],
              ),
            ),
          );
        } else {
          // Usuario no activo
          _showErrorDialog(email, password);
        }
      } catch (e) {
        Navigator.of(context).pop(); // Cerrar el cuadro de diálogo

        print('Login failed: $e');
        // Credenciales inválidas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Iniciando sesión...'),
          content: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showErrorDialog(String email, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de inicio de sesión'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Correo: $email'),
              Text('Contraseña: $password'),
              SizedBox(height: 20),
              Text('Correo o contraseña incorrectos'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: const Color(0xFFA80000), // Color personalizado para el AppBar
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  'INVCONTROL',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ClipPath(
        // Envuelve el Scaffold dentro de un ClipPath para darle una forma triangular en la parte inferior
        clipper: MyClipper(),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                        height: 70), // Ajusta este valor según tu preferencia
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText:
                      _isObscure, // Oculta el texto de la contraseña
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure =
                              !_isObscure; // Alterna la visibilidad de la contraseña
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA80000),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
