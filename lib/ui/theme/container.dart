import 'package:flutter/material.dart';

class DesignContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double? allBorderRadius, allPadding, allMargin;
  final EdgeInsetsGeometry? padding, margin;
  final Color? color;
  final bool bordered;
  final Border? border;
  final Clip? clipBehavior;
  final BoxShape shape;
  final double? width, height;
  final AlignmentGeometry? alignment;
  final bool enableBorderRadius;

  const DesignContainer({
    Key? key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.allBorderRadius,
    this.allPadding,
    this.border,
    this.bordered = false,
    this.clipBehavior,
    this.color,
    this.shape = BoxShape.rectangle,
    this.width,
    this.height,
    this.alignment,
    this.enableBorderRadius = true,
    this.allMargin,
    this.margin,
  }) : super(key: key);

  const DesignContainer.none({
    Key? key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.allBorderRadius = 0,
    this.allPadding = 0,
    this.border,
    this.bordered = false,
    this.clipBehavior,
    this.enableBorderRadius = true,
    this.color,
    this.shape = BoxShape.rectangle,
    this.width,
    this.height,
    this.alignment,
    this.allMargin,
    this.margin,
  }) : super(key: key);

  const DesignContainer.bordered({
    Key? key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.allBorderRadius,
    this.allPadding,
    this.border,
    this.bordered = true,
    this.enableBorderRadius = true,
    this.clipBehavior,
    this.color,
    this.shape = BoxShape.rectangle,
    this.width,
    this.height,
    this.alignment,
    this.allMargin,
    this.margin,
  }) : super(key: key);

  const DesignContainer.roundBordered({
    Key? key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.allBorderRadius,
    this.enableBorderRadius = true,
    this.allPadding,
    this.border,
    this.bordered = true,
    this.clipBehavior,
    this.color,
    this.shape = BoxShape.circle,
    this.width,
    this.height,
    this.alignment,
    this.allMargin,
    this.margin,
  }) : super(key: key);

  const DesignContainer.rounded({
    Key? key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.allBorderRadius,
    this.enableBorderRadius = true,
    this.allPadding,
    this.border,
    this.bordered = false,
    this.clipBehavior = Clip.antiAliasWithSaveLayer,
    this.color,
    this.shape = BoxShape.circle,
    this.width,
    this.height,
    this.alignment,
    this.allMargin,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin ?? EdgeInsets.all(allMargin ?? 0),
      decoration: BoxDecoration(
          color: color ?? Colors.black,
          shape: shape,
          borderRadius: enableBorderRadius
              ? (shape == BoxShape.rectangle
                  ? borderRadius ??
                      BorderRadius.all(Radius.circular(allBorderRadius ?? 6))
                  : null)
              : null,
          border: bordered
              ? border ?? Border.all(color: Colors.black, width: 1)
              : null),
      padding: padding ?? EdgeInsets.all(allPadding ?? 16),
      clipBehavior: clipBehavior ?? Clip.none,
      child: child,
    ); 
    return container;
  }
}
