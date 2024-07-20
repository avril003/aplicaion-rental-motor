import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class Edit extends StatefulWidget {
  final id;
  const Edit({Key? key, this.id}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future<void> sendPostRequest() async {
    final String apiUrl = "http://localhost/api/update.php";
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
      print(response.body);
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

  var _kode_barang = TextEditingController();
  var _nama_barang = TextEditingController();
  var _tahun_beli = TextEditingController();
  var _jumlah = TextEditingController();
  var _harga_beli = TextEditingController();

  Future<String> getData() async {
    var url = "http://localhost/api/readmore.php?id=" + "${widget.id}";
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    print(data);
    setState(() {
      _kode_barang.text = data[0]['kode_barang'].toString();
      _nama_barang.text = data[0]['nama_barang'];
      _tahun_beli.text = data[0]['tahun_beli'].toString();
      _jumlah.text = data[0]['jumlah'].toString();
      _harga_beli.text = data[0]['harga_beli'].toString();
    });
    return "Success";
  }

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
          title: const Text('Form Edit Validation'),
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
          // initialValue: "${widget.id}",
          controller: _kode_barang,
          validator: validateKode,
          onSaved: (String? val) {
            // _namapegawai = val;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nama Barang'),
          keyboardType: TextInputType.text,
          controller: _nama_barang,
          validator: validateNama,
          onSaved: (String? val) {
            // _usia = val;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tahun Beli'),
          keyboardType: TextInputType.number,
          controller: _tahun_beli,
          validator: validateTahun,
          onSaved: (String? val) {
            // _departemen = val;
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Jumlah Barang'),
          keyboardType: TextInputType.number,
          controller: _jumlah,
          validator: validateJumlah,
          onSaved: (String? val) {
            // _gaji = val;
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Harga Beli'),
          keyboardType: TextInputType.number,
          controller: _harga_beli,
          validator: validateHarga,
          onSaved: (String? val) {
            // _lamakerja = val;
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
      return 'Tahun Beli tidak boleh kosong';
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
      return 'Harga Beli Tidak Boleh Kosong';
    } else {
      return null;
    }
  }
}
