import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:so_keep/model/product_model.dart';

class Items extends StatefulWidget {
  List<Products> products;
  Items({super.key, required this.products});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late List<Products> _products;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _products = List.from(widget.products);
  }

  void _updateProduct(int index, Products updatedProduct) async {
    var box = Hive.box<Products>('productsBox');
    Products productToUpdate = _products[index];
    
    // Update the existing product's properties
    productToUpdate.itemName = updatedProduct.itemName;
    productToUpdate.price = updatedProduct.price;
    productToUpdate.itemType = updatedProduct.itemType;
    productToUpdate.productName = updatedProduct.productName;
    productToUpdate.qty = updatedProduct.qty;
    productToUpdate.size = updatedProduct.size;
    productToUpdate.imagePath = updatedProduct.imagePath; // Update image path
    
    await productToUpdate.save();
    
    setState(() {
      _products[index] = productToUpdate;
    });
  }

  void _deleteProduct(BuildContext context, int index) async {
    final box = Hive.box<Products>('productsBox');
    Products productToDelete = _products[index];
    await box.delete(productToDelete.key);
    
    setState(() {
      _products.removeAt(index);
    });
  }

  // Method to pick image from gallery
  Future<void> _pickImage(BuildContext context, int index) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      // Update the product with the new image path
      Products updatedProduct = _products[index];
      updatedProduct.imagePath = image.path;
      _updateProduct(index, updatedProduct);
      

      if(context.mounted){

 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      }
     
    }
  }

  // Method to take photo with camera
  Future<void> _takePhoto(BuildContext context, int index) async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (photo != null) {
      Products updatedProduct = _products[index];
      updatedProduct.imagePath = photo.path;
      _updateProduct(index, updatedProduct);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Method to remove image
  void _removeImage(BuildContext context, int index) {
    Products updatedProduct = _products[index];
    updatedProduct.imagePath = '';
    _updateProduct(index, updatedProduct);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image removed successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, Products product) {
    final TextEditingController nameController = 
        TextEditingController(text: product.productName);
    final TextEditingController priceController = 
        TextEditingController(text: product.price.toStringAsFixed(2));
    final TextEditingController sizeController = 
        TextEditingController(text: product.size.toString());
    final TextEditingController qtyController = 
        TextEditingController(text: product.qty.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Preview and Options
              _buildImageSection(context, index, product),
              SizedBox(height: 16),
              
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
                controller: sizeController,
                decoration: InputDecoration(
                  labelText: 'Size',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              final updatedProduct = Products(
                itemName: product.itemName,
                itemType: product.itemType,
                productName: nameController.text,
                price: double.tryParse(priceController.text) ?? product.price,
                size: double.tryParse(sizeController.text) ?? product.size,
                qty: double.tryParse(qtyController.text) ?? product.qty,
                imagePath: product.imagePath, // Keep existing image
              );
              
              _updateProduct(index, updatedProduct);
              
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

  Widget _buildImageSection(BuildContext context, int index, Products product) {
    return Column(
      children: [
        // Current Image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: product.imagePath!=null
              ? _buildProductImage(product.imagePath??"")
              : Icon(
                  Icons.inventory_2_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
        ),
        SizedBox(height: 8),
        
        // Image Options
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Pick from Gallery
            ElevatedButton.icon(
              onPressed: () => _pickImage(context, index),
              icon: Icon(Icons.photo_library, size: 16),
              label: Text('Gallery'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            
            // Take Photo
            ElevatedButton.icon(
              onPressed: () => _takePhoto(context, index),
              icon: Icon(Icons.camera_alt, size: 16),
              label: Text('Camera'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            
            // Remove Image (only if exists)
            if (product.imagePath!=null)
              IconButton(
                onPressed: () => _removeImage(context, index),
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Remove Image',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductImage(String imagePath) {
    // Check if it's a network image or local file
    if (imagePath.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, color: Colors.grey);
          },
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(imagePath),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, color: Colors.grey);
          },
        ),
      );
    }
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
              _deleteProduct(context, index);
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

    // Group products by itemName and itemType
    final Map<String, Map<String, List<Products>>> groupedProducts = {};

    for (var product in _products) {
      if (!groupedProducts.containsKey(product.itemName)) {
        groupedProducts[product.itemName] = {};
      }
      if (!groupedProducts[product.itemName]!.containsKey(product.itemType)) {
        groupedProducts[product.itemName]![product.itemType] = [];
      }
      groupedProducts[product.itemName]![product.itemType]!.add(product);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.05,
                  ),
                  itemCount: groupedProducts.length,
                  itemBuilder: (context, index) {
                    final itemName = groupedProducts.keys.elementAt(index);
                    final itemTypes = groupedProducts[itemName]!;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Name Header
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                          child: Text(
                            itemName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        
                        // Item Types for this Item Name
                        ...itemTypes.entries.map((typeEntry) {
                          final itemType = typeEntry.key;
                          final productsOfType = typeEntry.value;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item Type Subheader
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.01,
                                  left: screenWidth * 0.02,
                                ),
                                child: Text(
                                  'Type: $itemType',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              
                              // Products for this Item Type
                              ...productsOfType.asMap().entries.map((productEntry) {
                                final productIndex = productEntry.key;
                                final product = productEntry.value;
                                final globalIndex = _products.indexOf(product);
                                
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.008,
                                    horizontal: screenWidth * 0.04,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showProductDetails(context, product);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: double.infinity,
                                      height: screenHeight * 0.19,
                                      child: Padding(
                                        padding: EdgeInsets.all(screenWidth * 0.04),
                                        child: Row(
                                          children: [
                                            // Product Image/Icon
                                            Container(
                                              width: screenHeight * 0.08,
                                              height: screenHeight * 0.08,
                                              decoration: BoxDecoration(
                                                color: product.imagePath!=null 
                                                  ? Colors.amber.withOpacity(0.2)
                                                  : Colors.transparent,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: product.imagePath != null
                                                  ? _buildProductImage(product.imagePath??"")
                                                  : Icon(
                                                      Icons.inventory_2_outlined,
                                                      size: 30,
                                                      color: Colors.amber,
                                                    ),
                                            ),
                                            SizedBox(width: screenWidth * 0.04),
                                            
                                            // Product Details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    product.productName,
                                                    style: TextStyle(
                                                      fontSize: screenWidth*0.04,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Size: ${product.size}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*0.03,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    'Qty: ${product.qty}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*0.03,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            // Price
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '\#${product.price.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth*0.04,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xffC25D5D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            
                                            // Menu Button
                                            PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              icon: Container(
                                                width: screenWidth*0.07,
                                                height: screenWidth*0.07,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.more_vert,
                                                  size: screenWidth*0.03,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit, size: 18, color: Colors.blue),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'image',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.photo, size: 18, color: Colors.green),
                                                      SizedBox(width: 8),
                                                      Text('Change Image'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, size: 18, color: Colors.red),
                                                      SizedBox(width: 8),
                                                      Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  _showEditDialog(context, globalIndex, product);
                                                } else if (value == 'image') {
                                                  _showImageOptions(context, globalIndex);
                                                } else if (value == 'delete') {
                                                  _showDeleteConfirmation(context, globalIndex, product.productName);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              
                              SizedBox(height: screenHeight * 0.02),
                            ],
                          );
                        }),
                        
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                          height: screenHeight * 0.04,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, index);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(context, index);
              },
            ),
            if (_products[index].imagePath!=null)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Remove Image', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage(context, index);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Products product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Product Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image in Details
              if (product.imagePath!=null) ...[
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    child: _buildProductImage(product.imagePath??""),
                  ),
                ),
                SizedBox(height: 16),
              ],
              _buildDetailRow('Item Name', product.itemName),
              _buildDetailRow('Item Type', product.itemType),
              _buildDetailRow('Product Name', product.productName),
              _buildDetailRow('Size', product.size.toString()),
              _buildDetailRow('Quantity', product.qty.toString()),
              _buildDetailRow('Price', '\$${product.price.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}