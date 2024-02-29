import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryTabs();
}

class _CategoryTabs extends State<CategoryTabs> with TickerProviderStateMixin {
  late final TabController _tabController;
  final tabs = <String>["英超", "西甲", "德甲", "意甲", "法甲", "欧冠", "国王杯", "足总杯"];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
                controller: _tabController,
                isScrollable: true,
                tabs: <Widget>[
                  for (var tab in tabs)
                    Tab(
                      text: tab,
                    ),
                ],
              ),
            ),
            TextButton(onPressed: () {}, child: const Text("更多"))
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              for (var tab in tabs)
                const Center(
                  child: Text("It's cloudy here"),
                )
            ],
          ),
        ),
      ],
    );
  }
}
