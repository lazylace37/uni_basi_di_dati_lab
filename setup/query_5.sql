BEGIN TRANSACTION;

INSERT INTO Film VALUES (
        $TitoloFilm,
        2024,
        120,
        $TramaFilm,
        $AziendaProduttrice
);

INSERT INTO RegistaDelFilm VALUES (
        $TitoloFilm,
        2024,
        $NomeRegista,
        $CognomeRegista,
        $DataDiNascitaRegista
);

COMMIT;
