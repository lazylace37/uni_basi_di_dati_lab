CREATE TABLE AziendaProduttrice (
    Nome VARCHAR(255) PRIMARY KEY,
    NumeroDiFilmProdotti INT NOT NULL
);

CREATE TABLE Genere (
    Nome VARCHAR(100) PRIMARY KEY
);

CREATE TABLE ClienteRegistrato (
    Email VARCHAR(255) PRIMARY KEY,
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE Persona (
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    DataDiNascita DATE,

    PRIMARY KEY (Nome, Cognome, DataDiNascita)
);

CREATE TABLE Attore (
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    DataDiNascita DATE,

    PRIMARY KEY (Nome, Cognome, DataDiNascita),
    FOREIGN KEY (Nome, Cognome, DataDiNascita)
        REFERENCES Persona(Nome, Cognome, DataDiNascita)
        ON DELETE CASCADE
);

CREATE TABLE Regista (
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    DataDiNascita DATE,

    PRIMARY KEY (Nome, Cognome, DataDiNascita),
    FOREIGN KEY (Nome, Cognome, DataDiNascita)
        REFERENCES Persona(Nome, Cognome, DataDiNascita)
        ON DELETE CASCADE
);

CREATE TABLE Film (
    Titolo VARCHAR(255),
    AnnoDiProduzione INT,
    Durata INT NOT NULL CHECK (Durata > 0),
    Trama TEXT NOT NULL,
    AziendaProduttrice VARCHAR(255) NOT NULL,
    NomeRegista VARCHAR(100) NOT NULL,
    CognomeRegista VARCHAR(100) NOT NULL,
    DataDiNascitaRegista DATE NOT NULL,

    PRIMARY KEY (Titolo, AnnoDiProduzione),
    FOREIGN KEY (AziendaProduttrice)
        REFERENCES AziendaProduttrice(Nome)
        ON DELETE CASCADE,
    FOREIGN KEY (NomeRegista, CognomeRegista, DataDiNascitaRegista)
        REFERENCES Regista(Nome, Cognome, DataDiNascita)
        ON DELETE CASCADE
);

CREATE TABLE GenereDelFilm (
    TitoloFilm VARCHAR(255),
    AnnoDiProduzioneFilm INT,
    NomeGenere VARCHAR(100),

    PRIMARY KEY (TitoloFilm, AnnoDiProduzioneFilm, NomeGenere),
    FOREIGN KEY (TitoloFilm, AnnoDiProduzioneFilm)
        REFERENCES Film(Titolo, AnnoDiProduzione)
        ON DELETE CASCADE,
    FOREIGN KEY (NomeGenere)
        REFERENCES Genere(Nome)
        ON DELETE CASCADE
);

CREATE TABLE CopiaFisicaDiFilm (
    Numero INT,
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,

    PRIMARY KEY (Numero, TitoloFilm, AnnoFilm),
    FOREIGN KEY (TitoloFilm, AnnoFilm)
        REFERENCES Film(Titolo, AnnoDiProduzione)
        ON DELETE CASCADE
);

CREATE TABLE Recitazione (
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    NomeAttore VARCHAR(100),
    CognomeAttore VARCHAR(100),
    DataNascitaAttore DATE,

    PRIMARY KEY (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore),
    FOREIGN KEY (TitoloFilm, AnnoFilm)
        REFERENCES Film(Titolo, AnnoDiProduzione)
        ON DELETE CASCADE,
    FOREIGN KEY (NomeAttore, CognomeAttore, DataNascitaAttore)
        REFERENCES Attore(Nome, Cognome, DataDiNascita)
        ON DELETE CASCADE
);

CREATE TABLE Ruolo (
    NomeRuolo VARCHAR(100),
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    NomeAttore VARCHAR(100),
    CognomeAttore VARCHAR(100),
    DataNascitaAttore DATE,

    PRIMARY KEY (NomeRuolo, TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore),
    FOREIGN KEY (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
        REFERENCES Recitazione(TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
        ON DELETE CASCADE
);

CREATE TABLE FraseSignificativa (
    ID INT,
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    NomeAttore VARCHAR(100),
    CognomeAttore VARCHAR(100),
    DataNascitaAttore DATE,
    Frase TEXT NOT NULL,

    PRIMARY KEY (ID),
    FOREIGN KEY (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
        REFERENCES Recitazione(TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
        ON DELETE CASCADE
);

CREATE TABLE Noleggio (
    DataDiInizio DATE,
    NumeroCopia INT,
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    EmailCliente VARCHAR(255) NOT NULL,
    DurataMassimaNoleggio INT NOT NULL,
    DataDiFine DATE CHECK (DataDiFine IS NULL OR DataDiFine > DataDiInizio),

    PRIMARY KEY (DataDiInizio, NumeroCopia, TitoloFilm, AnnoFilm),
    FOREIGN KEY (NumeroCopia, TitoloFilm, AnnoFilm)
        REFERENCES CopiaFisicaDiFilm(Numero, TitoloFilm, AnnoFilm)
        ON DELETE CASCADE,
    FOREIGN KEY (EmailCliente)
        REFERENCES ClienteRegistrato(Email)
        ON DELETE CASCADE
);
