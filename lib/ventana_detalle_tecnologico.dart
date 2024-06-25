import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ventana_repotenciar.dart';

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
    final url = 'http://192.168.1.27:8000/api/componente/';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> allComponentes = jsonDecode(response.body);

        // Filtrar componentes por com_codigo_bien igual al tec_codigo del widget
        List<dynamic> filteredComponentes = allComponentes
            .where((componente) => componente['com_codigo_bien'] == widget.data['tec_codigo'])
            .toList();

        setState(() {
          componentes = filteredComponentes;
        });

        // Imprimir com_codigo_bien que se desea con tec_codigo
        print('Componentes para tec_codigo ${widget.data['tec_codigo']}:');
        componentes.forEach((componente) {
          print(componente['com_codigo_bien']);
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
            if (componentes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Componentes:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: componentes.length,
                    itemBuilder: (context, index) {
                      return _buildComponenteItem(componentes[index]);
                    },
                  ),
                ],
              ),
            if (componentes.isEmpty)
              Center(
                child: Text(
                  'No hay componentes disponibles para este bien.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (componentes.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VentanaRepotenciar(
                          tecId: widget.data['tec_codigo'].toString(),
                          data: componentes, // Pasar la lista de componentes filtrados
                        ),
                      ),
                    ).then((value) {
                      if (value != null && value is bool && value) {
                        obtenerComponentes(); // Actualizar lista de componentes si es necesario
                      }
                    });
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

  Widget _buildComponenteItem(dynamic componente) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('ID:', componente['com_id'].toString()),
        _buildDetailRow('Serie:', componente['com_serie'] ?? 'N/A'),
        _buildDetailRow('Modelo:', componente['com_modelo'] ?? 'N/A'),
        _buildDetailRow('Característica:', componente['com_caracteristica'] ?? 'N/A'),
        _buildDetailRow('Año de ingreso:', componente['com_anio_ingreso'] ?? 'N/A'),
        _buildDetailRow('Estado:', componente['com_estado'] ?? 'N/A'),
        SizedBox(height: 10),
      ],
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
