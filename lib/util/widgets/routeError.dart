import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

typedef RefreshFunction = Future<void> Function();

class RouteErrorWidget extends StatelessWidget {
  const RouteErrorWidget(Map<String, dynamic> error, RefreshFunction onRefresh)
      : _error = error,
        _onRefresh = onRefresh;

  final Map<String, dynamic> _error;
  final RefreshFunction _onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => RefreshIndicator(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(Icons.error, size: 44),
                      Text(_error["reason"], textAlign: TextAlign.center).tr(namedArgs: {"route": _error["route"]}),
                    ],
                  ),
                ),
              ),
            ),
            onRefresh: _onRefresh,
          )),
    );
  }
}
