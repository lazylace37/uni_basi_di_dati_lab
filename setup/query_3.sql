CREATE VIEW NumeroFilmPerRegista(NomeRegista, CognomeRegista, DataDiNascitaRegista, NumeroFilm) AS
SELECT Regista.Nome, Regista.Cognome, Regista.DataDiNascita, COUNT(*)
FROM Regista
	JOIN Film ON Film.NomeRegista = Regista.Nome AND
		Film.CognomeRegista = Regista.Cognome AND
		Film.DataDiNascitaRegista = Regista.DataDiNascita
GROUP BY Regista.Nome, Regista.Cognome, Regista.DataDiNascita;

SELECT NomeRegista, CognomeRegista, DataDiNascitaRegista
FROM NumeroFilmPerRegista
WHERE
	NumeroFilm >= ALL (
		SELECT NumeroFilm
		FROM NumeroFilmPerRegista
	);
