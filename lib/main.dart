import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/flexcolorscheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List _suggestions = <WordPair>[];
  final Set _saved = <WordPair>{};
  final TextStyle _biggerFont = const TextStyle(
    fontSize: 18.0,
  );
  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final Iterable<ListTile> tiles = _saved.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final List<Widget> divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
          : [];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider(
              color: Color(0xff104393),
            );
          }

          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(
              generateWordPairs().take(10),
            );
          }

          final bool alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel:
                  alreadySaved ? 'Remove from favorites' : 'Add to favorites',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }
}
