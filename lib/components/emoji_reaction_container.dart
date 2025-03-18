import 'package:flutter/material.dart';

class EmojiReactionContainer extends StatefulWidget {
  final Function(String?) onEmojiSelected;

  const EmojiReactionContainer({
    Key? key,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  State<EmojiReactionContainer> createState() => EmojiReactionContainerState();
}

class EmojiReactionContainerState extends State<EmojiReactionContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isClosing = false;

  final List<String> _emojis = ['❤️', '😂', '😮', '😢', '😡', '👍'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> closeContainer([String? emoji]) async {
    if (_isClosing) return;
    _isClosing = true;
    await _controller.reverse();
    if (!mounted) return;
    widget.onEmojiSelected(emoji);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF252942),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _emojis.map((emoji) {
              return _buildEmojiButton(emoji);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return InkWell(
      onTap: () => closeContainer(emoji),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
