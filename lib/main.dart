import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: AdPage(),
    );
  }
}

class AdPage extends StatefulWidget {
  AdPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AdPageState createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    this._controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: TabBar(
                controller: _controller,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.next_week),
                    text: 'Готовится...',
                  ),
                  Tab(
                    icon: const Icon(Icons.done_all),
                    text: 'Сделано уже',
                  ),
                  Tab(
                    icon: const Icon(Icons.info),
                    text: 'О программе',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('В ближайшей разработке:'),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                color: Colors.grey[50],
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(Icons.add),
                                  title: Text('Теги:'),
                                  subtitle: Text('aaa'),
                                  trailing: Text('5 из 100%'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                color: Colors.grey[50],
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(Icons.add),
                                  title: Text('Теги:'),
                                  subtitle: Text('aaa'),
                                  trailing: Text('5 из 100%'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                color: Colors.grey[50],
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(Icons.add),
                                  title: Text('Теги:'),
                                  subtitle: Text('aaa'),
                                  trailing: Text('5 из 100%'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                color: Colors.grey[50],
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(Icons.add),
                                  title: Text('Теги:'),
                                  subtitle: Text('aaa'),
                                  trailing: Text('5 из 100%'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.home),
                        title: TextField(
                          decoration: const InputDecoration(
                              hintText: 'Search for address...'),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text('Latitude: 48.09342\nLongitude: 11.23403'),
                        trailing: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Ads(title: 'Поддержите разработку в один клик',
                      subtitle: 'Посмотрите любую рекламу, на выбор, '
                          'и где-то разработчик купит кофе и создаст шедевр для вас ))',

                    ),
                  ),
                  Card(
                    child: Rate(
                      title: 'Ставьте оценку, вносите предложения.',
                      subtitle: 'Возможно, именно ваше станет следующей фичей',
                    ),
                  ),
                ],
              ),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class TabOfDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(runtimeType.toString()),
      ),
    );
  }
}

class TabOfPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(runtimeType.toString()),
      ),
    );
  }
}

class TabOfManifest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(runtimeType.toString()),
      ),
    );
  }
}

class Ads extends StatelessWidget {
  final String title;
  final String subtitle;

  const Ads({@required this.title, @required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).backgroundColor.withOpacity(0.5),
      child: Column(
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headline,),
          Text(subtitle, style: Theme.of(context).textTheme.subtitle,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(child: Text('video ad'), onPressed: () {}),
              RaisedButton(child: Text('just fullscreen ad'), onPressed: () {}),
          ],)
        ],
      ),
    );
  }
}

class Rate extends StatelessWidget {
  final String title;
  final String subtitle;

  const Rate({@required this.title, @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).backgroundColor.withOpacity(0.5),
      child: Column(
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headline,),
          Text(subtitle, style: Theme.of(context).textTheme.subtitle,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Icon(Icons.star_border),
                    Icon(Icons.star_border),
                    Icon(Icons.star_border),
                    Icon(Icons.star_border),
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
