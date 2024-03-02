import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum InfiniteListState {
  //刷新
  refresh,

  //加载
  loading
}

enum InfiniteListPullState { down, up }

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
  InfiniteListPullState? _pullState;

  //开始下拉位置
  double _startPullRefreshY = 0;

  bool _isReboundPullRefresh = false;

  bool _isRefreshing = false;

  double _top = 0;

  final double _maxTop = 100;

  late AnimationController _animationController;

  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    var curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    animation = Tween(begin: _maxTop, end: 60.0).animate(curve);
    _animationController.addListener(() {
      setState(() {
        _top = animation.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetPullRefresh() {
    setState(() {
      _top = 0;
      _startPullRefreshY = 0;
      _isReboundPullRefresh = false;
    });
  }

  // 触发下拉刷新
  void _pullRefresh(DragUpdateDetails details) {
    if (_isRefreshing) {
      return;
    }
    if (_startPullRefreshY == 0) {
      _startPullRefreshY = details.globalPosition.dy;
      return;
    }
    var top = details.globalPosition.dy - _startPullRefreshY;
    if (top < 0) {
      top = 0;
    } else if (top > _maxTop) {
      top = _maxTop;
    }
    if (top != _top) {
      setState(() {
        _top = top;
      });
    }

    //触发
    if (top == _maxTop) {
      _isReboundPullRefresh = false;
    } else {
      _isReboundPullRefresh = true;
    }
  }

  void _pullRefreshEnd(DragEndDetails details) async {
    if (_isRefreshing) {
      return;
    }
    if (_isReboundPullRefresh) {
      _resetPullRefresh();
    } else {
      _animationController.reset();
      _animationController.forward();
      _isRefreshing = true;
      await Future.delayed(const Duration(seconds: 2));
      _isRefreshing = false;
      _resetPullRefresh();
    }
  }

  void _pullLoading(DragUpdateDetails details) {}

  void _pullLoadingEnd(DragEndDetails details) async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: RawGestureDetector(
        gestures: {
          _MyVerticalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  _MyVerticalDragGestureRecognizer>(
            () => _MyVerticalDragGestureRecognizer(),
            (_MyVerticalDragGestureRecognizer recognizer) {
              recognizer.onUpdate = (DragUpdateDetails details) {
                if (_pullState == InfiniteListPullState.down) {
                  _pullRefresh(details);
                }
              };
              recognizer.onEnd = (DragEndDetails details) {
                if (_pullState == InfiniteListPullState.down) {
                  _pullRefreshEnd(details);
                }
              };
            },
          )
        },
        child: Column(
          children: [
            SizedBox(
              height: _top,
              child: const Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: NotificationListener(
                child: ListView.builder(
                  physics: _isReboundPullRefresh
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
                onNotification: (ScrollNotification notification) {
                  //滚动到顶部，触发下拉刷新
                  if (notification is OverscrollNotification) {
                    if (notification.overscroll < 0 &&
                        _pullState != InfiniteListPullState.down) {
                      _pullState = InfiniteListPullState.down;
                    } else if (notification.overscroll > 0 &&
                        _pullState != InfiniteListPullState.up) {
                      _pullState = InfiniteListPullState.up;
                    }
                  }
                  return false;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MyVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  bool needDrag = true;

  @override
  void rejectGesture(int pointer) {
    // 单方面宣布自己胜出
    acceptGesture(pointer);
  }
}
