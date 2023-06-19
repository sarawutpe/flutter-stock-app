import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/constants/api.dart';
import 'package:flutter_mystock/src/models/posts.dart';
import 'package:flutter_mystock/src/utils/format.dart';
import 'package:flutter_mystock/src/widgets/image_not_found.dart';

class ProductItem extends StatelessWidget {
  final double maxHeight;
  final Product product;

  final VoidCallback? onTap;

  const ProductItem(this.maxHeight,
      {Key? key, required this.product, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildImage(),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Stack _buildImage() {
    final height = maxHeight * 0.7;
    final productImage = product.image;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: productImage != null && productImage.isNotEmpty
              ? Image.network('${Api.imageURL}/$productImage')
              : const ImageNotFound(),
        ),
        if (product.stock! <= 0) _buildOutOfStock()
      ],
    );
  }

  Expanded _buildInfo() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name!, maxLines: 2, overflow: TextOverflow.ellipsis),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '฿${formatCurrency.format(product.price)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent),
                  ),
                  Text('${formatNumber.format(product.stock)} pieces'),
                ],
              )
            ],
          ),
        ),
      );

  Positioned _buildOutOfStock() => const Positioned(
        right: 2,
        top: 2,
        child: Card(
          margin: EdgeInsets.all(0),
          color: Colors.amber,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'out of stock',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      );
}
