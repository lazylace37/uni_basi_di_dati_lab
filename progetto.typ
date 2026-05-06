#import "templ.typ": *
#show: templ.with(
  title: "Progetto di Laboratorio di Basi di Dati",
  author: "",
  font-size: 11pt,
  font: "New Computer Modern",
)

= Analisi dei Requisiti

Contesto: industria cinematografica

== Glossario

#table(
  columns: (auto, auto, auto, auto),
  table.header[*Termine*][*Descrizione*][*Sinonimi*][*Collegamenti*],
  [Film],
  [],
  [],
  [Attori,\ Azienda Produttrice,\ Registi,\ Frasi Significative],

  [Attore], [], [Autore], [Film],
  [Regista],
  [Dirige almeno un film, e può recitare in uno o più film],
  [],
  [Film],

  [Copia fisica\ di un Film], [], [], [Film,\ Cliente],
  [Azienda\ Produttrice], [Produce uno o più film], [], [Film],
  [Cliente],
  [Noleggia una o più copie fisiche di film],
  [Cliente Registrato],
  [Film],
)

== Strutturazione dei Requisiti

#stack(
  dir: ttb,
  spacing: 1em,
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi di carattere generale*]),
    [Si supponga di aver collezionato il seguente insieme di
      requisiti per la progettazione di una base di dati
      relazionale per la gestione di informazioni
      sull'industria cinematografica.],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a film*]),
    [
      - Ogni film sia identificato univocamente dal suo titolo e dall'anno di
        produzione (assumiamo che in uno stesso anno non possano venir prodotti
        due o più film con lo stesso titolo, ma ammettiamo che film con lo
        stesso titolo possano essere prodotti in anni diversi, come accade nel
        caso dei remake).
      - Ogni film abbia una durata espressa in minuti, un’unica azienda
        produttrice e sia classificato come appartenente ad uno o più generi
        (commedia, thriller, film dell'orrore, fantasy, ..)
      - Ogni film abbia uno o più registi e zero, uno o più autori che vi
        recitano. Ogni film sia caratterizzato da una breve descrizione della
        trama. Infine, ogni film abbia zero o più frasi significative, ciascuna
        pronunciata da uno degli attori che recitano nel film (assumiamo che
        alcuni attori possano pronunciare più frasi significative, altri una
        sola frase significativa, altri ancora nessuna).
    ],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a attori*]),
    [Gli attori siano identificati univocamente dal nome e
      dalla data di nascita (assumiamo che non vi siano attori
      con lo stesso nome nati lo stesso giorno). Assumiamo che
      ogni attore compaia in almeno un film. Ogni attore
      svolga uno o più ruoli in ogni film nel quale recita. ],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a registi*]),
    [I registi siano identificati univocamente dal nome e
      dalla data di nascita (assumiamo che non vi siano
      registi con lo stesso nome nati lo stesso giorno).
      Assumiamo che ogni regista diriga almeno un film. Si
      ammetta che un regista possa anche recitare in uno o più
      film. inclusi flim da lui/lei diretti.],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(
      align: center,
    )[*Frasi relative a aziende produttrici*]),
    [Le aziende produttrici siano identificate dal loro nome
      e abbiano un unico recapito. Ogni azienda produttrice
      produca uno o più film.],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(
      align: center,
    )[*Frasi relative a videonoleggio (aggiunta alla consegna)*]),
    [Si vuole gestire il videonoleggio di film da parte dei clienti registrati.
      Un cliente può noleggiare una o più copie fisiche di un film per un certo
      periodo di tempo limitato. Se una copia fisica risulta prestata, non può
      essere rinoleggiata prima che essa venga restituita. Si vuole ricordare lo
      storico dei prestiti dei film da parte dei clienti.],
  ),
)

== Operazioni <operazioni>

#stack(
  dir: ttb,
  spacing: 1em,
  table(
    columns: 1fr,
    table.header[*Operazione 1*],
    [Ottieni il numero medio di attori che hanno partecipato in film di uno
      specifico genere.],
  ),
  table(
    columns: 1fr,
    table.header[*Operazione 2*],
    [Ottieni le coppie di clienti registrati che hanno visto gli stessi film.],
  ),
  table(
    columns: 1fr,
    table.header[*Operazione 3*],
    [Ottieni il regista che ha diretto il numero massimo di film.],
  ),
  table(
    columns: 1fr,
    table.header[*Operazione 4*],
    [Ottieni tutti gli attori che hanno recitato solo a film della stessa casa
      produttrice.],
  ),
  table(
    columns: (1fr, auto),
    table.header[*Operazione 5*][*Frequenza*],
    [Inserimento di nuovo film prodotto da una data casa produttrice.],
    [57 inserimenti al giorno #footnote[Dal sito web IMDB, risulta che nell'anno 2024
        sono stati rilasciati 20844 film, ovvero circa 57 film al giorno.]],
  ),
  table(
    columns: (1fr, auto),
    table.header[*Operazione 6*][*Frequenza*],
    [Calcola il numero di film prodotti da una data casa produttrice.],
    [50 richieste al giorno #footnote[Valore ipotetico - media rispetto a tutte
        le case produttrici.]],
  ),
)

= Progettazione Concettuale

#figure(
  image("ER-ER.png", format: "png", width: 95%),
  caption: [
    Schema Entità-Relazioni
  ],
)

== Vincoli di Integrità

// - Cicli problematici:
//   - Un attore può pronunciare una frase significativa solo in film in cui ha
//     recitato.
- Una copia fisica di un film noleggiata non può essere rinoleggiata prima che
  venga restituita.
- La data di inizio del noleggio deve essere antecedente alla data di fine
  noleggio.

Nota:
- Il ciclo 'Regista - Dirige - Milm - Recita in - Attore' non è problematico,
  perché un attore può recitare in un film che dirige.
- La durata massima del noleggio può essere maggiore della differenza tra la
  data di fine noleggio e la data di inizio noleggio, nel caso in cui la
  restituzione della copia fisica del film avvenga in ritardo.

== Note

Siccome la frase significativa è identificata da una complessa chiave composta
contenente anche una stringa possibilmente molto lunga, è giustificabile usare
una chiave surrogata per identificarla, sebbene non sia teoricamente richiesto.

= Progettazione Logica

== Ristrutturazione del Modello E-R

=== Tavola dei Volumi <tavola-volumi>

#table(
  columns: 3,
  table.header[*Concetto*][*Tipo*][*Volume*],
  [Film],
  [Entità],
  [730000 #footnote[Il sito web IMDB contiene 731089 film alla data di scrittura.]],

  [Produce], [Relazione], [730000],
  // TODO: lo inseriamo anche per le altre?
)

/*==== Tavola delle Operazioni

#stack(
  dir: ttb,
  spacing: 2em,
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    table.header(table.cell(align: center, colspan: 4)[*Operazione 5*]),
    [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
    [Azienda Produttrice], [Entità], [1], [Scrittura],
    [Produce], [Relazione], [1], [Scrittura],
  ),
)*/

=== Analisi delle Ridondanze

// Trovare le ridondanze:
// - attributi derivabili:
//   - da altri attributi della stessa entità
//   - da altri attributi di altre entità o relazioni (es. aggregazioni)
//   - conteggio di occorrenze
// - relazioni derivabili: cicli

Assumiamo un costo di un accesso in lettura di $1$, e in scrittura di $3$.

==== Ridondanza 1: Attributo derivato "Numero di Film Prodotti"

#block(breakable: false, grid(
  columns: 1fr,
  stroke: 1pt + black,
  inset: 5pt,
  [*Presenza di ridondanza*],
  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 5*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Film], [Entità], [1], [S],
      [Azienda Produttrice], [Entità], [1], [L],
      [Azienda Produttrice], [Entità], [1], [S],
      [Produce], [Relazione], [1], [S],
    ),

    $
      "Totale" & = (3 * "CostoLettura" + 1 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (3 * 1 + 1 * 3) * 57 \
      & = 342 "unità di costo al giorno"
    $,
  ),

  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 6*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Azienda Produttrice], [Entità], [1], [L],
    ),

    $
      "Totale" & = (1 * "CostoLettura" + 0 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (1 * 1 + 0 * 3) * 50 \
      & = 50 "unità di costo al giorno"
    $,
  ),

  $"Totale" = 342 + 50 = 392 "unità di costo al giorno"$
))

#block(breakable: false, grid(
  columns: 1fr,
  stroke: 1pt + black,
  inset: 5pt,
  [*Assenza di ridondanza*],
  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 5*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Film], [Entità], [1], [S],
      [Produce], [Relazione], [1], [S],
    ),

    $
      "Totale" & = (1 * "CostoLettura" + 1 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (1 * 1 + 1 * 3) * 57 \
      & = 228 "unità di costo al giorno"
    $,
  ),

  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 6*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Produce], [Relazione], [730000], [L],
    ),

    $
      "Totale" & = (730000 * "CostoLettura" + 0 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (730000 * 1 + 0 * 3) * 50 \
      & = 36500000 "unità di costo al giorno"
    $,
  ),

  $"Totale" = 228 + 36500000 = 36500228 "unità di costo al giorno"$
))

#box(
  stroke: 1pt + black,
  inset: 5pt,
  width: 100%,
)[Scegliamo di mantenere la ridondanza.]


=== Eliminazione delle Generalizzazioni

- Generalizzazione Persona: Siccome la generalizzazione è totale e sovrapposta,
  usiamo il metodo ibrido per la rimozione della generalizzazione, in cui
  aggiungiamo per ogni figlio una relazione con il genitore. Le entità figli
  diventano entità deboli.
  Aggiungiamo un vincolo di integrità per fare in modo che Persona si
  specializzi obbligatoriamente in almeno uno tra Attore e Resista.
- Generalizzazione Noleggio: Siccome le generalizzazione è totale e disgiunta,
  applichiamo la tecnica della rimozione dei figli. Per discriminare tra
  noleggio corrente e noleggio passato, utilizziamo l'attributo opzionale "Data
  di fine" come discriminante.
// Siccome il noleggio corrente è al massimo 1, questo non comporta

// TODO: spiegare perché non le altre

=== Traduzione degli Attributi Multivalore

Traduzione degli attributi "Frasi significative" e "Ruoli" della relazione
"Recita in".
- "Frasi Significative": aggiungiamo un'entità debole, in relazione $(0,N)$
  con "Recita in", dato che una stessa frase significativa può essere detta da
  attori diversi o in film diversi.
// - "Ruolo": aggiungiamo un'entità (non debole), in relazione $(1,N)$ con "Recita
//   in". Si è ipotizzato che un ruolo sia indicativo del tipo di personaggio
//   interpretato (ad es. protagonista, antagonista, comparsa, ...) invece che
//   legata allo specifico personaggio del film. // (ad es. )
- "Ruolo": aggiungiamo un'entità debole, in relazione $(1,1)$ con "Recita in".
// Si è ipotizzato che un ruolo sia indicativo del tipo di personaggio
// interpretato (ad es. protagonista, antagonista, comparsa, ...) invece che
// legata allo specifico personaggio del film. // (ad es. )

Traduzione dell'attributo multivalore "Generi": aggiungiamo una entità (non
debole) in relazione $(1,N)$ con "Film".

=== Eliminazione della Relazione Quaternaria

Siccome la relazione "Recita in", dopo la traduzione degli attributi multivalore,
risulta quaternaria, è stata reificata in una nuova entità "Recitazione",
debole rispetto a "Film" e "Attore".

=== Schema E-R Restrutturato

#figure(
  image("ER-ER-Ristrutturato.png", format: "png", width: 95%),
  caption: [
    Schema Entità-Relazioni Restrutturato
  ],
)

Vincoli di integrità:
- Una copia fisica di un film noleggiata non può essere rinoleggiata prima che
  venga restituita.
- Una persona deve essere o un Attore, o un Regista, o entrambi.
- La data di inizio del noleggio deve essere antecedente alla data di fine
  noleggio.

=== Scelta degli Identificatori Primari

- Per "Cliente Registrato" abbiamo due chiavi candidate: username e email.
  Si sceglie username.

== Traduzione nello Schema Relazionale <schema-relazionale>

#let relation(name, attributes, ..constraints) = block(
  inset: (left: 0.5em),
  breakable: false,
)[
  *#name* (#attributes)
  #set text(size: 0.9em)
  #set list(marker: [], indent: 1em)
  #for c in constraints.pos() [
    - #c
  ]
]

#let fk = text(fill: blue.darken(30%), weight: "bold")[FK: ]
#let vnn = text(fill: orange.darken(30%), weight: "bold")[VNN: ]
#let unique = text(fill: gray.darken(30%), weight: "bold")[UNIQUE: ]

#relation(
  "AziendaProduttrice",
  [#underline[Nome], NumeroDiFilmProdotti],
  [#vnn {NumeroDiFilmProdotti}],
)

#relation(
  "Film",
  [#underline[Titolo], #underline[AnnoDiProduzione], Durata, Trama, AziendaProduttrice, NomeRegista, CognomeRegista, DataDiNascitaRegista],
  [#fk {AziendaProduttrice} $arrow.r$ {AziendaProduttrice.Nome}],
  [#fk {NomeRegista, CognomeRegista, DataDiNascitaRegista} $arrow.r$ {Regista.Nome, Regista.Cognome, Regista.DataDiNascita}],
  [#vnn {Durata, Trama, AziendaProduttrice, NomeRegista, CognomeRegista, DataDiNascitaRegista}],
)

#relation(
  "Genere",
  [#underline[Nome]],
)

#relation(
  "GenereDelFilm",
  [#underline[TitoloFilm], #underline[AnnoDiProduzioneFilm], #underline[NomeGenere]],
  [#fk {TitoloFilm, AnnoDiProduzioneFilm} $arrow.r$ {Film.Titolo, Film.AnnoDiProduzione}],
  [#fk {NomeGenere} $arrow.r$ {Genere.Nome}],
)

#relation(
  "CopiaFisicaDiFilm",
  [#underline[Numero], #underline[TitoloFilm], #underline[AnnoFilm]],
  [#fk {TitoloFilm, AnnoFilm} $arrow.r$ {Film.Titolo, Film.AnnoDiProduzione}],
)

#relation(
  "Noleggio",
  [#underline[DataDiInizio], #underline[NumeroCopia], #underline[TitoloFilm], #underline[AnnoFilm], EmailCliente, DurataMassimaNoleggio, DataDiFine],
  [#fk {NumeroCopia, TitoloFilm, AnnoFilm} $arrow.r$ {CopiaFisicaDiFilm.Numero, CopiaFisicaDiFilm.TitoloFilm, CopiaFisicaDiFilm.AnnoFilm}],
  [#fk {EmailCliente} $arrow.r$ {ClienteRegistrato.Email}],
  [#vnn {EmailCliente, DurataMassimaNoleggio}],
)

#relation(
  "ClienteRegistrato",
  [#underline[Email], Username, Password],
  [#unique {Username}],
  [#vnn {Password, Username}],
)

#relation(
  "Persona",
  [#underline[Nome], #underline[Cognome], #underline[DataDiNascita]],
)

#relation(
  "Attore",
  [#underline[Nome], #underline[Cognome], #underline[DataDiNascita]],
  [#fk {Nome, Cognome, DataDiNascita} $arrow.r$ {Persona.Nome, Persona.Cognome, Persona.DataDiNascita}],
)

#relation(
  "Regista",
  [#underline[Nome], #underline[Cognome], #underline[DataDiNascita]],
  [#fk {Nome, Cognome, DataDiNascita} $arrow.r$ {Persona.Nome, Persona.Cognome, Persona.DataDiNascita}],
)

#relation(
  "Ruolo",
  [#underline[NomeRuolo], #underline[TitoloFilm], #underline[AnnoFilm], #underline[NomeAttore], #underline[CognomeAttore], #underline[DataNascitaAttore]],
  [#fk {TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore} $arrow.r$ {Recitazione.TitoloFilm, Recitazione.AnnoFilm, Recitazione.NomeAttore, Recitazione.CognomeAttore, Recitazione.DataNascitaAttore}],
)

#relation(
  "FraseSignificativa",
  [#underline[ID], Frase, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore],
  [#fk {TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore} $arrow.r$ {Recitazione.TitoloFilm, Recitazione.AnnoFilm, Recitazione.NomeAttore, Recitazione.CognomeAttore, Recitazione.DataNascitaAttore}],
  [#vnn {Frase}],
)

#relation(
  "Recitazione",
  [#underline[TitoloFilm], #underline[AnnoFilm], #underline[NomeAttore], #underline[CognomeAttore], #underline[DataNascitaAttore]],
  [#fk {TitoloFilm, AnnoFilm} $arrow.r$ {Film.Titolo, Film.AnnoDiProduzione}],
  [#fk {NomeAttore, CognomeAttore, DataNascitaAttore} $arrow.r$ {Attore.Nome, Attore.Cognome, Attore.DataDiNascita}],
)

=== Vincoli di Integrità

La traduzione dallo schema concettuale allo schema logico (schema relazionale)
rende necessaria l'aggiunta dei seguenti vincoli di integrità causati dalla
perdita di espressibilità del modello relazionale, oltre ai vincoli già
evidenziati inizialmente.

I vincoli intra-relazionali, escludendo i vincoli di chiave primaria, di
unicità, e di NOT NULL che sono stati già individuati in @schema-relazionale,
sono i seguenti:
- Noleggio: DataDiFine > DataDiInizio if DataDiFine IS NOT NULL
- Film: Durata > 0

I vincoli inter-relazionali, escludendo i vincoli di chiave esterna che sono
stati già individuati in @schema-relazionale, sono i seguenti; per ogni vincolo
sono riportate le azioni che potrebbero violare l'integrità della base di dati:
- Un'azienda produttrice deve aver prodotto almeno un film.
  - Inserimento di Azienda Produttrice
  - Cancellazione di Film
  - Modifica dell'attributo "AziendaProduttrice" di Film
- Un genere deve essere associato ad almeno un film
  - Inserimento Film
  - Cancellazione Film
  - Modifica di "Genere" nella relazione "GenereDelFilm"
  - Cancellazione di "Genere" nella relazione "GenereDelFilm"
- Un film deve essere associato ad almeno un genere
  - Cancellazione di Genere
- Un Film deve essere associato ad almeno una Recitazione
  - Cancellazione di Recitazione
  - Inserimento di Film
- Una Recitazione deve prevedere almeno un Ruolo
  - Cancellazione di Ruolo
  - Inserimento di Recitazione
- Un Attore deve recitare in almeno un Film
  - Inserimento di Attore
  - Cancellazione di Recitazione
- Un Regista deve dirigere almeno un Film
  - Inserimento Regista
  - Cancellazione di Film
  - Modifica di Film
- Una persona deve essere o un attore, o un regista, o
  entrambi:
  - Inserimento di Persona
  - Cancellazione di Attore
  - Cancellazione di Regista
- Ci può essere al massimo un noleggio attivo
  - Inserimento Noleggio
  - Modifica Noleggio
- Gli intervalli generati dalle date di inizio e di fine noleggio, per ogni copia fisica di un film, non devono sovrapporsi
  - Inserimento Noleggio
  - Modifica Noleggio
- Attributo derivato "Numero di Film Prodotti"
  - Inserimento Film
  - Modifica Film (attributo AziendaProduttrice)
  - Cancellazione Film

Notiamo che, per gli quanto riguardano gli intervalli generati dalle date
relative ai noleggi, si ipotizza di lavorare con intervalli chiusi. Segue,
quindi, che se un noleggio termina il giorno 10, un nuovo noleggio per la
stessa copia fisica di un film può iniziare a partire dal giorno 11.

Questi vincoli di integrità devono essere implementati utilizzando dei
meccanismi esterni, dato che questi non possono essere garantiti nel modello
relazionale.
Per i vincoli intra-relazionali verranno usati dei controlli CHECK, mentre per
i vincoli inter-relazionali dei _trigger_.

= Progettazione Fisica

== Creazione dello Schema in SQL DDL

Viene riportato il codice di creazione delle relazioni definite in
@schema-relazionale nel linguaggio Data Definition Language (DDL) di SQL.

#let text = read("setup/create.sql")
#show figure: set block(breakable: true)
#figure(
  raw(text, block: true, lang: "sql"),
  caption: [Creazione dello Schema]
) <sql-create>

= Implementazione

== Creazione della Base di Dati

Per creare una nuova base di dati, eseguire il seguente comando da shell:

```bash
psql -c "CREATE DATABASE industria_cinematografica;"
```

== Creazione delle Tabelle

Per eseguire il codice SQL DDL di @sql-create, eseguire sulla base di dati
appena creata:

```bash
psql -d industria_cinematografica -c "\i setup/create.sql"
```

== Implementazione dei Trigger

Vengono presentate le implementazioni dei seguenti trigger, scelti per le diverse tipologie di operazioni necessarie per mantenere i vincoli di integrità:
1. _Una persona deve essere o un attore, o un regista, o entrambi_: Trigger in inserimento su `Persona`.
2. _Ci può essere al massimo un noleggio attivo_: Trigger in modifica su `Noleggio`.
3. _Attributo derivato "Numero di Film Prodotti"_: Trigger in cancellazione su `Film`.
4. _Intervalli di noleggio non sovrapposti_: Trigger in inserimento su `Noleggio`.

Per il setup dei triggers, eseguire:
```bash
psql -d industria_cinematografica -c "\i setup/trigger_1.sql"
psql -d industria_cinematografica -c "\i setup/trigger_2.sql"
psql -d industria_cinematografica -c "\i setup/trigger_3.sql"
psql -d industria_cinematografica -c "\i setup/trigger_4.sql"
```

=== Trigger 1: Una persona deve essere o un attore, o un regista, o entrambi

#let text = read("setup/trigger_1.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Trigger 2: Ci può essere al massimo un noleggio attivo

#let text = read("setup/trigger_2.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Trigger 3: Attributo derivato "Numero di Film Prodotti"

#let text = read("setup/trigger_3.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Trigger 4: Intervalli di noleggio non sovrapposti

== Popolamento della Base di Dati

Per il popolamento della base di dati ci si è affidati ad uno script Python.
Per la generazione di un dataset realistico, si è utilizzata la libreria
_faker_, capace di generare dei dati realistici di vari domini, come nomi di
aziende, di persone, ecc.
L'uso del linguaggio di programmazione Python insieme a _faker_ ci ha permesso
di popolare la base di dati con dati piuttosto veritieri e con volumi
compatibili con quelli supposti in @tavola-volumi.

L'ordine degli inserimenti deve rispettare i vincoli definiti. In particolare,
sono state evidenziate queste dipendenze cicliche tra relazioni, causate dalla
partecipazione obbligatoria delle relazioni coinvolte. Il codice di inserimento
deve quindi posticipare (DEFERRED) il controllo dei vincoli al COMMIT.
- Persona $<->$ Attore o Regista: una Persona deve essere o un Attore o un
  Regista o entrambi; un Attore/Regista deve essere una persona
- Azienda $<->$ Film: un'Azienda deve avere prodotto almeno un Film; un Film
  deve essere prodotto da un'Azienda.
- Film $<->$ Genere: un Film deve avere un Genere; un Genere deve essere
  associato ad un Film
- Film $<->$ Regista: un Film deve avere un Regista che lo dirige; il Regista
  deve dirigere un Film
- Attore $<->$ Recitazione $<->$ Film $<->$ Ruolo: un Attore deve recitare in
  un Film; la Recitazione si riferisce ad un Film, un Attore e un Ruolo

== Interrogazioni

Le interrogazioni proposte di seguito fanno riferimento alle operazioni
definite in @operazioni.

=== Interrogazione 1

```sql
-- Troviamo per ogni film il numero di attori che vi recitano. Notiamo che ogni istanza di recitazione corrisponde ad un ed un solo un attore. Non serve quindi effettuare join con attore
CREATE VIEW NumeroAttoriPerFilm AS
SELECT Film.Titolo AS TitoloFilm, Film.AnnoDiProduzione AS AnnoFilm, COUNT(Recitazione.*) AS NumeroAttori
FROM Film
    JOIN Recitazione ON Film.Titolo = Recitazione.TitoloFilm AND Film.AnnoDiProduzione = Recitazione.AnnoFilm
GROUP BY Film.Titolo, Film.AnnoDiProduzione;

-- Utilizziamo la vista precedente per ottenere il numero medio di attori per genere
SELECT GenereDelFilm.NomeGenere, AVG(NumeroAttori)
FROM GenereDelFilm
    JOIN NumeroAttoriPerFilm ON GenereDelFilm.TitoloFilm = NumeroAttoriPerFilm.TitoloFilm AND GenereDelFilm.AnnoFilm = NumeroAttoriPerFilm.AnnoFilm
GROUP BY GenereDelFilm.NomeGenere;
```

=== Interrogazione 2

```sql
-- Troviamo i clienti che hanno visto gli stessi film.
SELECT NoleggiFilmPerCliente1.EmailCliente, NoleggiFilmPerCliente2.EmailCliente
FROM NoleggiFilmPerCliente AS NoleggiFilmPerCliente1,
    NoleggiFilmPerCliente AS NoleggiFilmPerCliente2
WHERE

-- Select con CONTAINS
SELECT Cliente1.Email, Cliente2.Email
FROM ClienteRegistrato Cliente1,
    ClienteRegistrato Cliente2
WHERE
    NOT EXISTS (
        SELECT *
        FROM NoleggiFilmPerCliente Noleggi1
        WHERE
            Noleggi1.EmailCliente = Cliente1.Email AND
            NOT EXISTS (
                SELECT *
                FROM NoleggiFilmPerCliente Noleggi2
                WHERE
                    Noleggi2.EmailCliente = Cliente2.Email AND
                    Noleggi1.NomeFilm = Noleggi2.NomeFilm AND
                    Noleggi1.AnnoFilm = Noleggi2.AnnoFilm
            )
        )
    AND
    NOT EXISTS (
        SELECT *
        FROM NoleggiFilmPerCliente Noleggi2
        WHERE
            Noleggi2.EmailCliente = Cliente2.Email AND
            NOT EXISTS (
                SELECT *
                FROM NoleggiFilmPerCliente Noleggi1
                WHERE
                    Noleggi1.EmailCliente = Cliente1.Email AND
                    Noleggi2.NomeFilm = Noleggi1.NomeFilm AND
                    Noleggi2.AnnoFilm = Noleggi1.AnnoFilm
            )
        )
    AND
        Cliente1.Email < Cliente2.Email;
```

=== Interrogazione 3

```sql
CREATE VIEW NumeroFilmPerRegista(NomeRegista, CognomeRegista, DataDiNascitaRegista, NumeroFilm) AS
SELECT Regista.Nome, Regista.Cognome, Regista.DataDiNascita, COUNT(*)
FROM Regista
	JOIN Film ON Film.NomeRegista = Regista.Nome AND
		Film.CognomeRegista = Regista.Cognome AND
		Film.DataDiNascitaRegista = Regista.DataDiNascita
GROUP BY Regista.Nome, Regista.Cognome, Regista.DataDiNascita;

SELECT NomeRegista, CognomeRegista, DataDiNascitaRegista
FROM NumeroFilmPerRegista
WHERE
	NumeroFilm >= ALL (
		SELECT NumeroFilm
		FROM NumeroFilmPerRegista
	);
```

=== Interrogazione 4

```sql
CREATE VIEW Attore_AziendeProd AS
  SELECT NomeAttore, CognomeAttore, DataNascitaAttore, AziendaProduttrice
  FROM   Recitazione JOIN Film
         ON  Recitazione.TitoloFilm = Film.Titolo
         AND Recitazione.AnnoFilm = Film.AnnoDiProduzione
;

SELECT A1.NomeAttore, A1.CognomeAttore, A1.DataNascitaAttore
FROM   Attore_AziendeProd A1
WHERE  NOT EXISTS (
  SELECT *
  FROM  AziendaProduttrice A2
  WHERE A1.NomeAttore = A2.NomeAttore
        AND A1.CognomeAttore = A2.CognomeAttore
        AND A1.DataNascitaAttore = A2.DataNascitaAttore
        AND A1.AziendaProduttrice <> A2.AziendaProduttrice
)
```

=== Interrogazione 5

```sql
INSERT INTO Film (Titolo, AnnoDiProduzione, Durata, Trama, AziendaProduttrice, NomeRegista, CognomeRegista, DataDiNascitaRegista)
VALUES ('Titolo del film', 2024, 120, 'Trama del film', 'Nome casa produttrice', 'Mario', 'Rossi', '1970-01-01');
```

=== Interrogazione 6

```sql
SELECT Nome, NumeroFilmProdotti
FROM AziendaProduttrice;
```
