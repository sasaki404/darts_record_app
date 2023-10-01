import 'package:darts_record_app/page/calendar_page.dart';
import 'package:darts_record_app/page/home_page.dart';
import 'package:darts_record_app/page/setting_page.dart';
import 'package:darts_record_app/provider/target_index.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetIndex = ref.watch(targetIndexNotifierProvider);
    const pages = [
      HomePage(),
      CalendarPage(),
      SettingPage(),
    ]; // ナビゲーションバーのアイテム
    const items = [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 25,
        ),
        label: "ホーム",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.calendar_month_outlined,
          size: 25,
        ),
        label: "カレンダー",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
          size: 25,
        ),
        label: "設定",
      ),
    ];
    final bar = BottomNavigationBar(
      items: items,
      backgroundColor: AppColor.black, // バーの色
      selectedItemColor: AppColor.blue, // 選ばれたアイテムの色
      unselectedItemColor: AppColor.white, // 選ばれていないアイテムの色
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: targetIndex,
      onTap: (index) {
        // タップされたときインデックスを変更する
        ref.read(targetIndexNotifierProvider.notifier).setIndex(index);
      },
      elevation: 0,
    );
    return ColoredBox(
      color: AppColor.darkGrey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.darkGrey,
          body: pages[targetIndex],
          bottomNavigationBar: bar,
        ),
      ),
    );
  }
}
