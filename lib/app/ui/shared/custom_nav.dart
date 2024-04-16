import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixel_insurance_v2/app/ui/settings/settings.dart';
import 'package:pixel_insurance_v2/app/ui/home/home_page.dart';
import 'package:pixel_insurance_v2/app/ui/home/homepage_packages.dart';
import 'package:pixel_insurance_v2/app/ui/theme/app_colors.dart';

import '../insurance/my_insurance.dart';

class CustomNav extends StatelessWidget {
  const CustomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      enableFeedback: true,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black87,
      showUnselectedLabels: true,
      selectedItemColor: primary,
      currentIndex: currentIndex,
      onTap: (val) {
        switch (val) {
          case 0:
            Get.off(
              () => HomePage(),
              transition: Transition.noTransition,
            );
            break;
          case 1:
            Get.off(
              () => const HomePagePackages(),
              transition: Transition.noTransition,
            );
            break;
          case 2:
            Get.off(
              () => const MyInsurance(),
              transition: Transition.noTransition,
            );
            break;
          case 3:
            Get.off(
              () => const SettingsPage(),
              transition: Transition.noTransition,
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: 30.0,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.layers_outlined,
            size: 30.0,
          ),
          label: 'Packages',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_bag_outlined,
            size: 30.0,
          ),
          label: 'My Insurances',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            size: 30.0,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
