import 'package:ecommerce/core/helpers/string_helper.dart';
import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText({
    super.key,
    required this.text,
    this.maxLines,
    this.textStyle,
  });

  final String text;
  final int? maxLines;
  final TextStyle? textStyle;
  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textPainter = TextPainter(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: widget.text,
            style: widget.textStyle,
          ),
          maxLines: widget.maxLines ?? 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isTextOverflowed = textPainter.didExceedMaxLines;

        return Column(
          children: [
            Row(
              mainAxisAlignment: StringHelper.mainAxisAlignment(
                text: widget.text,
                isDeviceArabic: false,
                reverse: true,
              ),
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    textAlign: StringHelper.textAlign(
                      text: widget.text,
                      isDeviceArabic: false,
                    ),
                    style: widget.textStyle,
                    maxLines: isReadMore ? null : (widget.maxLines ?? 3),
                    overflow: isReadMore
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (isTextOverflowed)
              TextButton.icon(
                onPressed: () => setState(() => isReadMore = !isReadMore),
                icon: Icon(
                  isReadMore
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_outlined,
                ),
                label: Text(isReadMore ? 'Show less' : 'Show more'),
              ),
          ],
        );
      },
    );
  }
}
