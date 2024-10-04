import 'package:flutter/material.dart';
import 'package:green_docor_app/item_details_screen.dart';
import 'package:green_docor_app/items.dart';


class ItemUIDesignWidget extends StatefulWidget
{
  Items? itemsInfo;
  BuildContext? context;

  ItemUIDesignWidget({
    this.itemsInfo,
    this.context
  });

  @override
  State<ItemUIDesignWidget> createState() => _ItemUIDesignWidgetState();
}

class _ItemUIDesignWidgetState extends State<ItemUIDesignWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      onTap: ()
      {
        //send user to the detail screen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailsScreen(
          clickedItemInfo: widget.itemsInfo,
        )));
      },
      splashColor: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              //Images
              Image.network(
                widget.itemsInfo!.itemImage.toString(),
                width: 140,
                height: 140,
              ),

              const SizedBox(width: 4.0,),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15,),

                      //Item name
                      Expanded(
                          child: Text(
                            widget.itemsInfo!.itemName.toString(),
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                            ),
                          ),
                      ),


                      //Seller name
                      Expanded(
                        child: Text(
                          widget.itemsInfo!.sellerName.toString(),
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ),



                      //show discount badge
                      //price- after discount price
                      Row(
                        children: [

                          //50% OFF badge
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.teal,
                            ),
                            alignment: Alignment.topLeft,
                            width: 40,
                            height: 44,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "50%",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                  Text(
                                    "OFF",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          //original price
                          //new price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //original price
                              Row(
                                children: [
                                  const Text(
                                    "Original Price: Rs",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.lightGreen,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    (double.parse(widget.itemsInfo!.itemPrice!) + double.parse(widget.itemsInfo!.itemPrice!)).toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.lightGreen,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),

                              //new price
                              Row(
                                children: [
                                  const Text(
                                    "New Price: Rs ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.teal,

                                    ),
                                  ),
                                  Text(
                                    widget.itemsInfo!.itemPrice.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8.0,
                      ),

                      const Divider(
                        height: 4,
                        color: Colors.green,
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

