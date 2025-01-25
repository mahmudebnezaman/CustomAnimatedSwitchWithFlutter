import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color buttonColor;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String activeText;
  final String inactiveText;
  final TextStyle? textStyle;
  final double width;
  final double height;
  final double buttonSize;

  const CustomSwitch({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.buttonColor = Colors.white,
    this.activeIcon = Icons.check,
    this.inactiveIcon = Icons.close,
    this.activeText = 'On',
    this.inactiveText = 'Off',
    this.textStyle,
    this.width = 140,
    this.height = 50,
    this.buttonSize = 40,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late bool _isOn;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (_isOn) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSwitch() {
    setState(() {
      _isOn = !_isOn;
      if (_isOn) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.onChanged(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: _isOn ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: !_isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _isOn ? widget.activeText : widget.inactiveText,
                  style: widget.textStyle ?? const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.buttonSize,
                height: widget.buttonSize,
                decoration: BoxDecoration(
                  color: widget.buttonColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Icon(
                    _isOn ? widget.activeIcon : widget.inactiveIcon,
                    color: _isOn ? widget.activeColor : widget.inactiveColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Switch Widget'),
        ),
        body: Center(
          child: CustomSwitch(
            initialValue: false,
            onChanged: (value) {
              print('Switch is now: $value');
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
            buttonColor: Colors.white,
            activeIcon: Icons.thumb_up,
            inactiveIcon: Icons.thumb_down,
            activeText: 'Active',
            inactiveText: 'Inactive',
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            width: 160,
            height: 60,
            buttonSize: 45,
          ),
        ),
      ),
    );
  }
}
