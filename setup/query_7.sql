INSERT INTO Recitazione VALUES (
        $TitoloFilm,
        $AnnoFilm,
        $NomeAttore,
        $CognomeAttore,
        $DataDiNascitaAttore
);

INSERT INTO Ruolo VALUES (
        $NomeRuolo,
        $TitoloFilm,
        $AnnoFilm,
        $NomeAttore,
        $CognomeAttore,
        $DataDiNascitaAttore
);

INSERT INTO FraseSignificativa(TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
VALUES (
        $TitoloFilm,
        $AnnoFilm,
        $NomeAttore,
        $CognomeAttore,
        $DataDiNascitaAttore,
        $Frase
);
