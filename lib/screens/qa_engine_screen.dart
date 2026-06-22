import 'package:flutter/material.dart';
import '../services/nexus_ai_service.dart';

class QaEngineScreen extends StatefulWidget {
  const QaEngineScreen({super.key});

  @override
  State<QaEngineScreen> createState() => _QaEngineScreenState();
}

class _QaEngineScreenState extends State<QaEngineScreen> {
  final _queryController = TextEditingController();
  final _aiService = NexusAiService();
  bool _isSimplified = false;
  bool _isLoading = false;
  String _sourceDocument = '';
  List<String> _answerSteps = [];

  void _submitQuery() async {
    if (_queryController.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _answerSteps = [];
    });

    final output = await _aiService.answerAcademicQuery(_queryController.text, _isSimplified);

    setState(() {
      _sourceDocument = output['source'] ?? 'Unknown Reference Block';
      _answerSteps = List<String>.from(output['steps'] ?? []);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grounded Q&A Engine', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Text('Simplify Jargon', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  Switch(
                    value: _isSimplified,
                    activeThumbColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (val) => setState(() => _isSimplified = val),
                  ),
                ],
              )
            ],
          ),
          const Text('Ask academic questions grounded directly in verified curriculum material.', style: TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'e.g., How do I solve system balancing constraints?',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    fillColor: const Color(0xFF1E293B),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _isLoading ? null : _submitQuery,
                icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  fixedSize: const Size(48, 48),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _answerSteps.isNotEmpty
                ? SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified, color: Color(0xFF10B981), size: 18),
                                const SizedBox(width: 6),
                                Expanded(child: Text('Grounded Context: $_sourceDocument', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                            const Divider(height: 24, color: Color(0xFF334155)),
                            Text(_isSimplified ? 'Intuitive Conceptual Breakdown:' : 'Step-by-Step Analytical Framework:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            ...List.generate(_answerSteps.length, (i) => _buildStep((i + 1).toString(), _answerSteps[i])),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(child: Text(_isLoading ? 'Running RAG processing engine...' : 'Submit a question to execute context document extraction.', style: const TextStyle(color: Color(0xFF64748B)))),
          )
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            child: Text(number, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.4))),
        ],
      ),
    );
  }
}