import 'package:flutter/material.dart';
import '../services/nexus_ai_service.dart';

class ProjectDiscoveryScreen extends StatefulWidget {
  const ProjectDiscoveryScreen({super.key});

  @override
  State<ProjectDiscoveryScreen> createState() => _ProjectDiscoveryScreenState();
}

class _ProjectDiscoveryScreenState extends State<ProjectDiscoveryScreen> {
  final _bioController = TextEditingController();
  final _aiService = NexusAiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _matchedProjects = [];

  void _findMatches() async {
    if (_bioController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    final results = await _aiService.discoverProjects(_bioController.text);

    setState(() {
      _matchedProjects = results;
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
          const Text('Semantic Matchmaker', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          const Text('Tell Nexus AI what you want to build or study to find conceptually aligned campus projects.', style: TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'e.g., I am an electrical student wanting to try building a physical automation prototype...',
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              fillColor: const Color(0xFF1E293B),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _findMatches,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.bolt),
              label: Text(_isLoading ? 'Analyzing Live Vectors...' : 'Discover Projects'),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: Text('Scanning conceptual knowledge graphs...'))
                : _matchedProjects.isEmpty
                    ? const Center(child: Text('Enter your interests above to generate AI project pairings.', style: TextStyle(color: Color(0xFF64748B))))
                    : ListView.builder(
                        itemCount: _matchedProjects.length,
                        itemBuilder: (context, index) {
                          final project = _matchedProjects[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(project['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: const Color(0xFF06B6D4).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                                        child: Text('${project['match']}% Match', style: const TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold, fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(project['reason'] ?? '', style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: ((project['tags'] ?? []) as List<dynamic>).map((tag) {
                                      return Chip(
                                        label: Text(tag.toString(), style: const TextStyle(fontSize: 11)),
                                        backgroundColor: const Color(0xFF334155),
                                        side: BorderSide.none,
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}