import "package:flutter/material.dart";

class NewPictogram extends StatelessWidget {
  const NewPictogram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          title: const Text('Dodaj svoj simbol'),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(
                  labelText: 'Naziv simbola',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Unesite naziv simbola';
                  }
                  return null;
                },
              ),
            ],
          ),
        ));
  }
}
