import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'ventana_detalle_tecnologico.dart';
import 'ventana_detalle_notecnologico.dart';
import 'ventana_detalle_software.dart';
import 'ventana_error_qr.dart';

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
    await Future.delayed(Duration(seconds: 6));
    if (!_isLoading) return; // Salir si el proceso de carga ya se ha detenido
    if (scannedCode.startsWith('DT-')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VentanaDetalleTecnologico(codigoQR: scannedCode)),
      );
    } else if (scannedCode.startsWith('DNT-')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VentanaDetalleNoTecnologico(codigoQR: scannedCode)),
      );
    } else if (scannedCode.startsWith('DS-')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VentanaDetalleSoftware(codigoQR: scannedCode)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VentanaErrorQR()),
      );
    }
  }

  void _toggleFlash() {
    controller.toggleFlash();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }
}
