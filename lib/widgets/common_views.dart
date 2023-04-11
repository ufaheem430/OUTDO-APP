import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdo_app/util/colors.dart';

class CommonViews {
  static void showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Appcolors.blue,
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: Appcolors.white,
                      )),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
            ],
          );
        });
  }
}
