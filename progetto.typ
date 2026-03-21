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
    [Ottieni, per ogni categoria di film, il numero medio di attori
      partecipanti.],
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

- Cicli problematici:
  - Un attore può pronunciare una frase significativa solo in film in cui ha
    recitato.
- Una copia fisica di un film noleggiata non può essere rinoleggiata prima che
  venga restituita.

Nota:
- Il ciclo 'Regista - Dirige - Milm - Recita in - Attore' non è problematico,
  perché un attore può recitare in un film che dirige.

// Note:
// - entità "Frase Significativa" aggiunta al posto di attributo multivalore nella
//   relazione "Recita in".

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

3 possibilità:
1. Accorpamento dei figli nel genitore
2. Accorpamento del genitore nei figli (solo se totale e disgiunta)
3. Sostituzione con relazione

=== Traduzione degli Attributi Multivalore
=== Scelta degli Identificatori Primari

== Traduzione nello Schema Relazionale
2 semestre

= Progettazione Fisica
2 semestre

= Implementazione
2 semestre
