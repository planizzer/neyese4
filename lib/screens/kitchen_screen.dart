// lib/screens/kitchen_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/pantry_item.dart';
import 'package:neyese4/data/providers.dart';

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({super.key});

  Future<void> _getImageAndAnalyze(ImageSource source, BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);
    if (image == null) return;

    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      final aiService = ref.read(aiServiceProvider);
      final productRepo = ref.read(productRepositoryProvider);

      // 1. Her zaman önce Gemini ile görüntüyü analiz et. Bu bizim temel ve en güvenilir verimiz.
      final aiResult = await aiService.analyzeProductImage(File(image.path));

      // 2. Analiz sonucunda bir barkod var mı kontrol et.
      final String? barcode = aiResult['barcode']?.toString();
      Map<String, dynamic> finalData = aiResult; // Başlangıç verimiz her zaman AI sonucu.

      // 3. Eğer barkod varsa, ek bilgi için Open Food Facts'e git.
      if (barcode != null && barcode.isNotEmpty) {
        final barcodeResult = await productRepo.fetchProductByBarcode(barcode);

        // 4. Eğer oradan da bir sonuç geldiyse, iki sonucu birleştir.
        // Önce barkod verisini al, sonra AI verisiyle üzerine yaz.
        // Bu, AI'ın daha iyi ayrıştırdığı quantity, unit, category gibi alanları korur.
        if (barcodeResult != null) {
          finalData = {
            ...barcodeResult, // Temel veriyi al (örn: resmi ürün adı)
            ...aiResult,      // AI'dan gelen yapısal veriyi üzerine yazarak önceliklendir
          };
        }
      }

      Navigator.pop(context); // Yükleniyor dialog'unu kapat
      _showAddItemFormSheet(context, ref, initialData: finalData);

    }  catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Analiz işlemi başarısız: $e')));
    }
  }

  void _showImageSourceOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(context: context, builder: (ctx) => Wrap(children: <Widget>[
      ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Kamerayı Kullan'), onTap: () { Navigator.pop(ctx); _getImageAndAnalyze(ImageSource.camera, context, ref); }),
      ListTile(leading: const Icon(Icons.photo_library), title: const Text('Galeriden Seç'), onTap: () { Navigator.pop(ctx); _getImageAndAnalyze(ImageSource.gallery, context, ref); }),
    ]));
  }

  void _showAddOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (ctx) => Wrap(children: <Widget>[
      ListTile(leading: const Icon(Icons.camera_alt_outlined), title: const Text('Fotoğraf ile Otomatik Ekle'), onTap: () { Navigator.pop(ctx); _showImageSourceOptions(context, ref); }),
      ListTile(leading: const Icon(Icons.edit_note), title: const Text('Elle Ekle'), onTap: () { Navigator.pop(ctx); _showAddItemFormSheet(context, ref); }),
    ]));
  }

  void _showAddItemFormSheet(BuildContext context, WidgetRef ref, {Map<String, dynamic>? initialData, dynamic itemKey, PantryItem? editingItem}) {
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _AddItemForm(initialData: initialData, editingItem: editingItem, onSave: (item) {
        final box = ref.read(pantryBoxProvider);
        if (itemKey != null) { box.put(itemKey, item); }
        else { box.put('${item.productName}-${item.addedDate.toIso8601String()}', item); }
        Navigator.pop(context);
      }),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantryBox = ref.watch(pantryBoxProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mutfağım (Akıllı Kiler)')),
      body: ValueListenableBuilder(
        valueListenable: pantryBox.listenable(),
        builder: (context, Box<PantryItem> box, _) {
          final items = box.values.toList();
          if (items.isEmpty) { return Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.kitchen_outlined, size: 100, color: Colors.grey[300]), const SizedBox(height: 24), const Text('Kilerin Henüz Boş', style: AppTextStyles.h2, textAlign: TextAlign.center), const SizedBox(height: 8), Text('Sağ alttaki (+) butonuna basarak kilerine yeni ürünler eklemeye başla!', style: AppTextStyles.body.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center, ), ], ), ), ); }
          final groupedItems = <String, List<PantryItem>>{};
          for (var i = 0; i < items.length; i++) {
            final item = items[i];
            (groupedItems[item.category] ??= []).add(item);
          }
          final sortedCategories = groupedItems.keys.toList()..sort();
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              final category = sortedCategories[index];
              final categoryItems = groupedItems[category]!;
              return ExpansionTile(
                title: Text(category, style: AppTextStyles.h2.copyWith(fontSize: 18)),
                initiallyExpanded: true,
                children: categoryItems.map((item) {
                  final itemKey = box.keyAt(box.values.toList().indexOf(item));
                  return ListTile(
                    title: Text(item.productName, style: AppTextStyles.body),
                    subtitle: Text('${item.quantity.toStringAsFixed(0)} ${item.unit} ${item.brand != null ? '(${item.brand})' : ''}'),
                    trailing: item.expirationDate != null ? Text('SKT: ${DateFormat('dd.MM.yy').format(item.expirationDate!)}', style: AppTextStyles.caption) : null,
                    onTap: () => _showAddItemFormSheet(context, ref, itemKey: itemKey, editingItem: item),
                    onLongPress: () { showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Ürünü Sil'), content: Text('"${item.productName}" ürününü kilerinden silmek istediğine emin misin?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')), TextButton(onPressed: () { box.delete(itemKey); Navigator.pop(ctx); }, child: const Text('Sil', style: TextStyle(color: Colors.red))), ], ), ); },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showAddOptions(context, ref), backgroundColor: AppColors.primaryAction, foregroundColor: Colors.white, child: const Icon(Icons.add)),
    );
  }
}

class _AddItemForm extends StatefulWidget {
  final Function(PantryItem) onSave;
  final Map<String, dynamic>? initialData;
  final PantryItem? editingItem;

  const _AddItemForm({required this.onSave, this.initialData, this.editingItem});
  @override
  State<_AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<_AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedUnit = 'adet';
  String _selectedCategory = 'Diğer';
  DateTime? _selectedDate;
  String? _barcode;
  String? _infoMessage;

  final List<String> _units = ['adet', 'g', 'kg', 'ml', 'L', 'paket', 'dilim', 'kaşık'];
  final List<String> _categories = ['Sebze & Meyve', 'Et & Tavuk', 'Süt Ürünleri', 'Bakliyat', 'Baharatlar', 'İçecekler', 'Atıştırmalık', 'Diğer'];

  @override
  void initState() {
    super.initState();
    if (widget.editingItem != null) {
      final item = widget.editingItem!;
      _nameController.text = item.productName;
      _brandController.text = item.brand ?? '';
      _quantityController.text = item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 2);
      _selectedUnit = item.unit;
      _selectedCategory = item.category;
      _selectedDate = item.expirationDate;
      _barcode = item.barcode;
    } else if (widget.initialData != null) {
      final data = widget.initialData!;
      _nameController.text = data['productName']?.toString() ?? '';
      _brandController.text = data['brand']?.toString() ?? '';
      _barcode = data['barcode']?.toString();

      // MİKTAR (QUANTITY) ALANI İÇİN DÜZELTME
      final quantity = data['quantity'];
      if (quantity != null && quantity.toString().isNotEmpty) {
        // Gelen veri 'num' (yani sayı) ise ondalıksız string'e çevir, değilse olduğu gibi al.
        _quantityController.text = (quantity is num) ? quantity.toStringAsFixed(0) : quantity.toString();
      }

      // BİRİM (UNIT) ALANI İÇİN DÜZELTME
      final initialUnit = data['unit']?.toString().toLowerCase();
      if (initialUnit != null) {
        // Gelen birim ('g', 'ml' vb.) bizim listemizde var mı diye kontrol et,
        // büyük/küçük harf duyarsız bir şekilde. Bulamazsan varsayılan olarak 'adet' ata.
        _selectedUnit = _units.firstWhere((u) => u.toLowerCase() == initialUnit, orElse: () => 'adet');
      }

      // KATEGORİ (CATEGORY) ALANI İÇİN DÜZELTME
      final initialCategory = data['category']?.toString();
      if (initialCategory != null) {
        // Gelen kategoriyi bizim uygulama kategorilerine akıllıca eşle.
        _selectedCategory = _mapApiCategoryToAppCategory(initialCategory);
      }

      final expDateString = data['expirationDate']?.toString();
      if (expDateString != null) {
        _selectedDate = DateTime.tryParse(expDateString);
      }

      if (_quantityController.text.isEmpty || _selectedDate == null) {
        _infoMessage = 'Bazı bilgiler okunamadı. Lütfen kontrol edip eksikleri tamamlayın.';
      } else {
        _infoMessage = 'Ürün bilgileri forma dolduruldu. Lütfen kontrol edin.';
      }
    }
  }

  String _mapApiCategoryToAppCategory(String apiCategory) {
    final lowerCaseCategory = apiCategory.toLowerCase().replaceAll('-', ' ');
    if (lowerCaseCategory.contains('dairies') || lowerCaseCategory.contains('cheese')) return 'Süt Ürünleri';
    if (lowerCaseCategory.contains('meat') || lowerCaseCategory.contains('poultry')) return 'Et & Tavuk';
    if (lowerCaseCategory.contains('fruit') || lowerCaseCategory.contains('vegetable')) return 'Sebze & Meyve';
    if (lowerCaseCategory.contains('beverages') || lowerCaseCategory.contains('drinks')) return 'İçecekler';
    if (lowerCaseCategory.contains('snacks')) return 'Atıştırmalık';

    final directMatch = _categories.firstWhere((c) => c.toLowerCase() == lowerCaseCategory, orElse: () => '');
    if (directMatch.isNotEmpty) return directMatch;

    return 'Diğer';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(24.0), child: Form(key: _formKey, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.editingItem != null ? 'Ürünü Düzenle' : 'Yeni Ürün Ekle', style: AppTextStyles.h2, textAlign: TextAlign.center),
        const SizedBox(height: 16),

        if (_infoMessage != null)
          _buildInfoMessage(_infoMessage!),

        TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Ürün Adı*'), validator: (value) => value!.isEmpty ? 'Lütfen bir ad girin' : null),
        TextFormField(controller: _brandController, decoration: const InputDecoration(labelText: 'Marka (İsteğe Bağlı)')),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(flex: 3, child: TextFormField(controller: _quantityController, decoration: const InputDecoration(labelText: 'Miktar*'), keyboardType: TextInputType.number, validator: (value) => value!.isEmpty ? 'Lütfen miktar girin' : null)),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: DropdownButtonFormField<String>(value: _selectedUnit, items: _units.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(), onChanged: (value) => setState(() => _selectedUnit = value!))),
        ]),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(labelText: 'Kategori*'),
          items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
          onChanged: (value) {
            if(value != null) {
              setState(() => _selectedCategory = value);
            }
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Son Kullanma Tarihi (İsteğe Bağlı)', hintText: _selectedDate == null ? 'Tarih Seç' : DateFormat('dd MMMM yyyy').format(_selectedDate!)),
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 30)), lastDate: DateTime.now().add(const Duration(days: 365 * 5)));
            if (date != null) setState(() => _selectedDate = date);
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.primaryAction),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newItem = PantryItem(
                productName: _nameController.text,
                brand: _brandController.text.isNotEmpty ? _brandController.text : null,
                quantity: double.tryParse(_quantityController.text) ?? 0,
                unit: _selectedUnit,
                category: _selectedCategory,
                addedDate: widget.editingItem?.addedDate ?? DateTime.now(),
                expirationDate: _selectedDate,
                barcode: widget.editingItem?.barcode ?? _barcode,
              );
              widget.onSave(newItem);
            }
          },
          child: Text(widget.editingItem != null ? 'GÜNCELLE' : 'KİLERE EKLE', style: AppTextStyles.button),
        )
      ],
    ),),),);
  }

  Widget _buildInfoMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: AppColors.primaryAction.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        const Icon(Icons.info_outline, color: AppColors.primaryAction),
        const SizedBox(width: 12),
        Expanded(child: Text(message, style: AppTextStyles.body.copyWith(color: AppColors.primaryAction))),
      ],),
    );
  }
}