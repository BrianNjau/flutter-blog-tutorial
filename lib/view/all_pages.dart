import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/model/blogs.dart';
import '/model/blog.dart';
import 'edit.dart';
import 'detail.dart';
import '/controller/blog_card.dart';

class AllPages extends StatefulWidget {
   const AllPages({Key? key}) : super(key: key);
 
  @override
  _AllPagesState createState() => _AllPagesState();
}

class _AllPagesState extends State<AllPages> {
  Icon customIcon = const Icon(Icons.search);
 Widget customSearchBar = const Text('My Feed',
 style: TextStyle(color: Colors.white, fontSize: 36,)
 );
  late List<Blog> blogs;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshingAllBogs();
  }

  @override
  void dispose() {
    BlogDatabaseHandler.instance.close();

    super.dispose();
  }

  Future refreshingAllBogs() async {
    setState(() => isLoading = true);

    blogs = await BlogDatabaseHandler.instance.readAllBlogs();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: customSearchBar,
           
          actions: [
            IconButton(onPressed: ()=>{ setState(() {
    if (customIcon.icon == Icons.search) {
     customIcon = const Icon(Icons.cancel);
   customSearchBar = const ListTile(
   leading: Icon(
    Icons.search,
    color: Colors.white,
    size: 28,
   ),
   title: TextField(
    decoration: InputDecoration(
    hintText: 'search for blogs...',
    hintStyle: TextStyle(
     color: Colors.white,
     fontSize: 18,
     fontStyle: FontStyle.italic,
    ),
    border: InputBorder.none,
    ),
    style: TextStyle(
    color: Colors.white,
    ),
   ),
   );
    } else {
     customIcon = const Icon(Icons.search);
     customSearchBar = const Text('My Feed');
    }
    })}, icon:customIcon)
          ],
          centerTitle:true
        ),
        
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : blogs.isEmpty
                  ? const Text(
                      'No Blogs created',
                      style: TextStyle(color: Colors.white, fontSize: 48,),
                    )
                  : buildingAllBlogs(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Create',
          foregroundColor: Color.fromARGB(255, 0, 0, 0),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditPage()),
            );

            refreshingAllBogs();
          },
          label: const Text(
            'Create',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );

  Widget buildingAllBlogs() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: blogs.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final blog = blogs[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(blogId: blog.id!),
              ));

              refreshingAllBogs();
            },
            child: BlogCard(blog: blog, index: index),
          );
        },
      );
}
