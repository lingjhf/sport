import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum InfiniteListState {
  //刷新
  refresh,

  //加载
  loading
}

enum InfiniteListPullDirection { down, up }

//是否处于下拉状态，如果可以，禁止滚动
//是否处于可回弹状态
//是否加载状态，加载中，不可以对加载区域操作
enum InfiniteLoading { pull, rebound, loading }

class InfiniteList extends StatefulWidget {
  const InfiniteList({
    super.key,
    this.finished = false,
    required this.child,
    this.onLoad,
  });

  final bool finished;

  final Widget child;

  final Future<void> Function(InfiniteListState state)? onLoad;

  @override
  State<StatefulWidget> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList>
    with SingleTickerProviderStateMixin {
  //拉的方向
  InfiniteListPullDirection? _pullDirection;

  late AnimationController _animationController;

  late CurvedAnimation _curve;

  late Animation<double> _animation;

  final _pullDownController = InfiniteListPullController();

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _animation = Tween(begin: 0.0, end: 0.0).animate(_curve);

    _animationController.addListener(() {
      setState(() {
        _pullDownController.height = _animation.value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _pullDownUpdate(DragUpdateDetails details) {
    _animationController.stop();
    var height = _pullDownController.height;
    print(height);
    _pullDownController.pullUpdate(details);
    if (_pullDownController.height != height) {
      setState(() {});
    }
  }

  //松开判断是否刷新
  void _pullDownEnd(DragEndDetails details) async {
    var height = _pullDownController.height;
    _pullDownController.pullEnd(details);
    if (_pullDownController.state == InfiniteLoading.pull) {
      setState(() {});
    } else {
      _animation =
          Tween(begin: height, end: _pullDownController.height).animate(_curve);
      _animationController.reset();
      _animationController.forward();
    }
  }

  //监听子组件滚动是否溢出
  bool _scrollNotification(ScrollNotification notification) {
    if (notification is OverscrollNotification) {
      if (notification.overscroll < 0) {
        _pullDirection = InfiniteListPullDirection.down;
      } else if (notification.overscroll > 0) {
        _pullDirection = InfiniteListPullDirection.up;
      }
    } else if (_pullDownController.state == null) {
      _pullDirection = null;
    }
    return true;
  }

  Widget _buildGestureDetector() {
    return RawGestureDetector(
      gestures: {
        _MyVerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            _MyVerticalDragGestureRecognizer>(
          () => _MyVerticalDragGestureRecognizer(),
          (_MyVerticalDragGestureRecognizer recognizer) {
            recognizer.onUpdate ??= (DragUpdateDetails details) {
              if (_pullDirection == InfiniteListPullDirection.down) {
                _pullDownUpdate(details);
              }
            };
            recognizer.onEnd ??= (DragEndDetails details) {
              if (_pullDirection == InfiniteListPullDirection.down) {
                _pullDownEnd(details);
              }
            };
          },
        )
      },
      child: NotificationListener(
        onNotification: _scrollNotification,
        child: ListView.builder(
          physics: _pullDownController.state == InfiniteLoading.pull
              ? const NeverScrollableScrollPhysics()
              : null,
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.green,
              height: 70,
              child: Text("$index"),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: _pullDownController.height, color: Colors.blue),
        Expanded(child: _buildGestureDetector()),
        Container(),
      ],
    );
  }
}

class _MyVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    // 单方面宣布自己胜出
    acceptGesture(pointer);
  }
}

class InfiniteListPullController {
  InfiniteLoading? state;

  double _pullStart = 0;

  double height = 0;

  final double maxHeight = 100;

  void pullUpdate(DragUpdateDetails details) {
    if (state == InfiniteLoading.loading) {
      return;
    }
    if (state != InfiniteLoading.pull) {
      state = InfiniteLoading.pull;
    }
    if (_pullStart == 0) {
      _pullStart = details.globalPosition.dy;
      return;
    }
    height = details.globalPosition.dy - _pullStart;
    if (height < 0) {
      height = 0;
    } else if (height > maxHeight) {
      height = maxHeight;
    }
  }

  //松开判断是否刷新
  void pullEnd(DragEndDetails details) async {
    if (state == InfiniteLoading.loading) {
      return;
    }
    _pullStart = 0;
    if (height < maxHeight) {
      state = InfiniteLoading.rebound;
      height = 0;
    } else {
      state = InfiniteLoading.loading;
      height = 60;
    }
  }
}
