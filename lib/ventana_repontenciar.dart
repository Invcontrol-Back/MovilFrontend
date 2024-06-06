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
  List<dynamic> componentes = [];
  dynamic selectedItem;
  dynamic individuoComponente;
  bool modalAumentarOpen = false;
  String detalleRepotencia = '';

  @override
  void initState() {
    super.initState();
    cargarComponentesRepotencia();
  }

  cargarComponentesRepotencia() {
    final url = 'http://127.0.0.1:8000/api/componente/';
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          componentes = jsonDecode(response.body);
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    }).catchError((error) {
      print('Error de conexión: $error');
    });
  }

  quitarComponente(dynamic componente) {
    // Implementa la lógica para quitar el componente
  }

  repotenciar() {
    // Implementa la lógica para repotenciar el componente seleccionado
  }

  openAumentarModal(dynamic component) {
    setState(() {
      individuoComponente = component;
      modalAumentarOpen = true;
    });
  }

  closeAumentarModal() {
    setState(() {
      modalAumentarOpen = false;
    });
  }

  selectItem(dynamic item) {
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.data[index]['com_serie']),
                  onTap: () => selectItem(widget.data[index]),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: repotenciar,
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
}
