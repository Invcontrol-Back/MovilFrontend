import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ventana_repotenciar.dart';

//RED 1

class VentanaDetalleTecnologico extends StatefulWidget {
  final Map<String, dynamic> data;

  VentanaDetalleTecnologico({required this.data});

  @override
  _VentanaDetalleTecnologicoState createState() => _VentanaDetalleTecnologicoState();
}

class _VentanaDetalleTecnologicoState extends State<VentanaDetalleTecnologico> {
  List<dynamic> componentes = [];

  @override
  void initState() {
    super.initState();
    obtenerComponentes();
  }

  Future<void> obtenerComponentes() async {
    final url = 'http://192.168.100.113:8000/api/detalleC/?parametro=${widget.data['tec_id']}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          componentes = jsonDecode(response.body);
        });
      } else {
        print('Error al obtener componentes: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

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
            _buildDetailRow('CÓDIGO:', widget.data['tec_codigo'] ?? 'N/A'),
            _buildDetailRow('SERIE:', widget.data['tec_serie'] ?? 'N/A'),
            _buildDetailRow('MODELO:', widget.data['tec_modelo'] ?? 'N/A'),
            _buildDetailRow('MARCA:', widget.data['tec_marca'] ?? 'N/A'),
            _buildDetailRow('IP:', widget.data['tec_ip'] ?? 'N/A'),
            _buildDetailRow('AÑO DE INGRESO:', widget.data['tec_anio_ingreso'] ?? 'N/A'),
            _buildDetailRow('ENCARGADO:', widget.data['usu_nombres'] ?? 'N/A'),
            _buildDetailRow('CATEGORÍA:', widget.data['cat_nombre'] ?? 'N/A'),
            _buildDetailRow('DEPARTAMENTO:', widget.data['dep_nombre'] ?? 'N/A'),
            _buildDetailRow('LOCALIZACIÓN:', widget.data['loc_nombre'] ?? 'N/A'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (componentes.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VentanaRepotenciar(
                          tecId: widget.data['tec_id'].toString(),
                          data: componentes,
                        ),
                      ),
                    );
                  } else {
                    print('No hay componentes disponibles.');
                  }
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
