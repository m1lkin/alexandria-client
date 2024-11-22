import 'package:alexandria/models/post.dart';
import 'package:alexandria/screens/post_screen.dart';
import 'package:alexandria/screens/search_screen.dart';
import 'package:alexandria/screens/user_screen.dart';
import 'package:alexandria/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO!!!!!!
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Alexandria',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 11, 129, 188)),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  
}
/*
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Container(color: Color(0xFFFFFFFF),);
        break;
      case 1:
        page = Container(color: Color(0x00000000),);
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          ),
        ),
        SafeArea(
          child: NavigationBar(
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.pages),
                label: "posts",
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_circle), 
                label: "account"
              ),
            ],
            
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          )
        ),
      ],
    );
  }
}
*/

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    Container(color: const Color.fromARGB(0, 255, 0, 0),),
    Container(color: const Color.fromARGB(0, 0, 0, 255),)
  ];

  final PostService _postService = PostService();

  List<PostModel> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      var buf = await _postService.getPosts();;
      setState(() {
        posts = buf;
      });
    } catch (e) {
      print("$e");
    }
  }  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Alexandria")),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.short_text),
            label: "Posts",
          ),
          NavigationDestination(
            icon: Icon(Icons.search), 
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: "Account",
          )
        ],
      ),
      body: [
        PostsScreen(posts: posts),
        SearchScreen(),
        UserScreen(),
      ][currentIndex],
    );
  }
}

