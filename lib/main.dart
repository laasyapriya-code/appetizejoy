
import 'package:flutter/material.dart';
import 'food_details_screen.dart';
import 'cart_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(const AppetizeJoy());
}

class AppetizeJoy extends StatelessWidget {
  const AppetizeJoy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppetizeJoy',
      theme: ThemeData(
        primaryColor: const Color(0xFFE87532),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<Map<String, String>> foods = [
    {
      'name': 'Pizza',
      'description': 'Cheesy and delicious pizza',
      'price': '₹249',
      'image': 'assets/images/pizza_ui.jpg',
      'category': 'Main Course',
    },
    {
      'name': 'Burger',
      'description': 'Fresh and juicy burger',
      'price': '₹149',
      'image': 'assets/images/burgerui.jpg',
      'category': 'Starters',
    },
    {
      'name': 'Noodles',
      'description': 'Hot and spicy noodles',
      'price': '₹179',
      'image': 'assets/images/noddlesui.jpg',
      'category': 'Main Course',
    },
    {
      'name': 'Brownie',
      'description': 'Rich chocolate brownie',
      'price': '₹99',
      'image': 'assets/images/brownieui.jpg',
      'category': 'Desserts',
    },
  ];

  final List<String> categories = [
    'All',
    'Starters',
    'Main Course',
    'Desserts',
    'Beverages',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFoods = foods.where((food) {
      final name = food['name']!.toLowerCase();
      final description = food['description']!.toLowerCase();
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          name.contains(query) || description.contains(query);

      final matchesCategory =
          selectedCategory == 'All' ||
              food['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE87532),
        foregroundColor: Colors.white,
        title: const Text(
          'AppetizeJoy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // Shopping cart icon with item count
        actions: [
          AnimatedBuilder(
            animation: CartProvider.instance,
            builder: (context, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),

                  if (CartProvider.instance.totalItems > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.white,
                        child: Text(
                          '${CartProvider.instance.totalItems}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFE87532),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Food, Good Mood!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Discover delicious food and satisfy your cravings.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 20),

            // Search bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for food...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Categories heading
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 12),

            // Category filters
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  selectedColor: const Color(0xFFE87532),
                  backgroundColor: const Color(0xFFF5E5D5),
                  labelStyle: TextStyle(
                    color: selectedCategory == category
                        ? Colors.white
                        : const Color(0xFF30251F),
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Popular dishes
            const Text(
              'Popular Dishes',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 15),

            if (filteredFoods.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'No food items found!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns =
                  constraints.maxWidth > 650 ? 2 : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredFoods.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 260,
                    ),
                    itemBuilder: (context, index) {
                      final food = filteredFoods[index];

                      return FoodCard(
                        name: food['name']!,
                        description: food['description']!,
                        price: food['price']!,
                        image: food['image']!,
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Food card widget
class FoodCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String image;

  const FoodCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(
              name: name,
              description: description,
              price: price,
              image: image,
            ),
          ),
        );
      },

      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF30251F),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE87532),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
