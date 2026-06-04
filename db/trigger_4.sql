CREATE OR REPLACE FUNCTION ControllaIntervalliNoleggio()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
  DECLARE
    CNT INTEGER;
  BEGIN
    -- Seleziona i noleggi che sono in overlap
    SELECT COUNT(*) INTO CNT
    FROM   Noleggio N
    WHERE  N.NumeroCopia = NEW.NumeroCopia
      AND  N.TitoloFilm  = NEW.TitoloFilm
      AND  N.AnnoFilm    = NEW.AnnoFilm
      AND  (NEW.DataDiFine IS NULL OR N.DataDiInizio <= NEW.DataDiFine)
      AND  (N.DataDiFine IS NULL OR NEW.DataDiInizio <= N.DataDiFine);

    IF CNT > 0
    THEN
      RAISE EXCEPTION 'Il Noleggio è invalido.';
    END IF;

    RETURN NEW;
  END;
$$;

CREATE OR REPLACE TRIGGER trg_ControllaIntervalliNoleggio
BEFORE INSERT ON Noleggio
FOR EACH ROW
EXECUTE FUNCTION ControllaIntervalliNoleggio();
