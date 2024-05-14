import 'package:flutter/material.dart';
import 'ventana_iniciar_sesion.dart';
import 'ventana_principal.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VentanaInicioEscaneo extends StatefulWidget {
  @override
  _VentanaInicioEscaneoState createState() => _VentanaInicioEscaneoState();
}

class _VentanaInicioEscaneoState extends State<VentanaInicioEscaneo> {
  int _selectedIndex = 1; // Índice del elemento seleccionado en el menú

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool qrMessageShown = false; // Variable booleana para controlar si se mostró el mensaje del QR

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Abrir la cámara automáticamente después de un pequeño retraso para permitir que la interfaz de usuario se construya
    Future.delayed(Duration.zero, () {
      if (mounted) {
        // Verificar si el widget está montado para evitar errores si se desmonta antes del retraso
        controller?.resumeCamera();
      }
    });
  }

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
                  _selectedIndex = 0; // Establecer el índice seleccionado
                });
                Navigator.pop(context); // Cerrar el drawer
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VentanaPrincipal()));
                // Navegar a la ventana principal al hacer clic en "Inicio"
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
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  controller.toggleFlash();
                },
                child: Text('Encender/Apagar Flash'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!qrMessageShown) {
        setState(() {
          qrMessageShown = true; // Marcamos que se mostró el mensaje del QR
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Código QR detectado'),
            content: Text('Se ha detectado el código QR: ${scanData.code}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    });
  }
}
