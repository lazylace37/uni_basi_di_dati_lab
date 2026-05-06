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

        # Inserimento di AziendaProduttrice, Film, Genere, Recitazione, Ruolo,
        # Attore, Regista, Persona con controlli DEFERRED
        cur.execute("BEGIN TRANSACTION;")

        film_creati = []
        copie_create = []
        clienti_creati = []

        ## Generi
        for genere in GENERI_PREDEFINITI:
            cur.execute("INSERT INTO Genere (Nome) VALUES (%s)", (genere,))

        for _ in range(NUM_FILM):
            ## AziendaProduttrice
            azienda = fake.unique.company()
            cur.execute(
                "INSERT INTO AziendaProduttrice (Nome, NumeroDiFilmProdotti) VALUES (%s, %s)",
                (azienda, 0) # Il trigger aggiornerà questo valore
            )

            ## Regista e Persona
            nome_r = fake.first_name()
            cognome_r = fake.last_name()
            nascita_r = fake.date_of_birth()
            cur.execute("INSERT INTO Persona (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome_r, cognome_r, nascita_r))
            cur.execute("INSERT INTO Regista (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome_r, cognome_r, nascita_r))

            ## Attore e Persona
            nome_a = fake.first_name()
            cognome_a = fake.last_name()
            nascita_a = fake.date_of_birth()
            cur.execute("INSERT INTO Persona (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome_a, cognome_a, nascita_a))
            cur.execute("INSERT INTO Attore (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome_a, cognome_a, nascita_a))

            ## Film
            titolo = fake.unique.catch_phrase()
            anno = fake.year()
            durata = random.randint(80, 180)
            trama = fake.text(max_nb_chars=200)
            cur.execute("""
                INSERT INTO Film (Titolo, AnnoDiProduzione, Durata, Trama, AziendaProduttrice, 
                                  NomeRegista, CognomeRegista, DataDiNascitaRegista)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (titolo, anno, durata, trama, azienda, nome_r, cognome_r, nascita_r))
            
            film_creati.append((titolo, anno))

            ## GenereDelFilm
            genere = random.choice(GENERI_PREDEFINITI)
            cur.execute("INSERT INTO GenereDelFilm (TitoloFilm, AnnoDiProduzioneFilm, NomeGenere) VALUES (%s, %s, %s)",
                        (titolo, anno, genere))

            ## Recitazione
            cur.execute("""
                INSERT INTO Recitazione (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
                VALUES (%s, %s, %s, %s, %s)
            """, (titolo, anno, nome_a, cognome_a, nascita_a))

            ## Ruolo
            ruolo = fake.job()
            cur.execute("""
                INSERT INTO Ruolo (NomeRuolo, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (ruolo, titolo, anno, nome_a, cognome_a, nascita_a))

            # ## FraseSignificativa (opzionale)
            # if random.random() > 0.2:
            #     cur.execute("""
            #         INSERT INTO FraseSignificativa (ID, Frase, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
            #         VALUES (%s, %s, %s, %s, %s, %s, %s)
            #     """, (fake.unique.random_int(min=1, max=10000), fake.sentence(), titolo, anno, nome_a, cognome_a, nascita_a))

        conn.commit()

        # Inserimento di ClienteRegistrato, Noleggio, CopiaFisicaDiFilm
        # Qui è importante che il Noleggio venga inserito dopo la relativa
        # CopiaFisicaDiFilm e il relativo ClienteRegistrato.

        ## ClienteRegistrato
        for _ in range(NUM_CLIENTI):
            email = fake.unique.email()
            username = fake.unique.user_name()
            password = fake.password(length=12)
            cur.execute("INSERT INTO ClienteRegistrato (Email, Username, Password) VALUES (%s, %s, %s)",
                        (email, username, password))
            clienti_creati.append(email)

        ## CopiaFisicaDiFilm
        for film in film_creati:
            titolo, anno = film
            for numero_copia in range(1, random.randint(1, 3) + 1):
                cur.execute("INSERT INTO CopiaFisicaDiFilm (Numero, TitoloFilm, AnnoFilm) VALUES (%s, %s, %s)",
                            (numero_copia, titolo, anno))
                copie_create.append((numero_copia, titolo, anno))

        ## Noleggio
        for copia in copie_create:
            numero, titolo, anno = copia
            cliente = random.choice(clienti_creati)
            
            # Generiamo una serie temporale coerente per non sovrapporre le date sulla stessa copia
            data_inizio = fake.date_time_between(start_date="-1y", end_date="-10d")
            
            for i in range(random.randint(1, 3)):
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
