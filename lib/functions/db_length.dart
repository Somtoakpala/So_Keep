import 'package:hive/hive.dart';
import 'package:so_keep/model/product_model.dart';

class GetDataBaselength {
Future<int> getData() async{
  
   Hive.registerAdapter(ProductsAdapter());
  var box = await Hive.openBox('myBox');

print("Box Length is: ${box.length}");
return box.length;
  
}


}