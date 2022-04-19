import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        "data": ((context) => NewData()),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Foreground State
    firebaseMessaging.getInitialMessage();
    FirebaseMessaging.onMessage.listen((messages) {
      if (messages.notification != null) {
        print(messages.notification!.title);
        print(messages.notification!.body);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((messages) {
      if (messages.notification != null) {
        print(messages.notification!.title);
        print(messages.notification!.body);
        print(messages.data["path"]);
        Navigator.pushNamed(context, messages.data["path"]);
      }
    });

    //when app is terminated:
    firebaseMessaging.getInitialMessage().then((messages) {
      if (messages != null) {
        print(messages.notification!.title);
        print(messages.notification!.body);
        print(messages.data["path"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("Home Page"))],
      ),
    );
  }
}
