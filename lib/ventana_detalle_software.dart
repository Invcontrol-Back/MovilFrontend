import 'package:flutter/material.dart';

class VentanaDetalleSoftware extends StatelessWidget {
  final String codigoQR;

  VentanaDetalleSoftware({required this.codigoQR});

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
                    'DETALLES DEL SOFTWARE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailRow('CÓDIGO:', codigoQR),
                _buildDetailRow('NOMBRE:', 'Visual Studio Community'),
                _buildDetailRow('TIPO:', 'Licencia'),
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
