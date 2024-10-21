import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/custom_text_field.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/profile/domain/entities/user_profile.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();

  PlatformFile? imagePickedFile;
  Uint8List? webImage;

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

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    } else {
      Navigator.pop(context);
    }
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Label(label: 'Uploading...')
                ],
              ),
            ),
          );
        } else {
          return _buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildEditPage() {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Label(label: 'Edit Profile', color: primary),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              // setState(() {
              //   updateProfile();
              // });
              updateProfile();
            },
            icon: Icon(Icons.upload),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: secondary,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child:
        
                    /// display selected image for mobile
                    (!kIsWeb && imagePickedFile != null)
                        ? Image.file(
                            File(imagePickedFile!.path!),
                            fit: BoxFit.cover,
                          )
        
                        /// display selected image for web
                        : (kIsWeb && webImage != null)
                            ? Image.memory(
                                webImage!,
                                fit: BoxFit.cover,
                              )
        
                            /// display existing profile image
                            : CachedNetworkImage(
                                imageUrl: widget.user.profileImageUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 72,
                                  color: primary,
                                ),
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: Label(
                  label: 'Pick Image',
                  fontSize: 15,
                ),
              ),
            ),
            Label(label: 'Bio'),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomTextField(
                controller: bioTextController,
                hintText: widget.user.bio,
                obscureText: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
