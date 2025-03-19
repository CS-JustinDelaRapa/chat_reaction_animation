// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'emoji_reaction_container.dart';

class ChatMessage extends StatefulWidget {
  final String message;
  final String time;

  const ChatMessage({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> with SingleTickerProviderStateMixin {
  final GlobalKey<EmojiReactionContainerState> _emojiKey = GlobalKey<EmojiReactionContainerState>();
  
  late final AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  
  bool _isLongPressed = false;
  OverlayEntry? _overlayEntry;
  Size? _cachedScreenSize;
  Size? _cachedMessageSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 75),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() async {
    // First reverse the emoji container animation
    await _emojiKey.currentState?.closeContainer(null);
    // Then reverse the message animation and remove overlay
    await _controller.reverse();
    _overlayEntry?.remove();
    setState(() => _isLongPressed = false);
  }

  void _showOverlay(BuildContext context, RenderBox box, Offset position) {
    // Cache screen and message sizes
    _cachedScreenSize = MediaQuery.of(context).size;
    _cachedMessageSize = box.size;
    
    // Calculate the initial position (where the user long-pressed)
    // Convert absolute coordinates to relative (0-1) for easier animation
    final startOffset = Offset(
      position.dx / _cachedScreenSize!.width,
      position.dy / _cachedScreenSize!.height,
    );
    
    // Calculate the final position for the overlay
    // Position the message on the right side of the screen (80% of screen width)
    // and vertically centered
    final endOffset = Offset(
      position.dx / _cachedScreenSize!.width,
      (_cachedScreenSize!.height - _cachedMessageSize!.height) / (2 * _cachedScreenSize!.height),
    );

    // Create a sliding animation that moves the message
    // from the long-press position to the center-right position
    _slideAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInToLinear,
    ));

    _overlayEntry = OverlayEntry(
      builder: (context) => RepaintBoundary(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) => _removeOverlay(),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5 * _controller.value,
                        sigmaY: 5 * _controller.value,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.5 * _controller.value),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: _slideAnimation.value.dx * _cachedScreenSize!.width,
                top: (_slideAnimation.value.dy * _cachedScreenSize!.height)-(_cachedMessageSize!.height * 1.85),
                child: EmojiReactionContainer(
                  key: _emojiKey,
                  onEmojiSelected: (emoji) {
                    if (emoji == null) {
                      _removeOverlay();
                    } else {
                      // Handle emoji selection here
                      _removeOverlay();
                    }
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Positioned(
                  right: _slideAnimation.value.dx * _cachedScreenSize!.width,
                  top: _slideAnimation.value.dy * _cachedScreenSize!.height,
                  child: child!,
                ),
                child: _buildMessageContainer(context),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  Widget _buildMessageContainer(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFF4A148C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.time,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!_isLongPressed) {
          setState(() => _isLongPressed = true);
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset position = box.localToGlobal(Offset.zero);
          _showOverlay(context, box, position);
        }
      },
      child: Opacity(
        opacity: _isLongPressed ? 0.0 : 1.0,
        child: Align(
          alignment: Alignment.centerRight,
          child: _buildMessageContainer(context),
        ),
      ),
    );
  }
}