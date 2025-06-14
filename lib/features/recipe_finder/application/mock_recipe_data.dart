// lib/features/recipe_finder/application/mock_recipe_data.dart

import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/ingredient_info.dart';
import 'package:neyese4/data/models/preparation_step.dart';

// Arayüz geliştirirken kullanacağımız sahte, zenginleştirilmiş tarif verisi.
final mockEnrichedRecipeContent = EnrichedRecipeContent(
  // YENİ EKLENDİ: Eksik olan zorunlu alan
  imageUrl: 'https://i.lezzet.com.tr/images-xxlarge-secondary/ev-yapimi-iskender-nasil-yapilir-22248768-4934-4217-a146-8323894814a5.jpg',

  title: "Ev Yapımı İskender Kebap",
  difficulty: "Orta",
  readyInMinutes: 45,
  tags: ["türk mutfağı", "ana yemek", "et", "yoğurtlu"],
  estimatedNutrition: {
    "Kalori": "650 kcal",
    "Protein": "45 g",
    "Yağ": "35 g",
    "Karbonhidrat": "40 g",
  },
  requiredUtensils: [
    "Geniş bir tava",
    "Servis tabağı",
    "Bıçak",
    "Sos tavası",
  ],
  ingredients: [
    IngredientInfo(amount: 500, unit: "g", name: "dana bonfile"),
    IngredientInfo(amount: 2, unit: "adet", name: "tırnak pide"),
    IngredientInfo(amount: 3, unit: "yemek kaşığı", name: "tereyağı"),
    IngredientInfo(amount: 1, unit: "yemek kaşığı", name: "domates salçası"),
    IngredientInfo(amount: 1, unit: "su bardağı", name: "süzme yoğurt"),
    IngredientInfo(amount: 2, unit: "adet", name: "domates"),
    IngredientInfo(amount: 4, unit: "adet", name: "sivri biber"),
  ],
  preparationSteps: [
    PreparationStep(
        stepNumber: 1,
        description: "Tırnak pideleri küp küp doğrayın ve servis tabağının tabanına yayın. Üzerine hafifçe ısıtılmış süzme yoğurdu gezdirin.",
        videoPrompt: "Hands dicing turkish pide bread into cubes and spreading them on a white plate. A spoon drizzling yogurt over the bread."
    ),
    PreparationStep(
        stepNumber: 2,
        description: "Geniş bir tavada etleri yüksek ateşte mühürleyin. Ayrı bir sos tavasında 2 yemek kaşığı tereyağını eritin ve salçayı kavurun. Az su ekleyerek sos kıvamına getirin.",
        videoPrompt: "Close-up shot of beef strips searing in a hot pan. A separate small pan with butter melting and tomato paste being stirred in."
    ),
    PreparationStep(
        stepNumber: 3,
        description: "Mühürlenmiş etleri yoğurtlu pidelerin üzerine yerleştirin. Hazırladığınız salçalı sosu etlerin üzerine gezdirin. Yanına közlenmiş domates ve biber ekleyin.",
        videoPrompt: "Placing the cooked beef over the yogurt and bread. Pouring the red tomato sauce over the beef. Placing grilled tomatoes and peppers on the side."
    ),
    PreparationStep(
        stepNumber: 4,
        description: "Kalan 1 yemek kaşığı tereyağını kızdırıp tabağın üzerinde gezdirerek cızırtılı bir sesle servis edin. Afiyet olsun!",
        videoPrompt: "Pouring sizzling hot melted butter from a small pan over the final Iskender dish, creating steam and a sizzling sound."
    ),
  ],
  chefTips: [
    "En iyi lezzet için mutlaka süzme yoğurt kullanın.",
    "Tereyağını yakmamaya özen gösterin, sadece kızdırmanız yeterli.",
    "Etleri çok ince yapraklar halinde kesmek, lezzeti artıracaktır."
  ],
);