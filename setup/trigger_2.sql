CREATE OR REPLACE FUNCTION ControllaNoleggioAttivo() RETURNS trigger AS $$
BEGIN
  IF EXISTS (
    SELECT *
    FROM Noleggio
    WHERE
      TitoloFilm = NEW.TitoloFilm AND
      AnnoFilm = NEW.AnnoFilm AND
      NumeroCopia = NEW.NumeroCopia AND
      DataDiInizio <> NEW.DataDiInizio AND
      DataDiFine IS NULL
  ) THEN
    RAISE EXCEPTION 'Ci può essere al massimo un noleggio attivo per questa copia fisica di film';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER Noleggio_ControllaNoleggioAttivoInModifica
AFTER UPDATE ON Noleggio
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION ControllaNoleggioAttivo();
