import 'package:flutter/material.dart';
import 'package:plant_friends/widgets/my_navigation_bar.dart';
import 'package:flutter/services.dart';


void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantFriends',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyNavigationBar()
    );
  }
}
