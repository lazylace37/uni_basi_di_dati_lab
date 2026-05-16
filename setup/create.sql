CREATE TABLE AziendaProduttrice (
    Nome VARCHAR(255) PRIMARY KEY,
    Recapito VARCHAR(255) UNIQUE NOT NULL,
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
    NumeroDiFilmRecitati INT NOT NULL,

    PRIMARY KEY (Nome, Cognome, DataDiNascita),
    FOREIGN KEY (Nome, Cognome, DataDiNascita)
        REFERENCES Persona(Nome, Cognome, DataDiNascita)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE Regista (
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    DataDiNascita DATE,

    PRIMARY KEY (Nome, Cognome, DataDiNascita),
    FOREIGN KEY (Nome, Cognome, DataDiNascita)
        REFERENCES Persona(Nome, Cognome, DataDiNascita)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE Film (
    Titolo VARCHAR(255),
    AnnoDiProduzione INT,
    Durata INT NOT NULL CHECK (Durata > 0),
    Trama TEXT NOT NULL,
    AziendaProduttrice VARCHAR(255) NOT NULL,

    PRIMARY KEY (Titolo, AnnoDiProduzione),
    FOREIGN KEY (AziendaProduttrice)
        REFERENCES AziendaProduttrice(Nome)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE RegistaDelFilm (
    TitoloFilm VARCHAR(255),
    AnnoDiProduzioneFilm INT,
    NomeRegista VARCHAR(100),
    CognomeRegista VARCHAR(100),
    DataDiNascitaRegista DATE,

    PRIMARY KEY (TitoloFilm, AnnoDiProduzioneFilm, NomeRegista, CognomeRegista, DataDiNascitaRegista),
    FOREIGN KEY (TitoloFilm, AnnoDiProduzioneFilm)
        REFERENCES Film(Titolo, AnnoDiProduzione)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (NomeRegista, CognomeRegista, DataDiNascitaRegista)
        REFERENCES Regista(Nome, Cognome, DataDiNascita)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE GenereDelFilm (
    TitoloFilm VARCHAR(255),
    AnnoDiProduzioneFilm INT,
    NomeGenere VARCHAR(100),

    PRIMARY KEY (TitoloFilm, AnnoDiProduzioneFilm, NomeGenere),
    FOREIGN KEY (TitoloFilm, AnnoDiProduzioneFilm)
        REFERENCES Film(Titolo, AnnoDiProduzione)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (NomeGenere)
        REFERENCES Genere(Nome)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE CopiaFisicaDiFilm (
    Numero INT,
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,

    PRIMARY KEY (Numero, TitoloFilm, AnnoFilm),
    FOREIGN KEY (TitoloFilm, AnnoFilm)
        REFERENCES Film(Titolo, AnnoDiProduzione)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
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
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (NomeAttore, CognomeAttore, DataNascitaAttore)
        REFERENCES Attore(Nome, Cognome, DataDiNascita)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
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
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE FraseSignificativa (
    ID INT,
    TitoloFilm VARCHAR(255) NOT NULL,
    AnnoFilm INT NOT NULL,
    NomeAttore VARCHAR(100) NOT NULL,
    CognomeAttore VARCHAR(100) NOT NULL,
    DataNascitaAttore DATE NOT NULL,
    Frase TEXT NOT NULL,

    PRIMARY KEY (ID),
    FOREIGN KEY (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
        REFERENCES Recitazione(TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
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
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (EmailCliente)
        REFERENCES ClienteRegistrato(Email)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
