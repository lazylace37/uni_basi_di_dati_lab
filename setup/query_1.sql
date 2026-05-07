-- Troviamo per ogni film il numero di attori che vi recitano. Notiamo che ogni istanza di recitazione corrisponde ad un ed un solo un attore. Non serve quindi effettuare join con attore
CREATE VIEW NumeroAttoriPerFilm AS
  SELECT Film.Titolo AS TitoloFilm,
    Film.AnnoDiProduzione AS AnnoFilm,
    COUNT(Recitazione.*) AS NumeroAttori
  FROM Film JOIN Recitazione ON
    Film.Titolo = Recitazione.TitoloFilm AND
    Film.AnnoDiProduzione = Recitazione.AnnoFilm
  GROUP BY Film.Titolo, Film.AnnoDiProduzione;

-- Utilizziamo la vista precedente per ottenere il numero medio di attori per genere
SELECT GenereDelFilm.NomeGenere, AVG(NumeroAttori)
FROM GenereDelFilm
JOIN NumeroAttoriPerFilm ON
  GenereDelFilm.TitoloFilm = NumeroAttoriPerFilm.TitoloFilm AND
  GenereDelFilm.AnnoDiProduzioneFilm = NumeroAttoriPerFilm.AnnoFilm
GROUP BY GenereDelFilm.NomeGenere;
