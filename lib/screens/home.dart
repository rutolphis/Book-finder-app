import 'package:flutter/material.dart';
import 'package:zadanie_praca/functions/api.dart';
import 'package:zadanie_praca/classes/book.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String name;
  bool isBLank = true;
  bool isLoading = true;
  late List<Book> books;

  void initState() {
    super.initState();
  }

  Future<void> getBooksLocal(String name) async {
    setState(() {
      isLoading = true;
    });
    books = await Api.getBooks(name);
    setState(() {
      isLoading = false;
    });
  }

  Widget findBookForm() {
    return Form(
        key: _formKey,
        child: Row(children: <Widget>[
          Expanded(
              child: TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            maxLength: 15,
            validator: (String? value) {
              if (value!.isEmpty == true) {
                return 'Vyplňte textové pole.';
              }
              return null;
            },
            onSaved: (String? value) {
              if (value!.isEmpty == false) {
                name = value;
              }
            },
          )),
          Expanded(
              child: ElevatedButton(
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              _formKey.currentState!.save();
              getBooksLocal(this.name);
            },
          ))
        ]));
  }

  Widget bookCards(){
    if(isLoading == true){
      return Center(child: CircularProgressIndicator());
    }
    else {
      return
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
        itemCount: books.length,
            physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Text(index.toString());
        },
      )
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vyhladávač kníh"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            findBookForm(),
            Text("cau"),
            bookCards()
          ]),
    );
  }
}
