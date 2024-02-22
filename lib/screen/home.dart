import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ict_aac/models/pictogram.dart';

List<String> categories = [
  'Potvrda',
  'Osobe',
  'Radnje',
  'Pridjevi',
  'Upitne riječi',
  'Prijedlozi',
  'Promet',
  'Trebam pomoć',
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

  List<Pictogram> people = [];
  List<Pictogram> action = [];
  List<Pictogram> adjectives = [];
  List<Pictogram> questionWords = [];
  List<Pictogram> prepositions = [];
  List<Pictogram> help = [];
  List<Pictogram> traffic = [];
  List<Pictogram> affirmation = [];
  List<Pictogram> animals = [];
  late List<Pictogram> currentView = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final pictogramsSnapshot =
        await FirebaseFirestore.instance.collection('pictograms').get();
    final List<Pictogram> pictograms = pictogramsSnapshot.docs.map((doc) {
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
        } else if (pictogram.category == 'potvrda') {
          affirmation.add(pictogram);
        } else if (pictogram.category == 'životinja') {
          animals.add(pictogram);
        }
      }
    });
  }

  void _selectPage(int index) {
    List<List<Pictogram>> pictograms = [
      affirmation,
      people,
      action,
      adjectives,
      questionWords,
      prepositions,
      traffic,
      help,
      animals,
    ];

    setState(() {
      _selectedPageIndex++;
    });
    currentView = pictograms[index];
    categoriesTitle = categories[index];
  }

  @override
  Widget build(BuildContext context) {
    Widget menu = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _selectPage(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              categories[index],
                              style: const TextStyle().copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/$index.jpg')),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                    onPressed: () {
                      setState(() {
                        _selectedPageIndex--;
                      });
                    },
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
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              currentView[index].label,
                              style: const TextStyle().copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  currentView[index].image,
                                  scale: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
        backgroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('ICT AAC'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              height: 100,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
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
