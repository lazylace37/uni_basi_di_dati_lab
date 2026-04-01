#import "templ.typ": *
#show: templ.with(
  title: "Progetto di Laboratorio di Basi di Dati",
  author: "",
  font-size: 11pt,
  font: "New Computer Modern",
)

= Progettazione Concettuale

== Analisi dei Requisiti

Contesto: industria cinematografica

=== Glossario

#table(
  columns: (auto, auto, auto, auto),
  table.header[*Termine*][*Descrizione*][*Sinonimi*][*Collegamenti*],
  [Film], [], [], [Attori,\ Azienda Produttice,\ Registi,\ Frasi Significative],
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

=== Strutturazione dei Requisiti

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

=== Operazioni

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

== Rappresentazione Concettuale dei Dati

#figure(
  image("ER-ER.png", format: "png", width: 95%),
  caption: [
    Schema Entità-Relazioni
  ],
)

=== Vincoli di Integrità

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

= Progettazione Logica

== Ristrutturazione del Modello E-R

=== Analisi delle Prestazioni

==== Tavola dei Volumi

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
- "Ruolo": aggiungiamo un'entità debole, in relazione $(1,N)$ con "Recita in".
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

== Traduzione nello Schema Relazionale

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
  [#vnn {Password}],
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
  [#underline[NomeRuolo]],
)

#relation(
  "FraseSignificativa",
  [#underline[Frase], #underline[TitoloFilm], #underline[AnnoFilm], #underline[NomeAttore], #underline[CognomeAttore], #underline[DataNascitaAttore], #underline[NomeRuolo]],
  [#fk {TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore, NomeRuolo} $arrow.r$ {Recitazione.TitoloFilm, Recitazione.AnnoFilm, Recitazione.NomeAttore, Recitazione.CognomeAttore, Recitazione.DataNascitaAttore, Recitazione.NomeRuolo}],
)

#relation(
  "Recitazione",
  [#underline[TitoloFilm], #underline[AnnoFilm], #underline[NomeAttore], #underline[CognomeAttore], #underline[DataNascitaAttore], #underline[NomeRuolo]],
  [#fk {TitoloFilm, AnnoFilm} $arrow.r$ {Film.Titolo, Film.AnnoDiProduzione}],
  [#fk {NomeAttore, CognomeAttore, DataNascitaAttore} $arrow.r$ {Attore.Nome, Attore.Cognome, Attore.DataDiNascita}],
  [#fk {NomeRuolo} $arrow.r$ {Ruolo.NomeRuolo}],
)

= Interrogazioni

== 01

```
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

== 02

```
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

= Progettazione Fisica
2 semestre

= Implementazione
2 semestre
