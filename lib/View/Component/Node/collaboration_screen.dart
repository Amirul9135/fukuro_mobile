import 'package:flutter/cupertino.dart';
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
            floating: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                UserList(
                  fnTap: _changeUserRole,
                  node: widget.node,
                  access: true,
                  title: "Collaborators",
                ),
                UserList(
                  fnTap: _changeUserRole,
                  node: widget.node,
                  access: false,
                  title: "Find Users",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //return true to signal refresh
  Future<bool> _changeUserRole(User user) async {
    print("add user $user");
    int role = await _selectRole(user);
    if (role == -1) {
      return false;
    }
    if (role != user.accessId) {
      print('chg00');
      bool conf = await _confirmChange(user, role);
      if (conf) {
        FukuroResponse res = await NodeController.changeUserAccess(
            widget.node.getNodeId(), user.userId, role);
        if (mounted) {
          if (res.ok()) {
            FukuroDialog.success(context, "Access Changes Applied", '');
          } else {
            FukuroDialog.error(
                context, "Failed to Change Access", res.msg().toString());
          }
        }
        return true;
      }
    }
    return false;
  }

  Future<bool> _confirmChange(User user, int role) async {
    String strMsg = "";
    if (role == 0) {
      strMsg =
          "Remove user access?\n${user.name} will no longer be able to access this node";
    } else if (role == 1) {
      strMsg =
          "Grant Admin access to ${user.name}?\nThis user will have access to all features for this node";
    } else if (role == 2) {
      strMsg =
          "Grant Collaborator access to ${user.name}?\nThis user will have access to all features for this node except configurations and logs";
    } else if (role == 3) {
      strMsg =
          "Grant Guest access to ${user.name}?\nThis user will only be able to monitor and receive notification concerning this node";
    }
    FukuroDialog msg = FukuroDialog(
      title: "Confirm Action",
      mode: FukuroDialog.QUESTION,
      message: strMsg,
      NoBtn: true,
      BtnText: "Proceed",
    );
    bool conf = false;
    await showDialog(context: context, builder: (_) => msg);
    if (msg.okpressed) {
      conf = true;
    }
    return conf;
  }

  //return true to signal refresh
  Future<bool> _removeUser(User user) async {
    print("remove user $user");
    return false;
  }

  _applyRoleChanges(User user) {}
  Future<int> _selectRole(User user) async {
    int role = 0;
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Select Role'),
          content: Text('Select the role to be assigned to ${user.name}'),
          actions: <Widget>[
            (user.accessId != 1)
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.shade900),
                    child: CupertinoDialogAction(
                      textStyle: const TextStyle(color: Colors.white),
                      child: const Text('Admin'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        role = 1;
                      },
                    ),
                  )
                : Container(),
            (user.accessId != 2)
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: CupertinoDialogAction(
                      textStyle: const TextStyle(color: Colors.white),
                      child: const Text('Collaborator'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        role = 2;
                      },
                    ),
                  )
                : Container(),
            (user.accessId != 3)
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlueAccent),
                    child: CupertinoDialogAction(
                      textStyle: const TextStyle(color: Colors.white),
                      child: const Text('Guest'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        role = 3;
                      },
                    ),
                  )
                : Container(),
            (user.accessId != 0)
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    child: CupertinoDialogAction(
                      textStyle: const TextStyle(color: Colors.white),
                      child: const Text('Remove'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        role = 0;
                      },
                    ),
                  )
                : Container(),
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.deepOrange),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                role = -1;
              },
            ),
          ],
        );
      },
    );
    return role;
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
    return  
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
          : Stack(
              fit: StackFit.expand,
              children: [
                Container( 
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.lightBlue.withOpacity(.1)),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView(
                    shrinkWrap: true,
                      children: data.map((e) {
                    print("mapping");
                    return GestureDetector(
                      onTap: () async {
                        if (await widget.fnTap?.call(e) == true) {
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
                              flex: 20,
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
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
                                        Row(
                                          children: [
                                            Text(
                                              e.name,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: (e.accessId == 1)
                                                      ? Colors.blue.shade900
                                                      : (e.accessId == 2)
                                                          ? Colors.blue
                                                          : (e.accessId == 3)
                                                              ? Colors
                                                                  .lightBlueAccent
                                                              : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                (e.accessId == 1)
                                                    ? "Admin"
                                                    : (e.accessId == 2)
                                                        ? "Collaborator"
                                                        : (e.accessId == 3)
                                                            ? "Guest"
                                                            : "",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                      children: [
                        Flexible(
                            flex: 8,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: TextFormField(
                                controller: txt,
                              ),
                            )),
                        Flexible(
                            flex: 2,
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2.5),
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
                    )
                    ,)
                    ),
              ],
            );
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
