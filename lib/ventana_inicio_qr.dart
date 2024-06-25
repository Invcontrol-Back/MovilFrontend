import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ventana_detalle_tecnologico.dart';
import 'ventana_error_qr.dart';

//RED 1

class VentanaInicioEscaneo extends StatefulWidget {
  @override
  _VentanaInicioEscaneoState createState() => _VentanaInicioEscaneoState();
}

class _VentanaInicioEscaneoState extends State<VentanaInicioEscaneo> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool _isLoading = false;
  bool _isFlashOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLoading = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 155,
                        width: 155,
                        child: CircularProgressIndicator(
                          strokeWidth: 11,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9D0000)),
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF9D0000),
                        ),
                        child: Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFA80000),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleFlash();
        },
        child: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFA80000),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
        });
        _navigateBasedOnScanResult(scanData.code!);
      }
    });
  }

  Future<void> _navigateBasedOnScanResult(String scannedCode) async {
    //final url = 'http://10.79.5.136:8000/api/tecnologico/obtener_tecnologico_especifico/?tecnologico=$scannedCode';
    final url = 'http://192.168.1.27:8000/api/tecnologico/obtener_tecnologico_especifico/?tecnologico=$scannedCode';
    print('Codigo: $url');
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verifica si la respuesta es una lista y toma el primer elemento si es necesario
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


  void _toggleFlash() {
    controller.toggleFlash();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }
}
