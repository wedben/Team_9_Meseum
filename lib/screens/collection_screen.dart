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
import 'dart:math';

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
  final Map<String, int> _artifactFrames = {};
  final Set<int> _usedFrames = {};
  final Map<String, int> _artifactDoFrames = {};
  final Set<int> _usedDoFrames = {};

  @override
  void initState() {
    super.initState();
    _loadArtifactStates().then((_) {
      _assignDoFramesIfNeeded();
      setState(() {});
    });
  }

  Future<void> _loadArtifactStates() async {
    final prefs = await SharedPreferences.getInstance();
    bool allFound = true;
    _usedFrames.clear();
    _usedDoFrames.clear();

    for (var artifact in widget.museum.artifacts) {
      bool found = prefs.getBool('${widget.museum.id}_${artifact.id}') ?? false;
      artifact.found = found;
      if (!found) allFound = false;
      // Загружаем индекс рамки для выполненных квестов природы
      if (widget.museum.id == 'nature_museum') {
        int? frameIdx = prefs.getInt('nature_museum_${artifact.id}_frame');
        if (frameIdx != null) {
          _artifactFrames[artifact.id] = frameIdx;
          _usedFrames.add(frameIdx);
        }
      }
    }

    setState(() {
      allTasksCompleted = allFound;
    });
  }

  Future<void> _saveArtifactState(Artifact artifact, bool found) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.museum.id}_${artifact.id}', found);
    // Для выполненных квестов природы — распределение рамки
    if (widget.museum.id == 'nature_museum' && found && !_artifactFrames.containsKey(artifact.id)) {
      int idx;
      if (_usedFrames.length < 3) {
        final all = [0, 1, 2];
        final unused = all.where((i) => !_usedFrames.contains(i)).toList();
        idx = (unused..shuffle()).first;
      } else {
        _usedFrames.clear();
        idx = Random().nextInt(3);
      }
      await prefs.setInt('nature_museum_${artifact.id}_frame', idx);
      _artifactFrames[artifact.id] = idx;
      _usedFrames.add(idx);
    }
  }

  void _assignDoFramesIfNeeded() {
    if (widget.museum.id != 'nature_museum') return;
    _usedDoFrames.clear();
    _artifactDoFrames.clear();
    
    for (var artifact in widget.museum.artifacts) {
      if (!artifact.found) {
        int idx;
        if (_usedDoFrames.length < 3) {
          final all = [0, 1, 2];
          final unused = all.where((i) => !_usedDoFrames.contains(i)).toList();
          idx = (unused..shuffle()).first;
        } else {
          _usedDoFrames.clear();
          idx = Random().nextInt(3);
        }
        _artifactDoFrames[artifact.id] = idx;
        _usedDoFrames.add(idx);
      }
    }
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
            builder: (context) => AlertDialog(
              title: Text('Поздравляем!'),
              content: Text('Вы выполнили все задания квеста!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ОК'),
                ),
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
      MaterialPageRoute(
        builder: (_) => RewardThankYouScreen(
          museumId: widget.museum.id == 'nature_museum' ? 'nature_museum' : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showRewardTile = widget.museum.id == 'nature_museum' && allTasksCompleted;
    final itemCount = widget.museum.artifacts.length + (showRewardTile ? 1 : 0);
    final isNature = widget.museum.id == 'nature_museum';

    return Scaffold(
      appBar: isNature ? null : AppBar(
        title: Text('Квест:  ${widget.museum.name}'),
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
                  if (widget.museum.id == 'nature_museum') {
                    await prefs.remove('nature_museum_${artifact.id}_frame');
                    _artifactFrames.remove(artifact.id);
                    _usedFrames.clear();
                  }
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
      body: Stack(
        children: [
          if (isNature)
            Image.asset(
              'assets/sprite/ramk_Shapk/shapk.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          Column(
            children: [
              if (isNature)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Text(
                                'Квест: ${widget.museum.name}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline, color: Colors.black),
                          tooltip: 'История музея',
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
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.black),
                          tooltip: 'Сбросить прогресс',
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Сбросить прогресс?'),
                                content: const Text('Вы уверены, что хотите сбросить прогресс по всем квестам этого музея?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Сбросить')),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              final prefs = await SharedPreferences.getInstance();
                              for (var artifact in widget.museum.artifacts) {
                                await prefs.remove('${widget.museum.id}_${artifact.id}');
                                artifact.found = false;
                                if (widget.museum.id == 'nature_museum') {
                                  await prefs.remove('nature_museum_${artifact.id}_frame');
                                  _artifactFrames.remove(artifact.id);
                                  _usedFrames.clear();
                                }
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
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/sprite/ramk_Shapk/ramk_after_reward.png',
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Забрать награду',
                      textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black12,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                                  museumId: widget.museum.id == 'nature_museum' ? 'nature_museum' : null,
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
                                  museumId: widget.museum.id == 'nature_museum' ? 'nature_museum' : null,
                      ),
                    ),
                  );
                } else if (type == 'qr') {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                                builder: (_) => QrQuestScreen(
                                  description: artifact.description,
                                  museumId: widget.museum.id == 'nature_museum' ? 'nature_museum' : null,
                                ),
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
                                  museumId: widget.museum.id == 'nature_museum' ? 'nature_museum' : null,
                      ),
                    ),
                  );
                }

                if (result == true) markAsFound(index);
              },
                        child: widget.museum.id == 'nature_museum'
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    artifact.found
                                        ? [
                                            'assets/sprite/ramk_Shapk/ramk_after1.png',
                                            'assets/sprite/ramk_Shapk/ramk_after2.png',
                                            'assets/sprite/ramk_Shapk/ramk_after3.png',
                                          ][_artifactFrames[artifact.id] ?? 0]
                                        : [
                                            'assets/sprite/ramk_Shapk/ramk_do1.png',
                                            'assets/sprite/ramk_Shapk/ramk_do2.png',
                                            'assets/sprite/ramk_Shapk/ramk_do3.png',
                                          ][_artifactDoFrames[artifact.id] ?? 0],
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      (artifact.name == 'Найди настоящего махаона') ||
                                      (index == 0 && artifact.name == 'Самый крупный экспонат')
                                          ? artifact.name.split(' ').join('\n')
                                          : artifact.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4,
                                            color: Colors.black12,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RewardThankYouScreen extends StatelessWidget {
  final String? museumId;
  const RewardThankYouScreen({super.key, this.museumId});

  @override
  Widget build(BuildContext context) {
    final isNature = museumId == 'nature_museum';
    return Scaffold(
      appBar: isNature ? null : AppBar(title: const Text('Поздравляем!')),
      body: Stack(
        children: [
          if (isNature)
            Image.asset(
              'assets/sprite/ramk_Shapk/shapk.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          Column(
            children: [
              if (isNature)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: const Text(
                                'Поздравляем!',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
