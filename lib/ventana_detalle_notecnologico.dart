import 'package:flutter/material.dart';

class VentanaDetalleNoTecnologico extends StatelessWidget {
  final String codigoQR;

  VentanaDetalleNoTecnologico({required this.codigoQR});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),  // Espacio para el botón de cerrar
                Center(
                  child: Text(
                    'DETALLES BIEN NO TECNOLÓGICO',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailRow('CÓDIGO:', codigoQR),
                _buildDetailRow('NOMBRE:', 'Mesa de Computadora'),
                _buildDetailRow('SERIE:', '4J212232'),
                _buildDetailRow('ENCARGADO:', 'Kevin Saquinga'),
                _buildDetailRow('MODELO:', 'Optiplex'),
                _buildDetailRow('MARCA:', 'DELL'),
                _buildDetailRow('COLOR:', 'Negro'),
                _buildDetailRow('MATERIAL:', 'Madera'),
                _buildDetailRow('DIMENSIONES:', 'Largo: 0.25, Ancho: 0.5, Alto: 1.5'),
                _buildDetailRow('CONDICIÓN:', 'Bueno'),
                _buildDetailRow('TIPO:', 'Muebles de oficina'),
                _buildDetailRow('FECHA DE INGRESO:', '17/03/2021'),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para repotenciar el bien no tecnológico
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
          _buildCloseButton(context),
        ],
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
