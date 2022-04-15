import 'package:flutter/material.dart';
import '../model/blogs.dart';
import '../model/blog.dart';
import '../controller/blog_form.dart';

class EditPage extends StatefulWidget {
  final Blog? blog;

  const EditPage({
    Key? key,
    this.blog,
  }) : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.blog?.title ?? '';
    description = widget.blog?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: BlogForm(
            title: title,
            description: description,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          onSurface: Colors.blue.shade900,
          shadowColor: Colors.grey.shade600,
          primary: isFormValid ? Colors.blue.shade900 : Colors.blue.shade900,
        ),
        onPressed: addOrUpdateBlog,
        child: const Text(
          'Add or Update',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  void addOrUpdateBlog() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.blog != null;

      if (isUpdating) {
        await updateBlog();
      } else {
        await addBlog();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateBlog() async {
    final blog = widget.blog!.copy(
      title: title,
      description: description,
    );

    await BlogDatabaseHandler.instance.update(blog);
  }

  Future addBlog() async {
    final blog = Blog(
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );

    await BlogDatabaseHandler.instance.create(blog);
  }
}
