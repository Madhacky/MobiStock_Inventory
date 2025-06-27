import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customBackButton ({required bool isdark}){
  return Container(
     decoration: BoxDecoration(
              color:  Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: isdark?Colors.black.withOpacity(0.3):  Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
    child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color:isdark?Colors.black: Colors.white,
                  size: 20,
                ),
                onPressed: () => Get.back(),
                padding: const EdgeInsets.all(8),
              ),
  );
}