-- Troviamo i clienti che hanno visto gli stessi film.
SELECT NoleggiFilmPerCliente1.EmailCliente, NoleggiFilmPerCliente2.EmailCliente
FROM NoleggiFilmPerCliente AS NoleggiFilmPerCliente1,
    NoleggiFilmPerCliente AS NoleggiFilmPerCliente2
WHERE

-- Select con CONTAINS
SELECT Cliente1.Email, Cliente2.Email
FROM ClienteRegistrato Cliente1, ClienteRegistrato Cliente2
WHERE
    NOT EXISTS (
        SELECT *
        FROM NoleggiFilmPerCliente Noleggi1
        WHERE
            Noleggi1.EmailCliente = Cliente1.Email AND
            NOT EXISTS (
                SELECT *
                FROM NoleggiFilmPerCliente Noleggi2
                WHERE
                    Noleggi2.EmailCliente = Cliente2.Email AND
                    Noleggi1.NomeFilm = Noleggi2.NomeFilm AND
                    Noleggi1.AnnoFilm = Noleggi2.AnnoFilm
            )
        )
    AND
    NOT EXISTS (
        SELECT *
        FROM NoleggiFilmPerCliente Noleggi2
        WHERE
            Noleggi2.EmailCliente = Cliente2.Email AND
            NOT EXISTS (
                SELECT *
                FROM NoleggiFilmPerCliente Noleggi1
                WHERE
                    Noleggi1.EmailCliente = Cliente1.Email AND
                    Noleggi2.NomeFilm = Noleggi1.NomeFilm AND
                    Noleggi2.AnnoFilm = Noleggi1.AnnoFilm
            )
        )
    AND
        Cliente1.Email < Cliente2.Email;
