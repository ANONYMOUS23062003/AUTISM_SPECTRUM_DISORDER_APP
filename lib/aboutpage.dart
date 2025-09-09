import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the Autism App'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Why We Developed This App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Our autism app was developed to help parents, caregivers, and professionals detect and track autism-related behaviors in children. By providing tools for early assessment, personalized games, and progress tracking, we aim to support the development and well-being of children with autism. Our goal is to empower families with accessible resources to make informed decisions and foster growth.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Text(
                'Common Questions About Autism',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    QuestionAnswerTile(
                      question: 'What is autism?',
                      answer:
                          'Autism, or Autism Spectrum Disorder (ASD), is a developmental condition that affects communication, behavior, and social interactions. It is called a "spectrum" because it varies widely in severity and symptoms.',
                    ),
                    QuestionAnswerTile(
                      question: 'What are the early signs of autism?',
                      answer:
                          'Early signs may include delayed speech development, lack of eye contact, repetitive behaviors, limited interest in social interactions, and sensitivity to sensory stimuli.',
                    ),
                    QuestionAnswerTile(
                      question: 'What causes autism?',
                      answer:
                          'The exact causes of autism are unknown. Research suggests a combination of genetic and environmental factors may contribute to the condition.',
                    ),
                    QuestionAnswerTile(
                      question: 'Is there a cure for autism?',
                      answer:
                          'There is no cure for autism. However, early intervention therapies and support can help individuals develop skills and improve their quality of life.',
                    ),
                    QuestionAnswerTile(
                      question: 'How can I support a child with autism?',
                      answer:
                          'Support may include providing a structured environment, using visual aids, practicing patience, encouraging their strengths, and seeking professional therapy or guidance.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionAnswerTile extends StatelessWidget {
  final String question;
  final String answer;

  const QuestionAnswerTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
