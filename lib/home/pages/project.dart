import 'package:flutter/material.dart';
import 'package:flutter_wheel/network/httputil.dart';
import 'package:flutter_wheel/network/Tree.dart';
import 'package:flutter_wheel/home/common_refresh_listview.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with AutomaticKeepAliveClientMixin {
  TreeBean treeBean;
  List<Tab> mTabs = [];

  _getTabBarTitles() {
    var url = HttpUtils.getUrl(article: HttpUtils.ProjectTree);
    HttpController.getData(url, (data) {
      print(data.toString());
      if (!mounted) return;
      setState(() {
        treeBean = TreeBean.fromJson(data);
        mTabs = _getTabs();
      });
    });
  }

  List<Tab> _getTabs() {
    List<Tab> tabs = [];
    if (treeBean != null) {
      for (var i = 0; i < treeBean.data.length; ++i) {
        Tab tab = new Tab(text: treeBean.data[i].name);
        tabs.add(tab);
      }
    }
    return tabs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTabBarTitles();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return treeBean == null
        ? Container()
        : DefaultTabController(
            length: mTabs == null ? 0 : mTabs.length,
            child: Scaffold(
                appBar: AppBar(
                  title: Text("项目"),
                  centerTitle: true,
                  bottom: TabBar(
                    tabs: mTabs,
                    isScrollable: true,
                    indicatorColor: Colors.red,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.black,
                    indicatorWeight: 5.0,
                    labelStyle: TextStyle(height: 2),
                  ),
                  backgroundColor: Colors.blue,
                ),
                body: TabBarView(
                  children: treeBean.data.map((TreeContent tab) {
                    return new Center(
                        child: CommonRefreshLv(
                            hostStr: HttpUtils.Projects,
                            params: {'cid': tab.id.toString()}));
                  }).toList(),
                )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
