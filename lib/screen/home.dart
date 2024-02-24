import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ict_aac/models/pictogram.dart';
import 'package:ict_aac/screen/about.dart';
import 'package:ict_aac/widgets/menu.dart';
import 'package:ict_aac/widgets/pictogram_card.dart';

List<String> categories = [
  'Moji simboli',
  'Često korišteno',
  'Osobe',
  'Radnje',
  'Pridjevi',
  'Upitne riječi',
  'Prijedlozi',
  'Promet',
  'Pomoć',
  'Životinje'
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;
  String categoriesTitle = '';
  List<Pictogram> sentence = [];

  List<Pictogram> custom = [];
  List<Pictogram> oftenUsed = [];
  List<Pictogram> people = [];
  List<Pictogram> action = [];
  List<Pictogram> adjectives = [];
  List<Pictogram> questionWords = [];
  List<Pictogram> prepositions = [];
  List<Pictogram> help = [];
  List<Pictogram> traffic = [];
  List<Pictogram> animals = [];
  late List<Pictogram> currentView = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadSentence();
  }

  Future<void> _loadCategories() async {
    final pictogramsSnapshot =
        await FirebaseFirestore.instance.collection('pictograms').get();
    final List<Pictogram> pictograms = pictogramsSnapshot.docs.map((doc) {
      return Pictogram.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    final customSnapshot =
        await FirebaseFirestore.instance.collection('custom').get();
    final List<Pictogram> customs = customSnapshot.docs.map((doc) {
      return Pictogram.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      for (final pictogram in pictograms) {
        if (pictogram.category == 'osoba') {
          people.add(pictogram);
        } else if (pictogram.category == 'radnja') {
          action.add(pictogram);
        } else if (pictogram.category == 'pridjev') {
          adjectives.add(pictogram);
        } else if (pictogram.category == 'upitna riječ') {
          questionWords.add(pictogram);
        } else if (pictogram.category == 'prijedlog') {
          prepositions.add(pictogram);
        } else if (pictogram.category == 'pomoć') {
          help.add(pictogram);
        } else if (pictogram.category == 'promet') {
          traffic.add(pictogram);
        } else if (pictogram.category == 'često') {
          oftenUsed.add(pictogram);
        } else if (pictogram.category == 'životinja') {
          animals.add(pictogram);
        }
      }
      custom = customs;
    });
  }

  Future<void> _loadSentence() async {
    final pictogramsSnapshot =
        await FirebaseFirestore.instance.collection('sentence').get();
    final List<Pictogram> pictograms = pictogramsSnapshot.docs.map((doc) {
      return Pictogram.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    setState(() {
      sentence = pictograms;
    });
  }

  Future<void> _showSentence(Pictogram pictogram) async {
    final isExisting = sentence.contains(pictogram);

    if (isExisting) {
      await FirebaseFirestore.instance
          .collection('sentence')
          .where('label', isEqualTo: pictogram.label)
          .where('description', isEqualTo: pictogram.description)
          .where('category', isEqualTo: pictogram.category)
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.delete();
        }
      });

      setState(() {
        sentence.remove(pictogram);
      });
    } else {
      await FirebaseFirestore.instance
          .collection('sentence')
          .add(pictogram.toMap());

      setState(() {
        sentence.add(pictogram);
      });
    }
  }

  Future<void> _removeLastPictogram() async {
    Pictogram lastPictogram = sentence.last;
    await FirebaseFirestore.instance
        .collection('sentence')
        .where('label', isEqualTo: lastPictogram.label)
        .where('description', isEqualTo: lastPictogram.description)
        .where('category', isEqualTo: lastPictogram.category)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.first.reference.delete();
      }
    });

    setState(() {
      sentence.remove(lastPictogram);
    });
  }

  void _selectPage(int index) {
    List<List<Pictogram>> pictograms = [
      custom,
      oftenUsed,
      people,
      action,
      adjectives,
      questionWords,
      prepositions,
      traffic,
      help,
      animals,
    ];

    pushPage();
    currentView = pictograms[index];
    categoriesTitle = categories[index];
  }

  void pushPage() {
    setState(() {
      _selectedPageIndex++;
    });
  }

  void popPage() {
    setState(() {
      _selectedPageIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget menu = Menu(categories: categories, selectPage: _selectPage);
    Widget content = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: popPage,
                    icon: const Icon(Icons.arrow_back, size: 24),
                  ),
                  Text(
                    categoriesTitle,
                    style: const TextStyle().copyWith(fontSize: 24),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: currentView.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showSentence(currentView[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: PictogramCard(pictogram: currentView[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    Widget activePage = menu;

    if (_selectedPageIndex == 1) {
      activePage = content;
    } else {
      activePage = menu;
    }

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Container(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  'AAK',
                  style: TextStyle().copyWith(fontSize: 32),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.house_outlined),
                title: Text(
                  'NASLOVNA',
                  style: const TextStyle().copyWith(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline_outlined),
                title: Text(
                  'DODAJ SVOJ SIMBOL',
                  style: const TextStyle().copyWith(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.info_outlined),
                title: Text(
                  'O APLIKACIJI',
                  style: const TextStyle().copyWith(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => const AboutScreen()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('AAK'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              height: 150,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sentence.length,
                      itemBuilder: (context, index) {
                        return PictogramCard(pictogram: sentence[index]);
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: _removeLastPictogram,
                            icon: const Icon(
                              Icons.backspace,
                              size: 36,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_circle_fill,
                              size: 36,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: activePage,
            ),
          ],
        ),
      ),
    );
  }
}
