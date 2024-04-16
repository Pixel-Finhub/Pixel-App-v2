import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class FileInputBuilder extends StatefulWidget {
  final Function(File?) onFileSelected;

  FileInputBuilder({required this.onFileSelected});

  @override
  _FileInputBuilderState createState() => _FileInputBuilderState();
}

class _FileInputBuilderState extends State<FileInputBuilder> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        widget.onFileSelected(_selectedFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 0, 5),
          child: Text('Upload File'),
        ),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.cloud_upload,
                    size: 20,
                  ),
                ),
                if (_selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _selectedFile!.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Text('Select a file'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

FormField<File?> buildFileFormField(BuildContext context) {
  return FormField<File?>(
    builder: (FormFieldState<File?> state) {
      return FileInputBuilder(
        onFileSelected: (File? file) {
          state.didChange(file);
        },
      );
    },
    validator: (value) {
      if (value == null) {
        return 'Please select a file';
      }
      return null; // Validation passed
    },
  );
}
