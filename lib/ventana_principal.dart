import 'package:flutter/material.dart';
import 'package:flutter_application_1/ventana_escaneo.dart';
import 'package:flutter_application_1/ventana_inicio_qr.dart';
import 'ventana_iniciar_sesion.dart'; // Importa la ventana de inicio de sesión aquí

class VentanaPrincipal extends StatefulWidget {
  final String nombre;
  final String apellido;
  final String correo;

  VentanaPrincipal({required this.nombre, required this.apellido, required this.correo});

  @override
  _VentanaPrincipalState createState() => _VentanaPrincipalState();
}

class _VentanaPrincipalState extends State<VentanaPrincipal> {
  int _selectedIndex = 0; // Índice del elemento seleccionado en el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INVCONTROL', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA80000),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${widget.nombre} ${widget.apellido}'),
              accountEmail: Text(widget.correo),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: _selectedIndex == 0 ? Color(0xFFA80000) : null),
              title: Text('Inicio', style: TextStyle(color: _selectedIndex == 0 ? Color(0xFFA80000) : null)),
              onTap: () {
                setState(() {
                  _selectedIndex = 0; // Establecer el índice seleccionado
                });
                Navigator.pop(context); // Cerrar el drawer
                // Agrega la lógica para la opción "Inicio" aquí
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: _selectedIndex == 1 ? Color(0xFFA80000) : null),
              title: Text('Escaneo QR', style: TextStyle(color: _selectedIndex == 1 ? Color(0xFFA80000) : null)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1; // Establecer el índice seleccionado
                });
                Navigator.pop(context); // Cerrar el drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => VentanaEscaneo()));
                // Navegar a la ventana de escaneo al hacer clic en "Escaneo QR"
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: _selectedIndex == 2 ? Color(0xFFA80000) : null),
              title: Text('Cerrar Sesión', style: TextStyle(color: _selectedIndex == 2 ? Color(0xFFA80000) : null)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VentanaIniciarSesion()));
                // Reemplazar la ventana actual con la ventana de inicio de sesión al hacer clic en "Cerrar Sesión"
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SISTEMA DE CONTROL DE INVENTARIOS',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),

        ],
      ),
    );
  }
}
