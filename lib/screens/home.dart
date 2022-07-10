import 'package:flutter/material.dart';
import 'package:zadanie_praca/functions/api.dart';
import 'package:zadanie_praca/classes/book.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String name;
  bool isBlank = true;
  bool isLoading = true;
  late List<Book> books;
  late int pages;
  int currentPage = 1;

  void initState() {
    super.initState();
  }

  Future<void> getBooksLocal(String name) async {
    this.pages = await Api.getTotal(this.name);
    this.pages = (this.pages / 10).ceil();

    setState(() {
      isLoading = true;
    });
    books = await Api.getBooks(name, currentPage.toString());
    if (pages > 0) {
      isBlank = false;
    } else {
      isBlank = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget findBookForm() {
    return Expanded(
        flex: 2,
        child: Form(
            key: _formKey,
            child: Row(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Názov knihy', counterText: ""),
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
                      ))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 12),
                      child: ElevatedButton(
                        child: Text(
                          'Vyhľadaj',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            currentPage = 1;
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          });
                          _formKey.currentState!.save();
                          getBooksLocal(this.name);
                        },
                      )))
            ])));
  }

  Widget bookCards() {
    if (isLoading == true) {
      return Expanded(
          flex: 7,
          child: Container(
              width: 300,
              height: 450,
              child: Transform.scale(
                  scale: 0.2, child: CircularProgressIndicator())));
    } else {
      if (books.length == 0 || books.isEmpty) {
        return Expanded(
            flex: 7, child: Center(child: Text("Žiadne knihy sa nenašli.")));
      } else {
        return Expanded(
            flex: 7,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: books.length,
              itemBuilder: (context, index) {
                return bookCard(books[index]);
              },
            ));
      }
    }
  }

  Widget bookCard(Book book) {
    return InkWell(
        onTap: () {
          bookDetail(book);
        },
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          height: 60,
          child: Center(
              child: Text(book.title,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis)),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10)),
        ));
  }

  Widget pagination() {
    if (!isBlank) {
      return Expanded(
          flex: 2,
          child: NumberPagination(
            threshold: 4,
            fontSize: 15,
            onPageChanged: (int pageNumber) {
              currentPage = pageNumber;
              getBooksLocal(this.name);

              setState(() {});
            },
            pageTotal: pages,
            pageInit: 1,
            // picked number when init page
            colorPrimary: Colors.white,
            colorSub: Colors.yellow,
          ));
    } else {
      return Expanded(flex: 2, child: Text(""));
    }
  }

  Future<void> bookDetail(Book book) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text(book.title),
        content: Container(
            height: 320.0,
            width: 300.0,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child:
                            Image.network(book.image, width: 500, height: 100)),
                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text("O knihe:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis)),
                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(book.subtitle == ""
                            ? "Žiadny popis."
                            : book.subtitle)),
                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text("Cena: ${book.price}")),
                    ElevatedButton(
                      onPressed: () async {
                        if (await canLaunch(book.url))
                          await launch(book.url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch ${book.url}";
                      },
                      child: Text("Chcem kúpiť knihu"),
                    )
                  ],
                ))),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.black.withOpacity(0.7)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Close", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Vyhladávač kníh"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[findBookForm(), bookCards(), pagination()]),
    );
  }
}
