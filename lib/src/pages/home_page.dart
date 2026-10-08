import 'package:flutter/material.dart';
import '../models/home_model.dart';
import '../services/db_helper.dart';
import '../services/analysis_service.dart';
import 'add_home_page.dart';
import 'report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeModel> _homes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomes();
  }

  Future<void> _loadHomes() async {
    setState(() {
      _isLoading = true;
    });

    final homes = await DbHelper.instance.getHomes();
    for (var home in homes) {
      if (home.readinessScore == null) {
        final score = AnalysisService.calculateReadinessScore(home);
        final updatedHome = home.copyWith(readinessScore: score);
        await DbHelper.instance.updateHome(updatedHome);
        homes[homes.indexOf(home)] = updatedHome;
      }
    }

    setState(() {
      _homes = homes;
      _isLoading = false;
    });
  }

  Future<void> _deleteHome(int id) async {
    await DbHelper.instance.deleteHome(id);
    _loadHomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PowerReady'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _homes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 64,
                        color: Color(0xFF6A6A6A),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'لا توجد منازل محفوظة',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddHomePage(),
                            ),
                          ).then((_) => _loadHomes());
                        },
                        child: const Text('إضافة منزل جديد'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadHomes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _homes.length,
                    itemBuilder: (context, index) {
                      final home = _homes[index];
                      final score = home.readinessScore ?? 0.0;
                      Color scoreColor = _getScoreColor(score);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            home.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'الموقع: ${home.location}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFB0B0B0),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'الجاهزية: ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFB0B0B0),
                                    ),
                                  ),
                                  Text(
                                    '${score.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: scoreColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: const Color(0xFFFF5252),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('تأكيد الحذف'),
                                  content: Text('هل تريد حذف ${home.name}؟'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('إلغاء'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteHome(home.id!);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'حذف',
                                        style:
                                            TextStyle(color: Color(0xFFFF5252)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportPage(home: home),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHomePage(),
            ),
          ).then((_) => _loadHomes());
        },
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.add, color: Color(0xFF000000)),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) {
      return const Color(0xFF00E676);
    } else if (score >= 60) {
      return const Color(0xFFFFC107);
    } else if (score >= 40) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFFF5252);
    }
  }
}

