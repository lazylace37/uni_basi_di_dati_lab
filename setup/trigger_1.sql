CREATE FUNCTION ControllaSpecializzazione() RETURNS trigger AS $$
BEGIN
  IF NOT EXISTS (
    SELECT *
    FROM Attore
    WHERE Nome = NEW.Nome AND Cognome = NEW.Cognome AND DataDiNascita = NEW.DataDiNascita
  ) AND NOT EXISTS (
    SELECT *
    FROM Regista
    WHERE Nome = NEW.Nome AND Cognome = NEW.Cognome AND DataDiNascita = NEW.DataDiNascita
  ) THEN
    RAISE EXCEPTION 'La persona deve essere o un attore, o un regista, o entrambi';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Persona_ControllaSpecializzazioneInInserimento
AFTER INSERT ON Persona
FOR EACH ROW
EXECUTE FUNCTION ControllaSpecializzazione();
