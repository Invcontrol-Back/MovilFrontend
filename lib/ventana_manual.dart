import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ventana_detalle_tecnologico.dart';
import 'ventana_error_qr.dart';
import 'ventana_escaneo.dart'; // Importa la ventana anterior para regresar

class VentanaManual extends StatefulWidget {
  @override
  _VentanaManualState createState() => _VentanaManualState();
}

class _VentanaManualState extends State<VentanaManual> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingreso Manual'),
        backgroundColor: Color(0xFFA80000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Por favor, ingrese el respectivo código para los bienes tecnológicos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Código',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA80000),
                minimumSize: Size(double.infinity, 40),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Ingresar', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text('Regresar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCode() async {
    final code = _controller.text.trim();
    if (code.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = 'http://192.168.100.113:8000/api/tecnologico/obtener_tecnologico_especifico/?tecnologico=$code';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VentanaDetalleTecnologico(data: (data[0] as Map).cast<String, dynamic>()),
            ),
          );
        } else if (data is Map) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VentanaDetalleTecnologico(data: (data as Map).cast<String, dynamic>()),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VentanaErrorQR()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VentanaErrorQR()),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VentanaErrorQR()),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
