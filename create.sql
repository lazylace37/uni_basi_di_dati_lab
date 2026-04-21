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

CREATE TABLE Ruolo (
    NomeRuolo VARCHAR(100) PRIMARY KEY
);

CREATE TABLE FraseSignificativa (
    ID INT PRIMARY KEY,
    Frase TEXT NOT NULL
);

CREATE TABLE Attore (
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    DataDiNascita DATE,
    PRIMARY KEY (Nome, Cognome, DataDiNascita),
    FOREIGN KEY (Nome, Cognome, DataDiNascita) REFERENCES Persona(Nome, Cognome, DataDiNascita)
);

CREATE TABLE Regista (
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    DataDiNascita DATE,
    PRIMARY KEY (Nome, Cognome, DataDiNascita),
    FOREIGN KEY (Nome, Cognome, DataDiNascita) REFERENCES Persona(Nome, Cognome, DataDiNascita)
);

CREATE TABLE Film (
    Titolo VARCHAR(255),
    AnnoDiProduzione INT,
    Durata INT NOT NULL,
    Trama TEXT NOT NULL,
    AziendaProduttrice VARCHAR(255) NOT NULL,
    NomeRegista VARCHAR(100) NOT NULL,
    CognomeRegista VARCHAR(100) NOT NULL,
    DataDiNascitaRegista DATE NOT NULL,
    PRIMARY KEY (Titolo, AnnoDiProduzione),
    FOREIGN KEY (AziendaProduttrice) REFERENCES AziendaProduttrice(Nome),
    FOREIGN KEY (NomeRegista, CognomeRegista, DataDiNascitaRegista) 
        REFERENCES Regista(Nome, Cognome, DataDiNascita)
);

CREATE TABLE GenereDelFilm (
    TitoloFilm VARCHAR(255),
    AnnoDiProduzioneFilm INT,
    NomeGenere VARCHAR(100),
    PRIMARY KEY (TitoloFilm, AnnoDiProduzioneFilm, NomeGenere),
    FOREIGN KEY (TitoloFilm, AnnoDiProduzioneFilm) REFERENCES Film(Titolo, AnnoDiProduzione),
    FOREIGN KEY (NomeGenere) REFERENCES Genere(Nome)
);

CREATE TABLE CopiaFisicaDiFilm (
    Numero INT,
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    PRIMARY KEY (Numero, TitoloFilm, AnnoFilm),
    FOREIGN KEY (TitoloFilm, AnnoFilm) REFERENCES Film(Titolo, AnnoDiProduzione)
);

CREATE TABLE Recitazione (
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    NomeAttore VARCHAR(100),
    CognomeAttore VARCHAR(100),
    DataNascitaAttore DATE,
    NomeRuolo VARCHAR(100),
    PRIMARY KEY (TitoloFilm, AnnoFilm, NomeAttore, CognomeAttore, DataNascitaAttore, NomeRuolo),
    FOREIGN KEY (TitoloFilm, AnnoFilm) REFERENCES Film(Titolo, AnnoDiProduzione),
    FOREIGN KEY (NomeAttore, CognomeAttore, DataNascitaAttore) 
        REFERENCES Attore(Nome, Cognome, DataDiNascita),
    FOREIGN KEY (NomeRuolo) REFERENCES Ruolo(NomeRuolo)
);

CREATE TABLE Noleggio (
    DataDiInizio DATE,
    NumeroCopia INT,
    TitoloFilm VARCHAR(255),
    AnnoFilm INT,
    EmailCliente VARCHAR(255) NOT NULL,
    DurataMassimaNoleggio INT NOT NULL,
    DataDiFine DATE,
    PRIMARY KEY (DataDiInizio, NumeroCopia, TitoloFilm, AnnoFilm),
    FOREIGN KEY (NumeroCopia, TitoloFilm, AnnoFilm) 
        REFERENCES CopiaFisicaDiFilm(Numero, TitoloFilm, AnnoFilm),
    FOREIGN KEY (EmailCliente) REFERENCES ClienteRegistrato(Email)
);
