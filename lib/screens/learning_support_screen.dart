import 'package:flutter/material.dart';

class LearningSupportScreen extends StatelessWidget {
  const LearningSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final concepts = [
      {
        'name': 'Fourier Transforms',
        'summary': 'A mathematical tool used to break down a continuous time signal into its separate baseline operational frequencies.',
        'prereqs': 'Integral Calculus, Complex Numbers',
        'mentors': '3 Senior Peer Mentors Available',
      },
      {
        'name': 'NoSQL Database Sharding',
        'summary': 'A database architecture practice that breaks up large data collections horizontally across independent server hardware pools.',
        'prereqs': 'Horizontal Scaling Principles, Primary Key Hashing',
        'mentors': '2 Postgraduate Mentors Available',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Concept Gap Diagnostics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Instantly identify structural prerequisites and local learning networks for complex engineering components.',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: concepts.length,
              itemBuilder: (context, index) {
                final concept = concepts[index];
                return ExpansionTile(
                  title: Text(concept['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text('Tap to review localized diagnostic pathway', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12)),
                  backgroundColor: const Color(0xFF1E293B),
                  collapsedBackgroundColor: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  childrenPadding: const EdgeInsets.all(16),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Core Framework Summary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF94A3B8))),
                        const SizedBox(height: 4),
                        Text(concept['summary']!, style: const TextStyle(color: Color(0xFFE2E8F0))),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.layers_outlined, size: 16, color: Color(0xFF6366F1)),
                            const SizedBox(width: 6),
                            Text('Required Prerequisites: ${concept['prereqs']}', style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.group_outlined, size: 16, color: Color(0xFF06B6D4)),
                            const SizedBox(width: 6),
                            Text('Campus Ecosystem Network: ${concept['mentors']}', style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
                          ],
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}