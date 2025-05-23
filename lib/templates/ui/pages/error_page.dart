const errorPageTemplate = '''import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Page')),
      body: const Center(child: Text('An error has occurred.')),
    );
  }
}''';

String generateErrorPage(String projectName) {
  return errorPageTemplate;
}
