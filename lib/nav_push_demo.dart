import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:navigator_demo/new_nav_demo.dart';

// Example of why pushing multiple routes won't work
// If you go through the pages more than once, and update
// the state observable, the issues is clearly reflected in logs


// Simple globals are updated with push allowing for data to be passed in some cases
// but it is not recommended for encapuslation purposes. This is an anti-pattern in almost all cases
String nostatevar = "a";

// This is one of the few cases, for mobile where a global is acceptable. It is only set once
Size ss = Size(0,0);


class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<String> _items = [];
  /// The current total price of all items (assuming all items cost $42).

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void clear(){
    _items.clear();
    notifyListeners();
  }

}


class NavDemoRoot extends StatefulWidget {
  const NavDemoRoot({Key? key}) : super(key: key);

  @override
  _NavDemoRootState createState() => _NavDemoRootState();
}

class _NavDemoRootState extends State<NavDemoRoot> {

  double dd_menu_height = 0.0;
  bool dd_expanded = false;
  Color dd_menu_color =  Colors.grey[200]!;
  double page_height = 0;
  @override
  Widget build(BuildContext context) {
    ss= MediaQuery.of(context).size;
    page_height = ss.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    print("root BUILD padding " );
    return SafeArea(child:Scaffold(
        appBar: AppBar(title:
       IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            if (dd_menu_height == 0.0) {
              setState(() {
                dd_menu_height = ss.height * .2;
                dd_expanded = true;
              });
            }
            else{
              setState(() {
                dd_menu_height = 0.0;
                dd_expanded = false;
              });
            }

          },

        ),),
        body:
   Container(
    width: ss.width,
    child:  Column(
        children:[
      Stack(children:[

        Container(
          width: ss.width,
          height: page_height ,
          child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          ElevatedButton(onPressed: (){
            print("push page 1 press");
            nostatevar = "b";
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context){return Page1();})
            );
          },
            child:Text("Push page 1"),
          ),
          ElevatedButton(onPressed: (){
            print("update states from root");
            context.read<CartModel>().add("Item added from root");
          },
            child:Text("Update state items"),
          ),
          ElevatedButton(onPressed: (){
            print("update states from root");
            context.read<CartModel>().clear();
          },
            child:Text("Clear state"),
          ),
          Text("No state var ~ " + nostatevar),

          Text("Watched items ~ " + '${context.watch<CartModel>()._items}')
        ]),),
        AnimatedContainer(duration: Duration(milliseconds: 300),
            height: dd_menu_height,
            child:Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child:
              AnimatedContainer(duration: Duration(milliseconds: 300),
                height: dd_menu_height/2,
                  child: GestureDetector(
              onTap: (){
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (_) =>
                      NavDemoRoot()), (route) => false);
            },
              child:Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: dd_expanded? 1.0:0),
                    color: dd_menu_color,),
                  width: ss.width*.5,

                  child:Center(child:Text("Standard Nav"),)),))),
                  Expanded(child: AnimatedContainer(duration: Duration(milliseconds: 300),
                      height: dd_menu_height/2,
                      child:GestureDetector(
                    onTap: (){
                        Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) =>
                  NewNavRoot()), (route) => false);
            },
                child: Container(
                    width: ss.width*.5,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black, width:  dd_expanded? 1.0:0),
                      color: dd_menu_color,),
                    child:
                    Center(child:Text("New Nav"))))))
              ],),)

        ),

      ])]))));
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    print("page 1 BUILD");
    return Scaffold(
        appBar: AppBar(),
        body:Container(
        width: ss.width,
        child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              ElevatedButton(onPressed: (){
                print("push page 2 press");
                nostatevar = "c";
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){return Page2();})
                );
              },
                child: Text("Push page 2"),
              ),
              ElevatedButton(onPressed: (){
                print("update states from page 1");
                context.read<CartModel>().add("Item added from page 1");
              },
                child:Text("Update state items"),
              ),

              Text("No state var ~ " + nostatevar),

              Text("Watched items ~ " + '${context.watch<CartModel>()._items}')
            ]))
    );
  }
}


class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    print("page 2 BUILD");
    return Scaffold(
      appBar: AppBar(),
      body:Container(
        width: ss.width,
        child:
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
    ElevatedButton(onPressed: (){
      print("push root press");
      nostatevar = "a";
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context){return NavDemoRoot();}));
    },
      child: Text("Push root"),
    ),
        ElevatedButton(onPressed: () {
          print("push root and remove press");
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) =>
              NavDemoRoot()), (route) => false);
        }, child: Text("Push and remove root")),

          Text("No state var ~ " + nostatevar),

          Text("Watched items ~ " + '${context.watch<CartModel>()._items}')

    ])
    ),);
  }
}
