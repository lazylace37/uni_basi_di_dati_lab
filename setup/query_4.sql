CREATE VIEW Attore_AziendeProd AS
  SELECT NomeAttore, CognomeAttore, DataNascitaAttore, AziendaProduttrice
  FROM   Recitazione JOIN Film
     ON  Recitazione.TitoloFilm = Film.Titolo
     AND Recitazione.AnnoFilm   = Film.AnnoDiProduzione;

SELECT DISTINCT A1.NomeAttore, A1.CognomeAttore, A1.DataNascitaAttore
FROM   Attore_AziendeProd A1
WHERE  NOT EXISTS (
  SELECT *
  FROM   Attore_AziendeProd A2
  WHERE  A1.NomeAttore         =  A2.NomeAttore
    AND  A1.CognomeAttore      =  A2.CognomeAttore
    AND  A1.DataNascitaAttore  =  A2.DataNascitaAttore
    AND  A1.AziendaProduttrice <> A2.AziendaProduttrice
)
