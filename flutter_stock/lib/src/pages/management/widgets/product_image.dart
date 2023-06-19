import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/constants/api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProductImage extends StatefulWidget {
  final Function(File? imageFile) callbackSetImageFile;
  final String? imageUrl;

  const ProductImage(
      {Key? key, required this.callbackSetImageFile, this.imageUrl})
      : super(key: key);

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  CroppedFile? _croppedFile;
  final _picker = ImagePicker();
  String? _imageUrl;

  @override
  void initState() {
    _imageUrl = widget.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerImage(),
          _buildPreviewImage(),
        ],
      ),
    );
  }

  OutlinedButton _buildPickerImage() => OutlinedButton.icon(
      onPressed: () {
        _modalPickerImage();
      },
      icon: const FaIcon(FontAwesomeIcons.image),
      label: const Text('image'));

  dynamic _buildPreviewImage() {
    var path = "";

    if (_imageUrl != null && _imageUrl != "") {
      path = '${Api.imageURL}/$_imageUrl';
    } else if (_croppedFile != null) {
      path = _croppedFile!.path;
    }

    if (path.isNotEmpty) {
      return Stack(
        children: [
          _buildPreviewContainer(path),
          _croppedFile != null ? _buildDeleteImageButton() : const SizedBox(),
        ],
      );
    }

    return const SizedBox();
  }

  Container _buildPreviewContainer(String path) => Container(
        color: Colors.black45,
        alignment: Alignment.center,
        height: 350,
        child: _imageUrl != null ? Image.network(path) : Image.file(File(path)),
      );

  Positioned _buildDeleteImageButton() => Positioned(
      top: 4,
      right: 4,
      child: SizedBox.fromSize(
        size: const Size(48, 48),
        child: ClipOval(
          child: Material(
            color: Colors.black45,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _croppedFile = null;
                  widget.callbackSetImageFile(null);
                });
              },
              child: const Icon(Icons.clear, color: Colors.white),
            ),
          ),
        ),
      ));

  void _modalPickerImage() {
    buildListTile(IconData icon, String title, ImageSource imageSource) =>
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.pop(context);
            _pickImage(imageSource);
          },
        );

    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildListTile(Icons.photo_camera, 'Take a picture for camera',
                    ImageSource.camera),
                buildListTile(Icons.photo_library, 'Choose from photo library',
                    ImageSource.gallery),
              ],
            )));
  }

  void _pickImage(ImageSource imageSource) {
    _picker
        .pickImage(
            source: imageSource,
            imageQuality: 70,
            maxWidth: 500,
            maxHeight: 500)
        .then((pickedFile) {
      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      }
    });
  }

  _cropImage(String file) {
    ImageCropper().cropImage(
      sourcePath: file,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    ).then((croppedFile) {
      // Set file crop to file
      if (croppedFile != null) {
        // Callback set image file
        widget.callbackSetImageFile(File(croppedFile.path));
        setState(() {
          _croppedFile = croppedFile;
          _imageUrl = null;
        });
      }
    });
  }
}
