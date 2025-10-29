import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_keep/components/custom_button.dart';
import 'package:so_keep/components/custom_category.dart';
import 'package:so_keep/model/product_model.dart';
import 'package:so_keep/screens/items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lists for dropdowns
  List<String> itemNames = [];
  List<String> itemTypes = [];

  // Separate state for dialog dropdowns
  String? dialogSelectedItemName;
  String? dialogSelectedItemType;
  List<String> dialogItemNames = [];
  List<String> dialogItemTypes = [];

  // Text editing controllers for form fields
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUniqueItemNames();
  }

  // Load unique item names from Hive
  void _loadUniqueItemNames() {
    final box = Hive.box<Products>('productsBox');
    final allProducts = box.values.toList();
    
    // Get unique item names
    itemNames = allProducts.map((product) => product.itemName).toSet().toList();
    
    // Get unique item types  
    itemTypes = allProducts.map((product) => product.itemType).toSet().toList();
    
    // Initialize dialog lists
    dialogItemNames = List.from(itemNames);
    dialogItemTypes = List.from(itemTypes);
  }

  @override
  void dispose() {
    productNameController.dispose();
    sizeController.dispose();
    qtyController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
          color: Color(0xffE5F9FF),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Grid section - Using ValueListenableBuilder for real-time updates
                SizedBox(
                  height: screenHeight * 0.6,
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<Products>('productsBox').listenable(),
                    builder: (context, Box<Products> box, widget) {
                      final products = box.values.toList();
                      
                      // Update dropdown options when data changes
                      _loadUniqueItemNames();
                      
                      if (products.isEmpty) {
                        return const Center(
                          child: Text(
                            "No items added yet",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: products.map((p) => p.itemName).toSet().length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Category(
                            text: product.itemName,
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => Items(products: products)
                                )
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Button
                CustomButton(
                  text: "Add Items",
                  onTap: () {
                    _showAddItemDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialog for adding items
  void _showAddItemDialog(BuildContext context) {
    // Reset dialog-specific state when opening dialog
    dialogSelectedItemName = null;
    dialogSelectedItemType = null;
    dialogItemNames = List.from(itemNames);
    dialogItemTypes = List.from(itemTypes);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add item",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Item Name Dropdown
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: dialogSelectedItemName,
                            decoration: const InputDecoration(
                              labelText: "Item Name",
                              border: OutlineInputBorder(),
                            ),
                            items: dialogItemNames
                                .map((name) => DropdownMenuItem(
                                    value: name, child: Text(name)))
                                .toList(),
                            onChanged: (value) {
                              setStateDialog(() {
                                dialogSelectedItemName = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        _addButton(
                          onPressed: () async {
                            final newItem = await _showAddInputDialog(context, "Item Name");
                            if (newItem != null && newItem.isNotEmpty) {
                              setStateDialog(() {
                                dialogItemNames.add(newItem);
                                dialogSelectedItemName = newItem;
                              });
                            }
                          },
                          context: context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Item Type Dropdown
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: dialogSelectedItemType,
                            decoration: const InputDecoration(
                              labelText: "Item Type",
                              border: OutlineInputBorder(),
                            ),
                            items: dialogItemTypes
                                .map((type) => DropdownMenuItem(
                                    value: type, child: Text(type)))
                                .toList(),
                            onChanged: (value) {
                              setStateDialog(() {
                                dialogSelectedItemType = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        _addButton(
                          onPressed: () async {
                            final newType = await _showAddInputDialog(context, "Item Type");
                            if (newType != null && newType.isNotEmpty) {
                              setStateDialog(() {
                                dialogItemTypes.add(newType);
                                dialogSelectedItemType = newType;
                              });
                            }
                          },
                          context: context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Product Name
                    TextField(
                      controller: productNameController,
                      decoration: const InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Size & Qty
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: sizeController,
                            decoration: const InputDecoration(
                              labelText: "Size",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: qtyController,
                            decoration: const InputDecoration(
                              labelText: "Qty",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Price
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: "Price",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC25D5D),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _saveProduct(context);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveProduct(BuildContext context) async {
    final box = Hive.box<Products>('productsBox');
    
    // Use dialog-specific values for saving
    if (dialogSelectedItemName == null || 
        dialogSelectedItemType == null || 
        productNameController.text.isEmpty || 
        sizeController.text.isEmpty || 
        qtyController.text.isEmpty || 
        priceController.text.isEmpty) {
      
      _showErrorDialog(context, "Please fill all fields correctly");
      return;
    }

    // Validate numeric fields
    final size = double.tryParse(sizeController.text);
    final qty = double.tryParse(qtyController.text);
    final price = double.tryParse(priceController.text);

    if (size == null || qty == null || price == null) {
      _showErrorDialog(context, "Please enter valid numbers for Size, Qty, and Price");
      return;
    }

    // Create and save product
    final product = Products(
      itemName: dialogSelectedItemName!, 
      itemType: dialogSelectedItemType!, 
      productName: productNameController.text, 
      size: size, 
      qty: qty, 
      price: price
    );

    // Save to Hive
    await box.add(product);

    // Update main lists with any new items added in dialog
    if (!itemNames.contains(dialogSelectedItemName)) {
      setState(() {
        itemNames.add(dialogSelectedItemName!);
      });
    }
    if (!itemTypes.contains(dialogSelectedItemType)) {
      setState(() {
        itemTypes.add(dialogSelectedItemType!);
      });
    }

    // Clear form fields
    _clearFormFields();

    // Close the dialog
    Navigator.pop(context);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully!'))
    );
  }

  void _clearFormFields() {
    dialogSelectedItemName = null;
    dialogSelectedItemType = null;
    productNameController.clear();
    sizeController.clear();
    qtyController.clear();
    priceController.clear();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// small + button beside dropdown - Fixed to prevent unnecessary rebuilds
  Widget _addButton({required VoidCallback onPressed, required BuildContext context}) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black12,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
      ),
    );
  }

  /// sub-dialog to enter new dropdown item
  Future<String?> _showAddInputDialog(BuildContext context, String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $title",
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}