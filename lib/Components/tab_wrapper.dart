import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class TabWrapper extends StatefulWidget {
  const TabWrapper({Key? key}) : super(key: key);

  @override
  State<TabWrapper> createState() => _TabWrapperState();
}

class _TabWrapperState extends State<TabWrapper> with SingleTickerProviderStateMixin {
  late final TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _tabHeight = MediaQuery.of(context).size.height * 0.6;
    return Center(
      widthFactor: 8.0,
      child: SizedBox(
        height: _tabHeight,
        child: TabContainer(
          controller: _tabController,
          childPadding: EdgeInsets.all(10.0),
          tabBorderRadius: BorderRadius.circular(10.0),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.amber,
          curve: Curves.easeIn,
          tabEdge: TabEdge.left,
          tabMinLength: 150,
          tabsStart: 0.1,
          tabsEnd: 0.9,
          tabs: [
            Tab(
              text: 'About Me',
              icon: Icon(Icons.person),
              iconMargin: EdgeInsets.all(3.0),
              height: 60,
            ),
            Tab(text: 'Work Experience', icon: Icon(Icons.work),iconMargin: EdgeInsets.all(3.0),
              height: 60,),
            Tab(text: 'Projects', icon: Icon(Icons.code),iconMargin: EdgeInsets.all(3.0),
              height: 60,),
          ],
          children: <Widget>[
              Text('Let me introduce myself!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
              Text('Let\'s talk about my work experience!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
              Text('Some of my projects!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
            ],
        ),
      ),
    );
  }
}
