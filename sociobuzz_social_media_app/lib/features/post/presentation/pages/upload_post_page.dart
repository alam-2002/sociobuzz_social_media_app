import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/custom_text_field.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/entities/post.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image
  PlatformFile? imagePickedFile;

  // web image
  Uint8List? webImage;

  final captionTextController = TextEditingController();

  //current user
  AppUser? currentUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  void uploadPost() {
    if (imagePickedFile == null || captionTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Label(
            label: 'Both image and caption are required',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: captionTextController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    final postCubit = context.read<PostCubit>();

    // for web
    if (kIsWeb) {
      postCubit.createPost(post: newPost, imageBytes: imagePickedFile?.bytes);
    }
    // for mobile
    else {
      postCubit.createPost(post: newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    captionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        print(state);
        // loading or uploading
        if (state is PostsLoading || state is PostsUploading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return _buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildUploadPage() {
    final primary = Theme.of(context).colorScheme.primary;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Label(
          label: 'Create Post',
          color: primary,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: uploadPost,
            icon: Icon(
              Icons.upload,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            SizedBox(height: 25),

            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: Label(label: 'Pick Image'),
            ),

            SizedBox(height: 30),

            CustomTextField(
              controller: captionTextController,
              hintText: 'Caption',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
