import 'package:code_lab_first_app/card.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
//

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  //
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
  //-------------------------------------------------------------
  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
//

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;

    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();//-----------------------Placeholder--------------
        break;
      case 2:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            // appBar: AppBar(
            //   title: Text('First App'),
            //   centerTitle: true,
            // ),
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.laptop_mac),
                        label: Text('leptop'),
                      ),
                    ],

                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                      print('selected: $value');
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
//

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon,size: 35,),
                label: Text('Like',style: TextStyle(fontSize: 35),),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next',style: TextStyle(fontSize: 35),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.',style: TextStyle(fontSize: 25),),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:',style: TextStyle(fontSize: 25),),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: IconButton(onPressed: (){
              appState.removeFavorite(pair);
            }, icon:Icon(Icons.favorite,size: 30,),),

            title: Text(pair.asLowerCase,style: TextStyle(fontSize: 25
            ),),
          ),
      ],
    );
  }
}