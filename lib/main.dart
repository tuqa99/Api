// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Future<Album> futurealbum;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     futurealbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'fetch data example',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('fetch data example'),
//         ),
//         body: Center(child: FutureBuilder<Album>(
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Text(snapshot.data!.title);
//             } else if (snapshot.hasError) {
//               return Text('${snapshot.error}');
//             }
//             return CircularProgressIndicator();
//           },
//         )),
//       ),
//     );
//   }
// }

// //second step
// //http convert responce
// Future<Album> fetchAlbum() async {
//   final response =
//       await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/2'));

//   if (response.statusCode == 200)
//     return Album.fromJson(jsonDecode(response.body));
//   else {
//     throw Exception('faile to load album');
//   }
// }

// //create  album class
// class Album {
//   final int userid;
//   final int id;
//   final String title;

//   const Album({
//     required this.id,
//     required this.userid,
//     required this.title,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(id: json['id'], userid: json['userid'], title: json['title']);
//   }
// }

// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Make network request
//Covert http response inside album

// Create album class (model)
class Album {
  final int id;
  // final int userId;
  final String titel;
  final String image;
  final double price;
  const Album(
      {required this.id,
      // required this.userId,
      required this.titel,
      required this.image,
      required this.price});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'],
        // userId: json['userId'],
        titel: json['title'],
        image: json['image'],
        price: double.parse(json['price'].toString()));
  }

  static List<Album> albumFromsnapshot(List snapshot) {
    return snapshot.map((data) {
      return Album.fromJson(data);
    }).toList();
  }
}

// void main() {
//   runApp(const SplashScree());
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Album>> futureAlbum;
  late final List<Album>? _userModel = [];
  Future<List<Album>> fetchAlbum() async {
    var url = Uri.parse("https://fakestoreapi.com/products");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var decodeData = json.decode(response.body) as List<dynamic>;
      List<Album> Prodect =
          decodeData.map((json) => Album.fromJson(json)).toList();
      return Prodect;
    } else {
      throw Exception("Field load Album");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    futureAlbum = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      home: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'The data from API',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: Checkbox.width,
              ),
              FutureBuilder(
                future: futureAlbum,
                builder: (context, snapshot) {
                  // assignment what is a snapshot
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    return Container(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(255, 243, 237, 237)),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Image.network(data[index].image),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  data[index].titel,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      data[index].price.toString(),
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 23,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.favorite_sharp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      title: 'api app',
    );
  }
}
