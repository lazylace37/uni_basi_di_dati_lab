#set smartquote(enabled: true, alternative: true)

#import "templ.typ": templ, thesis-front-page

#show: templ.with(
  title: "Progetto di Laboratorio di Basi di Dati",
  author: ("Gioele Vuaran", "Filippo Nassivera", "Mattia Rossetto", "Francesco Viciguerra"),
  font-size: 11pt,
  font: "New Computer Modern",
  front-page: thesis-front-page(
    department: "Scienze Matematiche, Informatiche e Fisiche",
    degree-type: "Corso di Laurea in",
    course: "Informatica",
    title: "Progetto di Laboratorio di Basi di Dati",
    candidates: (
      [Gioele Vuaran\ #link("mailto:167222@spes.uniud.it")],
      [Filippo Nassivera\ #link("mailto:165594@spes.uniud.it")],
      [Mattia Rossetto\ #link("mailto:169423@spes.uniud.it")],
      [Francesco Viciguerra\ #link("mailto:166896@spes.uniud.it")],
    ),
    academic-year: "2025/2026",
  )
)

#set table(stroke: .2mm + black)
#show raw: set block(width: 100%, inset: 7pt, stroke: .2mm + black, radius: 1%)

= Analisi dei Requisiti

Si vuole progettare una base di dati per la gestione di informazioni
sull'industria cinematografica. La consegna segue dall'esercizio 3 del compito
di basi di dati del 22 giugno 2009, con alcune aggiunte.

== Glossario

È stato prodotto un glossario dei termini che compaiono nel testo, insieme ad
eventuali sinonimi e collegamenti ad altri termini individuati.

#figure(
  table(
    align: left,
    columns: (auto, auto, auto, auto),
    table.header[*Termine*][*Descrizione*][*Sinonimi*][*Collegamenti*],
    [Film],
    [],
    [],
    [Attori,\ Azienda Produttrice,\ Registi,\ Frasi Significative],

    [Attore], [Recita in uno o più film], [Autore], [Film],
    [Regista],
    [Dirige almeno un film, e può recitare in uno o più film],
    [],
    [Film],

    [Copia fisica\ di un Film\*], [], [], [Film,\ Cliente],
    [Azienda\ Produttrice], [Produce uno o più film], [], [Film],
    [Cliente\*],
    [Noleggia una o più copie fisiche di film],
    [Cliente Registrato],
    [Film],

    [Ruolo], [Svolto da un attore in un film, indica il personaggio interpretato _(es. Cenerentola)_], [], [Attore,\ Film],
  ),
  caption: [Glossario (\* aggiunta alla consegna)],
)

== Strutturazione dei Requisiti

Si supponga di aver collezionato, dalla originale consegna,
il seguente insieme di requisiti per la progettazione di una base di dati
relazionale riguardante la gestione di informazioni
sull'industria cinematografica.

#stack(
  dir: ttb,
  spacing: 0.75em,
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a film*]),
    [
      - Ogni film sia identificato univocamente dal suo titolo e dall'anno di
        produzione (assumiamo che in uno stesso anno non possano venir prodotti
        due o più film con lo stesso titolo, ma ammettiamo che film con lo stesso
        titolo possano essere prodotti in anni diversi, come accade nel caso dei
        remake).
      - Ogni film abbia una durata espressa in minuti, un'unica azienda
        produttrice e sia classificato come appartenente ad uno o più generi
        (commedia, thriller, film dell'orrore, fantasy, ..)
      - Ogni film abbia uno o più registi e zero, uno o più autori che vi
        recitano.
      - Ogni film sia caratterizzato da una breve descrizione della trama.
      - Ogni film abbia zero o più frasi significative, ciascuna pronunciata da
        uno degli attori che recitano nel film (assumiamo che alcuni attori
        possano pronunciare più frasi significative, altri una sola frase
        significativa, altri ancora nessuna).
    ],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a attori*]),
    [
      - Gli attori siano identificati univocamente dal nome e dalla data di
        nascita (assumiamo che non vi siano attori con lo stesso nome nati lo
        stesso giorno).
      - Ogni attore compaia in almeno un film.
      - Ogni attore svolga uno o più ruoli in ogni film nel quale recita.
      - Si vuole registrare il numero di film in cui recita ogni attore.
    ],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a registi*]),
    [
      - I registi siano identificati univocamente dal nome e dalla data di
        nascita (assumiamo che non vi siano registi con lo stesso nome nati lo
        stesso giorno).
      - Ogni regista diriga almeno un film.
      - Un regista possa anche recitare in uno o più film, inclusi film da
        lui/lei diretti.
    ],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(
      align: center,
    )[*Frasi relative a aziende produttrici*]),
    [
      - Le aziende produttrici siano identificate dal loro nome e abbiano un
        unico recapito.
      - Ogni azienda produttrice produca uno o più film.
    ],
  ),
)

#v(1em)
Si supponga di aver collezionato anche gli ulteriori requisiti, in aggiunta alla consegna originale.

#stack(
  dir: ttb,
  spacing: 1em,
  table(
    columns: 1fr,
    table.header(table.cell(
      align: center,
    )[*Frasi relative a videonoleggio*]),
    [
      Si vuole gestire il videonoleggio di film da parte dei clienti registrati.
      - Un cliente può noleggiare una o più copie fisiche di un film per un
        certo periodo di tempo limitato. Se una copia fisica risulta prestata,
        non può essere rinoleggiata prima che essa venga restituita.
      - Si vuole ricordare lo storico dei prestiti dei film da parte dei
        clienti.
    ],
  ),
)

=== Ambiguità
La consegna risulta estremamente chiara, avendo quindi solo un minimo numero di
ambiguità.

È necessaria tuttavia una precisazione sul significato di _Ruolo_: come ruolo si
intende il personaggio interpretato da un determinato attore nel film. Notiamo
anche che tale personaggio viene considerato come specifico al film (ad esempio
il ruolo di _Cenerentola_ di un film risulterà differente dello stesso ruolo nel
suo remake).

== Operazioni <operazioni>

Le Operazioni 1-4 sono state definite per poter prepare delle interrogazioni,
sviluppate in @interrogazioni, mentre le Operazioni 5, 6, 7 e 8 con le relative
frequenze per l'analisi dei costi e delle ridondanze, sviluppate in
@ridondanze.

- _Operazione 1 (interrogazione)_: Ottieni il numero medio di attori che hanno partecipato in
  film di uno specifico genere.
- _Operazione 2 (interrogazione)_: Ottieni le coppie di clienti registrati che hanno visto gli
  stessi film.
- _Operazione 3 (interrogazione)_: Ottieni il regista che ha diretto il numero massimo di film.
- _Operazione 4 (interrogazione)_: Ottieni tutti gli attori che hanno recitato solo a film della
  stessa casa produttrice.
- _Operazione 5 (inserimento)_: Inserimento di nuovo film prodotto da una data casa
  produttrice. Frequenza: 57 inserimenti al giorno #footnote[Dal sito web IMDB,
    risulta che nell'anno 2024 sono stati rilasciati 20844 film, ovvero circa 57
    film al giorno.]
- _Operazione 6 (interrogazione)_: Calcola il numero di film prodotti da una data casa
  produttrice. Frequenza: 50 richieste al giorno #footnote[Valore ipotetico -
    media rispetto a tutte le case produttrici.]
- _Operazione 7 (inserimento)_: Inserimento di una recitazione, con relativo ruolo e frase significativa. Frequenza: 570 inserimenti al giorno #footnote[Circa 10 volte il numero di Film].
- _Operazione 8 (interrogazione)_: Calcola il numero di film in cui un attore ha recitato. Frequenza: 100 richieste al giorno.
- _Operazione 9 (rimozione)_: Rimozione di un film. 

= Progettazione Concettuale

Dall'analisi del testo e dei requisiti è stato prodotto lo schema
Entità-Relazioni di @er.

La strategia di progettazione scelta è stata la strategia _inside out_: lo
schema è stato quindi definito partendo dall'entità _Film_ e, poco a poco, è
stato allargato comprendendo il resto dei concetti identificati.
È risultato utile per questo il Glossario, dal quale si è dedotto come _Film_
fosse l'entità principale da cui tutte le altre dipendessero.

#figure(
  image("ER-ER.png", format: "png", width: 95%),
  caption: [Schema Entità-Relazioni],
) <er>

Seguono alcune osservazioni sullo schema E-R:
- Per _Copia fisica di Film_, entità debole di _Film_, si è usato il pattern di
  progettazione _istanza di_: una copia fisica ha un numero che la identifica
  tra tutte le copie fisiche di un determinato film.
- In _Azienda Produttrice_ viene mantenuto il numero di film da essa prodotti
  come un attributo derivato (derivato dalla relazione _Produce_).
- In _Attore_ viene mantenuto il numero di film in cui ha recitato come un
  attributo derivato (derivato dalla relazione _Recita in_)
- Per i noleggi si è usato il pattern per la storicizzazione, quindi
  specializzando il _Noleggio_ in _Noleggio Corrente_ e _Noleggio Passato_;
  quest'ultimo possiede l'attributo _Data di Fine_.
// Il noleggio è relativo ad una specifica copia fisica di film, dunque si è
// supposto che l'attributo `Data di Inizio` fosse sufficiente ad identificare
- In _Cliente Registrato_ sono presenti più chiavi candidate.
- In _Azienda Produttrice_ sono presenti più chiavi candidate.

== Vincoli di Integrità

I seguenti vincoli di integrità devono essere aggiunti al precedente schema per
garantire il significato atteso della base di dati:
- Una Copia fisica di un Film noleggiata non può essere rinoleggiata prima che
  venga restituita (questo implica che gli intervalli temporali generati dalle
  date di inizio e fine noleggio non si sovrappongano).
- La Data di Inizio del Noleggio deve essere antecedente alla Data di Fine
  Noleggio.

Notiamo:
- Il ciclo _'Regista - Dirige - Film - Recita in - Attore'_ non risulta problematico,
  in quanto uno specifico attore può recitare in un film che dirige.
- La durata massima del noleggio può essere maggiore della differenza tra la
  data di fine noleggio e la data di inizio noleggio, nel caso in cui la
  restituzione della copia fisica del film avvenga in ritardo.

= Progettazione Logica

== Ristrutturazione del Modello E-R

=== Tavola dei Volumi <tavola-volumi>

#align(
  center,
  figure(
    table(
      columns: 3,
      align: left,
      table.header[*Concetto*][*Tipo*][*Volume*],
      [Film],
      [Entità],
      [730000 #footnote[Il sito web IMDB contiene 731089 film alla data di scrittura.]],
      [Produce], [Relazione], [730000],
      [AziendaProduttrice], [Entità], [10000],

      [Recitazione], [Relazione], [7300000 #footnote[Circa 10 volte il numero di Film]],
      [Attore], [Entità], [2920000 #footnote[Circa il 40% delle Recitazioni]],
    ),
  )
)

=== Analisi delle Ridondanze <ridondanze>

Nello schema E-R sono presenti due ridondanze: l'attributo derivato
_Numero di Film Prodotti_ in _Azienda Produttrice_ e l'attributo derivato
_Numero di Film Recitati_ in _Attore_.
Nelle seguenti sezioni viene fatta un'analisi delle due ridondanze per decidere
se mantenerle o eliminarle.\
Si assume un costo di un accesso in lettura di $1$ unità di costo, e in
scrittura di $3$ unità di costo.

==== Ridondanza 1: Attributo derivato "Numero di Film Prodotti"

#block(breakable: false, grid(
  columns: 1fr,
  stroke: .2mm + black,
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
      "Totale" & = (1 * "CostoLettura" + 3 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (1 * 1 + 3 * 3) * 57 \
      & = 570 "unità di costo al giorno"
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

  $"Totale" = 570 + 50 = 620 "unità di costo al giorno"$
))

#block(breakable: false, grid(
  columns: 1fr,
  stroke: .2mm + black,
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
      "Totale" & = (0 * "CostoLettura" + 2 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (0 * 1 + 2 * 3) * 57 \
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
      [Produce], [Relazione], [73#footnote[Numero medio di Film prodotti per Azienda Produttrice = Volume(Produce) / Volume(Azienda)]], [L],
    ),

    $
      "Totale" & = (73 * "CostoLettura" + 0 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (73 * 1 + 0 * 3) * 50 \
      & = 3650 "unità di costo al giorno"
    $,
  ),

  $"Totale" = 342 + 3650 = 3992 "unità di costo al giorno"$
))

Dato che il costo in presenza di ridondanza, 620 unità al giorno, è minore del
costo in assenza di ridondanza, 3992 unità al giorno, si sceglie di *mantenere*
la ridondanza.

==== Ridondanza 2: Attributo derivato "Numero di Film Recitati"

#block(breakable: false, grid(
  columns: 1fr,
  stroke: .2mm + black,
  inset: 5pt,
  [*Presenza di ridondanza*],
  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 7*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Recita in], [Relazione], [1], [S],
      [Attore], [Entità], [1], [S],
      [Attore], [Entità], [1], [L],
    ),

    $
      "Totale" & = (1 * "CostoLettura" + 2 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (1 * 1 + 2 * 3) * 570 \
      & = 3990 "unità di costo al giorno"
    $,
  ),

  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 8*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Attore], [Entità], [1], [L],
    ),

    $
      "Totale" & = (1 * "CostoLettura" + 0 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (1 * 1 + 0 * 3) * 100 \
      & = 100 "unità di costo al giorno"
    $,
  ),

  $"Totale" = 3990 + 100 = 4090 "unità di costo al giorno"$
))

#block(breakable: false, grid(
  columns: 1fr,
  stroke: .2mm + black,
  inset: 5pt,
  [*Assenza di ridondanza*],
  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 7*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Recita in], [Relazione], [1], [S],
    ),

    $
      "Totale" & = (0 * "CostoLettura" + 1 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (0 * 1 + 1 * 3) * 570 \
      & = 1710 "unità di costo al giorno"
    $,
  ),

  stack(
    dir: ttb,
    spacing: 1em,
    table(
      columns: (1fr, auto, auto, auto),
      table.header(table.cell(align: center, colspan: 4)[*Operazione 8*]),
      [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
      [Recita in], [Relazione], [3#footnote[Volume(Recitazione) / Volume(Attore) = 2.3 arrotondato a 3]], [L],
    ),

    $
      "Totale" & = (3 * "CostoLettura" + 0 * "CostoScrittura") * "FrequenzaOperazione" \
      & = (3 * 1 + 0 * 3) * 100 \
      & = 300 "unità di costo al giorno"
    $,
  ),

  $"Totale" = 1710 + 300 = 2010 "unità di costo al giorno"$
))

Dato che il costo in presenza di ridondanza, 4090 unità al giorno, è maggiore
del costo in assenza di ridondanza, 2010 unità al giorno, si sceglie di
*eliminare* la ridondanza.

=== Eliminazione delle Generalizzazioni

Nello schema E-R sono presenti due generalizzazioni:

- *Generalizzazione _Persona_*: Siccome la generalizzazione è totale e sovrapposta,
  usiamo il metodo ibrido per la rimozione della generalizzazione, in cui si
  pone ogni entità figlia in relazione con l'entità genitore. Le entità figlie
  diventano quindi entità deboli. \
  Risulta necessario aggiungere un vincolo di integrità per fare in modo che _Persona_ si
  specializzi obbligatoriamente in _Attore_, _Resista_ o entrambi.

- *Generalizzazione _Noleggio_*: Siccome le generalizzazione è totale e disgiunta,
  applichiamo la tecnica della rimozione dei figli, spostando tutti gli attributi
  nella classe genitore. \
  Per discriminare tra _Noleggio Corrente_ e _Noleggio Passato_ utilizziamo
  l'attributo "Data di fine", che ora diventa opzionale, come discriminante:
  se è presente, il noleggio è da considerarsi passato, altrimenti è corrente.

=== Traduzione degli Attributi Multivalore

Si considerino gli attributi _Frasi significative_ e _Ruoli_ della relazione
_Recita in_:
- *_Frasi Significative_*: viene aggiunta un'entità debole in relazione $(1,1)$
  (nel lato _Frase Significativa_) con _Recita in_ .
- *_Ruolo_*: aggiungiamo un'entità debole in relazione $(1,1)$ (nel lato _Ruolo_)
  con _Recita in_

Si consideri l'attributo multivalore *_Generi_* in _Film_: viene aggiunta
un'entità (non debole) in relazione $(1,N)$ con _Film_.

=== Eliminazione della Relazione Quaternaria

Siccome la relazione _Recita in_, a seguito della traduzione degli attributi
multivalore, risulta quaternaria, è stata reificata in una nuova entità 
*_Recitazione_*, debole rispetto a _Film_ e _Attore_.

=== Aggiunta di Chiavi Primarie Surrogate

Dal momento che l'entità _Frase Significativa_ è identificata da una complessa
chiave composta contenente anche una stringa possibilmente molto lunga (la
frase stessa), è allora giustificabile usare una chiave surrogata per
identificarla, sebbene non sia teoricamente necessario.

=== Schema E-R Ristrutturato

#figure(
  image("ER-ER-Ristrutturato.png", format: "png", width: 95%),
  caption: [
    Schema Entità-Relazioni Ristrutturato
  ],
)

*Vincoli di integrità*:
- Una copia fisica di un film noleggiata non può essere rinoleggiata prima che
  venga restituita (questo implica che gli intervalli temporali generati dalle
  date di inizio e fine noleggio non si sovrappongano).
- La data di inizio del noleggio deve essere antecedente alla data di fine
  noleggio.
- Una _Persona_ deve essere o un _Attore_, o un _Regista_, o entrambi.

=== Scelta degli Identificatori Primari

Si considerino le seguenti entità con più chiavi primarie candidate:

- *_Cliente Registrato_*: vi sono due chiavi candidate: _username_ e _email_.
  Viene scelto *_username_*.
- *_Azienda Produttrice_*: abbiamo due chiavi candidate: _nome_ e _recapito_.
  Viene scelto *_nome_*.

== Traduzione nello Schema Relazionale <schema-relazionale>
Segue la traduzione dello schema E-R ristrutturato allo schema relazionale:

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
  [#underline[Nome], Recapito, NumeroDiFilmProdotti],
  [#vnn {Recapito, NumeroDiFilmProdotti}],
  [#unique {Recapito}],
)

#relation(
  "Film",
  [#underline[Titolo], #underline[AnnoDiProduzione], Durata, Trama, AziendaProduttrice],
  [#fk {AziendaProduttrice} $arrow.r$ {AziendaProduttrice.Nome}],
  [#vnn {Durata, Trama, AziendaProduttrice}],
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
  "RegistaDelFilm",
  [#underline[TitoloFilm], #underline[AnnoDiProduzioneFilm], #underline[NomeRegista], #underline[CognomeRegista], #underline[DataDiNascitaRegista]],
  [#fk {TitoloFilm, AnnoDiProduzioneFilm, NomeRegista, CognomeRegista, DataDiNascitaRegista} $arrow.r$ {Film.Titolo, Film.AnnoDiProduzione, Regista.Nome, Regista.Cognome, Regista.AnnoDiNascita}],
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
  [#vnn {Frase, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore}],
)

#relation(
  "Recitazione",
  [#underline[TitoloFilm], #underline[AnnoFilm], #underline[NomeAttore], #underline[CognomeAttore], #underline[DataNascitaAttore]],
  [#fk {TitoloFilm, AnnoFilm} $arrow.r$ {Film.Titolo, Film.AnnoDiProduzione}],
  [#fk {NomeAttore, CognomeAttore, DataNascitaAttore} $arrow.r$ {Attore.Nome, Attore.Cognome, Attore.DataDiNascita}],
)

=== Vincoli di Integrità <vin-int>

La traduzione dallo schema concettuale allo schema logico (schema relazionale)
rende necessaria l'aggiunta dei seguenti vincoli di integrità causati dalla
perdita di espressività del modello relazionale, che vanno a integrare i
vincoli già evidenziati inizialmente.

I *vincoli intra-relazionali*, escludendo i vincoli di chiave primaria, di
unicità, e di _NOT NULL_ che sono stati già individuati in @schema-relazionale,
sono i seguenti:
- _Noleggio_: _DataDiFine_ > _DataDiInizio_ if _DataDiFine_ IS NOT NULL
- _Film_: _Durata_ > 0

I *vincoli inter-relazionali*, escludendo i vincoli di chiave esterna che sono
stati già individuati in @schema-relazionale, sono i seguenti. Per ogni vincolo
sono riportate le azioni che potrebbero violare l'integrità della base di dati:
- Un'azienda produttrice deve aver prodotto almeno un film.
  - Inserimento in _Azienda Produttrice_
  - Cancellazione in _Film_
  - Modifica dell'attributo _AziendaProduttrice_ di Film
- Un genere deve essere associato ad almeno un film
  - Inserimento in _Genere_
  - Cancellazione in _Film_
  - Modifica dell'attributo _Genere_ nella relazione _GenereDelFilm_
  - Cancellazione dell'attributo _Genere_ nella relazione _GenereDelFilm_
- Un film deve essere associato ad almeno un genere
  - Inserimento in _Film_
  - Modifica di _Genere_ nella relazione _GenereDelFilm_
  - Cancellazione di _Genere_ nella relazione _GenereDelFilm_
- Un Film deve avere almeno un Regista
  - Inserimento in _Film_
  - Cancellazione in _Regista_
  - Modifica di _RegistaDelFilm_
  - Cancellazione di _RegistaDelFilm_
- Una Recitazione deve prevedere almeno un Ruolo
  - Cancellazione in _Ruolo_
  - Inserimento in _Recitazione_
- Un Attore deve recitare in almeno un Film
  - Inserimento in _Attore_
  - Modifica in _Recitazione_
  - Cancellazione in _Recitazione_
- Un Regista deve dirigere almeno un Film
  - Inserimento in _Regista_
  - Cancellazione in _Film_
  - Modifica in _RegistaDelFilm_
  - Cancellazione di _RegistaDelFilm_
- Una persona deve essere o un attore, o un regista, o
  entrambi:
  - Inserimento di _Persona_
  - Cancellazione di _Attore_
  - Cancellazione di _Regista_
- Ci può essere al massimo un noleggio attivo
  - Inserimento in _Noleggio_
  - Modifica in _Noleggio_
- Gli intervalli generati dalle date di inizio e di fine noleggio, per ogni copia fisica di un film, non devono sovrapporsi
  - Inserimento in _Noleggio_
  - Modifica in _Noleggio_
- Attributo derivato _Numero di Film Prodotti_ in _Azienda Produttrice_
  - Inserimento in _Film_
  - Modifica di _AziendaProduttrice_ nella relazione _Film_
  - Cancellazione in _Film_

Notiamo che, per gli quanto riguardano gli intervalli generati dalle date
relative ai noleggi, si ipotizza di lavorare con intervalli chiusi. Segue,
quindi, che se un noleggio termina il giorno 10, un nuovo noleggio per la
stessa copia fisica di un film può iniziare a partire dal giorno 11.

= Progettazione Fisica

In questa sezione viene riportato il codice DDL (Data Definition Language) SQL
per la creazione delle tabelle definite in @schema-relazionale.

I vincoli di integrità _intra-relazionali_ sono stati implementati a livello di
tabella tramite l'uso di clausole `CHECK`.

Per quanto riguarda i vincoli _inter-relazionali_:
- *Cancellazioni*: per la gestione delle chiavi esterne in fase di
  cancellazione, si è optato per l'uso di clausole `ON DELETE NO ACTION` nella
  maggior parte delle relazioni; sebbene l'utilizzo di `ON DELETE CASCADE`
  mantenga comunque l'integrità della base di dati, si è preferito rifiutare le
  operazioni di rimozione piuttosto che propagare le cancellazioni a cascata,
  cosa che comporterebbe la rimozione di grandi parti della base di dati (si
  immagini per esempio la cancellazione di una casa produttrice, che
  comporterebbe la cancellazione di tutti i film da essa prodotti).
- *Modifiche*: per le operazioni di aggiornamento invece è stato scelto
  l'utilizzo di `ON UPDATE CASCADE`, che non comporta effetti collaterali
  distruttivi.
- *Vincoli generici*: i rimanenti vincoli di integrità _inter-relazionali_
  sono stati invece implementati tramite _trigger_ (@trigger).

#let text = read("db/create.sql")
#show figure: set block(breakable: true)
#figure(
  raw(text, block: true, lang: "sql"),
  caption: [Creazione dello Schema],
) <sql-create>

= Implementazione

Per una più semplice e veloce configurazione della base di dati è stata creata
un'unica lista di comandi per la creazione delle tabelle, dei triggers, del popolamento
della base di dati, e dell'esecuzione delle interrogazioni.

```bash
psql -d $USER \
    -c "CREATE DATABASE industria_cinematografica;"

psql -d industria_cinematografica -P pager \
    -c "\i db/create.sql"    \
    -c "\i db/trigger_1.sql" \
    -c "\i db/trigger_2.sql" \
    -c "\i db/trigger_3.sql" \
    -c "\i db/trigger_4.sql" \
    -c "\i db/trigger_5.sql" \
    -c "\i db/seed.sql"       \
    -c "\i db/operation_1__query_1.sql"   \
    -c "\i db/operation_2__query_2.sql"   \
    -c "\i db/operation_3__query_3.sql"   \
    -c "\i db/operation_4__query_4.sql"   \
    -c "\i db/operation_6__query_5.sql"   \
    -c "\i db/operation_8__query_6.sql"
```

Nel caso si volesse eseguire l'istanziazione delle operazioni di inserimento e di
cancellazione con parametri di esempio, è possibile eseguire i seguenti comandi:
```bash
psql -d industria_cinematografica -P pager \
    -c "\i db/operation_5__insertion_1_instanced.sql" \
    -c "\i db/operation_7__insertion_2_instanced.sql" \
    -c "\i db/operation_9__deletion_1_instanced.sql" \
```
Si nota che l'esecuzione ripetuta di tali comandi porta ad un fallimento, data la
natura statica dei dati d'esempio inseriti o cancellati.

Al fine di porre ulteriore chiarezza, nelle sezioni successive vengono descritti 
questi passaggi uno a uno.

== Creazione della Base di Dati

Il seguente comando crea la nuova base di dati, sulla quale verranno eseguiti i
seguenti comandi di creazione delle tabelle, dei trigger, del popolamento, e
delle interrogazioni.

```bash
psql -c "CREATE DATABASE industria_cinematografica;"
```

== Creazione delle Tabelle

Una volta creata la base di dati, vengono create le tabelle, con i relativi 
vincoli di integrità, attraverso il seguente comando:

```bash
psql -d industria_cinematografica -c "\i db/create.sql"
```

== Implementazione dei Trigger <trigger>

Vengono presentate le implementazioni dei seguenti trigger, scelti per le
diverse tipologie di operazioni necessarie per mantenere i vincoli di
integrità:
1. *_Una persona deve essere o un attore, o un regista, o entrambi_*: Trigger in
   inserimento su _Persona_.
2. *_Ci può essere al massimo un noleggio attivo_*: Trigger in modifica su
   _Noleggio_.
3. *_Attributo derivato "Numero di Film Prodotti"_*: Trigger in cancellazione su
   _Film_.
4. *_Intervalli di noleggio non sovrapposti_*: Trigger in inserimento su
   _Noleggio_.

Per il setup dei triggers, eseguire:
```bash
psql -d industria_cinematografica -c "\i db/trigger_1.sql"
psql -d industria_cinematografica -c "\i db/trigger_2.sql"
psql -d industria_cinematografica -c "\i db/trigger_3.sql"
psql -d industria_cinematografica -c "\i db/trigger_4.sql"
psql -d industria_cinematografica -c "\i db/trigger_5.sql"
```

Si nota che è stato implementato anche un quinto trigger, relativo all'aggiornamento in inserimento dell'attributo derivato _"Numero di Film Prodotti"_. Non viene riportato per motivi di brevità.

=== Trigger 1: Una persona deve essere o un attore, o un regista, o entrambi

#let text = read("db/trigger_1.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Trigger 2: Ci può essere al massimo un noleggio attivo

#let text = read("db/trigger_2.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Trigger 3: Attributo derivato "Numero di Film Prodotti"

#let text = read("db/trigger_3.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Trigger 4: Intervalli di noleggio non sovrapposti

#let text = read("db/trigger_4.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

== Popolamento della Base di Dati

Il popolamento della base di dati è stato effettuato attraverso uno script
_Python_.
Per la generazione di un dataset realistico si è utilizzata la libreria
_faker_, capace di generare dati verosimili per vari domini, come nomi di
aziende, di persone, ecc.
L'obiettivo era quello di inizializzare la base di dati in modo completo, per
far sì che le operazioni di @interrogazioni restituissero risultati
significativi, e corretti, per rispettare i vincoli di integrità e quindi
evitare errori da parte dei trigger.
L'utilizzo di questi strumenti ha permesso di popolare la base di dati, anche se
con volumi ridotti rispetto a quelli proposti in @tavola-volumi.

È importante notare che l'ordine degli inserimenti deve rispettare i vincoli di
integrità definiti.

In particolare, sono state evidenziate alcune dipendenze cicliche tra
relazioni, causate dalla partecipazione obbligatoria delle relazioni coinvolte.
Per queste dipendenze cicliche, l'inserimento deve avvenire all'interno in una
o più transazioni con il controllo dei vincoli posticipato (`DEFERRED`) al
`COMMIT`.\
Segue la lista delle dipendenze problematiche:
- _Persona $<->$ Attore/Regista_: una _Persona_ deve essere o un _Attore_ o un
  _Regista_ o entrambi; un _Attore/Regista_ deve essere una Persona
- _Azienda $<->$ Film_: un'_Azienda_ deve avere prodotto almeno un _Film_; un _Film_
  deve essere prodotto da un'_Azienda_
- _Film $<->$ Genere_: un _Film_ deve avere un _Genere_; un _Genere_ deve essere
  associato ad un _Film_
- _Film $<->$ Regista_: un _Film_ deve avere un _Regista_ che lo dirige; un _Regista_
  deve dirigere un _Film_
- _Attore $<->$ Recitazione $<->$ Ruolo_: un _Attore_ deve partecipare ad almeno
  una _Recitazione_; la _Recitazione_ si riferisce a un _Attore_ e richiede almeno un
  _Ruolo_.

Di conseguenza, tutti i dati relativi alle tabelle _Azienda_, _Film_, _Generi_,
_Registi_ (e _Persone_), _RegistaDelFilm_ e _GenereDelFilm_ devono essere
inseriti in un'unica transazione.\
Lo stesso vale per _Recitazioni_, _Attori_ (e _Persone_), e _Ruoli_.

Per le rimanenti relazioni non è necessario posticipare il controllo dei
vincoli, ma i seguenti ordini di inserimento devono essere rispettati:
- _Noleggio_: l'inserimento deve avvenire successivamente all'inserimento del
  relativo _Cliente Registrato_ e della relativa _Copia fisica di film_ (tra
  _Cliente Registrato_ e _Copia fisica di film_ non è necessario un
  ordinamento);
- _Frasi Significative_: possono essere inserite in qualunque momento
  successivo all'inserimento della relativa _Recitazione_.

In definitiva, lo script di inserimento segue il seguente ordine di inserimenti:
1. Crea una transazione in cui inserisce _Aziende, Film, Generi, Registi_ (e le
   associate _Persone_), _RegistaDelFilm_ e _GenereDelFilm_, con vincoli `DEFERRED`.
2. Crea una seconda transazione in cui inserisce _Recitazioni_, _Attori_ (e le
   associate _Persone_), e _Ruoli_, con vincoli `DEFERRED`.
3. Inserisce, in questo ordine, _ClienteRegistrato_, _CopiaFisicaDiFilm_ e
   _Noleggio_.
4. Inserisce _FrasiSignificative_.

Allo scopo di rendere la configurazione del database più semplice, lo script
Python non inizializza la base di dati direttamente, ma crea un file `seed.sql` con le
istruzioni di inserimento. In questo modo non è necessario installare le
dipendenze richieste dallo script.

== Interrogazioni ed Operazioni <interrogazioni>

Vengono proposte in seguito le interrogazioni ed operazioni in riferimento a
quanto definito in @operazioni.

Notiamo che, per quanto riguarda le operazioni di inserimento e di cancellazione, tutti i parametri prefissati con `$` sono da considerarsi come variabili, e dunque da sostituire con i valori di input desiderati.
Per ogni operazione utilizzante questi parametri, è possibile trovare un esempio con valori di input specifici nei file terminanti con `_instanced` (per esempio, _operation\_5\_\_insertion_1_instanced.sql_).

=== Operazione 1

#let text = read("db/operation_1__query_1.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 2

#let text = read("db/operation_2__query_2.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 3

#let text = read("db/operation_3__query_3.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 4

#let text = read("db/operation_4__query_4.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 5

L'operazione 5, è di inserimento. Notiamo che l'aggiornamento dell'attributo
derivato _Numero di Film Prodotti_ in _Azienda Produttrice_ è gestito da un
trigger, quindi non è necessario occuparsene nell'operazione di inserimento.

#let text = read("db/operation_5__insertion_1.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 6

L'operazione 6, risulta estremamente semplice in quanto usa l'attributo derivato,
dato che la ridondanza è stata mantenuta.

Si nota che nel prototipo della base di dati è stato solo implementato il trigger
per la rimozione di film. Segue che i valori ritornati dall'esecuzione della
query nel prototipo non risulteranno aggiornati.

#let text = read("db/operation_6__query_5.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 7

#let text = read("db/operation_7__insertion_2.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")


=== Operazione 8

Avendo eliminato l'attributo derivato _numero di film recitati_, il numero di
film deve essere calcolato.

#let text = read("db/operation_8__query_6.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

=== Operazione 9

L'operazione 9 è di cancellazione. Notiamo tuttavia che, a causa dell'utilizzo
di `ON DELETE NO ACTION` per la maggior parte delle chiavi esterne, è necessario
cancellare anche tutte le istanze correlate al film da cancellare. A causa delle
dipendenze cicliche tra le relazioni, è necessario eseguire questa operazione in
una unica transazione. \
Questa operazione di rimozione è implementata per puro scopo dimostrativo, in
quanto nella vera base di dati, la cancellazione di entità dovrebbe essere solo
un caso eccezionale, e non una pratica comune.

#let text = read("db/operation_9__deletion_1.sql")
#show figure: set block(breakable: true)
#raw(text, block: true, lang: "sql")

= Conclusioni
In questo progetto è stata progettata una base di dati per un'industria cinematografica, partendo da un modello concettuale, passando per un modello logico, fino ad arrivare alla progettazione fisica, con la creazione dello schema in SQL DDL, l'implementazione dei trigger, il popolamento della base di dati e l'esecuzione di alcune interrogazioni. \

Si è capito come progettare ed implementare una solida base di dati, in particolar modo, come strutturare il processo nelle sue varie fasi.

Le competenze acquisite in questo progetto sono molteplici, e resteranno sicuramente utili per la progettazione di basi di dati in futuro, sia a livello accademico che professionale.
