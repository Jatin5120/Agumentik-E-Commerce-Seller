import 'package:constants/constants.dart';
import 'package:e_commerce_seller/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    Key? key,
  }) : super(key: key);

  static final NavController _navController = Get.find();

  static const List<String> _icons = [
    'Shop Icon.svg',
    'Heart Icon.svg',
    'Chat bubble Icon.svg',
    'User Icon.svg',
  ];

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < _icons.length; i++) ...[
              Obx(
                () => IconButton(
                  onPressed: () {
                    _navController.currentIndex = i;
                  },
                  icon: SvgPicture.asset(
                    kIconsPath + _icons[i],
                    color: i == _navController.currentIndex ? kPrimaryColor : inActiveIconColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
