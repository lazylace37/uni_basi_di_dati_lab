BEGIN TRANSACTION;

INSERT INTO Film VALUES (
        $TitoloFilm,
        $AnnoFilm,
        $DurataFilm,
        $TramaFilm,
        $AziendaProduttrice
);

INSERT INTO RegistaDelFilm VALUES (
        $TitoloFilm,
        $AnnoFilm,
        $NomeRegista,
        $CognomeRegista,
        $DataDiNascitaRegista
);

COMMIT;
