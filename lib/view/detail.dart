import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/blogs.dart';
import '../model/blog.dart';
import 'edit.dart';

class DetailPage extends StatefulWidget {
  final int blogId;

  const DetailPage({
    Key? key,
    required this.blogId,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Blog blog;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshBlog();
  }

  Future refreshBlog() async {
    setState(() => isLoading = true);

    blog = await BlogDatabaseHandler.instance.readBlog(widget.blogId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            const Text(' ... '),
            editButton(),
            const Text(' ... '),
            deleteButton(),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      blog.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat.yMMMd().format(blog.createdTime),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      blog.description,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          onSurface: Colors.blue.shade900,
          shadowColor: Colors.grey.shade600,
          primary: Colors.blue.shade900,
        ),
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditPage(blog: blog),
            ),
          );

          refreshBlog();
        },
        child: const Text(
          'Edit',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );

  Widget deleteButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          onSurface: Colors.blue.shade900,
          shadowColor: Colors.grey.shade600,
          primary: Colors.blue.shade900,
        ),
        onPressed: () async {
          await BlogDatabaseHandler.instance.delete(widget.blogId);

          Navigator.of(context).pop();
        },
        child: const Text(
          'Delete',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
}
