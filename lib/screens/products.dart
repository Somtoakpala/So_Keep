/* import 'package:flutter/material.dart';
import 'package:so_keep/model/product_model.dart';
import 'package:so_keep/screens/items.dart';

class ProductsScreen extends StatelessWidget {
  final List<Products> products;
  final String itemType;
  final int productsIndex;
  final Function(int, Products)? onProductUpdated;
  final Function(int)? onProductDeleted;
  
  const ProductsScreen({
    super.key,
    required this.products,
    required this.itemType,
    required this.productsIndex,
    this.onProductUpdated,
    this.onProductDeleted,
  });

  void _showEditDialog(BuildContext context, int index, Products product) {
    final TextEditingController nameController = 
        TextEditingController(text: product.productName);
    final TextEditingController priceController = 
        TextEditingController(text: product.price.toStringAsFixed(2));
    /* final TextEditingController descriptionController = 
        TextEditingController(text: product.description); */

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 12),
              TextField(
                /* controller: descriptionController, */
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              /* final updatedProduct = Products(
                productName: nameController.text,
                price: double.tryParse(priceController.text) ?? product.price,
                
                // Add other properties if needed
              ); */
              
              /* if (onProductUpdated != null) {
                onProductUpdated!(index, updatedProduct);
              } */
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (onProductDeleted != null) {
                onProductDeleted!(index);
              }
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('$itemType Products'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
          color: Color(0xffE5F9FF),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.05),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Items screen with all products
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Items(products: products),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Product Icon
                              Container(
                                width: 80,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shopping_bag,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 2),
                              
                              // Product Name
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  product.productName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                             
                              
                              // Price
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffC25D5D),
                                ),
                              ),

 // Edit and Delete buttons - POSITIONED CORRECTLY
                        

                            ],
                          ),
                        ),
                        
                       
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} */