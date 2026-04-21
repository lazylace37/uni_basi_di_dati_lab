import random
from datetime import timedelta

import psycopg2
from faker import Faker

DB_CONFIG = {
    "host": "localhost",
    "database": "postgres",
    "user": "postgres",
    "password": "postgres",
    "port": "5432",
}

fake = Faker()


def seed_database():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("Connected to PostgreSQL. Starting data insertion...")

        # AziendaProduttrice
        aziende = []
        for _ in range(50):
            nome = fake.company()
            aziende.append(nome)
            cursor.execute(
                "INSERT INTO AziendaProduttrice (Nome, NumeroDiFilmProdotti) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                (nome, random.randint(1, 500)),
            )

        # Genere
        generi = [
            "Azione",
            "Commedia",
            "Drama",
            "Horror",
            "Sci-Fi",
            "Documentario",
            "Thriller",
            "Western",
        ]
        for g in generi:
            cursor.execute(
                "INSERT INTO Genere (Nome) VALUES (%s) ON CONFLICT DO NOTHING", (g,)
            )

        # Ruolo
        ruoli = ["Protagonista", "Antagonista", "Spalla", "Comparsa", "Cameo"]
        for r in ruoli:
            cursor.execute(
                "INSERT INTO Ruolo (NomeRuolo) VALUES (%s) ON CONFLICT DO NOTHING", (r,)
            )

        # Persona
        persone = []
        for _ in range(300):
            p = (
                fake.first_name(),
                fake.last_name(),
                fake.date_of_birth(minimum_age=20, maximum_age=80),
            )
            persone.append(p)
            cursor.execute(
                "INSERT INTO Persona (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING",
                p,
            )

        # Regista & Attore
        registi = persone[:100]
        attori = persone[100:]
        for r in registi:
            cursor.execute(
                "INSERT INTO Regista (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING",
                r,
            )
        for a in attori:
            cursor.execute(
                "INSERT INTO Attore (Nome, Cognome, DataDiNascita) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING",
                a,
            )

        # ClienteRegistrato
        clienti_email = []
        for _ in range(100):
            email = fake.unique.email()
            clienti_email.append(email)
            cursor.execute(
                "INSERT INTO ClienteRegistrato (Email, Username, Password) VALUES (%s, %s, %s)",
                (email, fake.unique.user_name(), fake.password()),
            )

        # Film
        film_keys = []
        for _ in range(100):
            regista = random.choice(registi)
            titolo = fake.catch_phrase()
            anno = random.randint(1980, 2024)
            film_keys.append((titolo, anno))
            cursor.execute(
                """INSERT INTO Film (Titolo, AnnoDiProduzione, Durata, Trama, AziendaProduttrice, NomeRegista, CognomeRegista, DataDiNascitaRegista) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""",
                (
                    titolo,
                    anno,
                    random.randint(80, 180),
                    fake.text(max_nb_chars=200),
                    random.choice(aziende),
                    regista[0],
                    regista[1],
                    regista[2],
                ),
            )

        # GenereDelFilm
        for f in film_keys:
            selected_generi = random.sample(generi, random.randint(1, 2))
            for g in selected_generi:
                cursor.execute(
                    "INSERT INTO GenereDelFilm VALUES (%s, %s, %s)", (f[0], f[1], g)
                )

        # CopiaFisicaDiFilm
        copie = []
        for f in film_keys:
            for i in range(1, random.randint(2, 4)):
                copie.append((i, f[0], f[1]))
                cursor.execute(
                    "INSERT INTO CopiaFisicaDiFilm VALUES (%s, %s, %s)", (i, f[0], f[1])
                )

        # Recitazione
        for f in film_keys:
            cast = random.sample(attori, random.randint(3, 5))
            for a in cast:
                cursor.execute(
                    "INSERT INTO Recitazione VALUES (%s, %s, %s, %s, %s, %s)",
                    (f[0], f[1], a[0], a[1], a[2], random.choice(ruoli)),
                )

        # Noleggio
        for _ in range(150):
            copia = random.choice(copie)
            data_inizio = fake.date_between(start_date="-1y", end_date="today")
            data_fine = data_inizio + timedelta(days=random.randint(1, 7))
            cursor.execute(
                """INSERT INTO Noleggio (DataDiInizio, NumeroCopia, TitoloFilm, AnnoFilm, EmailCliente, DurataMassimaNoleggio, DataDiFine) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                (
                    data_inizio,
                    copia[0],
                    copia[1],
                    copia[2],
                    random.choice(clienti_email),
                    7,
                    data_fine,
                ),
            )

        # FraseSignificativa
        for i in range(1, 101):
            cursor.execute(
                "INSERT INTO FraseSignificativa VALUES (%s, %s)", (i, fake.sentence())
            )

        conn.commit()
        print(f"Success! Populated {cursor.rowcount} total operations.")
    except Exception as e:
        print(f"An error occurred: {e}")
        if conn:
            conn.rollback()
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


if __name__ == "__main__":
    seed_database()
