import 'package:ecommerce/config/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDraggableScrollableSheet extends StatefulWidget {

  final Widget child;
  const CustomDraggableScrollableSheet({super.key,required this.child});

  @override
  State<CustomDraggableScrollableSheet> createState() => _CustomDraggableScrollableSheetState();
}

class _CustomDraggableScrollableSheetState extends State<CustomDraggableScrollableSheet> {

  late DraggableScrollableController _draggableScrollableController;
  ValueNotifier<double> bottomSheetSize = ValueNotifier(0.20);


  @override
  void initState() {

    _draggableScrollableController = DraggableScrollableController();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      if (_draggableScrollableController.isAttached) {
        _draggableScrollableController.addListener(() {
          bottomSheetSize.value = _draggableScrollableController.size;
          if (_draggableScrollableController.size == 1) {
            bottomSheetSize.value=_draggableScrollableController.size;
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      minChildSize: 0.15,
      maxChildSize: 0.15,
      initialChildSize: 0.15,
      expand: false,
      builder: (BuildContext context, ScrollController controller) {
        return ValueListenableBuilder(
          valueListenable: bottomSheetSize,
          builder: (context, value, child) {
            return Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: AppColors.white,
                    borderRadius: value == 1
                        ? null
                        : const BorderRadius.vertical(
                        top: Radius.circular(20))),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  controller: controller,
                  child: widget.child,
                ));
          },
        );
      },
    );
  }
}
