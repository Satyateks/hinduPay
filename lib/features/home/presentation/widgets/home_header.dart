import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color:Color(0xFFF70101),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ॐ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(onPressed: () {},icon: Icon(Icons.search, size: 23, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 24, color: Colors.white)),
        ],
      ),
    );
  }
}

