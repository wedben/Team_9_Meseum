import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/artifact.dart';
import 'task_screen.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Artifact> artifacts = List.generate(
    8,
    (index) => Artifact(name: 'Артефакт ${index + 1}'),
  );

  @override
  void initState() {
    super.initState();
    _loadArtifactStates();
  }

  Future<void> _loadArtifactStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < artifacts.length; i++) {
      bool found = prefs.getBool('artifact_$i') ?? false;
      artifacts[i].found = found;
    }
    setState(() {});
  }

  Future<void> _saveArtifactState(int index, bool found) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('artifact_$index', found);
  }

  void markAsFound(int index) {
    setState(() {
      artifacts[index].found = true;
    });
    _saveArtifactState(index, true);

    if (artifacts.every((a) => a.found)) {
      Future.delayed(Duration(milliseconds: 500), () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Поздравляем!'),
            content: Text('Вы нашли все артефакты и раскрыли Сырную Тайну!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              )
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Костромская коллекция')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: artifacts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final artifact = artifacts[index];
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskScreen(artifactName: artifact.name),
                  ),
                );
                if (result == true) markAsFound(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: artifact.found ? Colors.amber : Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    artifact.found ? artifact.name : '???',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: artifact.found ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
