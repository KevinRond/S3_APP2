CREATE OR REPLACE FUNCTION TABLEAU(debut time, fin time, date_val date, categorie varchar(4))
    RETURNS TABLE
            (
                Local_num varchar(32),
                Pav_id varchar(32),
                heure time,
                cip varchar(32),
                Reserve_id varchar(32),
                description varchar(64)
            )
AS $$
WITH horaire AS (
    SELECT
        lf.Local_num,
        lf.Pav_id,
        lookup.heure,
        reservation.cip,
        reservation.reserve_id,
        CASE
            WHEN reservation.local_num IS NULL THEN 'Aucune reservation'
            ELSE reservation.description
            END AS description
    FROM
        (
            SELECT Local_num, Pav_id
            FROM LOCAL
            WHERE fonc_id = categorie
        ) AS lf
            CROSS JOIN
        (
            SELECT
                generate_series(date_val + debut::time, date_val + fin::time, interval '2 hours') AS heure
        ) AS lookup
            LEFT JOIN reservation ON
                    lf.Local_num = reservation.Local_num AND
                    lf.Pav_id = reservation.Pav_id AND
                    lookup.heure > reservation.heure_debut AND
                    lookup.heure < reservation.heure_fin AND
                    date_val = reservation.date
)
SELECT * FROM horaire
ORDER BY  Local_num, heure;
$$ LANGUAGE SQL;


SELECT * FROM TABLEAU('00:00:00', '23:45:00', '2021-09-28', '0114');
