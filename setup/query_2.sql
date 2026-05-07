SELECT C1.Email, C2.Email
FROM   ClienteRegistrato C1, ClienteRegistrato C2
WHERE  NOT EXISTS ( -- non esiste un Film che ha visto C1 ma non C2
         SELECT *
         FROM   Noleggio N1
         WHERE  N1.EmailCliente = C1.Email AND
                NOT EXISTS (
                  SELECT *
                  FROM   Noleggio N2
                  WHERE  N2.EmailCliente = C2.Email    AND
                         N1.TitoloFilm = N2.TitoloFilm AND
                         N1.AnnoFilm = N2.AnnoFilm
                )
       )
       AND
       NOT EXISTS ( -- non esiste un Film che ha visto C2 ma non C1
         SELECT *
         FROM   Noleggio N1
         WHERE  N1.EmailCliente = C2.Email AND
                NOT EXISTS (
                  SELECT *
                  FROM   Noleggio N2
                  WHERE  N2.EmailCliente = C1.Email    AND
                         N1.TitoloFilm = N2.TitoloFilm AND
                         N1.AnnoFilm = N2.AnnoFilm
                )
       )
       AND C1.Email < C2.Email;
