# Nexus AI — The Intelligent Student Co-Pilot

An intelligent orchestration layer designed to help students bridge the gap between theoretical knowledge, academic support, and practical project discovery.

---

## 📌 Project Overview

* **Selected Track:** Solo Developer Track
* **Hackathon Challenge / Problem Statement:** *AI/ML: Build an intelligent feature that helps students discover projects, get answers, or receive relevant learning support.*

---

## 💡 Solution Summary

**Nexus AI** consolidates three core student needs—discovery, academic QA, and micro-learning—into a single, cohesive intelligent dashboard. Instead of disjointed tools, Nexus AI treats a student's current curriculum, knowledge gaps, and project ambitions as an interconnected web using semantic embeddings and vector search.

The system is split into three main modules:

1. **Semantic Matchmaker (Project Discovery):** Moving away from rigid keyword or tag-based searches, this module uses text embeddings to match students with open campus projects based on natural language bios, current courses, or casual interest descriptions.
2. **Grounded Q&A Engine (Get Answers):** A Retrieval-Augmented Generation (RAG) pipeline localized to verified student coursework, lecture notes, and textbook content. It delivers structured, step-by-step breakdowns rather than generic chatbot responses, complete with conceptual source citations.
3. **Concept Gap Diagnostics (Learning Support):** When browsing advanced projects or complex solutions, students can highlight dense technical terms. The AI instantly generates a micro-learning pathway containing a 3-bullet core summary, essential prerequisites, and links to peer mentors who have mastered the topic.

---

## 🛠️ Architecture & Tech Stack

* **Frontend:** Flutter (Cross-platform iOS, Android, and Web delivery)
* **Backend & Database:** Firebase (Cloud Firestore & Cloud Functions)
* **AI/Vector Layer:** Google Gemini API (for advanced text embeddings, semantic matching, and structured JSON generation)
* **Vector Database:** Firebase Vector Search extension (leveraging Google Cloud Vertex AI)

---

## 🚀 Setup & Installation Steps

Follow these steps to set up and run the project locally.

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
* [Firebase CLI](https://firebase.google.com/docs/cli) installed and authenticated.
* A Gemini API key from [Google AI Studio](https://aistudio.google.com/).

### 1. Clone the Repository
```bash
git clone [https://github.com/your-username/nexus-ai.git](https://github.com/your-username/nexus-ai.git)
cd nexus-ai
