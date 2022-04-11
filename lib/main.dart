import 'package:constants/constants.dart';
import 'package:e_commerce_seller/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:models/models.dart';

import 'controllers/controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeControllers();
  runApp(const MyApp());
}

void initializeControllers() {
  Get.put<StorageController>(StorageController());
  Get.put<UserDataController>(UserDataController());
  Get.put<AuthController>(AuthController());
  Get.put<NavController>(NavController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initialRoute,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<CategoryModel> categories = [
    CategoryModel(
      categoryID: '1',
      name: 'Books & Stationary',
      color: kGraphColors[0].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fbooks_stationary.png?alt=media&token=f5cabd83-9e8c-4c88-890f-d9f52408082e',
    ),
    CategoryModel(
      categoryID: '2',
      name: 'Consumer Electronics',
      color: kGraphColors[1].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fconsumer_electronics.png?alt=media&token=ea7ae42f-5b33-4272-ab4d-634eed141fe4',
    ),
    CategoryModel(
      categoryID: '3',
      name: 'Fashion & Footwear',
      color: kGraphColors[2].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Ffashion_footwear.png?alt=media&token=669a26fa-ccb3-42b5-8f5c-33c7915d699c',
    ),
    CategoryModel(
      categoryID: '4',
      name: 'Groceries',
      color: kGraphColors[3].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fgroceries.png?alt=media&token=9587c3fe-b569-4be7-b3fe-96f47ccd1aa5',
    ),
    CategoryModel(
      categoryID: '5',
      name: 'Home & Kitchen',
      color: kGraphColors[4].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fhome_kitchen.png?alt=media&token=e982b5f2-2a12-47b1-967e-28c4b426a3f0',
    ),
    CategoryModel(
      categoryID: '6',
      name: 'Baby Products',
      color: kGraphColors[5].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fbaby_products.png?alt=media&token=79dbfb69-a060-45aa-a2c1-e76a05c279b5',
    ),
    CategoryModel(
      categoryID: '7',
      name: 'Jewelery',
      color: kGraphColors[6].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fjewelery.png?alt=media&token=5b561cd1-638f-4c1d-9f17-f88b8da671d9',
    ),
    CategoryModel(
      categoryID: '8',
      name: 'Gaming',
      color: kGraphColors[7].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fgaming.png?alt=media&token=cc9ed37f-a277-44be-a234-aa4d3d88d6d0',
    ),
    CategoryModel(
      categoryID: '9',
      name: 'Sports & Fitness',
      color: kGraphColors[8].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fsports_fitness.png?alt=media&token=ae3aa7cf-cb1b-429a-98a0-aebbb423afe4',
    ),
    CategoryModel(
      categoryID: '10',
      name: 'Beauty & Care',
      color: kGraphColors[9].value,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/agumentik-e-commerce.appspot.com/o/categories%2Fbeauty_personal_care.png?alt=media&token=14717c74-e7b0-432f-b019-1ff977efd8e9',
    ),
  ];

  Future<void> _showLoading() async {
    // DialogHelper.showLoadingDialog();
    DialogHelper.showSuccessDialog();
    // DialogHelper.showErrorDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final Color color = Color(categories[index].color);
          return Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              borderRadius: kMediumRadius,
              border: Border.all(color: color, width: 2),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Image.network(
                    categories[index].imageUrl,
                    // width: Get.width * 0.15,
                    fit: BoxFit.contain,
                    height: Get.width * 0.25,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          color: kPrimaryColor,
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    shape: kSmallBorder,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        categories[index].name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showLoading,
        // onPressed: () => FirebaseService.uploadCategories(categories: categories),
        label: const Text('Upload'),
        icon: const Icon(Icons.upload_rounded),
      ),
    );
  }
}
