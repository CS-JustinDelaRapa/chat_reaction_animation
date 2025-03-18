import 'package:chat_reaction_animation/components/chat_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(Icons.chevron_left),
        ),
        titleSpacing: 0,
        title: Row(
          spacing: 8,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Image.asset('assets/images/avatar.png'),
            ),
            const Text('EPL Homies',
                style: TextStyle(
                  fontFamily: 'Druk',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
        actions: [
          _buildIconButton('assets/images/trophy.png'),
          const SizedBox(width: 8),
          _buildIconButton('assets/images/receipt.png'),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                _buildStatsButton('assets/images/coin.png', '400'),
                const SizedBox(width: 8),
                _buildStatsButton('assets/images/energy.png', '3')
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 19, 20, 34),
                border: Border.symmetric(
                  horizontal: BorderSide(color: Color(0xFF252942), width: 1),
                ),
              ),
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(16),
                children: const [
                  ChatMessage(
                    message: 'Did you catch the match last night? That last-minute goal was insane! And did you see how the defense just opened up? Classic case of "not tracking your man',
                    time: '13:00',
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            color: const Color(0xFF0b0c14),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white60,
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: const TextStyle(
                        color: Colors.white54
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF424660),
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF252942),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: const Icon(
                            Icons.sentiment_satisfied_alt,
                            color: Colors.white54,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161928),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF252942), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Image.asset(icon),
      )
    );
  }

  Widget _buildStatsButton(String icon, String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF161928),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF252942), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Druk',
                  fontSize: 16,
                  fontWeight: FontWeight.w700
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
