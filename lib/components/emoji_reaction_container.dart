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

  final List<String> _emojiAssets = const [
    'assets/emojis/emoji_1.png',
    'assets/emojis/emoji_2.png',
    'assets/emojis/emoji_3.png',
    'assets/emojis/emoji_4.png',
    'assets/emojis/emoji_5.png',
    'assets/emojis/emoji_6.png',
    'assets/emojis/emoji_7.png',
  ];

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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF252942),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...(_emojiAssets)
                  .map((emoji) => _buildEmojiButton(emoji))
                  .toList(),
              const SizedBox(width: 4),
              _buildExpandButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emojiAsset) {
    bool isPressed = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          onTap: () => closeContainer(emojiAsset),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedScale(
              scale: isPressed ? 1.5 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Image.asset(
                emojiAsset,
                width: 28,
                height: 28,
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildExpandButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF424660),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.expand_more,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
