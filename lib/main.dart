import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List quakes = [];
void main() async {
  quakes = await getQuakes();

  runApp(new MaterialApp(
    title: "EARTH QUAKES",
    home: new Quake(),
  ));
}

class Quake extends StatelessWidget {
  const Quake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("EARTQUAKE APP"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
          child: ListView.builder(
        itemCount: quakes.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, index) {
          var feature = quakes[index];
          return Card(
            child: ListTile(
              title: Text(feature['properties']['mag'].toString()),
              subtitle: Text(feature['properties']['place']),
              onTap: () {
                _showAlerPage(context, feature['properties']['place']);
              },
            ),
          );
        },
      )),
    );
  }

  void _showAlerPage(BuildContext context, String message) {
    // ignore: unused_local_variable
    var alert = new AlertDialog(
      title: Text('QUAKES'),
      content: Text(message),
      actions: [
        FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('DONE'),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}

Future<List> getQuakes() async {
  Uri apiUrl = Uri.parse(
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');
  http.Response response = await http.get(apiUrl);
  var body = jsonDecode(response.body);

  return body['features'];
}
