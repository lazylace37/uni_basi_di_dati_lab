BEGIN TRANSACTION;

INSERT INTO Film VALUES (
        'Il mio film',
        2024,
        120,
        'Francesco fa un film',
        'Love PLC'
);

INSERT INTO RegistaDelFilm VALUES (
        'Il mio film',
        2024,
        'Sarah',
        'Rodriguez',
        DATE('1949-08-31')
);

COMMIT;
