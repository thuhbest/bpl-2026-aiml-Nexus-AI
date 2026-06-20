import 'package:flutter/material.dart';

class QaEngineScreen extends StatefulWidget {
  const QaEngineScreen({super.key});

  @override
  State<QaEngineScreen> createState() => _QaEngineScreenState();
}

class _QaEngineScreenState extends State<QaEngineScreen> {
  final _queryController = TextEditingController();
  bool _isSimplified = false;
  bool _hasAnswer = false;

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
              const Text(
                'Grounded Q&A Engine',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text('Simplify Jargon', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  Switch(
                    value: _isSimplified,
                    activeThumbColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (val) {
                      setState(() => _isSimplified = val);
                    },
                  ),
                ],
              )
            ],
          ),
          const Text(
            'Ask academic questions grounded directly in verified curriculum material.',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Ask an engineering concept or past proof query...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    fillColor: const Color(0xFF1E293B),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  if (_queryController.text.trim().isNotEmpty) {
                    setState(() => _hasAnswer = true);
                  }
                },
                icon: const Icon(Icons.send),
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
            child: _hasAnswer
                ? SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.verified, color: Color(0xFF10B981), size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Grounded Context: EEE2046F Core Syllabus Module 3',
                                  style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                            const Divider(height: 24, color: Color(0xFF334155)),
                            Text(
                              _isSimplified 
                                ? 'Here is a simple, intuitive layout breakdown:' 
                                : 'Step-by-Step Analytical Execution Framework:',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            _buildStep(
                              '1', 
                              _isSimplified 
                                ? 'Isolate the system\'s physical parts and draw pointing arrows for all forces acting on it.' 
                                : 'Establish spatial vector equilibrium frameworks and map discrete component interactions.'
                            ),
                            _buildStep(
                              '2', 
                              _isSimplified 
                                ? 'Sum up everything pushing or pulling horizontally and vertically to set your mathematical baseline.' 
                                : 'Execute an algebraic summation of orthogonal vectors relative to the primary plane constraints.'
                            ),
                            _buildStep(
                              '3', 
                              _isSimplified 
                                ? 'Double-check twisting forces around the central anchor to make sure it doesn\'t move.' 
                                : 'Evaluate the secondary moment constraints about the structural pivot coordinates to prevent runtime calculation drift.'
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'Submit a curriculum question to trigger RAG document extraction.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
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
          Expanded(
            child: Text(text, style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.4)),
          ),
        ],
      ),
    );
  }
}