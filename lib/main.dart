import 'network.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DASI Board',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
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
    DonePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: Text('DASI Board', textAlign: TextAlign.center)),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_1),
            title: Text('To Do'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_2),
            title: Text('Doing'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_3),
            title: Text('Done'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class TodoPage extends StatefulWidget{
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>{
  List<Task> litems = new List<Task>();

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TextField(
          controller: eCtrl,
          onSubmitted: (text) {
            litems.add(new Task(text));
            eCtrl.clear();
            //Send the new task to the API//
            sendPost(text);
            setState(() {});
          },
        ),
        new Expanded(
          child: ListView.separated(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(litems[index].title),
              );
            },
            separatorBuilder: (context, index){
              return Divider();
            }
          ),
        )
      ],
    );
  }

  void addTodoTask(Task newTask){
    litems.add(newTask);
  }
}

class DoingPage extends StatefulWidget{
  @override
  _DoingPageState createState() => _DoingPageState();
}

class _DoingPageState extends State<DoingPage>{
  List<Task> litems = new List<Task>();

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: ListView.separated(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(litems[index].title),
              );
            },
            separatorBuilder: (context, index){
              return Divider();
            }
          ),
        )
      ],
    );
  }
}

// class _DoingPageState extends State<DoingPage>{
//   //final Future<PostReply> post = sendPost();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FlatButton.icon(
//         color: Colors.red,
//         icon: Icon(Icons.check),
//         label: Text('test'),
//         onPressed: (){
//           sendPost("test2");
//         }
//       )
//     );
//   }
// }

class DonePage extends StatefulWidget{
  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage>{
  List<Task> litems = new List<Task>();

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: ListView.separated(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(litems[index].title),
              );
            },
            separatorBuilder: (context, index){
              return Divider();
            }
          ),
        )
      ],
    );
  }
}

class Task{
  int taskId;
  String title;
  int stateId;

  Task(this.title);
}
