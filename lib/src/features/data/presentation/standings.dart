
class StandingsRow  {

  const StandingsRow({
    required this.team,
    this.played = 0,
    this.won = 0,
    this.lost = 0,
    this.points = 0,
    this.position = 0,
  });
  
  //队名
  final String team;
  
  //场次
  final int played;
  
  //胜
  final int won;

  //负
  final int lost;

  //积分
  final int points;

  //排名
  final int position;
}