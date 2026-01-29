# ekitabay

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

4. Les défis spécifiques au Mushaf de Médine
    -   La Police d'écriture : Le texte Uthmani nécessite des polices spécifiques (ex: KFGQPC Uthman Taha Naskh). Assurez-vous que les ligatures ne sautent pas lors du changement de style.

    -   Pagination : Si vous voulez un aspect "vrai livre", il faudra gérer les PageView. Chaque page doit calculer quels versets elle contient pour activer le surlignage.

Note importante : Pour un rendu parfait "au mot près" (si vous décidez d'aller plus loin que le verset), vous devrez utiliser des coordonnées de rendu (RenderBox) pour dessiner un rectangle de couleur derrière le texte, car le texte arabe peut être complexe à segmenter.