import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List userInformation = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
      var url = "https://jsonplaceholder.typicode.com/users/";
      var response = await http.get(Uri.parse(url));

      if(response.statusCode == 200){
        setState(() {
          userInformation = convert.jsonDecode(response.body) as List<dynamic>;
        });
      }
  }

  void deleteData(var id) async {
      var url = "https://jsonplaceholder.typicode.com/users/$id";
      var response = await http.delete(Uri.parse(url));

      if(response.statusCode == 200) {
        final filtered = userInformation.where((element) => element['id'] != id).toList();
        setState(() {
            userInformation = filtered;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get and Delete"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: userInformation.length,
          itemBuilder: (context, index){
            return Dismissible(
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.delete),
              ),
              key: ValueKey<Map>(userInformation[index]),
                  onDismissed: (DismissDirection direction){
                      deleteData(userInformation[index]['id']);
                  },
              child:Card(
                child: ListTile(
                  title: Text(userInformation[index]['name']),
                  subtitle: Text(userInformation[index]['email']),
                ),
              ),
            );
          }
      ),
    );
  }
}
