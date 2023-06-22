import 'package:flutter/material.dart';
import 'models/user.dart';
import 'chat.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: body(),
      ),
    );
  }

  body() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: const Text("WhatsApp"),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        tabs: [Tab(text: "Chats")],
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      )),
                ),
              )
            ],
        body: const TabBarView(children: [
          ChatList(),
        ]));
  }
}

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<User> userList = [
    User(
        name: "João",
        phone: "(33) 9998-4742",
        avatarUrl: "https://i.pravatar.cc/100?img=1"),
    User(
        name: "Austine",
        phone: "(20) 2439-6146",
        avatarUrl: "https://i.pravatar.cc/100?img=2"),
    User(
        name: "Crystal",
        phone: "(75) 6510-2088",
        avatarUrl: "https://i.pravatar.cc/100?img=3"),
    User(
        name: "Roy",
        phone: "(88) 5769-5166",
        avatarUrl: "https://i.pravatar.cc/100?img=4"),
    User(
        name: "Feliza",
        phone: "(82) 0778-1438",
        avatarUrl: "https://i.pravatar.cc/100?img=5"),
    User(
        name: "Jard",
        phone: "(73) 2212-3701",
        avatarUrl: "https://i.pravatar.cc/100?img=6"),
    User(
        name: "Urson",
        phone: "(53) 0255-8232",
        avatarUrl: "https://i.pravatar.cc/100?img=7"),
    User(
        name: "Kliment",
        phone: "(39) 6496-2216",
        avatarUrl: "https://i.pravatar.cc/100?img=8"),
    User(
        name: "Kristen",
        phone: "(49) 3454-6999",
        avatarUrl: "https://i.pravatar.cc/100?img=9"),
    User(
        name: "Mindy",
        phone: "(37) 2503-2315",
        avatarUrl: "https://i.pravatar.cc/100?img=10"),
    User(
        name: "Jeanine",
        phone: "(50) 2772-4499",
        avatarUrl: "https://i.pravatar.cc/100?img=11"),
    User(
        name: "Kasper",
        phone: "(29) 8541-1765",
        avatarUrl: "https://i.pravatar.cc/100?img=12"),
    User(
        name: "Cherida",
        phone: "(77) 2460-6760",
        avatarUrl: "https://i.pravatar.cc/100?img=13"),
    User(
        name: "Lulu",
        phone: "(40) 7141-4947",
        avatarUrl: "https://i.pravatar.cc/100?img=14"),
    User(
        name: "Kingsley",
        phone: "(72) 2765-8277",
        avatarUrl: "https://i.pravatar.cc/100?img=15"),
    User(
        name: "Way",
        phone: "(88) 6558-8597",
        avatarUrl: "https://i.pravatar.cc/100?img=16"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userList.length,
      itemBuilder: (context, index) => UserCard(user: userList[index]),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
        ),
        title: Row(
          children: [
            Text(user.name),
            const SizedBox(width: 8),
            Text(user.phone,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        subtitle: user.messages.isEmpty
            ? const Text("Nenhuma mensagem",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ))
            : Text(user.messages.last),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => _openChat(context, user),
      ),
    );
  }

  void _openChat(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(user: user),
      ),
    );
  }
}
