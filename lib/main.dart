import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'DASI Board',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    TodoPage(),
    DoingPage(),
    PlaceholderWidget(Colors.green),
  ];

  void sendPost() async{
    final response = await http.post('http://35.184.87.160/task', body: {'title':'Test_Task'});
  }

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DASI Board'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items:[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('To Do'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Doing'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Done'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}

class TodoPage extends StatelessWidget{
  final Future<Post> post = fetchPost();

  @override
  Widget build(BuildContext context) {
    debugPrint('test');
    return Center(
      child: FutureBuilder<Post>(
        future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.test);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
    );
  }
}

class DoingPage extends StatelessWidget{
  final Future<PostReply> post = sendPost();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton.icon(
        color: Colors.red,
        icon: Icon(Icons.check),
        label: Text('test'),
        onPressed: (){
          sendPost();
        }
      )

      // child: FutureBuilder<PostReply>(
      //   future: post,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return Text(snapshot.data.test);
      //       } else if (snapshot.hasError) {
      //         return Text("${snapshot.error}");
      //       }

      //       // By default, show a loading spinner.
      //       return CircularProgressIndicator();
      //     },
      //   ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget{
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

Future<Post> fetchPost() async{
  final response = await http.get('http://35.184.87.160/health');

  if(response.statusCode == 200){
    return Post.fromJson(json.decode(response.body));
  } else{
    throw Exception('Failed to load post request');
  }
}

Future<PostReply> sendPost() async{
  String title = "{\"title\":\"TitleAppFlutter\"}";//jsonEncode({'title':'TitleAppFlutter'});

  return http.post('http://35.184.87.160/task', body: json.encode({"title":"test2"}), headers:{ HttpHeaders.contentTypeHeader: 'application/json'}).then((http.Response response){
    if(response.statusCode == 201){
      return PostReply.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load post response');
    }
  });
}

class PostReply{
  final String test;

  PostReply({this.test});

  factory PostReply.fromJson(Map<String, dynamic> json) {
    return PostReply(
      test: json['status'],
    );
  }  

}

class Post {
  final String test;

  Post({this.test});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      test: json['status'],
    );
  }
}

// class _MyAppState extends State<MyApp> {
//   Future<Post> post;

//   @override
//   void initState() {
//     super.initState();
//     post = fetchPost();
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DASI Board',
//       theme: ThemeData(
//         primarySwatch: Colors.grey,
//       ),
//       //home: MyHomePage(title: 'Flutter Demo Home Page'),
//       //home: MyHomePage(),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('fetch test')
//         ),
//         body: Center(
//           child: FutureBuilder<Post>(
//             future: post,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data.test);
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }

//               // By default, show a loading spinner.
//               return CircularProgressIndicator();
//             },
//           ),
//         ) 
//       ),
//     );
//   }
// }

//void sendPost() async{
  //final response = await http.post('http://104.198.21.88/task', body: {'title':'Test_Task'});

  // if(response.statusCode == 200){
  //   return 
  // } else{
  //   throw Exception('Failed to load post');
  // }
//}

// class MyHomePage extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(

//       ),
//       body: Center(
//         FutureBuilder<Post>(
//           future: post,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Text(snapshot.data.title);
//             } else if (snapshot.hasError) {
//               return Text("${snapshot.error}");
//             }

//             // By default, show a loading spinner.
//             return CircularProgressIndicator();
//           },
//         );
//       ) 
//     );
//   }
// }

// class UselessDrawer extends StatelessWidget{
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () { Scaffold.of(context).openDrawer(); },
//               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//             );
//           },
//         ),
//         title: Text('test'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//               ),
//               child: Text(
//                 'DASI Board',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.arrow_right),
//               title: Text('Things To Do'),
//               onTap: (){
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () { Scaffold.of(context).openDrawer(); },
//               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//             );
//           },
//         ),
//         title: Text(widget.title),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: const <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//               ),
//               child: Text(
//                 'DASI Board',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.arrow_right),
//               title: Text('Things To Do'),
//               onTap: (){
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
