
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({Key? key, required this.title, required this.hint, this.controller, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Get.isDarkMode?Colors.white:Colors.black87,
              fontFamily: "NexaBold",
              fontSize: 16,
            ),
          ),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(

                  child: TextFormField(

                    readOnly: widget==null?false:true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                    controller: controller,
                    style:  TextStyle(
                        fontSize: 14,
                        fontFamily: "NexaBold",
                        color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      contentPadding: EdgeInsets.only(left: 10),
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "NexaBold",
                          color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.surface,
                            width: 0,
                          )
                      ),

                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.surface,
                            width: 0,
                          )
                      ),
                    ),
                    //keyboardType: TextInputType.multiline,
                    //maxLines: null,
                    //expands: true,


                  ),
                ),
                widget==null?Container():Container(child: widget,)
              ],
            ),
          ),

        ],

      ),
    );
  }
}
