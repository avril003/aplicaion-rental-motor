import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'validate.dart';
import 'edit_brg.dart';

void main() {
  runApp(MaterialApp(
    home: BelajarGetData(),
  ));
}

class BelajarGetData extends StatelessWidget {
  // final String apiUrl = "https://siunjaya.id/apik/read.php";
  final String apiUrl = "http://localhost/api/read.php";

  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembelian Barang'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://th.bing.com/th/id/R.fcac02a3e321cdd4f332d5b2aa4231f3?rik=UhPWtFw3v7OhaA&riu=http%3a%2f%2fstatic1.squarespace.com%2fstatic%2f514b05c6e4b04d7440eb010a%2f5fdae31345914905e709620f%2f5fdae52bfda9ac373f49b831%2f1665684850088%2fplain-shipping-boxes-packhelp-kva.jpg%3fformat%3d1500w&ehk=fhn7H%2fn60d1E4brdJVtRQazEGEHKoSrTMURNOyGZvyI%3d&risl=&pid=ImgRaw&r=0'),
                      ),
                      title: Text(
                          snapshot.data[index]['kode_barang'].toString() +
                              " " +
                              snapshot.data[index]['nama_barang']),
                      subtitle: Text('Tahun Pembelian: ' +
                          snapshot.data[index]['tahun_beli'].toString()),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit Data',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Edit(
                                        id: snapshot.data[index]['_id'],
                                      ),
                                    ));
                              }),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Hapus Data',
                              onPressed: () {})
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
