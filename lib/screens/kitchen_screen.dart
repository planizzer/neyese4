import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/kitchen_ingredient.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Hive'ı UI'da kullanmak için import ediyoruz.

// Veritabanı kutusunun adını tanımlıyoruz.
const String kKitchenBox = 'kitchen_box';

// Mutfağımdaki malzemeler kutusunu dinleyen bir provider.
// Bu, listenin anında güncellenmesini sağlar.
final kitchenBoxProvider = Provider((ref) => Hive.box<KitchenIngredient>(kKitchenBox));

class KitchenScreen extends ConsumerStatefulWidget {
  const KitchenScreen({super.key});

  @override
  ConsumerState<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends ConsumerState<KitchenScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final box = ref.read(kitchenBoxProvider);
      // Malzemenin adını anahtar (key) olarak kullanarak ekliyoruz.
      // Bu, aynı malzemenin tekrar eklenmesini engeller.
      box.put(text.toLowerCase(), KitchenIngredient(name: text));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kutuyu dinleyerek arayüzümüzü reaktif hale getiriyoruz.
    final kitchenBox = ref.watch(kitchenBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutfağım'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Malzeme ekleme alanı
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Malzeme Ekle',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addIngredient(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addIngredient,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryAction,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Malzeme listesi
          Expanded(
            // Kutudaki değişiklikleri dinleyen ValueListenableBuilder.
            child: ValueListenableBuilder(
              valueListenable: kitchenBox.listenable(),
              builder: (context, Box<KitchenIngredient> box, _) {
                final ingredients = box.values.toList();
                if (ingredients.isEmpty) {
                  return const Center(
                    child: Text('Mutfağınızda hiç malzeme yok.'),
                  );
                }
                return ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return ListTile(
                      title: Text(ingredient.name, style: AppTextStyles.body),
                      // Malzemeyi silmek için bir ikon.
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          // Malzemeyi anahtarını kullanarak siliyoruz.
                          box.delete(ingredient.name.toLowerCase());
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
