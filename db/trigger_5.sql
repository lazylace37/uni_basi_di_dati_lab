CREATE OR REPLACE FUNCTION AggiornaNumeroFilmProdottiInInserimento() RETURNS trigger AS $$
BEGIN
  UPDATE AziendaProduttrice
  SET NumeroDiFilmProdotti = (
    SELECT COUNT(*)
    FROM Film
    WHERE AziendaProduttrice = NEW.AziendaProduttrice
  )
  WHERE Nome = NEW.AziendaProduttrice;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Film_AggiornaNumeroFilmProdottiInInserimento
AFTER INSERT ON Film
FOR EACH ROW
EXECUTE FUNCTION AggiornaNumeroFilmProdottiInInserimento();
