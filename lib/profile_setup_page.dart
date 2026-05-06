import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'services/firebase_user_service.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final FirebaseUserService service = FirebaseUserService();
  final ImagePicker picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedSubject = 'Programming';
  File? imageFile;
  bool isSaving = false;

  final List<String> subjects = const [
    'Maths',
    'Science',
    'English',
    'Programming',
    'Physics',
  ];

  @override
  void initState() {
    super.initState();
    loadOldData();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> loadOldData() async {
    final user = service.currentUser;
    if (user == null) return;

    final data = await service.getUserProfile(user.uid);
    if (!mounted || data == null) return;

    setState(() {
      nameController.text = (data['name'] ?? '').toString();
      ageController.text = (data['age'] ?? '').toString();
      selectedSubject = (data['focusSubject'] ?? 'Programming').toString();
    });
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
    });
  }

  Future<void> saveProfile() async {
    final user = service.currentUser;
    if (user == null) return;

    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text.trim()) ?? 0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your name')),
      );
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      String imageUrl = '';

      final oldData = await service.getUserProfile(user.uid);
      if (oldData != null && oldData['backgroundImageUrl'] != null) {
        imageUrl = oldData['backgroundImageUrl'].toString();
      }

      if (imageFile != null) {
        imageUrl = await service.uploadBackgroundImage(imageFile!, user.uid);
      }

      await service.saveUserProfile(
        uid: user.uid,
        name: name,
        age: age,
        focusSubject: selectedSubject,
        backgroundImageUrl: imageUrl,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved to Firebase')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  decoration: const InputDecoration(
                    labelText: 'Focus Subject',
                    border: OutlineInputBorder(),
                  ),
                  items: subjects
                      .map(
                        (subject) => DropdownMenuItem(
                          value: subject,
                          child: Text(subject),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSubject = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Background Image'),
                ),
                const SizedBox(height: 12),
                if (imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      imageFile!,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSaving ? null : saveProfile,
                  child: Text(isSaving ? 'Saving...' : 'Save to Firebase'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}