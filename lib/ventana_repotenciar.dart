import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VentanaRepotenciar extends StatefulWidget {
  final String tecId;
  final List<dynamic> data;

  VentanaRepotenciar({required this.tecId, required this.data});

  @override
  _VentanaRepotenciarState createState() => _VentanaRepotenciarState();
}


class _VentanaRepotenciarState extends State<VentanaRepotenciar> {
  List<dynamic> componentesDisponibles = [];
  List<dynamic> marcas = [];
  List<dynamic> dependencias = [];
  List<dynamic> subcategorias = [];
  dynamic selectedItem;
  bool modalEditarOpen = false;
  String estado = '';
  String descripcionRepotencia = '';
  TextEditingController codigoUTAController = TextEditingController();
  TextEditingController marcaController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController numeroSerieController = TextEditingController();
  TextEditingController anioIngresoController = TextEditingController();
  TextEditingController caracteristicasController = TextEditingController();
  TextEditingController subcategoriaController = TextEditingController();
  TextEditingController dependenciaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarComponentesDisponibles();
    cargarMarcas();
    cargarDependencias();
    cargarSubcategorias();
    cargarComponentesDisponibles();
  }

  Future<void> cargarComponentesDisponibles() async {
    final url = 'http://192.168.1.27:8000/api/componente/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        print('Componentes disponibles: $decodedData');

        setState(() {
          componentesDisponibles = decodedData;
        });
      } else {
        print('Error al obtener componentes: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  Future<void> cargarMarcas() async {
    final url = 'http://192.168.1.27:8000/api/marca/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        print('Marcas disponibles: $decodedData');

        setState(() {
          marcas = decodedData;
        });
      } else {
        print('Error al obtener marcas: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  Future<void> cargarDependencias() async {
    final url = 'http://192.168.1.27:8000/api/dependencia/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        print('Dependencias disponibles: $decodedData');

        setState(() {
          dependencias = decodedData;
        });
      } else {
        print('Error al obtener dependencias: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  Future<void> cargarSubcategorias() async {
    final url = 'http://192.168.1.27:8000/api/detalleCategoria/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        print('Subcategorías disponibles: $decodedData');

        setState(() {
          subcategorias = decodedData;
        });
      } else {
        print('Error al obtener subcategorías: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  void repotenciar(dynamic item) {
    if (item != null) {
      // Si se seleccionó un item existente, se va a editar
      setState(() {
        modalEditarOpen = true;
        selectedItem = item;
        // Inicializar los controladores con los valores actuales del componente seleccionado
        codigoUTAController.text = item['com_codigo_uta'] ?? '';
        marcaController.text = item['mar_nombre'] ?? '';
        modeloController.text = item['com_modelo'] ?? '';
        numeroSerieController.text = item['com_serie'] ?? '';
        anioIngresoController.text = item['com_anio_ingreso'] ?? '';
        caracteristicasController.text = item['com_caracteristica'] ?? '';
        subcategoriaController.text = item['det_cat_nombre'] ?? '';
        dependenciaController.text = item['dep_nombre'] ?? '';
        estado = item['com_estado'] ?? '';
        descripcionRepotencia = ''; // Limpiar el campo de descripción de repotencia
      });
    } else {
      // Si no se seleccionó un item, se va a agregar uno nuevo
      setState(() {
        modalEditarOpen = true;
        selectedItem = null; // Limpiar el item seleccionado después de cerrar el modal
        // Limpiar los controladores para los nuevos datos
        codigoUTAController.clear();
        marcaController.clear();
        modeloController.clear();
        numeroSerieController.clear();
        anioIngresoController.clear();
        caracteristicasController.clear();
        subcategoriaController.clear();
        dependenciaController.clear();
        estado = '';
        descripcionRepotencia = '';
      });
    }
  }

  void closeEditarModal() {
    setState(() {
      modalEditarOpen = false;
      selectedItem = null; // Limpiar el item seleccionado después de cerrar el modal
    });
  }

  Future<void> agregarComponente() async {
    // Obtener el código del bien del widget.data
    String codigoBien = widget.tecId ?? ''; // Asegúrate de que tecId sea String

    // Construir el cuerpo de la solicitud POST para agregar un nuevo componente
    Map<String, dynamic> nuevoComponente = {
      'com_codigo_uta': codigoUTAController.text,
      'com_modelo': modeloController.text,
      'com_serie': numeroSerieController.text,
      'com_anio_ingreso': anioIngresoController.text,
      'com_caracteristica': caracteristicasController.text,
      'com_mar': marcas.firstWhere((marca) => marca['mar_nombre'] == marcaController.text)['mar_id'],
      'com_det_cat': subcategorias.firstWhere((subcategoria) => subcategoria['det_cat_nombre'] == subcategoriaController.text)['det_cat_id'],
      'com_dep': dependencias.firstWhere((dependencia) => dependencia['dep_nombre'] == dependenciaController.text)['dep_id'],
      'com_estado': estado,
      'com_eliminado': 'no', // Puede que necesites ajustar esto según tu lógica de negocio
      'com_codigo_bien': codigoBien, // Asignar el código del bien aquí
    };

    // Realizar la solicitud HTTP POST para agregar el nuevo componente
    final url = 'http://192.168.1.27:8000/api/componente/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(nuevoComponente),
      );
      if (response.statusCode == 201) {
        print('Componente agregado correctamente');
        // Actualizar la lista de componentes disponibles
        cargarComponentesDisponibles();
        // Cerrar el modal después de agregar el componente
        closeEditarModal();
      } else {
        print('Error al agregar componente: ${response.reasonPhrase}');
        // Mostrar algún mensaje de error al usuario si es necesario
      }
    } catch (error) {
      print('Error de conexión: $error');
      // Mostrar algún mensaje de error al usuario si es necesario
    }
  }




  Future<void> editarComponente() async {
    // Construir el cuerpo de la solicitud PUT para editar el componente seleccionado
    Map<String, dynamic> componenteEditado = {
      'com_codigo_uta': codigoUTAController.text,
      'com_modelo': modeloController.text,
      'com_serie': numeroSerieController.text,
      'com_anio_ingreso': anioIngresoController.text,
      'com_caracteristica': caracteristicasController.text,
      'com_mar': marcas.firstWhere((marca) => marca['mar_nombre'] == marcaController.text)['mar_id'],
      'com_det_cat': subcategorias.firstWhere((subcategoria) => subcategoria['det_cat_nombre'] == subcategoriaController.text)['det_cat_id'],
      'com_dep': dependencias.firstWhere((dependencia) => dependencia['dep_nombre'] == dependenciaController.text)['dep_id'],
      'com_estado': estado,
      'com_eliminado': 'no', // Puede que necesites ajustar esto según tu lógica de negocio
    };

    // Realizar la solicitud HTTP PUT para editar el componente
    final url = 'http://192.168.1.27:8000/api/componente/${selectedItem['com_id']}/';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(componenteEditado),
      );
      if (response.statusCode == 200) {
        print('Componente editado correctamente');
        // Actualizar la lista de componentes disponibles
        cargarComponentesDisponibles();
        // Cerrar el modal después de editar el componente
        closeEditarModal();
      } else {
        print('Error al editar componente: ${response.reasonPhrase}');
        // Mostrar algún mensaje de error al usuario si es necesario
      }
    } catch (error) {
      print('Error de conexión: $error');
      // Mostrar algún mensaje de error al usuario si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Componentes'),
            Text(
              'Código del Bien: ${selectedItem != null ? selectedItem['com_codigo_bien'] ?? 'N/A' : 'N/A'}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                var item = widget.data[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Serie: ${item['com_serie'] ?? 'N/A'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código Bien: ${item['com_codigo_bien'] ?? 'N/A'}'),
                        Text('Código UTA: ${item['com_codigo_uta'] ?? 'N/A'}'),
                        Text('Subcategoría: ${item['det_cat_nombre'] ?? 'N/A'}'),
                        Text('Modelo: ${item['com_modelo'] ?? 'N/A'}'),
                        Text('Marca: ${item['mar_nombre'] ?? 'N/A'}'),
                        Text('Características: ${item['com_caracteristica'] ?? 'N/A'}'),
                        Text('Dependencia: ${item['dep_nombre'] ?? 'N/A'}'),
                        Text('Año de Ingreso: ${item['com_anio_ingreso'] ?? 'N/A'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.red),
                      onPressed: () => repotenciar(item),
                    ),
                  ),
                );
              },
            ),
            if (modalEditarOpen) _buildEditarModal(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => repotenciar(null),
        backgroundColor: Color(0xFF9D0000), // Color rojo
        child: Icon(Icons.add, color: Colors.white), // Ícono "+" en blanco
      ),
    );
  }

  Widget _buildEditarModal(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      bottom: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCloseButton(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Aumentar el padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: codigoUTAController,
                      decoration: InputDecoration(labelText: 'Código UTA'),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    DropdownButtonFormField(
                      value: marcaController.text.isNotEmpty ? marcaController.text : null,
                      items: marcas.map<DropdownMenuItem<String>>((dynamic marca) {
                        return DropdownMenuItem<String>(
                          value: marca['mar_nombre'],
                          child: Text(marca['mar_nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          marcaController.text = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Marca',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    TextFormField(
                      controller: modeloController,
                      decoration: InputDecoration(labelText: 'Modelo'),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    TextFormField(
                      controller: numeroSerieController,
                      enabled: selectedItem == null, // Bloquear solo si no hay item seleccionado
                      decoration: InputDecoration(
                        labelText: 'Número de Serie',
                        enabled: selectedItem == null,
                      ),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    TextFormField(
                      controller: anioIngresoController,
                      decoration: InputDecoration(labelText: 'Año de Ingreso'),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    TextFormField(
                      controller: caracteristicasController,
                      decoration: InputDecoration(labelText: 'Características'),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    DropdownButtonFormField(
                      value: subcategoriaController.text.isNotEmpty ? subcategoriaController.text : null,
                      items: subcategorias.map<DropdownMenuItem<String>>((dynamic subcategoria) {
                        return DropdownMenuItem<String>(
                          value: subcategoria['det_cat_nombre'],
                          child: Text(subcategoria['det_cat_nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          subcategoriaController.text = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Subcategoría',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    DropdownButtonFormField(
                      value: dependenciaController.text.isNotEmpty ? dependenciaController.text : null,
                      items: dependencias.map<DropdownMenuItem<String>>((dynamic dependencia) {
                        return DropdownMenuItem<String>(
                          value: dependencia['dep_nombre'],
                          child: Text(dependencia['dep_nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dependenciaController.text = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Dependencia',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    TextFormField(
                      initialValue: estado,
                      decoration: InputDecoration(labelText: 'Estado'),
                      onChanged: (value) {
                        setState(() {
                          estado = value;
                        });
                      },
                    ),
                    SizedBox(height: 20), // Aumentar el espacio entre los campos
                    TextFormField(
                      initialValue: descripcionRepotencia,
                      decoration: InputDecoration(labelText: 'Descripción Repotencia'),
                      onChanged: (value) {
                        setState(() {
                          descripcionRepotencia = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    closeEditarModal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9D0000), // Mismo color que Guardar
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white), // Texto blanco
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedItem != null && selectedItem['com_id'] != null) {
                      editarComponente();
                    } else {
                      agregarComponente();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9D0000), // Mismo color que Cancelar
                  ),
                  child: Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white), // Texto blanco
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () {
          closeEditarModal();
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF9D0000), // Color rojo
          ),
          child: Icon(Icons.close, color: Colors.white),
        ),
      ),
    );
  }
}
