# DAVSTar – Dansk AI Tarot & Astrologi

**Version 1.3** – Komplet Flutter-app med Tarot, Astrologi, Numerologi og Hukommelse.

## Funktioner

- **Tarot-læsning** – Træk 3 kort fra et komplet 78-korts tarot-dæk med dansk fortolkning
- **5 Spread-typer** – Tre-korts, Kærlighed, Karriere, Sundhed, Beslutning
- **Numerologi** – Automatisk beregning af Life Path Number og Personligt År
- **Astrologi** – Integration med FreeAstroAPI for natal chart og transitter
- **Hukommelse** – Gemmer tidligere læsninger og bruger dem til at give mere personlige svar
- **Indbygget fortolkningsmotor** – Alle 78 kort har danske fortolkninger (oprejst + omvendt)

## Opsætning

### Forudsætninger

- Flutter SDK >= 3.2.0
- Dart >= 3.2.0

### Installation

```bash
# Klon repository
git clone https://github.com/cptleftnut/DAVStar.git
cd DAVStar

# Installer dependencies
flutter pub get

# Tilføj tarot-billeder i assets/tarot_cards/
# Filnavne skal matche formatet: {id}_{navn}.jpg
# Eksempel: 00_narren.jpg, 01_magikeren.jpg

# Kør appen
flutter run
```

### Tarot-billeder

Tilføj dine 78 tarot-kortbilleder i `assets/tarot_cards/` med formatet:
- `{id}_{dansk_navn}.jpg` (f.eks. `00_narren.jpg`, `w01_essen_af_stave.jpg`)
- Danske specialtegn erstattes: æ→ae, ø→oe, å→aa

### API-nøgler (valgfrit)

Appen fungerer uden API-nøgler takket være den indbyggede fortolkningsmotor.

For astrologi-funktioner kan du tilføje en FreeAstroAPI-nøgle via `flutter_secure_storage`.

## Projektstruktur

```
lib/
├── main.dart                          # App entry point
├── core/
│   └── davstar_prompt.dart            # System prompt template
├── data/
│   └── tarot_deck.dart                # Komplet 78-korts dæk
├── models/
│   └── tarot_card.dart                # Tarot-kort model
├── providers/
│   └── app_provider.dart              # State management (Provider)
├── screens/
│   ├── home_screen.dart               # Hovednavigation
│   ├── tarot_reading_screen.dart      # Tarot-læsning
│   ├── astrology_input_screen.dart    # Fødselsdata input
│   ├── daily_horoscope_screen.dart    # Dagens horoskop
│   └── saved_readings_screen.dart     # Gemte læsninger
└── services/
    ├── astrology_service.dart         # FreeAstroAPI integration
    ├── numerology_service.dart        # Numerologi-beregninger
    └── tarot_interpretation_service.dart  # Indbygget fortolkningsmotor
```

## Byg APK

```bash
flutter build apk --release
```

## Licens

Privat projekt.
