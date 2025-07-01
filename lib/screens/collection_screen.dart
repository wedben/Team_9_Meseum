import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/museum.dart';
import '../models/artifact.dart';
import 'task_screen.dart';

class CollectionScreen extends StatefulWidget {
  final Museum museum;
  
  const CollectionScreen({
    Key? key,
    required this.museum,
  }) : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();
    _loadArtifactStates();
  }

  Future<void> _loadArtifactStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (var artifact in widget.museum.artifacts) {
      bool found = prefs.getBool('${widget.museum.id}_${artifact.id}') ?? false;
      artifact.found = found;
    }
    setState(() {});
  }

  Future<void> _saveArtifactState(Artifact artifact, bool found) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.museum.id}_${artifact.id}', found);
  }

  void markAsFound(int index) {
    setState(() {
      widget.museum.artifacts[index].found = true;
    });
    _saveArtifactState(widget.museum.artifacts[index], true);

    if (widget.museum.artifacts.every((a) => a.found)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('Поздравляем!'),
              content: Text('Вы выполнили все задания квеста!'),
              actions: [
                TextButton(
                  onPressed: null,
                  child: Text('OK'),
                )
              ],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Квест: ${widget.museum.name}')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('История музея'),
                    content: SingleChildScrollView(
                      child: Text(widget.museum.history),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Закрыть'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Показать историю музея'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: widget.museum.artifacts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final artifact = widget.museum.artifacts[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskScreen(
                            artifactName: artifact.name,
                            artifactDescription: artifact.description,
                          ),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              artifact.found ? Icons.check_circle : Icons.help_outline,
                              size: 40,
                              color: artifact.found ? Colors.green : Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artifact.found ? artifact.name : 'Задание ${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: artifact.found ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
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
  }
}