import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/museum.dart';
import '../models/artifact.dart';
import 'task_screen.dart';
import 'photo_quest_screen.dart';
import 'text_input_quest_screen.dart';
import 'qr_quest_screen.dart';
import 'dart:io' show Platform;
import 'ar_reward_ios_screen.dart';
import 'ar_reward_android_screen.dart';

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
  bool allTasksCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadArtifactStates();
  }

  Future<void> _loadArtifactStates() async {
    final prefs = await SharedPreferences.getInstance();
    bool allFound = true;

    for (var artifact in widget.museum.artifacts) {
      bool found = prefs.getBool('${widget.museum.id}_${artifact.id}') ?? false;
      artifact.found = found;
      if (!found) allFound = false;
    }

    setState(() {
      allTasksCompleted = allFound;
    });
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
      setState(() {
        allTasksCompleted = true;
      });

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

  void _openRewardThankYouScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RewardThankYouScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showRewardTile = widget.museum.id == 'nature_museum' && allTasksCompleted;
    final itemCount = widget.museum.artifacts.length + (showRewardTile ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Квест: ${widget.museum.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: 'История музея',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('История музея'),
                  content: SingleChildScrollView(
                    child: Text(widget.museum.history),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Закрыть'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Сбросить прогресс',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Сбросить прогресс?'),
                  content: Text('Вы уверены, что хотите сбросить прогресс по всем квестам этого музея?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Отмена')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Сбросить')),
                  ],
                ),
              );
              if (confirmed == true) {
                final prefs = await SharedPreferences.getInstance();
                for (var artifact in widget.museum.artifacts) {
                  await prefs.remove('${widget.museum.id}_${artifact.id}');
                  artifact.found = false;
                }
                await prefs.remove('visited_${widget.museum.id}');
                setState(() {
                  allTasksCompleted = false;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (showRewardTile && index == itemCount - 1) {
              return GestureDetector(
                onTap: _openRewardThankYouScreen,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Забрать награду',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }
            final artifact = widget.museum.artifacts[index];
            final type = artifact.type;
            final answer = artifact.answer;

            return GestureDetector(
              onTap: () async {
                dynamic result;
                if (type == 'photo') {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotoQuestScreen(
                        targetLabel: answer,
                        description: artifact.description,
                        hint: artifact.description,
                      ),
                    ),
                  );
                } else if (type == 'text') {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TextInputQuestScreen(
                        question: artifact.description,
                        correctAnswer: answer,
                      ),
                    ),
                  );
                } else if (type == 'qr') {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QrQuestScreen(description: artifact.description),
                    ),
                  );
                } else {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskScreen(
                        artifactName: artifact.name,
                        artifactDescription: artifact.description,
                        description: artifact.description,
                      ),
                    ),
                  );
                }

                if (result == true) markAsFound(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: artifact.found ? Colors.amber : Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    artifact.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
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

class RewardThankYouScreen extends StatelessWidget {
  const RewardThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поздравляем!')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Спасибо за прохождение нашего квеста!\nВы отлично справились!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                if (Platform.isIOS) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ARRewardIosScreen()),
                  );
                } else if (Platform.isAndroid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ARRewardAndroidScreen()),
                  );
                }
              },
              icon: const Icon(Icons.card_giftcard),
              label: const Text('Забрать награду'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
