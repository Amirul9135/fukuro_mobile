import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/Model/user.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart'; 

class CollaborationScreen extends StatefulWidget {
  final Node node;
  const CollaborationScreen({Key? key, required this.node}) : super(key: key);
  @override
  CollaborationScreenState createState() => CollaborationScreenState();
}

class CollaborationScreenState extends State<CollaborationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // Initialize your state here
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);
  }

  _onTabChange() {
    print("change");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: _tabs,
              ),
              vsync: this,
            ),
            pinned: true,
            floating: false,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                UserList(
                  fnTap: _removeUser,
                  node: widget.node,
                  access: true,
                  title: "Collaborators",
                ),
                UserList(
                  fnTap: _addUser,
                  node: widget.node,
                  access: false,
                  title: "Collaborators",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _addUser(User user) async {
    print("add user $user");
    FukuroDialog msg = FukuroDialog(
      title: "Add User",
      message:
          "Selected user ${user.name} will have access this node ${widget.node.getName()}",
      mode: FukuroDialog.WARNING,
      NoBtn: true,
      BtnText: "Yes",
    );

    await showDialog(context: context, builder: (_) => msg);
    if (msg.okpressed) {
      FukuroResponse res = await NodeController.toggleAccess(
          widget.node.getNodeId(), user.userId, true);
      if (res.ok()) {
        if(mounted){ 
          await FukuroDialog.success(context, "aded", "");
        }
        return true;
      }
      else{
        if(mounted){ 
           await FukuroDialog.error(context, "Failed to add user", res.msg());
        }
        
      }
     
    }
    return false;
  }

  Future<bool> _removeUser(User user) async {
    print("remove user $user");
    FukuroDialog msg = FukuroDialog(
      title: "Remove User",
      message:
          "Selected user ${user.name} will no longer be able to access this node ${widget.node.getName()}",
      mode: FukuroDialog.WARNING,
      NoBtn: true,
      BtnText: "Yes",
    );

    await showDialog(context: context, builder: (_) => msg);
    if (msg.okpressed) {
      FukuroResponse res = await NodeController.toggleAccess(
          widget.node.getNodeId(), user.userId, false);
      if (res.ok()) {
        if(mounted){ 
          await FukuroDialog.success(context, "Removed", "");
        }
        return true;
      }
      else{
        if(mounted){ 
           await FukuroDialog.error(context, "Failed to Remove user", res.msg());
        }
        
      }
     
    }
    return false;
  }
}

class UserList extends StatefulWidget {
  final Node node;
  final bool access;
  final String title;
  final Future<bool> Function(User)? fnTap;
  const UserList(
      {Key? key,
      required this.node,
      required this.access,
      required this.title,
      this.fnTap})
      : super(key: key);
  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  final List<User> data = [];
  final TextEditingController txt = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    // Initialize your state here
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      (loading)
          ? const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                        height:
                            16), // Adjust the space between the indicator and text
                    Text('Loading...'),
                  ],
                ),
              ),
            )
          : Expanded(
              child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.lightBlue.withOpacity(.1)),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                  children: data.map((e) {
                print("mapping");
                return GestureDetector(
                  onTap: () async {
                     if(await widget.fnTap?.call(e) == true){
                      
                    _loadUser();
                     }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.only(
                        bottom: 15.0), // Set the margin here
                    child: Row(
                      children: [
                        Flexible(
                          flex: 10,
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue, // Background color
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2.5),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.person_sharp,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                )),
                          ),
                        ),
                        Flexible(
                            flex: 80,
                            child: Container(
                                margin: EdgeInsets.only(right: 20),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        e.name,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            "Email : ${e.email}",
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              "Phone : ${e.phone}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ],
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                  ),
                );
              }).toList()),
            )),
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              Flexible(
                  flex: 9,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: TextFormField(
                      controller: txt,
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue, // Background color
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _loadUser();
                        },
                      ),
                    ),
                  ))
            ],
          ))
    ]);
  }

  _loadUser() async {
    loading = true;
    data.clear();
    if (mounted) {
      setState(() {});
    }
    FukuroResponse res = await NodeController.findUser(
        widget.node.getNodeId(), widget.access, txt.text);
    if (res.ok()) {
      for (var u in res.body()) {
        data.add(User.fromJson(u));
      }
    }
    loading = false;
    if (mounted) {
      setState(() {});
    }
  }
}

const _tabs = [
  Tab(icon: Icon(Icons.supervised_user_circle_rounded), text: "Collaborators"),
  Tab(icon: Icon(Icons.group_add_rounded), text: "Add Users"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  //_SliverAppBarDelegate(this._tabBar,this.vsync);

  _SliverAppBarDelegate({required this.tabBar, required this.vsync}) : super();

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  final TickerProvider vsync;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
