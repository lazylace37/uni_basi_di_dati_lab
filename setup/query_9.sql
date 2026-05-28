BEGIN TRANSACTION;

DELETE
FROM Ruolo
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoFilm = $AnnoFilm;

DELETE
FROM FraseSignificativa
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoFilm = $AnnoFilm;

DELETE
FROM Recitazione
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoFilm = $AnnoFilm;

DELETE
FROM GenereDelFilm
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoDiProduzioneFilm = $AnnoFilm;

DELETE
FROM CopiaFisicaDiFilm
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoDiProduzioneFilm = $AnnoFilm;

DELETE
FROM RegistaDelFilm
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoDiProduzioneFilm = $AnnoFilm;

DELETE
FROM Noleggio
WHERE
        TitoloFilm = $TitoloFilm AND
        AnnoFilm = $AnnoFilm;

DELETE
FROM Film
WHERE
        Titolo = $TitoloFilm AND
        AnnoDiProduzione = $AnnoFilm;

DELETE
FROM Genere
WHERE
        (SELECT COUNT(*) FROM GenereDelFilm WHERE NomeGenere = Genere.Nome) = 0;

DELETE
FROM Attore
WHERE
        (SELECT COUNT(*) FROM Recitazione WHERE NomeAttore = Attore.Nome AND CognomeAttore = Attore.Cognome AND DataNascitaAttore = Attore.DataDiNascita) = 0;

DELETE
FROM Regista
WHERE
        (SELECT COUNT(*) FROM RegistaDelFilm WHERE NomeRegista = Regista.Nome AND CognomeRegista = Regista.Cognome AND DataDiNascitaRegista = Regista.DataDiNascita) = 0;

DELETE
FROM Persona
WHERE
        (SELECT COUNT(*) FROM Attore WHERE Nome = Persona.Nome AND Cognome = Persona.Cognome AND DataDiNascita = Persona.DataDiNascita) = 0
        AND
        (SELECT COUNT(*) FROM Regista WHERE Nome = Persona.Nome AND Cognome = Persona.Cognome AND DataDiNascita = Persona.DataDiNascita) = 0;

-- Notiamo che il numero di film prodotti è già aggiornato dal trigger 
-- associato, in quanto non impostato come deferred.
DELETE
FROM AziendaProduttrice
WHERE
        AziendaProduttrice.NumeroDiFilmProdotti = 0;

COMMIT;