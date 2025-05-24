import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Demo product data
    final List<Product> loadedProducts = [
      Product(
        id: 'p1',
        name: 'T-Shirt',
        description: 'A nice t-shirt - it is really comfortable!',
        price: 99000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p2',
        name: 'Trousers',
        description: 'A pair of trousers.',
        price: 159000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p3',
        name: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 79000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p4',
        name: 'Pan',
        description: 'Prepare any meal you want.',
        price: 249000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p5',
        name: 'Baju Batik',
        description: 'Baju batik kebanggan orang madura.',
        price: 350000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p6',
        name: 'Lacoste',
        description: 'Baju yang sering dipakek starboy.',
        price: 500000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p7',
        name: 'Lacoste',
        description: 'Baju yang sering dipakek starboy.',
        price: 500000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p8',
        name: 'Lacoste',
        description: 'Baju yang sering dipakek starboy.',
        price: 500000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p9',
        name: 'Lacoste',
        description: 'Baju yang sering dipakek starboy.',
        price: 500000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: 'p10',
        name: 'Lacoste',
        description: 'Baju yang sering dipakek starboy.',
        price: 500000,
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        
        // Categories
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _buildCategoryChip('All', true),
              _buildCategoryChip('Clothing', false),
              _buildCategoryChip('Electronics', false),
              _buildCategoryChip('Home', false),
              _buildCategoryChip('Beauty', false),
              _buildCategoryChip('Sports', false),
            ],
          ),
        ),
        
        // Products grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, i) => ProductItem(
              product: loadedProducts[i],
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}