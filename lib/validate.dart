import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  Future<void> sendPostRequest() async {
    final String apiUrl = "http://localhost/api/create.php";
    var response = await http.post(Uri.parse(apiUrl),
        //headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "kode_barang": _kode_barang,
          "nama_barang": _nama_barang,
          "tahun_beli": _tahun_beli,
          "jumlah": _jumlah,
          "harga_beli": _harga_beli
        }));

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print(response.body);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BelajarGetData(),
          ));
    } else {
      // ignore: avoid_print
      print('Gagal disimpan');
    }
  }

  String? _kode_barang;
  String? _nama_barang;
  String? _tahun_beli;
  String? _jumlah;
  String? _harga_beli;
  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      sendPostRequest();
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Form Validation'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: formUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Kode Barang'),
          keyboardType: TextInputType.number,
          validator: validateKode,
          onSaved: (String? val) {
            _kode_barang = val;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nama Barang'),
          keyboardType: TextInputType.text,
          validator: validateNama,
          onSaved: (String? val) {
            _nama_barang = val;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tahun Beli'),
          keyboardType: TextInputType.number,
          validator: validateTahun,
          onSaved: (String? val) {
            _tahun_beli = val;
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Jumlah Barang'),
          keyboardType: TextInputType.number,
          validator: validateJumlah,
          onSaved: (String? val) {
            _jumlah = val;
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Harga Beli'),
          keyboardType: TextInputType.number,
          validator: validateHarga,
          onSaved: (String? val) {
            _harga_beli = val;
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        OutlinedButton(
          onPressed: _validateInputs,
          child: const Text('Simpan'),
        )
      ],
    );
  }

  String? validateKode(String? value) {
    if (value!.isEmpty) {
      return 'Kode Tidak Boleh Kosong';
    }
    if (value.length < 3) {
      return 'Kode harus lebih dari 2 karakter';
    } else {
      return null;
    }
  }

  String? validateNama(String? value) {
    if (value!.isEmpty) {
      return 'Nama tidak boleh kosong';
    } else {
      return null;
    }
  }

  String? validateTahun(String? value) {
    if (value!.isEmpty) {
      return 'Tahun tidak boleh kosong';
    } else {
      return null;
    }
  }

  String? validateJumlah(String? value) {
    if (value!.isEmpty) {
      return 'Jumlah Tidak Boleh Kosong';
    } else {
      return null;
    }
  }

  String? validateHarga(String? value) {
    if (value!.isEmpty) {
      return 'Harga Tidak Boleh Kosong';
    } else {
      return null;
    }
  }
}
