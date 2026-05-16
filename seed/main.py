import random
from datetime import timedelta

import psycopg2
from faker import Faker

DB_CONFIG = {
    "host": "localhost",
    "database": "industria_cinematografica",
    "user": "postgres",
    "password": "postgres",
    "port": "5432",
}

fake = Faker()

NUM_FILM = 70
NUM_CLIENTI = 10
NUM_PERSONE = 100

GENERI_PREDEFINITI = [
    "Azione", "Commedia", "Drammatico", "Fantascienza", "Horror", 
    "Thriller", "Romantico", "Animazione", "Documentario", "Avventura", 
    "Fantasy", "Giallo", "Musical", "Storico", "Western"
]

def seed_database():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        print("Connected to PostgreSQL. Starting data insertion...")

        ## Persona, Attore e Regista
        n_registi = int(NUM_PERSONE * 0.2)
        n_registi_e_attori = int(NUM_PERSONE * 0.2)
        n_attori = NUM_PERSONE - n_registi - n_registi_e_attori

        persone_registi = []
        for _ in range(n_registi):
            persone_registi.append((fake.first_name(), fake.last_name(), fake.date_of_birth()))
        persone_attori = []
        for _ in range(n_attori):
            persone_attori.append((fake.first_name(), fake.last_name(), fake.date_of_birth()))
        persone_entrambi = []
        for _ in range(n_registi_e_attori):
            persone_entrambi.append((fake.first_name(), fake.last_name(), fake.date_of_birth()))

        all_registi = persone_registi + persone_entrambi
        all_attori = persone_attori + persone_entrambi

        # Inserimento di Azienda, Film, Genere, Regista+Persona, RegistaDelFilm, GenereDelFilm
        cur.execute("BEGIN TRANSACTION;")

        ## Generi
        for genere in GENERI_PREDEFINITI:
            cur.execute("INSERT INTO Genere (Nome) VALUES (%s)", (genere,))

        ## Registi
        for p in all_registi:
            cur.execute("INSERT INTO Persona (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", p)
            cur.execute("INSERT INTO Regista (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", p)

        ## AziendaProduttrice
        aziende = []
        for _ in range(10):
            nome_azienda = fake.unique.company()
            recapito = fake.unique.address()
            cur.execute(
                "INSERT INTO AziendaProduttrice (Nome, Recapito, NumeroDiFilmProdotti) VALUES (%s, %s, %s)",
                (nome_azienda, recapito, 0) # Il trigger aggiornerà questo valore
            )
            aziende.append(nome_azienda)

        film_creati = []
        for _ in range(NUM_FILM):
            azienda = random.choice(aziende) # AziendaProduttrice del film

            ## Film
            titolo = fake.unique.catch_phrase()
            anno = fake.year()
            durata = random.randint(80, 180)
            trama = fake.text(max_nb_chars=200)
            
            cur.execute("""
                INSERT INTO Film (Titolo, AnnoDiProduzione, Durata, Trama, AziendaProduttrice)
                VALUES (%s, %s, %s, %s, %s)
            """, (titolo, anno, durata, trama, azienda))
            film_creati.append((titolo, anno))

            ## RegistaDelFilm
            registi_film = random.sample(all_registi, k=random.randint(1, 2))
            for r in registi_film:
                cur.execute("""
                    INSERT INTO RegistaDelFilm (TitoloFilm, AnnoDiProduzioneFilm, NomeRegista, CognomeRegista, DataDiNascitaRegista)
                    VALUES (%s, %s, %s, %s, %s)
                """, (titolo, anno, r[0], r[1], r[2]))

            ## GenereDelFilm
            generi_film = random.sample(GENERI_PREDEFINITI, k=random.randint(1, 3))
            for g in generi_film:
                cur.execute("INSERT INTO GenereDelFilm (TitoloFilm, AnnoDiProduzioneFilm, NomeGenere) VALUES (%s, %s, %s)",
                            (titolo, anno, g))

        conn.commit()

        # Inserimento di Recitazione, Attore+Persona, Ruolo
        cur.execute("BEGIN TRANSACTION;")

        ## Attori in Persona
        for nome_a, cognome_a, nascita_a in persone_attori:
            cur.execute("INSERT INTO Persona (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", (nome_a, cognome_a, nascita_a))

        recitazioni_create = []
        for nome_a, cognome_a, nascita_a in all_attori:
            ## Attore
            cur.execute("INSERT INTO Attore (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", (nome_a, cognome_a, nascita_a))

            # Facciamo recitare l'attore in 1, 2 o 3 film
            film_per_attore = random.sample(film_creati, k=random.randint(1, 3))
            for titolo, anno in film_per_attore:
                ## Recitazione
                cur.execute("""
                    INSERT INTO Recitazione (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
                    VALUES (%s, %s, %s, %s, %s)
                """, (titolo, anno, nome_a, cognome_a, nascita_a))
                recitazioni_create.append((titolo, anno, nome_a, cognome_a, nascita_a))

                ## Ruoli di questo attore per questo film
                for _ in range(random.randint(1, 2)):
                    ruolo = fake.unique.job()
                    cur.execute("""
                        INSERT INTO Ruolo (NomeRuolo, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (ruolo, titolo, anno, nome_a, cognome_a, nascita_a))
                fake.unique.clear()
        conn.commit()

        # Inserimento di CopiaFisicaDiFilm, ClienteRegistrato e Noleggi

        ## ClienteRegistrato
        clienti_creati = []
        for _ in range(NUM_CLIENTI):
            email = fake.unique.email()
            username = fake.unique.user_name()
            password = fake.password(length=12)
            cur.execute("INSERT INTO ClienteRegistrato (Email, Username, Password) VALUES (%s, %s, %s)",
                        (email, username, password))
            clienti_creati.append(email)

        ## CopiaFisicaDiFilm
        copie_create = []
        for film in film_creati:
            titolo, anno = film
            for numero_copia in range(1, random.randint(1, 3) + 1):
                cur.execute("INSERT INTO CopiaFisicaDiFilm (Numero, TitoloFilm, AnnoFilm) VALUES (%s, %s, %s)",
                            (numero_copia, titolo, anno))
                copie_create.append((numero_copia, titolo, anno))

        ## Noleggio
        for copia in copie_create:
            numero, titolo, anno = copia

            # Generiamo una serie temporale coerente per non sovrapporre le date sulla stessa copia
            data_inizio = fake.date_time_between(start_date="-1y", end_date="-10d")
            
            for i in range(random.randint(0, 3)):
                cliente = random.choice(clienti_creati)
                durata_max = random.randint(3, 14)
                giorni_effettivi = random.randint(1, durata_max)
                data_fine = data_inizio + timedelta(days=giorni_effettivi)
                
                cur.execute("""
                    INSERT INTO Noleggio (DataDiInizio, NumeroCopia, TitoloFilm, AnnoFilm, 
                                          EmailCliente, DurataMassimaNoleggio, DataDiFine)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (data_inizio.date(), numero, titolo, anno, cliente, durata_max, data_fine.date()))
                
                # Spostiamo la data inizio avanti rispetto alla fine per il noleggio successivo
                data_inizio = data_fine + timedelta(days=random.randint(1, 5))

        # Inserimento di FraseSignificativa
        # Scegliamo un po' di recitazioni
        recitazioni_con_frase = random.sample(recitazioni_create, k=int(len(recitazioni_create) * 0.3))

        id_frase = 1
        for titolo, anno, nome_a, cognome_a, nascita_a in recitazioni_con_frase:
            # 1 o 2 frasi per una recitazione
            for _ in range(random.randint(1, 2)):
                frase = fake.sentence()
                cur.execute("""
                    INSERT INTO FraseSignificativa (ID, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore, Frase)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (id_frase, titolo, anno, nome_a, cognome_a, nascita_a, frase))
                id_frase += 1

        conn.commit()
        print("Done")
    except Exception as e:
        print(f"An error occurred: {e}")
        if conn:
            conn.rollback()
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()


if __name__ == "__main__":
    seed_database()
