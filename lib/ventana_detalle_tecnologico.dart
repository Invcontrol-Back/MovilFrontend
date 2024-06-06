import 'package:flutter/material.dart';
import 'package:flutter_application_1/ventana_repontenciar.dart';

class VentanaDetalleTecnologico extends StatelessWidget {
  final Map<String, dynamic> data;

  VentanaDetalleTecnologico({required this.data});

  @override
  Widget build(BuildContext context) {
    // Verifica si data['componentes'] es nulo antes de usarlo
    List<dynamic> componentes = data['componentes'] ?? [];

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
            _buildDetailRow('CÓDIGO:', data['tec_codigo'] ?? 'N/A'),
            _buildDetailRow('SERIE:', data['tec_serie'] ?? 'N/A'),
            _buildDetailRow('MODELO:', data['tec_modelo'] ?? 'N/A'),
            _buildDetailRow('MARCA:', data['tec_marca'] ?? 'N/A'),
            _buildDetailRow('IP:', data['tec_ip'] ?? 'N/A'),
            _buildDetailRow('AÑO DE INGRESO:', data['tec_anio_ingreso'] ?? 'N/A'),
            _buildDetailRow('ENCARGADO:', data['usu_nombres'] ?? 'N/A'),
            _buildDetailRow('CATEGORÍA:', data['cat_nombre'] ?? 'N/A'),
            _buildDetailRow('DEPARTAMENTO:', data['dep_nombre'] ?? 'N/A'),
            _buildDetailRow('LOCALIZACIÓN:', data['loc_nombre'] ?? 'N/A'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VentanaRepotenciar(
                        tecId: data['tec_id'].toString(), // Convertir a cadena si es necesario
                        data: componentes, // Usa la lista de componentes verificada
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF9D0000),
                ),
                child: Text('REPOTENCIAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir una fila de detalles
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

  // Método para construir el botón de cierre
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
