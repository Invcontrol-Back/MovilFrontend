import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//RED 3

class VentanaRepotenciar extends StatefulWidget {
  final String tecId;
  final List<dynamic> data;

  VentanaRepotenciar({required this.tecId, required this.data});

  @override
  _VentanaRepotenciarState createState() => _VentanaRepotenciarState();
}

class _VentanaRepotenciarState extends State<VentanaRepotenciar> {
  List<dynamic> componentesDisponibles = [];
  dynamic selectedItem;
  bool modalAumentarOpen = false;
  String detalleRepotencia = '';

  @override
  void initState() {
    super.initState();
    cargarComponentesDisponibles();
  }

  Future<void> cargarComponentesDisponibles() async {
    final url = 'http://192.168.100.113:8000/api/componente/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          componentesDisponibles = jsonDecode(response.body);
        });
      } else {
        print('Error al obtener componentes: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  Future<void> quitarComponente(String detalleId) async {
    final url =
        'http://192.168.100.113:8000/api/detalletecnologico/$detalleId/';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 204) {
        setState(() {
          widget.data.removeWhere((item) => item['det_tec_id'] == detalleId);
        });
        print('Componente quitado exitosamente');
      } else {
        print('Error al quitar componente: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  Future<void> repotenciar(String componenteId) async {
    final url =
        'http://192.168.100.113:8000/api/detalletecnologico/repotenciar/';
    final entidad = {
      'componente_id': componenteId,
      'det_tec_id': selectedItem['det_tec_id'].toString(),
      'det_repotencia': detalleRepotencia
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(entidad),
      );
      if (response.statusCode == 200) {
        print('Repotenciación exitosa');
        setState(() {
          // Actualizar datos del componente seleccionado si es necesario
          selectedItem['com_codigo_bien'] = entidad['componente_id'];
          selectedItem['det_cat_nombre'] = entidad['det_cat_nombre'];
        });
      } else {
        print('Error al repotenciar: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  void openAumentarModal(dynamic component) {
    setState(() {
      selectedItem = component;
      modalAumentarOpen = true;
    });
  }

  void closeAumentarModal() {
    setState(() {
      modalAumentarOpen = false;
    });
  }

  void selectItem(dynamic item) {
    setState(() {
      selectedItem = selectedItem == item ? null : item;
    });
    print('Item seleccionado: $selectedItem');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repotenciar Bien Tecnológico'),
        backgroundColor: Color(0xFFA80000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCloseButton(context),
            SizedBox(height: 20),
            Text(
              'DETALLES DEL COMPONENTE',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  var item = widget.data[index];
                  return ListTile(
                    title: Text('Serie: ${item['com_serie'] ?? 'N/A'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Código Bien: ${item['com_codigo_bien'] ?? 'N/A'}'),
                        Text(
                            'Subcategoría: ${item['det_cat_nombre'] ?? 'N/A'}'),
                        Text('Modelo: ${item['com_modelo'] ?? 'N/A'}'),
                        Text('Marca: ${item['com_marca'] ?? 'N/A'}'),
                        Text(
                            'Características: ${item['com_caracteristica'] ?? 'N/A'}'),
                        Text('Dependencia: ${item['dep_nombre'] ?? 'N/A'}'),
                        Text(
                            'Año de Ingreso: ${item['com_anio_ingreso'] ?? 'N/A'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item['com_serie'] != null)
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditDialog(context, item),
                          ),
                        if (item['com_serie'] != null)
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                quitarComponente(item['det_tec_id'].toString()),
                          ),
                      ],
                    ),
                    onTap: () => selectItem(item),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedItem != null) {
                  // Agregar validación aquí
                  repotenciar(selectedItem['com_id'].toString());
                } else {
                  print('No hay componente seleccionado.');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF9D0000),
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text('REPOTENCIAR'),
            ),
          ],
        ),
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

  Future<void> _showEditDialog(BuildContext context, dynamic item) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Componente"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: componentesDisponibles.length,
              itemBuilder: (context, index) {
                var componente = componentesDisponibles[index];
                return ListTile(
                  title: Text('Código Bien: ${componente['com_codigo_bien']}'),
                  subtitle:
                      Text('Subcategoría: ${componente['det_cat_nombre']}'),
                  onTap: () {
                    Navigator.pop(context);
                    repotenciar(componente['com_id'].toString());
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
