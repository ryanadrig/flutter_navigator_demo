import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Example of why pushing multiple routes won't work
// If you go through the pages more than once, and update
// the state observable, the issues is clearly reflected in logs


// This can be updated with push allowing for data to be passed in some cases
String nostatevar = "a";

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<String> _items = [];
  /// The current total price of all items (assuming all items cost $42).

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

}


class NavDemoRoot extends StatefulWidget {
  const NavDemoRoot({Key? key}) : super(key: key);

  @override
  _NavDemoRootState createState() => _NavDemoRootState();
}

class _NavDemoRootState extends State<NavDemoRoot> {

  @override
  Widget build(BuildContext context) {
    print("root BUILD");
    return Scaffold(
        appBar: AppBar(leading: DropdownButton(
          onChanged: (val){
            if (val == "cyc"){

            }
          },
          items: [DropdownMenuItem(child: Text("Cyclic Example"), value: "cyc",)],
        ),),
        body:Container(child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

          Text("No state var ~ " + nostatevar),

          Text("Watched items ~ " + '${context.watch<CartModel>()._items}')
        ]),));
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
    return Scaffold(body:Container(

        child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
    return Scaffold(body:Container(child:
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
    ElevatedButton(onPressed: (){
      print("push root press");
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

    ])
    ),);
  }
}
