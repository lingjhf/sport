import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum InfiniteListState {
  //刷新
  refresh,

  //加载
  loading
}

enum InfiniteListPullDirection { down, up }

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



  void _pullDown(DragUpdateDetails details){

  }

  void _pullDownEnd(DragEndDetails details){

  }

  //监听子组件滚动是否溢出
  bool _scrollNotification(ScrollNotification notification) {
    if (notification is OverscrollNotification) {
      if (notification.overscroll < 0) {
      } else if (notification.overscroll > 0) {}
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
            recognizer.onUpdate = (DragUpdateDetails details) {
              if (_pullState == InfiniteListPullDirection.down) {
                _pullRefresh(details);
              }
            };
            recognizer.onEnd = (DragEndDetails details) {
              if (_pullState == InfiniteListPullDirection.down) {
                _pullRefreshEnd(details);
              }
            };
          },
        )
      },
      child: NotificationListener(
        onNotification: _scrollNotification,
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(),
        Expanded(child: _buildGestureDetector()),
        Container(),
      ],
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

class InfiniteLoadingAreaController with ChangeNotifier {
  double _height = 0;

  double get height => _height;

  void shrink(double value) {
    _height = value;
    notifyListeners();
  }
}

//是否处于下拉状态，如果可以，禁止滚动
//是否处于可回弹状态
//是否加载状态，加载中，不可以对加载区域操作
enum InfiniteLoading { pull, rebound, loading }

class InfiniteLoadingArea extends StatefulWidget {
  const InfiniteLoadingArea({
    super.key,
    required this.controller,
    this.height = 0,
  });

  final InfiniteLoadingAreaController controller;

  //当前高度
  final double height;

  @override
  State<StatefulWidget> createState() => _InfiniteLoadingAreaState();
}

class _InfiniteLoadingAreaState extends State<InfiniteLoadingArea>
    with SingleTickerProviderStateMixin {
  final double _height = 0.0;

  late AnimationController _animationController;

  late Animation<double> _animation;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _animationController = AnimationController(vsync: this);
    var curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InfiniteLoadingArea oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return SizedBox(
          height: _height,
        );
      },
    );
  }
}
