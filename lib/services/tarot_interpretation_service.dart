import 'dart:math';
import '../models/tarot_card.dart';
import 'numerology_service.dart';

class TarotInterpretationService {
  final NumerologyService _numService = NumerologyService();

  static const Map<String, Map<String, String>> _cardMeanings = {
    // Major Arcana
    "Narren": {
      "upright": "Nye begyndelser, spontanitet, eventyr og ubegrænset potentiale. Narren opfordrer dig til at tage springet med tillid.",
      "reversed": "Uforsigtighed, naivitet, risikabel adfærd. Du bør overveje konsekvenserne, før du handler.",
    },
    "Magikeren": {
      "upright": "Manifestation, kreativ kraft, viljestyrke og handling. Du har alle værktøjer til rådighed.",
      "reversed": "Manipulation, uudnyttet potentiale, bedrag. Vær ærlig over for dig selv om dine intentioner.",
    },
    "Ypperstepræstinden": {
      "upright": "Intuition, ubevidst visdom, indre stemme og mystik. Lyt til din indre vejledning.",
      "reversed": "Undertrykt intuition, hemmeligheder, tilbageholdt information. Du ignorerer vigtige signaler.",
    },
    "Kejserrinden": {
      "upright": "Frugtbarhed, overflod, natur og moderlig omsorg. En periode med vækst og kreativitet.",
      "reversed": "Kreativ blokering, afhængighed, kvælende omsorg. Find balance mellem at give og modtage.",
    },
    "Kejseren": {
      "upright": "Autoritet, struktur, stabilitet og faderlig beskyttelse. Tag kontrol over din situation.",
      "reversed": "Dominans, stivhed, manglende fleksibilitet. Vær forsigtig med at være for kontrollerende.",
    },
    "Hierofanten": {
      "upright": "Tradition, spirituel vejledning, konformitet og uddannelse. Søg visdom fra etablerede kilder.",
      "reversed": "Oprør mod konventioner, personlig frihed, uortodokse tilgange. Find din egen vej.",
    },
    "De Elskende": {
      "upright": "Kærlighed, harmoni, partnerskab og valg. Et vigtigt valg mellem hjertet og fornuften.",
      "reversed": "Ubalance i forhold, fejlkommunikation, indre konflikt. Vær ærlig om dine følelser.",
    },
    "Vognen": {
      "upright": "Sejr, viljestyrke, beslutsomhed og kontrol. Du har momentum til at nå dine mål.",
      "reversed": "Manglende retning, aggression, magtesløshed. Genvurder din kurs og find fokus.",
    },
    "Styrke": {
      "upright": "Indre styrke, mod, tålmodighed og medfølelse. Din indre kraft er din største ressource.",
      "reversed": "Selvtvivl, svaghed, usikkerhed. Find din indre løve og stå fast.",
    },
    "Eremitten": {
      "upright": "Introspektion, indre søgen, visdom og ensomhed. Tag tid til selvrefleksion.",
      "reversed": "Isolation, ensomhed, tilbagetrækning. Undgå at lukke dig selv ude fra verden.",
    },
    "Lykkehjulet": {
      "upright": "Skæbne, cykliske forandringer, held og nye muligheder. Livets hjul drejer til din fordel.",
      "reversed": "Modgang, uventede forandringer, modstand mod forandring. Acceptér livets naturlige cyklusser.",
    },
    "Retfærdighed": {
      "upright": "Retfærdighed, sandhed, balance og konsekvenser. Handlinger har følger – vær ærlig.",
      "reversed": "Uretfærdighed, uærlighed, ubalance. Noget i dit liv kræver en mere retfærdig tilgang.",
    },
    "Den Hængte": {
      "upright": "Overgivelse, nyt perspektiv, ofring og tålmodighed. Se tingene fra en ny vinkel.",
      "reversed": "Modstand mod forandring, unødvendige ofre, stagnation. Slip kontrollen.",
    },
    "Døden": {
      "upright": "Transformation, afslutninger, forandring og genfødsel. Noget gammelt må ende for at noget nyt kan begynde.",
      "reversed": "Modstand mod forandring, frygt for transformation, stagnation. Lad det gamle gå.",
    },
    "Mådehold": {
      "upright": "Balance, tålmodighed, moderation og harmoni. Find den gyldne middelvej.",
      "reversed": "Ubalance, overdrivelse, utålmodighed. Du presser for hårdt i én retning.",
    },
    "Djævelen": {
      "upright": "Afhængighed, materialisme, skyggesider og fristelse. Erkend dine lænker.",
      "reversed": "Frigørelse, genvinding af kontrol, selvbevidsthed. Du er på vej mod frihed.",
    },
    "Tårnet": {
      "upright": "Pludselig forandring, sammenbrud, åbenbaring og kaos. Det som virker ødelæggende, rydder vejen for noget bedre.",
      "reversed": "Frygt for forandring, forsinkelse af det uundgåelige. Forandringen kommer – vær forberedt.",
    },
    "Stjernen": {
      "upright": "Håb, inspiration, fornyelse og spirituel klarhed. Der er lys forude.",
      "reversed": "Håbløshed, mangel på tro, skuffelse. Genfind din tro på fremtiden.",
    },
    "Månen": {
      "upright": "Illusion, frygt, intuition og det ubevidste. Ikke alt er, som det ser ud.",
      "reversed": "Klarhed efter forvirring, frigørelse fra frygt. Sandheden kommer frem.",
    },
    "Solen": {
      "upright": "Glæde, succes, vitalitet og optimisme. En strålende periode venter dig.",
      "reversed": "Midlertidig nedtrykthed, overdreven optimisme. Find den ægte glæde indeni.",
    },
    "Dommedag": {
      "upright": "Opvågning, fornyelse, dom og kald. Tiden er kommet til at svare på dit livs kald.",
      "reversed": "Selvtvivl, manglende selvrefleksion, nægter at lytte til kaldet. Vær ærlig over for dig selv.",
    },
    "Verden": {
      "upright": "Fuldendelse, integration, præstation og rejse. Du har nået en vigtig milepæl.",
      "reversed": "Ufuldendthed, manglende afslutning, forsinkelse. Du er tæt på målet – giv ikke op.",
    },

    // Wands (Stave)
    "Essen af Stave": {
      "upright": "Ny inspiration, potentiale, kreativ gnist og begyndelse på et projekt.",
      "reversed": "Forsinkelser, manglende motivation, kreativ blokering.",
    },
    "To af Stave": {
      "upright": "Planlægning, fremtidige muligheder, beslutninger og opdagelse.",
      "reversed": "Frygt for det ukendte, manglende planlægning, begrænset udsyn.",
    },
    "Tre af Stave": {
      "upright": "Ekspansion, fremsyn, oversøiske muligheder og vækst.",
      "reversed": "Forsinkelser i planer, frustration, mangel på fremsyn.",
    },
    "Fire af Stave": {
      "upright": "Fest, harmoni, hjemkomst og stabilitet.",
      "reversed": "Personlig konflikt, ustabilitet i hjemmet, manglende harmoni.",
    },
    "Fem af Stave": {
      "upright": "Konkurrence, konflikt, stridigheder og rivalisering.",
      "reversed": "Undgåelse af konflikt, indre spændinger, kompromis.",
    },
    "Seks af Stave": {
      "upright": "Sejr, anerkendelse, succes og offentlig ros.",
      "reversed": "Fiasko, manglende anerkendelse, egoisme.",
    },
    "Syv af Stave": {
      "upright": "Forsvar, udholdenhed, stå fast og beslutsomhed.",
      "reversed": "Overgivenhed, udmattelse, manglende modstandskraft.",
    },
    "Otte af Stave": {
      "upright": "Hurtig bevægelse, fremgang, rejse og momentum.",
      "reversed": "Forsinkelser, frustration, manglende fremdrift.",
    },
    "Ni af Stave": {
      "upright": "Modstandsdygtighed, vedholdenhed, næsten i mål.",
      "reversed": "Paranoia, udmattelse, overvældelse.",
    },
    "Ti af Stave": {
      "upright": "Byrder, ansvar, hårdt arbejde og stress.",
      "reversed": "Lettelse af byrder, delegation, accept af hjælp.",
    },
    "Page af Stave": {
      "upright": "Entusiasme, udforskning, nye idéer og eventyrlyst.",
      "reversed": "Overfladiskhed, manglende retning, urealistiske planer.",
    },
    "Ridder af Stave": {
      "upright": "Energi, passion, eventyr og impulsivitet.",
      "reversed": "Hastværk, overmod, manglende tålmodighed.",
    },
    "Dronning af Stave": {
      "upright": "Selvtillid, beslutsomhed, varme og social intelligens.",
      "reversed": "Jalousi, usikkerhed, krævende adfærd.",
    },
    "Konge af Stave": {
      "upright": "Lederskab, vision, entreprenørskab og karisma.",
      "reversed": "Arrogance, utålmodighed, høje forventninger.",
    },

    // Cups (Kopper)
    "Essen af Kopper": {
      "upright": "Ny kærlighed, medfølelse, kreativitet og emotionel begyndelse.",
      "reversed": "Emotionel tomhed, blokeret kærlighed, selvcentrering.",
    },
    "To af Kopper": {
      "upright": "Partnerskab, forening, gensidig respekt og romantik.",
      "reversed": "Ubalance i forhold, brudte forbindelser, mistillid.",
    },
    "Tre af Kopper": {
      "upright": "Fest, venskab, samvær og fællesskab.",
      "reversed": "Overdrivelse, sladder, overfladiske relationer.",
    },
    "Fire af Kopper": {
      "upright": "Apati, kontemplation, utilfredshed og indadvendthed.",
      "reversed": "Ny motivation, accept af muligheder, bevægelse fremad.",
    },
    "Fem af Kopper": {
      "upright": "Tab, sorg, skuffelse og fokus på det negative.",
      "reversed": "Accept, tilgivelse, bevæge sig videre fra tab.",
    },
    "Seks af Kopper": {
      "upright": "Nostalgi, barndomsminder, uskyld og glæde fra fortiden.",
      "reversed": "At leve i fortiden, manglende fremadrettethed.",
    },
    "Syv af Kopper": {
      "upright": "Drømme, fantasi, valg og illusioner.",
      "reversed": "Klarhed, fokus, realistiske mål.",
    },
    "Otte af Kopper": {
      "upright": "At forlade noget, emotionel rejse, søgen efter dybere mening.",
      "reversed": "Frygt for forandring, fastlåsthed, undgåelse.",
    },
    "Ni af Kopper": {
      "upright": "Tilfredshed, lykke, ønsker opfyldt og velstand.",
      "reversed": "Utilfredshed, materialisme, uopfyldte ønsker.",
    },
    "Ti af Kopper": {
      "upright": "Familielykke, harmoni, emotionel opfyldelse.",
      "reversed": "Brudte relationer, familiekonflikter, uharmoni.",
    },
    "Page af Kopper": {
      "upright": "Kreativ besked, drømmeri, følsomhed og intuition.",
      "reversed": "Emotionel umodenhed, kreativ blokering.",
    },
    "Ridder af Kopper": {
      "upright": "Romantik, charm, fantasi og følelser i bevægelse.",
      "reversed": "Humørsvingninger, urealistiske forventninger, skuffelse.",
    },
    "Dronning af Kopper": {
      "upright": "Medfølelse, omsorg, emotionel sikkerhed og intuition.",
      "reversed": "Emotionel afhængighed, martyrkompleks, overbeskyttelse.",
    },
    "Konge af Kopper": {
      "upright": "Emotionel modenhed, diplomati, balance og visdom.",
      "reversed": "Emotionel manipulation, kulde, undertrykte følelser.",
    },

    // Swords (Sværd)
    "Essen af Sværd": {
      "upright": "Klarhed, sandhed, gennembrud og intellektuel kraft.",
      "reversed": "Forvirring, kaos, fejlkommunikation.",
    },
    "To af Sværd": {
      "upright": "Svært valg, stilstand, balance og blokeringer.",
      "reversed": "Informationsoverbelastning, beslutningsvægring.",
    },
    "Tre af Sværd": {
      "upright": "Hjertesorg, smerte, sorg og svigt.",
      "reversed": "Helbredelse, tilgivelse, at komme videre efter smerte.",
    },
    "Fire af Sværd": {
      "upright": "Hvile, restitution, kontemplation og genopladning.",
      "reversed": "Rastløshed, udbrændthed, mangel på hvile.",
    },
    "Fem af Sværd": {
      "upright": "Konflikt, nederlag, tab og uærlighed.",
      "reversed": "Forsoning, at lære af fejl, tilgivelse.",
    },
    "Seks af Sværd": {
      "upright": "Overgang, bevæge sig videre, rejse og forandring.",
      "reversed": "Fastlåst, modstand mod nødvendig forandring.",
    },
    "Syv af Sværd": {
      "upright": "Bedrag, strategi, list og hemmeligheder.",
      "reversed": "Afsløring af sandheden, anger, ærlig selvrefleksion.",
    },
    "Otte af Sværd": {
      "upright": "Begrænsning, fælde, magtesløshed og selvpålagte barrierer.",
      "reversed": "Ny frihed, frigørelse, selvempowerment.",
    },
    "Ni af Sværd": {
      "upright": "Angst, frygt, mareridt og bekymring.",
      "reversed": "Lettelse, recovery, at stå ansigt til ansigt med frygt.",
    },
    "Ti af Sværd": {
      "upright": "Afslutning, smertefuld transformation, rock bottom.",
      "reversed": "Genopstandelse, ny begyndelse efter krise.",
    },
    "Page af Sværd": {
      "upright": "Nysgerrighed, mental energi, nye idéer og kommunikation.",
      "reversed": "Sladder, spredning af rygter, overfladisk tænkning.",
    },
    "Ridder af Sværd": {
      "upright": "Ambition, beslutsomhed, hurtig handling og skarpsindighed.",
      "reversed": "Impulsivitet, hovmod, aggression.",
    },
    "Dronning af Sværd": {
      "upright": "Uafhængighed, klarhed, intellektuel styrke og direkte kommunikation.",
      "reversed": "Kulde, bitterhed, overdreven kritik.",
    },
    "Konge af Sværd": {
      "upright": "Intellektuel autoritet, logik, sandhed og retfærdighed.",
      "reversed": "Tyranni, manipulation, misbrug af intellektuel magt.",
    },

    // Pentacles (Mønter)
    "Essen af Mønter": {
      "upright": "Ny mulighed, velstand, investering og materiel begyndelse.",
      "reversed": "Mistet mulighed, dårlig planlægning, manglende fremgang.",
    },
    "To af Mønter": {
      "upright": "Balance, tilpasningsevne, jonglering af prioriteter.",
      "reversed": "Overbelastning, ubalance, finansielt rod.",
    },
    "Tre af Mønter": {
      "upright": "Samarbejde, teamwork, håndværk og læring.",
      "reversed": "Manglende teamwork, middelmådigt arbejde, konflikter på jobbet.",
    },
    "Fire af Mønter": {
      "upright": "Sikkerhed, konservatisme, opsparing og kontrol.",
      "reversed": "Grådighed, materialisme, frygt for tab.",
    },
    "Fem af Mønter": {
      "upright": "Finansiel modgang, fattigdom, isolation og bekymring.",
      "reversed": "Recovery, ny hjælp, forbedring af omstændigheder.",
    },
    "Seks af Mønter": {
      "upright": "Generøsitet, velgørenhed, at give og modtage hjælp.",
      "reversed": "Gæld, selviskhed, ensidigt forhold.",
    },
    "Syv af Mønter": {
      "upright": "Tålmodighed, langsigtet investering, evaluering af fremgang.",
      "reversed": "Utålmodighed, dårlige investeringer, manglende resultater.",
    },
    "Otte af Mønter": {
      "upright": "Flid, dedikation, mesterskab og fokus.",
      "reversed": "Perfektionisme, ensformighed, manglende passion.",
    },
    "Ni af Mønter": {
      "upright": "Overflod, luksus, selvtilstrækkelighed og raffinement.",
      "reversed": "Overforbrug, afhængighed af materielle ting.",
    },
    "Ti af Mønter": {
      "upright": "Arv, familieformue, langvarig succes og tradition.",
      "reversed": "Familiekonflikter om penge, tab af arv, finansiel ustabilitet.",
    },
    "Page af Mønter": {
      "upright": "Ny mulighed, studier, planlægning og ambition.",
      "reversed": "Manglende fremgang, urealistiske mål, dovenskab.",
    },
    "Ridder af Mønter": {
      "upright": "Pålidelighed, hårdt arbejde, rutine og ansvarlighed.",
      "reversed": "Stagnation, dovenskab, perfektionisme.",
    },
    "Dronning af Mønter": {
      "upright": "Praktisk omsorg, økonomisk sikkerhed, jordnær visdom.",
      "reversed": "Uorganisering, negligering af hjem, arbejdsnarkomani.",
    },
    "Konge af Mønter": {
      "upright": "Velstand, sikkerhed, lederskab og disciplin.",
      "reversed": "Grådighed, materialisme, ufleksibilitet.",
    },
  };

  static const Map<String, List<String>> _spreadPositions = {
    'Tre-korts spread': ['Fortid', 'Nutid', 'Fremtid'],
    'Kærlighedsspread': ['Dig selv', 'Din partner', 'Forholdet'],
    'Karriere & Arbejde': ['Nuværende situation', 'Udfordringer', 'Muligheder'],
    'Sundhed & Balance': ['Krop', 'Sind', 'Ånd'],
    'Beslutningsspread': ['Mulighed A', 'Mulighed B', 'Råd'],
  };

  String generateReading({
    required List<Map<String, dynamic>> drawnCards,
    required String spreadType,
    String? birthDate,
    int? lifePathNumber,
    int? personalYear,
    String? conversationHistory,
  }) {
    final buffer = StringBuffer();
    final positions = _spreadPositions[spreadType] ?? ['Position 1', 'Position 2', 'Position 3'];

    buffer.writeln('═══════════════════════════════════');
    buffer.writeln('✦ DAVSTar – $spreadType ✦');
    buffer.writeln('═══════════════════════════════════\n');

    // Oversigt
    buffer.writeln('**Oversigt**\n');
    buffer.writeln(_generateOverview(drawnCards, spreadType));
    buffer.writeln();

    // Individuel kortfortolkning
    buffer.writeln('**Individuel Kortfortolkning**\n');
    for (int i = 0; i < drawnCards.length && i < positions.length; i++) {
      final card = drawnCards[i];
      final tarotCard = card['card'] as TarotCard;
      final isReversed = card['isReversed'] as bool;
      final position = positions[i];

      buffer.writeln('▸ $position: ${tarotCard.name} (${isReversed ? "Omvendt" : "Oprejst"})');

      final meaning = _cardMeanings[tarotCard.name];
      if (meaning != null) {
        buffer.writeln(isReversed ? meaning['reversed']! : meaning['upright']!);
      }

      buffer.writeln(_getPositionInsight(position, tarotCard, isReversed));
      buffer.writeln();
    }

    // Samlet syntese
    buffer.writeln('**Samlet Syntese**\n');
    buffer.writeln(_generateSynthesis(drawnCards, spreadType));
    buffer.writeln();

    // Numerologi integration
    if (lifePathNumber != null) {
      buffer.writeln('**Numerologisk Indsigt**\n');
      buffer.writeln('Dit Life Path Number er $lifePathNumber – ${_numService.getDescription(lifePathNumber)}.');
      if (personalYear != null) {
        buffer.writeln('Du er i personligt år $personalYear – ${_numService.getDescription(personalYear)}.');
      }
      buffer.writeln(_getNumerologyIntegration(lifePathNumber, drawnCards));
      buffer.writeln();
    }

    // Praktiske råd
    buffer.writeln('**Praktiske Råd**\n');
    buffer.writeln(_generateAdvice(drawnCards, spreadType));
    buffer.writeln();

    // Afslutning
    buffer.writeln('**Afsluttende Bemærkning**\n');
    buffer.writeln(_generateClosing(drawnCards, spreadType));

    return buffer.toString();
  }

  String _generateOverview(List<Map<String, dynamic>> cards, String spread) {
    final majorCount = cards.where((c) => (c['card'] as TarotCard).suit == 'Major Arcana').length;
    final reversedCount = cards.where((c) => c['isReversed'] as bool).length;

    final buffer = StringBuffer();

    if (majorCount > 1) {
      buffer.writeln('Denne læsning indeholder $majorCount Major Arcana-kort, hvilket indikerer en periode med vigtige livsbeslutninger og skæbnebestemte begivenheder.');
    } else if (majorCount == 1) {
      buffer.writeln('Et Major Arcana-kort er til stede, hvilket tilføjer dybde og betydning til denne læsning.');
    }

    if (reversedCount > 1) {
      buffer.writeln('Med $reversedCount omvendte kort er der indre udfordringer, som kræver opmærksomhed og selvrefleksion.');
    }

    final suits = <String, int>{};
    for (final card in cards) {
      final suit = (card['card'] as TarotCard).suit;
      suits[suit] = (suits[suit] ?? 0) + 1;
    }

    if (suits.containsKey('Cups') || suits.containsKey('Kopper')) {
      buffer.writeln('Kopper-elementet bringer følelsesmæssig dybde til din læsning.');
    }
    if (suits.containsKey('Wands') || suits.containsKey('Stave')) {
      buffer.writeln('Stave-elementet indikerer kreativ energi og handlekraft.');
    }
    if (suits.containsKey('Swords') || suits.containsKey('Sværd')) {
      buffer.writeln('Sværd-elementet peger på mentale udfordringer og behovet for klarhed.');
    }
    if (suits.containsKey('Pentacles') || suits.containsKey('Mønter')) {
      buffer.writeln('Mønter-elementet handler om materielle og praktiske aspekter af dit liv.');
    }

    return buffer.toString();
  }

  String _getPositionInsight(String position, TarotCard card, bool isReversed) {
    final Map<String, String> insights = {
      'Fortid': 'I fortidspositionen viser dette kort, hvad der har formet din nuværende situation.',
      'Nutid': 'I nutidspositionen afspejler dette kort din aktuelle energi og omstændigheder.',
      'Fremtid': 'I fremtidspositionen peger dette kort mod den retning, dit liv bevæger sig.',
      'Dig selv': 'Dette kort repræsenterer din egen energi og tilgang i forholdet.',
      'Din partner': 'Her ser vi, hvad din partner bringer til relationen.',
      'Forholdet': 'Dette kort viser den samlede dynamik og potentiale i jeres forhold.',
      'Nuværende situation': 'Her ser vi den overordnede energi i din arbejdssituation.',
      'Udfordringer': 'Dette kort belyser de forhindringer, du skal navigere.',
      'Muligheder': 'Her afsløres de muligheder, der venter forude.',
      'Krop': 'Dette kort taler til din fysiske sundhed og energi.',
      'Sind': 'Her ser vi din mentale tilstand og tankeprocesser.',
      'Ånd': 'Dette kort berører din spirituelle rejse og indre balance.',
      'Mulighed A': 'Den første vej du kan vælge – overvej denne energi grundigt.',
      'Mulighed B': 'Den alternative vej – mærk efter, hvad der resonerer mest.',
      'Råd': 'Kortenes visdom guider dig mod den bedste beslutning.',
    };

    return insights[position] ?? '';
  }

  String _generateSynthesis(List<Map<String, dynamic>> cards, String spread) {
    final buffer = StringBuffer();

    buffer.writeln('Når vi ser på alle kortene samlet, tegner der sig et billede af');

    final hasPositive = cards.any((c) => !(c['isReversed'] as bool));
    final hasNegative = cards.any((c) => c['isReversed'] as bool);

    if (hasPositive && hasNegative) {
      buffer.writeln('en blanding af positive muligheder og udfordringer, der kræver balance og bevidsthed. '
          'De oprejste kort viser vejen fremad, mens de omvendte kort inviterer til indre arbejde og refleksion.');
    } else if (hasPositive) {
      buffer.writeln('overvejende positiv energi og fremgang. Kortene støtter hinanden og indikerer en gunstig periode.');
    } else {
      buffer.writeln('en tid med indre refleksion og potentielle udfordringer. Husk, at omvendte kort også rummer mulighed for vækst og transformation.');
    }

    return buffer.toString();
  }

  String _getNumerologyIntegration(int lifePath, List<Map<String, dynamic>> cards) {
    final buffer = StringBuffer();
    final random = Random();

    final themes = [
      'Dette resonerer med energien i dine trukne kort og forstærker budskabet om personlig vækst.',
      'Sammen med din numerologiske profil peger kortene på en periode med vigtig udvikling.',
      'Din numerologiske vibration harmonerer med kortenes budskab og understreger vigtigheden af denne læsning.',
    ];

    buffer.writeln(themes[random.nextInt(themes.length)]);
    return buffer.toString();
  }

  String _generateAdvice(List<Map<String, dynamic>> cards, String spread) {
    final buffer = StringBuffer();
    final random = Random();

    final advicePool = [
      'Tag dig tid til at meditere over kortenes budskab. Lad visdom synke ind, før du handler.',
      'Skriv dine tanker ned i en journal – det vil hjælpe med at klargøre kortenes vejledning.',
      'Vær opmærksom på synkroniciteter i de kommende dage. Universet sender dig tegn.',
      'Del dine refleksioner med en betroet person. Fælles indsigt kan åbne nye perspektiver.',
      'Overvej, hvordan kortenes budskab relaterer til dine daglige beslutninger og handlinger.',
    ];

    final spreadAdvice = {
      'Kærlighedsspread': 'I kærlighedens sfære er kommunikation nøglen. Vær ærlig og åben over for dine følelser.',
      'Karriere & Arbejde': 'På arbejdsfronten gælder det om at forblive fokuseret og tro mod dine værdier.',
      'Sundhed & Balance': 'Prioritér selvpleje og lyt til din krops signaler. Balance er fundamental.',
      'Beslutningsspread': 'Stol på din intuition, men understøt den med rationel overvejelse.',
      'Tre-korts spread': 'Lad fortiden informere, nutiden inspirere, og fremtiden motivere dig.',
    };

    buffer.writeln(spreadAdvice[spread] ?? advicePool[random.nextInt(advicePool.length)]);
    buffer.writeln();
    buffer.writeln(advicePool[random.nextInt(advicePool.length)]);

    return buffer.toString();
  }

  String _generateClosing(List<Map<String, dynamic>> cards, String spread) {
    final closings = [
      'Husk, at tarotkortene er et spejl af din indre visdom. Du har allerede svarene – kortene hjælper dig blot med at se dem klart. Stol på din rejse. ✦',
      'Kortene har talt, men det er din egen intuition, der er den stærkeste guide. Tag denne visdom med dig og lad den forme dine valg i de kommende dage. ✦',
      'Denne læsning er en invitation til selvrefleksion og vækst. Brug kortenes vejledning som et kompas, mens du navigerer din vej fremad. ✦',
    ];

    final random = Random();
    return closings[random.nextInt(closings.length)];
  }
}
