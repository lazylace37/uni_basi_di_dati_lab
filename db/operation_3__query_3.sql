CREATE OR REPLACE VIEW NumeroFilmPerRegista(NomeRegista, CognomeRegista, DataDiNascitaRegista, NumeroFilm) AS
SELECT Regista.Nome, Regista.Cognome, Regista.DataDiNascita, COUNT(*)
FROM Regista
	JOIN RegistaDelFilm ON RegistaDelFilm.NomeRegista = Regista.Nome AND
		RegistaDelFilm.CognomeRegista = Regista.Cognome AND
		RegistaDelFilm.DataDiNascitaRegista = Regista.DataDiNascita
GROUP BY Regista.Nome, Regista.Cognome, Regista.DataDiNascita;

SELECT NomeRegista, CognomeRegista, DataDiNascitaRegista, NumeroFilm
FROM NumeroFilmPerRegista
WHERE
	NumeroFilm >= ALL (
		SELECT NumeroFilm
		FROM NumeroFilmPerRegista
	);
