import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = [
    "Кофе",
    "Раф/Моккачино",
    "Авторские напитки",
    "Холодные напитки"
  ];
  int selectedCategoryIndex = 0;
  final Map<String, List<Map<String, String>>> items = {
    "Кофе": [
      {"name": "Эспрессо", "price": "99 руб", "image": "assets/espresso.png"},
      {
        "name": "Американо",
        "price": "109 руб",
        "image": "assets/americano.png"
      },
      {"name": "Капучино", "price": "169 руб", "image": "assets/capucino.png"},
      {"name": "Латте", "price": "169 руб", "image": "assets/latte.png"},
    ],
    "Раф/Моккачино": [
      {
        "name": "Раф классический",
        "price": "219 руб",
        "image": "assets/rafclassic.png"
      },
      {
        "name": "Раф цитрусовый",
        "price": "219 руб",
        "image": "assets/rafcitrus.png"
      },
      {
        "name": "Раф кокосовый",
        "price": "219 руб",
        "image": "assets/rafcocos.png"
      },
      {
        "name": "Моккачино классический",
        "price": "229 руб",
        "image": "assets/mokkachinoclassic.png"
      },
    ],
    "Авторские напитки": [
      {
        "name": "Карамельно-арахисовый латте",
        "price": "219 руб",
        "image": "assets/karamellatte.png"
      },
      {
        "name": "Раф карамельный попкорн",
        "price": "229 руб",
        "image": "assets/rafkaramel.png"
      },
      {
        "name": "Латте с халвой",
        "price": "219 руб",
        "image": "assets/lattehalva.png"
      },
      {
        "name": "Латте ореховый",
        "price": "219 руб",
        "image": "assets/latteoreh.png"
      },
    ],
    "Холодные напитки": [
      {
        "name": "Айс Латте classic",
        "price": "209 руб",
        "image": "assets/icelatteclassic.png"
      },
      {
        "name": "Айс Латте Клубника-Лемонграсс",
        "price": "219 руб",
        "image": "assets/strawblatte.png"
      },
      {"name": "Итальяно", "price": "219 руб", "image": "assets/italiano.png"},
      {"name": "Бамбл", "price": "229 руб", "image": "assets/bambl.png"},
    ],
  };

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};

  @override
  void initState() {
    super.initState();
    for (var category in categories) {
      _categoryKeys[category] = GlobalKey();
    }
  }

  void scrollToCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
    Scrollable.ensureVisible(
      _categoryKeys[categories[index]]!.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    scrollToCategory(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: selectedCategoryIndex == index
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedCategoryIndex == index
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var category = categories[index];
                return Column(
                  key: _categoryKeys[category],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: items[category]!.length,
                      itemBuilder: (context, itemIndex) {
                        var item = items[category]![itemIndex];
                        return CoffeeCard(
                          name: item["name"]!,
                          price: item["price"]!,
                          image: item["image"]!,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CoffeeCard extends StatefulWidget {
  final String name;
  final String price;
  final String image;

  const CoffeeCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  _CoffeeCardState createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  int quantity = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 0) quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: widget.image.isEmpty
                  ? const Placeholder(fallbackHeight: 100)
                  : Image.asset(widget.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: incrementQuantity,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF668EE3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quantity == 0
                        ? widget.price
                        : "${widget.price} x $quantity",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (quantity > 0) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: decrementQuantity,
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
