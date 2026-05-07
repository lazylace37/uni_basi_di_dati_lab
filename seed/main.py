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

        # Inserimento di AziendaProduttrice, Film, Genere, Recitazione, Ruolo,
        # Attore, Regista, Persona con controlli DEFERRED
        cur.execute("BEGIN TRANSACTION;")

        ## Generi
        for genere in GENERI_PREDEFINITI:
            cur.execute("INSERT INTO Genere (Nome) VALUES (%s)", (genere,))

        ## Persona
        persone = []
        for _ in range(NUM_PERSONE):
            nome = fake.first_name()
            cognome = fake.last_name()
            nascita = fake.date_of_birth()
            persone.append((nome, cognome, nascita))
            cur.execute("INSERT INTO Persona (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome, cognome, nascita))

        ## Attori
        attori_pool = persone[:int(NUM_PERSONE * 0.8)] # 80% attori = 60% solo attori + 20% anche registi
        for nome, cognome, nascita in attori_pool:
            cur.execute("INSERT INTO Attore (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome, cognome, nascita))
        
        ## Registi
        registi_pool = persone[int(NUM_PERSONE * 0.6):] # 40% registi = 20% solo registi + 20% anche attori
        for nome, cognome, nascita in registi_pool:
            cur.execute("INSERT INTO Regista (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s)", 
                        (nome, cognome, nascita))

        ## AziendaProduttrice
        aziende = [fake.unique.company() for _ in range(10)]
        for azienda in aziende:
            cur.execute(
                "INSERT INTO AziendaProduttrice (Nome, NumeroDiFilmProdotti) VALUES (%s, %s)",
                (azienda, 0) # Il trigger aggiornerà questo valore
            )

        frase_id = 1
        film_creati = []
        for _ in range(NUM_FILM):
            nome_r, cognome_r, nascita_r = random.choice(registi_pool) # Regista del film

            azienda = random.choice(aziende) # AziendaProduttrice del film

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
            generi_film = random.sample(GENERI_PREDEFINITI, k=random.randint(1, 3))
            for g in generi_film:
                cur.execute("INSERT INTO GenereDelFilm (TitoloFilm, AnnoDiProduzioneFilm, NomeGenere) VALUES (%s, %s, %s)",
                            (titolo, anno, g))

            ## Attori che recitano in questo film
            attori_film = random.sample(attori_pool, k=random.randint(1, 15))
            for nome_a, cognome_a, nascita_a in attori_film:
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

                ## FraseSignificativa
                if random.random() < 0.2:
                    for _ in range(random.randint(1, 2)):
                        frase = fake.sentence(nb_words=random.randint(5, 15))
                        cur.execute("""
                            INSERT INTO FraseSignificativa (ID, Frase, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
                            VALUES (%s, %s, %s, %s, %s, %s, %s)
                        """, (frase_id, frase, titolo, anno, nome_a, cognome_a, nascita_a))
                        frase_id += 1

        conn.commit()

        # Inserimento di ClienteRegistrato, Noleggio, CopiaFisicaDiFilm
        # Qui è importante che il Noleggio venga inserito dopo la relativa
        # CopiaFisicaDiFilm e il relativo ClienteRegistrato.

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
            cliente = random.choice(clienti_creati)
            
            # Generiamo una serie temporale coerente per non sovrapporre le date sulla stessa copia
            data_inizio = fake.date_time_between(start_date="-1y", end_date="-10d")
            
            for i in range(random.randint(0, 3)):
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
