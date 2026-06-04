BEGIN TRANSACTION;

INSERT INTO Recitazione VALUES (
        'Exclusive 24/7 help-desk',
        1979,
        'Meredith',
        'Carson',
        DATE('1914-04-23')
);

INSERT INTO Ruolo VALUES (
        'Penelope',
        'Exclusive 24/7 help-desk',
        1979,
        'Meredith',
        'Carson',
        DATE('1914-04-23')
);

INSERT INTO FraseSignificativa(TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore, Frase)
VALUES (
        'Exclusive 24/7 help-desk',
        1979,
        'Meredith',
        'Carson',
        DATE('1914-04-23'),
        'The help-desk must be always available, ALWAYS!'
);

COMMIT;