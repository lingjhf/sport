import 'package:flutter/material.dart';

class StandingsRow {
  const StandingsRow({
    required this.team,
    this.icon = '',
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.points = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
  });

  //队名
  final String team;

  final String icon;

  //场次
  final int played;

  //胜
  final int won;

  //平
  final int drawn;

  //负
  final int lost;

  //积分
  final int points;

  //进球
  final int goalsFor;

  //失球
  final int goalsAgainst;
}

class Standings extends StatelessWidget {
  const Standings({super.key, this.rows = const []});

  final List<StandingsRow> rows;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: const MaterialStatePropertyAll(Colors.blue),
      headingRowHeight: 34,
      columns: const [
        DataColumn(label: Text("排名")),
        DataColumn(label: Text("赛")),
        DataColumn(label: Text("胜")),
        DataColumn(label: Text("平")),
        DataColumn(label: Text("负")),
        DataColumn(label: Text("进失球")),
        DataColumn(label: Text("积分")),
      ],
      rows: [
        for (var row in rows)
          DataRow(
            cells: [
              DataCell(Text(row.team)),
              DataCell(Text('${row.played}')),
              DataCell(Text('${row.won}')),
              DataCell(Text('${row.drawn}')),
              DataCell(Text('${row.lost}')),
              DataCell(Text('${row.goalsFor}/${row.goalsAgainst}')),
              DataCell(Text('${row.points}')),
            ],
          )
      ],
    );
  }
}
