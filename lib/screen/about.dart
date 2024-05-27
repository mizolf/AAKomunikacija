import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _buildBulletPoint(String title, String description) {
    return ListTile(
      leading: const Icon(Icons.brightness_1, size: 8.0),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('O aplikaciji'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Augmentativna i alternativna komunikacija',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'Augmentativna i alternativna komunikacija (AAK) obuhvaća metode i sredstva koja pomažu osobama s teškoćama u verbalnoj komunikaciji da se učinkovito izraze. '
                        'To može uključivati upotrebu gesta, znakova, slika, simbola, komunikacijskih ploča i elektroničkih uređaja. '
                        'AAK se koristi kao dopuna (augmentacija) postojećim komunikacijskim sposobnostima ili kao alternativa kada verbalna komunikacija nije moguća.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 18.0),
                      Center(
                        child: Text(
                          'AAKomunikacija',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                          'AAKomunikacija omogućuje korisnicima da se izraze i komuniciraju s drugima putem različitih sredstava, kao što su slike, simboli, tekst i sintetički govor. '),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          _buildBulletPoint(
                            'Poboljšanje komunikacije',
                            'AAKomunikacija omogućuje korisnicima da izraze svoje potrebe, želje, misli i osjećaje na način koji im je pristupačan. Pomažu u smanjenju frustracija povezanih s nemogućnošću komunikacije.',
                          ),
                          _buildBulletPoint(
                            'Obrazovanje',
                            'Omogućuje učenicima s komunikacijskim teškoćama da sudjeluju u nastavi i obrazovnim aktivnostima. Pomažu u učenju novih riječi, pojmova i komunikacijskih vještina.',
                          ),
                          _buildBulletPoint(
                            'Samostalnost i uključenost',
                            'Povećava samostalnost korisnika omogućujući im da samostalno obavljaju svakodnevne aktivnosti i komuniciraju s okolinom. Promiču socijalnu uključenost omogućujući korisnicima da sudjeluju u društvenim interakcijama.',
                          ),
                          _buildBulletPoint(
                            'Podrška roditeljima i skrbnicima',
                            'Aplikacija pruža alat roditeljima i skrbnicima za bolju komunikaciju s djecom i odraslim osobama koje imaju komunikacijske poteškoće.',
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Općenito, aplikacije za AAK su važan alat za osobe s raznim komunikacijskim i govornim teškoćama, uključujući one s autizmom, cerebralnom paralizom, te različitim sindromima i poremećajima koji utječu na sposobnost govora.',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text("2024 \u00a9 Mislav Češnik"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
