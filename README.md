# Info Carte SIM

Une application Flutter moderne et élégante pour afficher les informations détaillées des cartes SIM de votre appareil Android.

## 📱 Fonctionnalités

- Affichage du numéro de téléphone principal
- Détection et affichage des informations pour plusieurs cartes SIM
- Pour chaque carte SIM :
  - Numéro de téléphone
  - Nom de l'opérateur
  - Code pays
  - Préfixe téléphonique international
  - Code opérateur
- Interface utilisateur moderne avec animations fluides
- Support du thème Material Design 3
- Gestion des erreurs et des permissions

## 🚀 Prérequis

- Flutter (dernière version stable)
- Android SDK
- Un appareil Android ou un émulateur

## 📥 Installation

1. Clonez le dépôt :
```bash
git clone [url-du-depot]
cd sim_card_info
```

2. Installez les dépendances :
```bash
flutter pub get
```

3. Lancez l'application :
```bash
flutter run
```

## ⚙️ Configuration Android

L'application nécessite la permission `READ_PHONE_STATE` pour accéder aux informations des cartes SIM. Cette permission est automatiquement demandée lors du lancement de l'application.

Dans le fichier `android/app/src/main/AndroidManifest.xml`, assurez-vous que la permission suivante est présente :

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

## 💡 Utilisation

1. Lancez l'application
2. Accordez la permission d'accès au téléphone lorsque demandé
3. Les informations des cartes SIM s'afficheront automatiquement

## 🎨 Interface Utilisateur

L'application utilise une interface moderne avec :
- Un dégradé de couleur élégant
- Des animations de transition fluides
- Des cartes Material Design pour l'affichage des informations
- Des icônes intuitives pour chaque type d'information
- Une gestion adaptative des erreurs et des états de chargement

## 📝 Notes

- L'application est optimisée pour Android
- Les permissions sont nécessaires pour le bon fonctionnement de l'application
- En cas de refus des permissions, un message d'erreur approprié est affiché

## 🔒 Sécurité

L'application accède uniquement aux informations de base des cartes SIM et ne collecte ni ne stocke aucune donnée personnelle.
