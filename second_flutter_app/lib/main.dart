import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp()); //ESTO LOS MISMO

/*void main() {
  runApp(MyApp());
}*/

/*class MyApp extends StatelessWidget { //ESTE WIDGET NO GUARDA LOS VALORES NI EL ESTADO DURANTE SU EJECUCIÓN
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random(); //objeto del paquete english_words
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter!!'),
        ),
        body: Center(
          child: Text(wordPair.asPascalCase),
        )
      ),
    );
  }
}*/

class MyApp extends StatelessWidget {
  //ESTE WIDGET NO GUARDA LOS VALORES NI EL ESTADO DURANTE SU EJECUCIÓN
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, //quitar el banner que pone 'debug'
        title: 'Welcome to Flutter',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  //ESTE WIDGET GUARDA LOS VALORES Y EL ESTADO DURANTE SU EJECUCIÓN
  @override
  State<StatefulWidget> createState() {
    return RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  //AQUI GUARDAMOS EL ESTADO DEL WIDGET
  final _suggestions = <
      WordPair>[]; //el guión bajo de "_suggestions" indica que es una variable privada
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 28.0);

  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random(); //objeto del paquete english_words
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //ESTO CREA UN NUEVO LAYOUT. EN FLUTTER SE LLAMAN ROUTE (RUTAS)
      final tiles = _saved.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });

      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestion'),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          //si es impar..
          return Divider();
        }
        if (i >= _suggestions.length) {
          _suggestions.addAll(
              generateWordPairs().take(10)); //añade 10 palabras a la lista
        }
        final index = i ~/ 2;
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        //si esta guardada: Icons.favorite sino: Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        //cuando hace clic en el widget
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair); //para quitar de favoritos
          } else {
            _saved.add(pair); //para añadir a favoritos
          }
        });
      },
    );
  }
}
