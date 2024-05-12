import 'package:flutter/material.dart';
import 'package:flutter_application_1/ventana_iniciar_sesion.dart';
import 'ventana_principal.dart'; // Importa la ventana principal aquí

class VentanaEscaneo extends StatefulWidget {
  @override
  _VentanaEscaneoState createState() => _VentanaEscaneoState();
}

class _VentanaEscaneoState extends State<VentanaEscaneo> {
  int _selectedIndex = 1; // Índice del elemento seleccionado en el menú

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
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
                // Agrega la lógica para la opción "Inicio" aquí
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: _selectedIndex == 1 ? Color(0xFFA80000) : null),
              title: Text('Escaneo QR', style: TextStyle(color: _selectedIndex == 1 ? Color(0xFFA80000) : null)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
                // Agrega la lógica para la opción "Escaneo QR" aquí
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey), // Icono para iniciar el escaneo
            SizedBox(height: 20),
            Text(
              'Por favor, inicie el escaneo QR para los diferentes bienes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/scan_image.jpg'), // Agrega la ruta de tu imagen de escaneo
              radius: 60,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agrega la lógica para iniciar el escaneo aquí
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA80000), // Color del botón igual al de los otros botones
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text('Iniciar Escaneo', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
