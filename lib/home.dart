import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color kBg = Color(0xFF29384D);
const Color kCream = Color(0xFFFFF1D4);
const Color kSheet = Color(0xFF1E2A47);
const Color kRed = Color(0xFFFF4040);

class Contact {
  final String name;
  final String email;
  final String phone;
  final File? image;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Contact> contacts = [];

  Widget buildField(
      String hint,
      TextEditingController controller,
      void Function(String) onChanged,
      ) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: kCream),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kCream, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kCream),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kCream, width: 2),
        ),
      ),
    );
  }


  void showAddSheet() {
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final phoneC = TextEditingController();
    File? image;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: kSheet,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final picked = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (picked != null) {
                              setSheet(() => image = File(picked.path));
                            }
                          },
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kCream),
                              image: image != null
                                  ? DecorationImage(
                                image: FileImage(image!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: image == null
                                ? const Icon(Icons.image,
                                color: kCream, size: 40)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameC.text.isEmpty ? 'User Name' : nameC.text,
                                style: const TextStyle(color: kCream),
                              ),
                              const Divider(color: kCream),
                              Text(
                                emailC.text.isEmpty
                                    ? 'example@gmail.com'
                                    : emailC.text,
                                style: const TextStyle(
                                    color: kCream, fontSize: 12),
                              ),
                              const Divider(color: kCream),
                              Text(
                                phoneC.text.isEmpty
                                    ? '+200000000000'
                                    : phoneC.text,
                                style: const TextStyle(
                                    color: kCream, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    buildField('Enter User Name', nameC, (_) => setSheet(() {})),
                    const SizedBox(height: 12),
                    buildField('Enter User Email', emailC, (_) => setSheet(() {})),
                    const SizedBox(height: 12),
                    buildField('Enter User Phone', phoneC, (_) => setSheet(() {})),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCream,
                          foregroundColor: kBg,
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (nameC.text.isEmpty) return;

                          setState(() {
                            contacts.add(Contact(
                              name: nameC.text,
                              email: emailC.text,
                              phone: phoneC.text,
                              image: image,
                            ));
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Enter user'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget buildCard(Contact c, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          c.image != null
              ? Image.file(c.image!, fit: BoxFit.cover)
              : Container(
            color: Colors.grey,
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),


          Positioned(
            left: 8,
            bottom: 90,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: kCream,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(c.name,
                  style: const TextStyle(fontSize: 10, color: kBg)),
            ),
          ),

          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kCream,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    const Icon(Icons.email, size: 12, color: kBg),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(c.email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, color: kBg)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.phone, size: 12, color: kBg),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(c.phone,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, color: kBg)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 24,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        setState(() => contacts.removeAt(index));
                      },
                      icon: const Icon(Icons.delete, size: 12),
                      label: const Text('Delete',
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        leadingWidth: 117,
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset('assets/images/2.png'),
        ),
      ),


      body: contacts.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/1.gif', width: 300, height: 300),
            const Text(
              'There is No Contacts Added Here',
              style: TextStyle(
                fontSize: 20,
                color: kCream,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) =>
            buildCard(contacts[index], index),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contacts.isNotEmpty) ...[
            FloatingActionButton(
              heroTag: 'delete_all',
              backgroundColor: kRed,
              onPressed: () => setState(() => contacts.clear()),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: kCream,
            onPressed: showAddSheet,
            child: const Icon(Icons.add, color: kBg),
          ),
        ],
      ),
    );
  }
}