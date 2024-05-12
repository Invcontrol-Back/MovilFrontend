import 'package:flutter/material.dart';

class VentanaPrincipal extends StatefulWidget {
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
              icon: Icon(Icons.menu, color: Colors.white), // Cambiar color del icono del menú a blanco
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
              accountName: Text('Nombre Apellido'),
              accountEmail: Text('correo@example.com'),
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
                // Aquí puedes agregar la lógica para la opción "Inicio"
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
                // Aquí puedes agregar la lógica para la opción "Escaneo QR"
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: _selectedIndex == 2 ? Color(0xFFA80000) : null),
              title: Text('Cerrar Sesión', style: TextStyle(color: _selectedIndex == 2 ? Color(0xFFA80000) : null)),
              onTap: () {
                setState(() {
                  _selectedIndex = 2; // Establecer el índice seleccionado
                });
                Navigator.pop(context); // Cerrar el drawer
                // Aquí puedes agregar la lógica para la opción "Cerrar Sesión"
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
          Image.asset('assets/images/logo.png'), // Ajusta la ruta según la ubicación de tu imagen
        ],
      ),
    );
  }
}
