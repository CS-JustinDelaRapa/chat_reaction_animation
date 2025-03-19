import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionMenuContainer extends StatefulWidget {
  final Function(String?) onActionSelected;

  const ActionMenuContainer({
    Key? key,
    required this.onActionSelected,
  }) : super(key: key);

  @override
  State<ActionMenuContainer> createState() => ActionMenuContainerState();
}

class ActionMenuContainerState extends State<ActionMenuContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isClosing = false;

  final List<Map<String, dynamic>> _actions = const [
    {'icon': Icons.turn_left, 'label': 'Reply', 'color': Colors.white},
    {'icon': FontAwesomeIcons.copy, 'label': 'Copy', 'color': Colors.white},
    {'icon': FontAwesomeIcons.pencil, 'label': 'Edit', 'color': Colors.white},
    {'icon': FontAwesomeIcons.floppyDisk, 'label': 'Save', 'color': Colors.white},
    {'icon': Icons.turn_right, 'label': 'Forward', 'color': Colors.white},
    {'icon': FontAwesomeIcons.trashCan, 'label': 'Delete', 'color': Colors.redAccent},
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

  Future<void> closeContainer([String? action]) async {
    if (_isClosing) return;
    _isClosing = true;
    await _controller.reverse();
    if (!mounted) return;
    widget.onActionSelected(action);
  }

  Widget _buildActionButton(Map<String, dynamic> action) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => closeContainer(action['label']),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                action['label'] as String,
                style: TextStyle(
                  color: action['color'] as Color,
                  fontSize: 14,
                ),
              ),
              Icon(
                action['icon'] as IconData,
                color: action['color'] as Color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return ScaleTransition(
    scale: _scaleAnimation,
    child: FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        constraints: const BoxConstraints(
          maxHeight: 300, // Add a reasonable max height
          maxWidth: 250,  // Add a reasonable max width
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF252942),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),  // Add scroll physics
          itemCount: _actions.length,
          separatorBuilder: (context, index) => const Divider(height: 2, color:  Color(0xFF424660),),
          itemBuilder: (context, index) => _buildActionButton(_actions[index])
        ),
      ),
    ),
  );
}
}
