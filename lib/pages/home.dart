import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/pages/details.dart';
import 'package:fooddeliveryapp/service/database.dart';
import 'package:fooddeliveryapp/admin/admin_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false;
  bool pizza = false;
  bool salad = false;
  bool burger = false;

  late Stream<QuerySnapshot> foodItemStream;

  @override
  void initState() {
    super.initState();
    foodItemStream = DatabaseMethods().getFoodItem("Pizza");
  }

  void updateFoodItemStream(String category) {
    setState(() {
      foodItemStream = DatabaseMethods().getFoodItem(category);
    });
  }

  // Function to build food items in both horizontal and vertical lists
  Widget buildFoodItems(List<DocumentSnapshot> docs) {
    final firstTenItems = docs.take(10).toList();
    final remainingItems = docs.length > 10 ? docs.sublist(10) : [];

    return Stack(
      children: [
        // Upper Section: First 10 food items in horizontal scrolling
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 250, // Adjust height as necessary
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: firstTenItems.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = firstTenItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                          image: ds["Image"],
                          name: ds["Name"],
                          detail: ds["Detail"],
                          price: ds["Price"].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 20,
                    margin: const EdgeInsets.all(10),
                    child: Material(
                      elevation: 3.0,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Image.network(
                              ds["Image"],
                              height: 100.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                            Text(ds["Name"], style: boldTextFieldStyle()),
                            const SizedBox(height: 5.0),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 50.0, // Fixed height for description
                                maxWidth: 100.0, // Adjust as per requirement
                              ),
                              child: Text(
                                ds["Detail"],
                                style: lightTextFielsStyle(),
                                maxLines: 3, // Limit to 3 lines
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text("\$${ds["Price"]}", style: boldTextFieldStyle()),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Lower Section: Remaining items in vertical scrolling
        Positioned(
          top: 150 + 45, // Adjust this value to control the overlap
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            margin: const EdgeInsets.only(top: 23), // Margin to push it down
            child: ListView.builder(
              itemCount: remainingItems.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = remainingItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                          image: ds["Image"],
                          name: ds["Name"],
                          detail: ds["Detail"],
                          price: ds["Price"].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.network(
                              ds["Image"],
                              height: 100.0,
                              width: 80.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ds["Name"], style: boldTextFieldStyle()),
                                const SizedBox(height: 5.0),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 50.0, // Fixed height for description
                                    maxWidth: 200.0, // Adjust as per requirement
                                  ),
                                  child: Text(
                                    ds["Detail"],
                                    style: lightTextFielsStyle(),
                                    maxLines: 3, // Limit to 3 lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text("\$${ds["Price"]}", style: boldTextFieldStyle()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget allItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items available'));
        }

        return buildFoodItems(snapshot.data!.docs);
      },
    );
  }

  Color getItemColor(bool selected) {
    return selected ? Colors.red : Colors.white;
  }

  TextStyle boldTextFieldStyle() {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  }

  TextStyle headlineTextFielsStyle() {
    return const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  }

  TextStyle lightTextFielsStyle() {
    return const TextStyle(fontSize: 16, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Naseeb", style: boldTextFieldStyle()),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLogin(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0.0),
              Text("Delicious Food", style: headlineTextFielsStyle()),
              Text("Discover and Get Great Food", style: lightTextFielsStyle()),
              const SizedBox(height: 40.0),
              showItem(),
              const SizedBox(height: 20.0),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200, // Adjust height as needed
                child: allItems(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for displaying category items (e.g., Ice-cream, Pizza, etc.)
  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              icecream = true;
              pizza = false;
              burger = false;
              salad = false;
              updateFoodItemStream("Ice-cream");
            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: getItemColor(icecream),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("assets/images/ice-cream.png", height: 40),

                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              icecream = false;
              pizza = true;
              burger = false;
              salad = false;
              updateFoodItemStream("Pizza");
            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: getItemColor(pizza),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("assets/images/pizza.png", height: 40),

                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              icecream = false;
              pizza = false;
              burger = true;
              salad = false;
              updateFoodItemStream("Burger");
            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: getItemColor(burger),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("assets/images/burger.png", height: 40),

                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              icecream = false;
              pizza = false;
              burger = false;
              salad = true;
              updateFoodItemStream("Salad");
            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: getItemColor(salad),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("assets/images/salad.png", height: 40),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
