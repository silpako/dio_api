import 'package:dio_api/model/postmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/post_controller.dart';

class PostHomePage extends StatelessWidget {
  const PostHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow,
        title: const Text(
          'Dio CRUD',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () => _showCreateDialog(context, controller),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.posts.isEmpty) {
          return const Center(child: Text('No Posts Available'));
        }
        return ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 3,
              child: ListTile(
                title: Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(post.body),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context, controller, post);
                    } else if (value == 'patch') {
                      _showPatchDialog(context, controller, post);
                    } else if (value == 'delete') {
                      controller.deletePost(post.id ?? 0);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(
                        'PUT Update',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'patch',
                      child: Text(
                        'PATCH Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Create Dialog
  void _showCreateDialog(BuildContext context, PostController controller) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Create New Post',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'Body',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.createNewPost(titleCtrl.text, bodyCtrl.text);
              Get.back();
            },
            child: const Text(
              'Create',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Edit Dialog (PUT)
  void _showEditDialog(
    BuildContext context,
    PostController controller,
    PostModel post,
  ) {
    final titleCtrl = TextEditingController(text: post.title);
    final bodyCtrl = TextEditingController(text: post.body);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Edit Post (PUT)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              controller: bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'Body',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updatePost(
                post.id ?? 0,
                titleCtrl.text,
                bodyCtrl.text,
              );
              Get.back();
            },
            child: const Text(
              'Update',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Patch Dialog
  void _showPatchDialog(
    BuildContext context,
    PostController controller,
    PostModel post,
  ) {
    final titleCtrl = TextEditingController(text: post.title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Update Title (PATCH)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: 'New Title',
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.patchPost(post.id ?? 0, titleCtrl.text);
              Get.back();
            },
            child: const Text(
              'Update',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
