CREATE OR REPLACE FUNCTION procedure_reserv_update() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF EXISTS (
            SELECT 1
            FROM reservation res
            WHERE res.local_num = NEW.local_num
                AND ((res.num_cubicule = NEW.num_cubicule) OR (res.num_cubicule IS NULL AND NEW.num_cubicule IS NULL))
                AND res.heure_debut < NEW.heure_fin
                AND res.heure_fin > NEW.heure_debut
                AND res.reserve_id <> NEW.reserve_id
                AND res.pav_id = NEW.pav_id
        )
        THEN
            RAISE EXCEPTION 'Conflit dans la reservation : L interval de temps choisi chevauche une reservation existante.';
END IF;
        IF (NEW.heure_fin - NEW.heure_debut) > INTERVAL '4 hours' THEN
            RAISE EXCEPTION 'La durée de réservation doit être inférieure ou égale à 4 heures.';
END IF;

INSERT INTO logbook(log_id, description, date, local_num, num_cubicule, pav_id, cip)
VALUES(DEFAULT, 'Reservation creee', CURRENT_DATE, new.local_num, new.num_cubicule, new.pav_id, new.cip);
RETURN NEW;
ELSIF TG_OP = 'UPDATE' THEN
        IF EXISTS (
            SELECT 1
            FROM reservation res
            WHERE res.local_num = NEW.local_num
              AND res.pav_id = NEW.pav_id
              AND res.heure_debut < NEW.heure_fin
              AND res.heure_fin > NEW.heure_debut
              AND res.reserve_id <> NEW.reserve_id
        )
        THEN
            RAISE EXCEPTION 'Conflit dans la reservation : L interval de temps choisi chevauche une reservation existante.';
END IF;
            IF (NEW.heure_fin - NEW.heure_debut) > INTERVAL '4 hours' THEN
                RAISE EXCEPTION 'La durée de réservation doit être inférieure ou égale à 4 heures.';
END IF;
INSERT INTO logbook(log_id, description, date, local_num, numcubicule, pav_id, cip)
VALUES(DEFAULT, 'Reservation updatee', CURRENT_DATE, new.local_num, new.num_cubicule, new.pav_id, new.cip);
--         UPDATE log
--         SET description = 'Update de la reservation', date = CURRENT_DATE
--         WHERE local_num = new.local_num AND pav_id = new.pav_id;

RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_reservation_update ON reservation;
DROP TRIGGER IF EXISTS trigger_reservation_delete ON reservation;

CREATE OR REPLACE FUNCTION procedure_reservation_delete()
    RETURNS TRIGGER AS $$
BEGIN
INSERT INTO log(log_id,description, date, local_num, pav_id, cip)
VALUES(DEFAULT,'Reservation annule', CURRENT_TIMESTAMP, old.local_num, OLD.pav_id, old.cip);
RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_reservation_update
    AFTER INSERT OR UPDATE ON reservation
                        FOR EACH ROW
                        EXECUTE PROCEDURE procedure_reserv_update();

CREATE TRIGGER trigger_reservation_delete
    AFTER DELETE
    ON reservation
    FOR EACH ROW EXECUTE PROCEDURE procedure_reservation_delete();
