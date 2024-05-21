import 'package:flutter/material.dart';

class VentanaDetalleTecnologico extends StatelessWidget {
  final String codigoQR;

  VentanaDetalleTecnologico({required this.codigoQR});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCloseButton(context),
            SizedBox(height: 20),
            Center(
              child: Text(
                'DETALLES BIEN TECNOLÓGICO',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('CÓDIGO:', codigoQR),
            _buildDetailRow('SERIE:', '4J212232'),
            _buildDetailRow('NOMBRE:', 'Computadora de Escritorio'),
            _buildDetailRow('ENCARGADO:', 'Juan Zapata'),
            _buildDetailRow('MARCA:', 'Optiplex 7070'),
            _buildDetailRow('MODELO:', 'DELL'),
            _buildDetailRow('BLOQUE:', 'Bloque 2'),
            _buildDetailRow('LOCALIZACIÓN:', 'PC 01'),
            _buildDetailRow('LABORATORIO:', 'Laboratorio CTT'),
            _buildDetailRow('IP:', '172.21.111.101'),
            _buildDetailRow('MEMORIA RAM:', '16GB'),
            _buildDetailRow('PROCESADOR:', 'Ryzen 5 5500'),
            _buildDetailRow('ALMACENAMIENTO:', 'HDD 2TB, M.2 250GB'),
            _buildDetailRow('CÓDIGO ADICIÓN:', '8856124781'),
            _buildDetailRow('DETALLE REPOTENCIACIÓN:', 'Disco sólido M.2 250GB'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para repotenciar el bien tecnológico
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF9D0000),
                ),
                child: Text('REPOTENCIAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF9D0000),
          ),
          child: Icon(Icons.close, color: Colors.white),
        ),
      ),
    );
  }
}
