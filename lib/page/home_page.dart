import 'package:darts_record_app/page/game/list_page.dart';
import 'package:darts_record_app/page/record/record_page.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.black,
        appBar: TabBar(
          labelColor: AppColor.lightGrey,
          indicatorColor: AppColor.blue,
          tabs: [
            Tab(text: 'GAME'),
            Tab(text: 'RECORD'),
          ],
        ),
        body: TabBarView(
          children: [
            ListPage(),
            RecordPage(),
          ],
        ),
      ),
    );
  }
}
