import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:ict_aac/models/pictogram.dart';
import 'package:ict_aac/screen/about.dart';
import 'package:ict_aac/screen/add_pictogram.dart';
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
  final FlutterTts flutterTts = FlutterTts();
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

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void initSettings() async {
    await flutterTts.setLanguage("hr-HR");
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    initSettings();
    await flutterTts.speak(text);
  }

  void _playSentence(List<Pictogram> pictograms) {
    initSettings();
    String text = '';
    for (Pictogram pictogram in pictograms) {
      text += pictogram.label;
      text += ' ';
    }
    _speak(text);
  }

  Future<void> _loadCategories(String userId) async {
    final pictogramsSnapshot =
        await FirebaseFirestore.instance.collection('pictograms').get();
    final List<Pictogram> pictograms = pictogramsSnapshot.docs.map((doc) {
      return Pictogram.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    final customSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customPictograms')
        .snapshots()
        .listen((snapshot) {
      final List<Pictogram> customs = snapshot.docs.map((doc) {
        return Pictogram.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      custom = customs;
    });

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
    });
  }

  void _showSentence(Pictogram pictogram) {
    final isExisting = sentence.contains(pictogram);

    if (isExisting) {
      setState(() {
        sentence.remove(pictogram);
      });
    } else {
      setState(() {
        sentence.add(pictogram);
      });
    }
  }

  Future<void> _removeLastPictogram() async {
    Pictogram lastPictogram = sentence.last;

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

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _getCurrentUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
    if (user != null) {
      await _loadCategories(user.uid);
    }
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
                      _speak(currentView[index].label);
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
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                accountName: Text(
                  _currentUser?.email!.split('@')[0].toUpperCase() ?? 'No name',
                  style: const TextStyle(color: Colors.black87),
                ),
                accountEmail: Text(
                  _currentUser?.email ?? 'No email',
                  style: const TextStyle(color: Colors.black87),
                ),
                currentAccountPicture: const Icon(
                  Icons.person_3_outlined,
                  size: 40,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.house_outlined),
                title: Text(
                  'NASLOVNA',
                  style: const TextStyle().copyWith(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
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
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                ),
                title: Text(
                  'ODJAVI SE',
                  style: const TextStyle().copyWith(fontSize: 18),
                ),
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('AAKomunikacija'),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddPictogramScreen(),
                        ),
                      );
                    },
                    icon:
                        const Icon(Icons.add_circle_outline_rounded, size: 48),
                  ),
                  IconButton(
                    onPressed: () {
                      _playSentence(sentence);
                    },
                    icon:
                        const Icon(Icons.play_circle_filled_outlined, size: 48),
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
