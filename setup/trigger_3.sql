CREATE FUNCTION AggiornaNumeroFilmProdotti() RETURNS trigger AS $$
BEGIN
  UPDATE AziendaProduttrice
  SET NumeroDiFilmProdotti = (
    SELECT COUNT(*)
    FROM Film
    WHERE AziendaProduttrice = OLD.AziendaProduttrice
  )
  WHERE Nome = OLD.AziendaProduttrice;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Film_AggiornaNumeroFilmProdottiInRimozione
AFTER DELETE ON Film
FOR EACH ROW
EXECUTE FUNCTION AggiornaNumeroFilmProdotti();
