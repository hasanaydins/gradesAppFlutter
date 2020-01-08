import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Not Hesapla',
      theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.deepPurpleAccent,
          accentColor: Colors.deepPurpleAccent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int dersKredi = 1;
  double dersHarf = 4;
  String dersAdi = "turkce";
  double ortalama = 0;

  static int sayac = 0;

  var formKey = GlobalKey<FormState>();

  List<Ders> tumDersler;

  @override
  void initState() {
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Not Hesapla"),
      ),
      resizeToAvoidBottomPadding: false,
      body: uygulamaGovdesi(),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    /* ---------------------------  DERS ADI  ---------------------------*/
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: "Ders Adı",
                          labelStyle: TextStyle(fontSize: 16),
                          hintText: "Ders adı giriniz"),
                      validator: (girilenDeger) {
                        if (girilenDeger.length > 0) {
                          return null;
                        } else {
                          return "Lütfen en az bir ders giriniz";
                        }
                      },
                      onSaved: (gelenDeger) {
                        dersAdi = gelenDeger;

                        setState(() {
                          tumDersler.add(Ders(dersAdi, dersHarf, dersKredi));

                          ortalama = 0;

                          ortalamayiHesapla();
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 10, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kredi",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          /* ---------------------------  KREDİ  ---------------------------*/

                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: dersKredileriItems(),
                              value: dersKredi,
                              onChanged: (gelenDeger) {
                                dersKredi = gelenDeger;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black12,
                                offset: new Offset(0, 2.0),
                                blurRadius: 1.0,
                              )
                            ],
                            border:
                                Border.all(color: Colors.grey[200], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(14, 10, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Harf Notu",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Container(
                          /* ---------------------------  HARF NOTU  ---------------------------*/

                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              items: dersHarfDegerleriItems(),
                              value: dersHarf,
                              onChanged: (secilenharf) {
                                setState(() {
                                  dersHarf = secilenharf;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black12,
                                offset: new Offset(0, 2.0),
                                blurRadius: 1.0,
                              )
                            ],
                            border:
                                Border.all(color: Colors.grey[200], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurpleAccent.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 60,
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                          }
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        color: Colors.deepPurpleAccent,
                        child: Text(
                          "Ekle ve Hesapla",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      /* ---------------------------  ORTALAMA  ---------------------------*/

                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      alignment: Alignment.center,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(0, 2.0),
                            blurRadius: 2.0,
                          )
                        ],
                        border: Border.all(color: Colors.grey[200], width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          // set the default style for the children TextSpans
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontSize: 22),
                          children: [
                            TextSpan(
                              text: 'Ortalama : ',
                            ),
                            TextSpan(
                                text: tumDersler.length == 0
                                    ? '0'
                                    : '${ortalama.toStringAsFixed(3)}',
                                style:
                                    TextStyle(color: Colors.deepPurpleAccent)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            /* ---------------------------  LİSTELER  ---------------------------*/

            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                itemBuilder: _listeElemanlariniDoldur,
                itemCount: tumDersler.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text("$i Kredi"),
      ));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];

    harfler.add(DropdownMenuItem(
      child: Text("AA"),
      value: 4.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("BA"),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("BB"),
      value: 3.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("CC"),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("CB"),
      value: 2.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("CC"),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("DD"),
      value: 1.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("FF"),
      value: 0,
    ));

    return harfler;
  }

  Widget _listeElemanlariniDoldur(BuildContext context, int index) {
    sayac++;

    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        });
      },
      child: Card(
        child: ListTile(
          onTap: () {
            setState(() {
              tumDersler.removeAt(index);
              ortalamayiHesapla();
            });
          },
          trailing: Icon(Icons.delete),
          title: Text(tumDersler[index].ad),
          subtitle: Text("Ders Kredisi: " +
              tumDersler[index].kredi.toString() +
              ",  Harf Degeri: " +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamNotu = 0;

    double toplamKredi = 0;

    for (var oankiDers in tumDersler) {
      var kredi = oankiDers.kredi;
      var harf = oankiDers.harfDegeri;

      toplamNotu = toplamNotu + (harf * kredi);
      toplamKredi += kredi;
    }

    ortalama = toplamNotu / toplamKredi;
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
