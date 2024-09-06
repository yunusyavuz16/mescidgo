import 'package:flutter/material.dart';

class LanguageSwitch extends StatefulWidget {
  final bool isTurkish;
  final ValueChanged<bool> onToggle;

  const LanguageSwitch({
    Key? key,
    required this.isTurkish,
    required this.onToggle,
  }) : super(key: key);

  @override
  _LanguageSwitchState createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch>
    with SingleTickerProviderStateMixin {
  late bool _isTurkish;

  @override
  void initState() {
    super.initState();
    _isTurkish = widget.isTurkish;
  }

  void _toggleSwitch() {
    setState(() {
      _isTurkish = !_isTurkish;
      widget.onToggle(_isTurkish);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 120,
        height: 50,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment:
                  _isTurkish ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _isTurkish ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  _isTurkish ? '' : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'EN',
                  style: TextStyle(
                    color: _isTurkish ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text(
                  'TR',
                  style: TextStyle(
                    color: _isTurkish ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
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