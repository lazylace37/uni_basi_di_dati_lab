SELECT NomeAttore, CognomeAttore, DataNascitaAttore, COUNT(*) AS NumeroFilm
FROM Recitazione
GROUP BY NomeAttore, CognomeAttore, DataNascitaAttore;
