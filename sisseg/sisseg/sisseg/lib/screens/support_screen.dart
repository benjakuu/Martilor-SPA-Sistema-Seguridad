import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: '¿Cómo cambio mi contraseña?',
      answer:
          'Para cambiar tu contraseña, ve a Configuraciones > Seguridad > Cambiar Contraseña. Deberás ingresar tu contraseña actual y la nueva contraseña dos veces.',
    ),
    FAQItem(
      question: '¿Cómo actualizo mis datos personales?',
      answer:
          'Puedes actualizar tus datos personales en la sección "Datos Personales" del menú principal. Allí encontrarás todos los campos editables.',
    ),
    FAQItem(
      question: '¿Cómo contacto al soporte técnico?',
      answer:
          'Puedes contactarnos a través del formulario de contacto en esta misma página, o escribirnos directamente a soporte@martilor.com',
    ),
  ];

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isUrgent = false;
  final List<Message> _chatMessages = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Soporte'),
          backgroundColor: Colors.purple.shade900,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: 'Chat'),
              Tab(icon: Icon(Icons.contact_mail), text: 'Contacto'),
              Tab(icon: Icon(Icons.help), text: 'FAQs'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.purple.shade900, const Color(0xFF1A1A2E)],
            ),
          ),
          child: TabBarView(
            children: [
              _buildChatTab(),
              _buildContactForm(),
              _buildFAQsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _chatMessages.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final message = _chatMessages[index];
              return _buildChatMessage(message);
            },
          ),
        ),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildChatMessage(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.purple.shade400 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                fillColor: Colors.white.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _chatMessages.add(Message(
          text: _messageController.text,
          isUser: true,
        ));
        // Simular respuesta automática
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _chatMessages.add(Message(
              text: 'Gracias por tu mensaje. Un agente te responderá pronto.',
              isUser: false,
            ));
          });
        });
      });
      _messageController.clear();
    }
  }

  Widget _buildContactForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'Asunto',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Mensaje',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          CheckboxListTile(
            title:
                const Text('Es urgente', style: TextStyle(color: Colors.white)),
            value: _isUrgent,
            onChanged: (value) => setState(() => _isUrgent = value!),
          ),
          ElevatedButton(
            onPressed: _submitContactForm,
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _submitContactForm() {
    if (_subjectController.text.isNotEmpty &&
        _messageController.text.isNotEmpty) {
      // Simular envío del formulario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensaje enviado correctamente')),
      );
      _subjectController.clear();
      _messageController.clear();
      setState(() => _isUrgent = false);
    }
  }

  Widget _buildFAQsList() {
    return ListView.builder(
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(
            _faqs[index].question,
            style: const TextStyle(color: Colors.white),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _faqs[index].answer,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
