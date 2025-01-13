import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
      title: 'Calci app',
      theme: ThemeData(
        // This is the theme of your application.
        
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
      ),
      home:  MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier{
  var current = WordPair.random();

  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }

  var favourites = <WordPair>[];
  void toggleFavourite(){
    if(favourites.contains(current)){
      favourites.remove(current);
    }
    else{
      favourites.add(current);
    }
    notifyListeners();
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
// class MyHomePage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     var appstate = context.watch<MyAppState>();
//     var pair = appstate.current;

//     IconData icon;
//     if(appstate.favourites.contains(pair)){
//       icon = Icons.favorite;
//     }
//     else{
//       icon = Icons.favorite_border;
//     }

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             bigCard(pair: pair),
//             SizedBox(height: 20), //space between the card and button!!! This space happens vertically because the child is columned.
        
//             Row(
//               mainAxisSize: MainAxisSize.min,

//               children: [
//                 ElevatedButton.icon(onPressed: (){
//                   appstate.toggleFavourite();
//                 }, 
//                 icon: Icon(icon), //shows heart symbol before the next button
//                 label: Text('Like')),
//                 SizedBox(width: 8), //space between icon and next button!
//               // This space happened horizontally because icon and next button is inside row.
//                 ElevatedButton(onPressed: (){
//                   //print("Button pressed");
//                   appstate.getNext();
//                 } ,
//                 child: Text('Next')),
//               ],
//             )
//           ],
//         ),
//       )
//     );
//   }
// }
class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget page;
    switch(selectedIndex){
      case 0: 
      page = GeneratorPage();
      case 1:
      // page = Placeholder();
      page = FavoritesPage();
      default:
      throw UnimplementedError('No widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(child: NavigationRail( //separates the widget 
                extended: Constraints.maxWidth >= 800,
                destinations: [              
                  NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text("Home")),
                    
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text("Favourites")),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value){
                  setState(() {
                    selectedIndex = value;
                  });
                },
                ),
              ),
              Expanded(child: Container( //separates the widget
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page, //it'll go to above widget: page
              ),
              )
            ]
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    Set<String> textfav = {};

    IconData icon;
    if(appState.favourites.contains(pair)){
      icon = Icons.favorite;
    }
    else{
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          bigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(onPressed: (){
                appState.toggleFavourite();  
                textfav.add(appState.current.toString());
              },
              icon: Icon(icon),
              label: Text("Favourite"),
               
              ),
              SizedBox(width: 10),

              ElevatedButton(onPressed: (){
                appState.getNext();
              }, 
              child: Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var appState = context.watch<MyAppState>();
    if(appState.favourites.isEmpty){
      return Center(
        child: Text("There is no favourites"),
      );  
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('you have' 
          '${appState.favourites.length} favourites: '),
        ),
        for(var list in appState.favourites)
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text(list.asLowerCase),
        ),
      ],
    );
  }
}

class bigCard extends StatelessWidget {
  const bigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first}  ${pair.second}",
        ),
      ),
    );
  }
}

