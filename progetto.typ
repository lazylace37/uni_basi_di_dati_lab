#import "templ.typ": *
#show: templ.with(
  title: "Progetto di Laboratorio di Basi di Dati",
  author: "",
  font-size: 10pt,
)

= Progettazione Concettuale

== Analisi dei Requisiti

Eliminiamo le ambiguità e produciamo:

=== Glossario

#table(
  columns: (auto, 1fr, auto, auto),
  table.header[*Termine*][*Descrizione*][*Sinonimi*][*Collegamenti*],
  [Docente], [Docente dei corsi], [Insegnante], [Corso],
  [Corso], [...], [...], [...],
)

=== Strutturazione dei Requisiti

#stack(
  dir: ttb,
  spacing: 1em,
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi di carattere generale*]),
    [#lorem(20)],
  ),
  table(
    columns: 1fr,
    table.header(table.cell(align: center)[*Frasi relative a ...*]),
    [...],
  ),
)

=== Operazioni

#stack(
  dir: ttb,
  spacing: 1em,
  table(
    columns: (1fr, auto),
    table.header[*Operazione 1*][*Frequenza*],
    [#lorem(10)], [n volte al giorno],
  ),
  table(
    columns: (1fr, auto),
    table.header[*Operazione 2*][*Frequenza*],
    [#lorem(10)], [n volte al giorno],
  ),
)

== Rappresentazione Concettuale dei Dati

Scegliere la strategia di progetto: top-down, bottom-up o inside-out.

Uso di design pattern per risolvere problemi comuni.

Schema E-R.

Vincoli di integrità.

= Progettazione Logica

== Ristrutturazione del Modello E-R

=== Analisi delle Prestazioni

==== Tavola dei Volumi

Il volume è la cardinalià attesa - il numero di istanze

#table(
  columns: 3,
  table.header[*Concetto*][*Tipo*][*Volume*],
  [Sede], [Entità], [10],
  [...], [Relazione], [...],
)

==== Tavola delle Operazioni

#stack(
  dir: ttb,
  spacing: 2em,
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    table.header(table.cell(align: center, colspan: 4)[*Operazione 1*]),
    [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
    [Impiegato], [Entità], [1], [Lettura],
    [Afferenza], [Relazione], [3], [Lettura],
  ),
)

=== Analisi delle Ridondanze

Trovare le ridondanze:
- attributi derivabili:
  - da altri attributi della stessa entità
  - da altri attributi di altre entità o relazioni (es. aggregazioni)
  - conteggio di occorrenze
- relazioni derivabili: cicli

Per ogni ridondanza, valutiamo le prestazioni nel caso in cui la teniamo e nel
caso in cui la togliamo (tavola degli accessi).

#table(
  columns: (1fr, 1fr),
  table.header(table.cell(align: center, colspan: 2)[*Ridondanza 1*]),
  [*Presenza di ridondanza*], [*Assenza di ridondanza*],
  stack(
    dir: ttb,
    spacing: 2em,
    stack(
      dir: ttb,
      spacing: 1em,
      table(
        columns: (1fr, 1fr, 1fr, 1fr),
        table.header(table.cell(align: center, colspan: 4)[*Operazione 1*]),
        [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
        [Impiegato], [Entità], [1], [Lettura],
        [Afferenza], [Relazione], [3], [Lettura],
      ),
      [Totale = (n° letture \* costo letture + n° scritture \* costo scritture) \* frequenza = ],
    ),
    stack(
      dir: ttb,
      spacing: 1em,
      table(
        columns: (1fr, 1fr, 1fr, 1fr),
        table.header(table.cell(align: center, colspan: 4)[*Operazione 2*]),
        [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
        [...], [...], [1], [Lettura],
      ),
      [Totale = (n° letture \* costo letture + n° scritture \* costo scritture) \* frequenza = ],
    ),
  ),
  stack(
    dir: ttb,
    spacing: 2em,
    stack(
      dir: ttb,
      spacing: 1em,
      table(
        columns: (1fr, 1fr, 1fr, 1fr),
        table.header(table.cell(align: center, colspan: 4)[*Operazione 1*]),
        [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
        [Impiegato], [Entità], [1], [Lettura],
        [Afferenza], [Relazione], [3], [Lettura],
      ),
      [Totale = (n° letture \* costo letture + n° scritture \* costo scritture) \* frequenza = ],
    ),
    stack(
      dir: ttb,
      spacing: 1em,
      table(
        columns: (1fr, 1fr, 1fr, 1fr),
        table.header(table.cell(align: center, colspan: 4)[*Operazione 2*]),
        [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*],
        [...], [...], [1], [Lettura],
      ),
      [Totale = (n° letture \* costo letture + n° scritture \* costo scritture) \* frequenza = ],
    ),
  ),

  [Totale = .. + ..], [Totale = .. + ..],
  table.cell(colspan: 2)[Scegliamo di tenere/rimuovere la ridondanza.],
)

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
