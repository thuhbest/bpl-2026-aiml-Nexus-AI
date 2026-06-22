import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NexusAiService {
  late final GenerativeModel _model;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  bool _isInitialized = false;

  NexusAiService() {
    // DOUBLE DEFENSE: Explicitly verify initialization before reading keys
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isNotEmpty) {
        _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(responseMimeType: 'application/json'),
        );
        _isInitialized = true;
        debugPrint("Nexus AI Service successfully initialized with Live Gemini API.");
      } else {
        _isInitialized = false;
        debugPrint("Nexus AI running in Demo Mock Mode (Empty API Key).");
      }
    } catch (e) {
      _isInitialized = false;
      debugPrint("Nexus AI running in Demo Mock Mode (DotEnv fallback engaged): $e");
    }
  }

  /// 1. SEMANTIC MATCHMAKER (Project Discovery Engine)
  Future<List<Map<String, dynamic>>> discoverProjects(String userBio) async {
    if (!_isInitialized) return _getMockProjects();

    try {
      QuerySnapshot snapshot = await _firestore.collection('projects').get();
      List<Map<String, dynamic>> projectsList = [];
      
      if (snapshot.docs.isEmpty) {
        await _seedInitialProjects();
        snapshot = await _firestore.collection('projects').get();
      }

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        projectsList.add({
          'id': doc.id,
          'title': data['title'] ?? 'Untitled Project',
          'description': data['description'] ?? '',
        });
      }

      final prompt = '''
      You are an expert academic matchmaker. Analyze the student's background/interests and match them against the available campus projects.
      
      Student Profile: "$userBio"
      Available Projects Data: ${jsonEncode(projectsList)}
      
      Return a JSON array of objects with exactly these keys:
      "title": (string),
      "match": (integer),
      "reason": (string),
      "tags": (array of 2-3 short technical strings)
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final List<dynamic> decoded = jsonDecode(response.text ?? '[]');
      
      List<Map<String, dynamic>> matches = List<Map<String, dynamic>>.from(decoded);
      matches.sort((a, b) => (b['match'] as num).compareTo(a['match'] as num));
      return matches;
    } catch (e) {
      debugPrint("Error running Semantic Matchmaker: $e");
      return _getMockProjects();
    }
  }

  /// 2. GROUNDED Q&A ENGINE (Retrieval-Augmented Generation)
  Future<Map<String, dynamic>> answerAcademicQuery(String query, bool simplifyJargon) async {
    if (!_isInitialized) return _getMockAnswer(simplifyJargon);

    try {
      QuerySnapshot snapshot = await _firestore.collection('curriculum').get();
      if (snapshot.docs.isEmpty) {
        await _seedInitialCurriculum();
        snapshot = await _firestore.collection('curriculum').get();
      }

      String groundingContext = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return "Source: ${data['module']}\nContent: ${data['content']}";
      }).join("\n\n");

      final prompt = '''
      You are an elite Engineering teaching assistant. Answer the student's question using ONLY the verified curriculum data below.
      
      Verified Curriculum Reference Data:
      $groundingContext
      
      Student Question: "$query"
      
      Instructions:
      ${simplifyJargon 
        ? "Break down the solution using simplified, intuitive physical analogies suitable for a first-year student." 
        : "Provide a rigorous, step-by-step formal analytical derivation suitable for an advanced engineering student."}
      
      Return a JSON object containing exactly these keys:
      "source": (string),
      "steps": (array of strings)
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return jsonDecode(response.text ?? '{}') as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error running Grounded Q&A: $e");
      return _getMockAnswer(simplifyJargon);
    }
  }

  /// 3. CONCEPT GAP DIAGNOSTICS (Learning Path Generation)
  Future<Map<String, dynamic>> generateDiagnosticPathway(String conceptName) async {
    if (!_isInitialized) return _getMockDiagnostic(conceptName);

    try {
      final prompt = '''
      Analyze the core concept: "$conceptName".
      Return a JSON object with exactly these keys:
      "summary": (A clear 1-2 sentence core functional definition of the framework),
      "prereqs": (A comma-separated string listing 2-3 foundational baseline subjects needed beforehand),
      "mentors": (A string indicating support availability, e.g., "3 Senior Peer Mentors Available")
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return jsonDecode(response.text ?? '{}') as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error running Gap Diagnostics: $e");
      return _getMockDiagnostic(conceptName);
    }
  }

  // ==========================================
  // HACKATHON SEED ENGINE & SAFETY FALLBACKS
  // ==========================================
  Future<void> _seedInitialProjects() async {
    final batch = _firestore.batch();
    final projects = [
      {
        'title': 'Autonomous Rover Interface',
        'description': 'Building custom micro-firmware drivers, hardware integration lines, and structural PID feedback systems for high-performance automation platforms.'
      },
      {
        'title': 'IoT Smart Energy Monitor',
        'description': 'Engineering multi-node current sensor networks utilizing fundamental circuit analysis and low-power hardware-to-cloud telemetry paths.'
      }
    ];
    for (var p in projects) {
      batch.set(_firestore.collection('projects').doc(), p);
    }
    await batch.commit();
  }

  Future<void> _seedInitialCurriculum() async {
    final batch = _firestore.batch();
    final chunks = [
      {
        'module': 'EEE2046F Core Syllabus Module 3 (Statics & Systems)',
        'content': 'System vector balancing requires isolating the physical subcomponents into isolated free-body systems. Total vertical and horizontal forces must algebraically balance out to zero. Secondary moment constraints track physical twist vectors relative to structural pivot centers.'
      }
    ];
    for (var c in chunks) {
      batch.set(_firestore.collection('curriculum').doc(), c);
    }
    await batch.commit();
  }

  List<Map<String, dynamic>> _getMockProjects() => [
    {
      'title': 'Autonomous Rover Interface',
      'match': 96,
      'reason': 'Matches your interest in physical automation prototypes and embedded firmware controls.',
      'tags': ['Robotics', 'C++', 'Hardware']
    },
    {
      'title': 'IoT Smart Energy Monitor',
      'match': 84,
      'reason': 'Aligns with your experience in circuit analysis and hardware-software sensor interfaces.',
      'tags': ['IoT', 'Embedded Systems', 'Firebase']
    }
  ];

  Map<String, dynamic> _getMockAnswer(bool simplified) => {
    'source': 'EEE2046F Core Syllabus Module 3',
    'steps': simplified 
      ? [
          'Isolate the system\'s physical parts and draw pointing arrows for all forces acting on it.',
          'Sum up everything pushing or pulling horizontally and vertically to set your mathematical baseline.',
          'Double-check twisting forces around the central anchor to make sure it doesn\'t move.'
        ] 
      : [
          'Establish spatial vector equilibrium frameworks and map discrete component interactions.',
          'Execute an algebraic summation of orthogonal vectors relative to the primary plane constraints.',
          'Evaluate the secondary moment constraints about the structural pivot coordinates to prevent runtime calculation drift.'
        ]
  };

  Map<String, dynamic> _getMockDiagnostic(String name) => {
    'summary': 'A functional technical abstraction mapping $name parameters across computational system interfaces.',
    'prereqs': 'Linear Algebra, Structured Engineering Analysis',
    'mentors': '3 Active Peer Experts Available'
  };
}