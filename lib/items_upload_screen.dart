import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_docor_app/api_consumer.dart';
import 'package:green_docor_app/home_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


class ItemsUploadScreen extends StatefulWidget
{
  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen>
{
  Uint8List? imageFileUint8List;
  TextEditingController sellerNameTextEditingController = TextEditingController();
  TextEditingController sellerPhoneTextEditingController = TextEditingController();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController = TextEditingController();
  TextEditingController itemPriceTextEditingController = TextEditingController();

  bool isUploading = false;
  String downloadUrlOfUploadedImage = "";

  //upload form screen
  Widget uploadFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade50,
        title: const Text(
          "Upload New Item",
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.teal,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: ()
              {
                  //validate upload from fields
                if (isUploading != true)
                {
                  validateUploadFromAndUploadItemInfo();
                }

              },
              icon: const Icon(
                Icons.cloud_upload,
                color: Colors.teal,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [

         isUploading == true
            ? const LinearProgressIndicator(color: Colors.purpleAccent,)
            : Container(),

          //image
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: imageFileUint8List != null ?
              Image.memory(
                imageFileUint8List!
              ) : LoadingAnimationWidget.fourRotatingDots(
                     color: Colors.teal,
                      size: 100,
              ),
            ),
          ),

          const Divider(
            color: Colors.blueGrey,
            thickness: 2,
          ),

          //seller name
          ListTile(
            leading: const Icon(
                Icons.person_pin_rounded,
                color: Colors.teal,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.teal),
                controller: sellerNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Seller name",
                  hintStyle: TextStyle(color: Colors.teal),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
          ),

          //seller phone
          ListTile(
            leading: const Icon(
              Icons.phone_android_rounded,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.teal),
                controller: sellerPhoneTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Seller phone",
                  hintStyle: TextStyle(color: Colors.teal),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
          ),

          //item name
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.teal),
                controller: itemNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Item name",
                  hintStyle: TextStyle(color: Colors.teal),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
          ),

          //item description
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.teal),
                controller: itemDescriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "item description",
                  hintStyle: TextStyle(color: Colors.teal),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
          ),

          //item price
          ListTile(
            leading: const Icon(
              Icons.price_change,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.teal),
                controller: itemPriceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Item price",
                  hintStyle: TextStyle(color: Colors.teal),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  validateUploadFromAndUploadItemInfo()
  async {
      if(imageFileUint8List != null)
      {
          if(sellerNameTextEditingController.text.isNotEmpty
              && sellerPhoneTextEditingController.text.isNotEmpty
              && itemNameTextEditingController.text.isNotEmpty
              && itemDescriptionTextEditingController.text.isNotEmpty
              && itemPriceTextEditingController.text.isNotEmpty)
          {
            setState(() {
              isUploading = true;
            });

            //Upload image to firebase storage
            String imageUniqueName = DateTime.now().microsecondsSinceEpoch.toString();

            fStorage.Reference firebaseStorageRef = fStorage.FirebaseStorage.instance.ref()
                .child("Items Image")
                .child(imageUniqueName);

            fStorage.UploadTask uploadTaskImageFile = firebaseStorageRef.putData(imageFileUint8List!);

            fStorage.TaskSnapshot taskSnapshot = await uploadTaskImageFile.whenComplete(() {});
            await taskSnapshot.ref.getDownloadURL().then((imageDownloadUrl)
            {
              downloadUrlOfUploadedImage = imageDownloadUrl;
            });

            // save item info to firestore
            saveItemInfoToFirebase();

          }
          else
          {
            Fluttertoast.showToast(msg: "Please complete upload form. Every field is mandatory");
          }
      }
      else
      {
        Fluttertoast.showToast(msg: "Please select image file.");
      }
  }

  saveItemInfoToFirebase()
  {
    String itemUniqueId = DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseFirestore.instance.collection("items")
        .doc(itemUniqueId)
        .set(
        {
          "itemID": itemUniqueId,
          "itemName": itemNameTextEditingController.text,
          "itemDescription": itemDescriptionTextEditingController.text,
          "itemImage": downloadUrlOfUploadedImage,
          "itemPrice": itemPriceTextEditingController.text,
          "sellerName": sellerNameTextEditingController.text,
          "sellerPhone":sellerPhoneTextEditingController.text,
          "publishedDate": DateTime.now(),
          "status": "available",
        });
    Fluttertoast.showToast(msg: "Your New item uploaded successfully.");

    setState(() {
      isUploading = false;
      imageFileUint8List = null;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
  }

  //default screen
  Widget defaultScreen()
  {
    return Scaffold (
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Upload New Item",
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.add_photo_alternate,
                color: Colors.teal,
                size: 110,

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: ()
                {
                    showDialogBox();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  "Add New Item",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDialogBox(){
    return showDialog(
      context: context,
      builder: (c){
        return SimpleDialog(
          backgroundColor: Colors.teal,
          title: const Text(
            "Item Image",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [

            SimpleDialogOption(
              onPressed: (){
                captureImageWithPhoneCamera();
              },
              child: const Text(
                "Take a photo from Camera",
                style: TextStyle(
                  color: Colors.white,
                )
              ),
            ),

            SimpleDialogOption(
              onPressed: (){
                chooseImageFromPhoneGallery();
              },
              child: const Text(
                  "Choose image from Gallery",
                  style: TextStyle(
                    color: Colors.white,
                  )
              ),
            ),

            SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                  )
              ),
            ),
          ],
        );
      }
    );
  }

  captureImageWithPhoneCamera() async
  {
    Navigator.pop(context);
    try{
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if(pickedImage != null){
        String imagePath = pickedImage.path;
        imageFileUint8List = await pickedImage.readAsBytes();

        //remove background from image
        //make image transparent
         imageFileUint8List = await ApiConsumer().removeImageBackgroundApi(imagePath);

        setState(() {
          imageFileUint8List;
        });
      }
    }
    catch(errorMsg){
        print(errorMsg.toString());

        setState(() {
          imageFileUint8List = null;
        });
    }
  }

  chooseImageFromPhoneGallery() async
  {
    Navigator.pop(context);
    try{
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedImage != null){
        String imagePath = pickedImage.path;
        imageFileUint8List = await pickedImage.readAsBytes();

        //remove background from image
        //make image transparent
        imageFileUint8List = await ApiConsumer().removeImageBackgroundApi(imagePath);

        setState(() {
          imageFileUint8List;
        });
      }
    }
    catch(errorMsg){
      print(errorMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return imageFileUint8List == null ? defaultScreen() : uploadFormScreen();
  }
}

