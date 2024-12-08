import 'package:flutter/material.dart';
import '../database/database_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseService.instance.getHistory();
    setState(() {
      history = data;
    });
  }

  Future<void> _deleteHistory(int id) async {
    final db = await DatabaseService.instance.database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('No history found.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  leading: Icon(
                    entry['status'] == 'pass'
                        ? Icons.check_circle
                        : Icons.error,
                    color:
                        entry['status'] == 'pass' ? Colors.green : Colors.red,
                  ),
                  title: Text(entry['name']),
                  subtitle: Text('${entry['date']} at ${entry['time']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteHistory(entry['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: {
                              'name': entry['name'],
                              'status': entry['status'],
                              'details':
                                  'Detailed results for ${entry['name']}',
                              'recommendations': [
                                'Recommendation 1 for ${entry['name']}',
                                'Recommendation 2 for ${entry['name']}',
                              ],
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
