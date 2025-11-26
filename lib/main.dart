import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://cgwfzqbmopppkngkcqut.supabase.co',
    anonKey: 'sb_publishable_F8-wHeLqz8_VDDw-bXmPFg_1333s2ED',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS2 Inventory Manager',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: false),
      home: const MyHomePage(title: 'CS2 Inventory Manager'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, int> dataId = {};
  List<dynamic> dataMap = [];
  Map<String, String> inventory = {
    "Gloves": "",
    "Knifes": "",
    "Rifles": "",
    "Heavy": "",
    "SMGs": "",
    "Pistols": ""
  };
  bool recupDataBool = false;
  int id = 1;
  int idset = 1;

  bool auto = false;

  final TextEditingController _idSetController = TextEditingController(
    text: "1",
  );

  Future<void> insertData() async {
    final response = await supabase.from('inventory').insert({
      'Gloves': inventory['Gloves'],
      'Knifes': inventory['Knifes'],
      'Rifles': inventory['Rifles'],
      'Heavy': inventory['Heavy'],
      'SMGs': inventory['SMGs'],
      'Pistols': inventory['Pistols'],
    });
  }

  void ajouter() {
    inventory[dataMap[id]['category']['name']] = dataMap[id]['name'];
    afficheData();
  }

  void randomID() async {
    while (auto) {
      await Future.delayed(const Duration(seconds: 1));
      id = Random().nextInt(2012) + 1;
      recupDataBool = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void recupData() async {
    await recupDataJson();
    if (mounted) {
      setState(() {});
    }
  }

  void getInventoryId() async {
    final data = await supabase.from('inventory').select("id");
    afficheData();
    print(data);
  }

  Future<void> recupDataJson() async {
    String url =
        "https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api/en/skins.json";
    var reponse = await http.get(Uri.parse(url));
    if (reponse.statusCode == 200) {
      dataMap = convert.jsonDecode(reponse.body);
      recupDataBool = true;
    }
  }

  Widget afficheData() {
    Column contenu = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.empty(growable: true),
    );

    if (recupDataBool && dataMap.isNotEmpty && id < dataMap.length) {
      contenu.children.add(
        CachedNetworkImage(
          imageUrl: dataMap[id]["image"].toString(),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
      contenu.children.add(
        Text(
          dataMap[id]['name'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );

      contenu.children.add(
        Text(
          "Category: ${dataMap[id]['category']['name']}",
          style: const TextStyle(fontSize: 16),
        ),
      );

      for (var cat in inventory.keys) {
        if (cat != "id") {
          contenu.children.add(
            Text(
              "$cat : ${inventory[cat]}",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }
      }
    }
    Center affichage = Center(child: contenu);
    return affichage;
  }

  Widget attente() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'En attente des données',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void decrement() {
    setState(() {
      if (id > 1) {
        id--;
        recupDataBool = false;
      }
    });
  }

  void goToIid() {
    setState(() {
      if (idset < 1) idset = 1;
      if (idset > 2013) idset = 2013;
      id = idset;
      recupDataBool = false;
    });
  }

  void increment() {
    setState(() {
      if (id < 2013) {
        id++;
        recupDataBool = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!recupDataBool) {
      recupData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_settings),
            tooltip: 'Auto gaming',
            onPressed: () {
              auto = !auto;
              randomID();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idSetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Aller à l'ID",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null) {
                        setState(() {
                          idset = parsed;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: goToIid, child: const Text("OK")),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: recupDataBool ? afficheData() : attente()),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    insertData();
                    afficheData();
                  },
                  child: const Text("Injecter"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: getInventoryId,
                  child: const Text("Afficher les ID d'inventaire"),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ajouter();
          afficheData();
        },
        child: Text("n° $id"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.red,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.navigate_before, color: Colors.white),
                onPressed: decrement,
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next, color: Colors.white),
                onPressed: increment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
