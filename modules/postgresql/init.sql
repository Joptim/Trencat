-- CREATE EXTENSION 'postgis';

CREATE TABLE IF NOT EXISTS nodes (
    id              INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 0 MINVALUE 0 INCREMENT BY 1),
    alias           VARCHAR(30),
    --description     VARCHAR(100),
    CONSTRAINT nodes_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS railroad (
    id              INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 0 MINVALUE 0 INCREMENT BY 1),
    alias           VARCHAR(30),
    source          INT           NOT NULL,
    target          INT           NOT NULL,
    length          REAL          NOT NULL CHECK (length > 0),
    max_velocity    REAL          NOT NULL CHECK (max_velocity > 0),
    slope           DOUBLE PRECISION NOT NULL DEFAULT 0,
    bend_radius     REAL,
    tunnel          BOOLEAN       NOT NULL DEFAULT FALSE, 
    bidirectional   BOOLEAN       NOT NULL DEFAULT FALSE,
    --description     VARCHAR(100),
    CONSTRAINT railroad_pk PRIMARY KEY (id),
    CONSTRAINT railroad_source_fk FOREIGN KEY (source) REFERENCES nodes (id),
    CONSTRAINT railroad_target_fk FOREIGN KEY (target) REFERENCES nodes (id)
);

CREATE TABLE IF NOT EXISTS station (
    id              INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 0 MINVALUE 0 INCREMENT BY 1),
    alias           VARCHAR(30)   NOT NULL,
    --description     VARCHAR(100),
    CONSTRAINT station_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS station_platforms (
    id              INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 0 MINVALUE 0 INCREMENT BY 1),
    station_id      INTEGER       NOT NULL,
    railroad_id     INTEGER       NOT NULL,
    capacity        INTEGER       NOT NULL CHECK (capacity > 0),
    --description     VARCHAR (100),
    CONSTRAINT station_platform_pk PRIMARY KEY (id),
    CONSTRAINT station_platform_station_id_fk FOREIGN KEY (station_id) REFERENCES station (id),
    CONSTRAINT station_platform_railroad_id_fk FOREIGN KEY (railroad_id) REFERENCES railroad (id)
);

CREATE TABLE IF NOT EXISTS train (
    id              INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 0 MINVALUE 0 INCREMENT BY 1),
    alias           VARCHAR(30)   NOT NULL,
    model           VARCHAR(50)   NOT NULL,
    mass            REAL          NOT NULL CHECK (mass > 0),
    mass_factor     REAL          NOT NULL CHECK (mass_factor > 0),
    units           SMALLINT      NOT NULL CHECK (units > 0),
    capacity        SMALLINT      NOT NULL CHECK (capacity > 0),
    length          REAL          NOT NULL CHECK (length > 0),
    max_traction    REAL          NOT NULL CHECK (max_traction > 0),
    max_brake       REAL          NOT NULL CHECK (max_brake > 0),
    emergency_brake REAL          NOT NULL CHECK (emergency_brake > 0),
    resistance_lin  DOUBLE PRECISION        NOT NULL CHECK (resistance_lin > 0),
    resistance_qua  DOUBLE PRECISION       NOT NULL CHECK (resistance_qua > 0),
    CONSTRAINT train_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS semaphores (
    id              INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 0 MINVALUE 0 INCREMENT BY 1),
    node_id         INTEGER NOT NULL,
    railroad_id     INTEGER NOT NULL,
    --description     VARCHAR(100),
    CONSTRAINT semaphores_pk PRIMARY KEY (id),
    CONSTRAINT semaphores_pk PRIMARY KEY (node_id, railroad_id),
    CONSTRAINT semaphores_railroad_id_fk FOREIGN KEY (railroad_id) REFERENCES railroad(id)
);

COMMENT ON COLUMN railroad.length            IS 'Length in meters';
COMMENT ON COLUMN railroad.length            IS 'Maximum velocity in meters/second';
COMMENT ON COLUMN railroad.slope             IS 'Slope in radians';
COMMENT ON COLUMN railroad.bend_radius       IS 'Bend radius in meters';
COMMENT ON COLUMN railroad.tunnel            IS 'Does segment run inside a tunnel';
COMMENT ON COLUMN station_platforms.capacity IS 'Number of people that the train carry inside';
COMMENT ON COLUMN train.capacity             IS 'Number of people that the train carry inside';
COMMENT ON COLUMN train.mass_factor          IS 'Mass factor has no units';
COMMENT ON COLUMN train.length               IS 'Length in meters';
COMMENT ON COLUMN train.max_traction         IS 'Traction in Newtons';
COMMENT ON COLUMN train.max_brake            IS 'Brake in Newtons';
COMMENT ON COLUMN train.emergency_brake      IS 'Brake in Newtons';
COMMENT ON COLUMN train.resistance_lin       IS 'Linear coefficient of self basic resistance';
 COMMENT ON COLUMN train.resistance_qua      IS 'Quadratic coefficient of self basic resistance';

----------------------------------------------------------------------------------------------

INSERT INTO nodes(id) VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11),
(12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25),
(26), (27), (28), (29), (30), (31), (32), (33), (34), (35), (36), (37), (38), (39),
(40), (41), (42), (43), (44), (45), (46), (47), (48), (49), (50), (51), (52), (53),
(54), (55), (56), (57), (58), (59), (60), (61), (62), (63), (64), (65), (66), (67),
(68), (69), (70), (71), (72);

INSERT INTO railroad (id, alias, source, target, length, max_velocity, slope, bend_radius, tunnel, bidirectional)
VALUES (0, 'end_parking', 0, 1, 150, 5, 0, NULL, TRUE, TRUE),
       (1, 'station', 1, 2, 140, 60, 0, NULL, TRUE, FALSE),
       (2, NULL, 2, 3, 1350, 60, 0.01851957712, NULL, TRUE, FALSE),
       (3, 'station', 3, 4, 135, 60, 0, NULL, TRUE, FALSE),
       (4, NULL, 4, 5, 1050, 60, 0.02666982817, NULL, TRUE, FALSE),
       (5, NULL, 5, 6, 290, 60, 0.02666982817, 216, TRUE, FALSE),
       (6, NULL, 6, 7, 500, 60, 0.01200028802 , NULL, TRUE, FALSE),
       (7, 'station', 7, 8, 135, 60, 0, NULL, TRUE, FALSE),
       (8, NULL, 8, 9, 1100, 60, 0.0372813629, NULL, TRUE, FALSE),
       (9, NULL, 9, 10, 310, 60, 0.0372813629, 340, TRUE, FALSE),
       (10, NULL, 10, 11, 1380, 60, 0.02319048438, NULL, TRUE, FALSE),
       (11, 'station', 11, 12, 134.5, 60, 0, NULL, TRUE, FALSE),
       (12, NULL, 12, 13, 290, 60, 0, NULL, TRUE, FALSE),
       (13, NULL, 13, 14, 136, 30, 0.01470641246, 89, TRUE, FALSE),
       (14, NULL, 14, 15, 500, 60, -0.04801845114, NULL, TRUE, FALSE),
       (15, NULL, 15, 16, 105, 30, 0, 92, TRUE, FALSE),
       (16, NULL, 16, 17, 370, 60, 0.016211692702, NULL, TRUE, FALSE),
       (17, NULL, 17, 18, 76, 30, 0.016211692702, 73, TRUE, FALSE),
       (18, NULL, 18, 19, 680, 60, 0.02941600681, NULL, TRUE, FALSE),
       (19, 'station', 19, 20, 155, 60, 0, NULL, TRUE, FALSE),
       (20, NULL, 20, 21, 611, 60, 0.04092795571, NULL, TRUE, FALSE),
       (21, 'station', 21, 22, 138, 60, 0, NULL, TRUE, FALSE),
       (22, NULL, 22, 23, 1470, 60, -2.040817743e-3 , NULL, TRUE, FALSE),
       (23, 'station', 23, 24, 140, 60, 0, NULL, TRUE, FALSE),
       (24, NULL, 24, 25, 730, 60, -0.02328977662, NULL, TRUE, FALSE),
       (25, NULL, 25, 26, 714, 60, 0, 642, TRUE, FALSE),
       (26, NULL, 26, 27, 845, 60, -0.02367084949, NULL, TRUE, FALSE),
       (27, 'station', 27, 28, 162, 60, 0, NULL, TRUE, FALSE),
       (28, NULL, 28, 29, 1530, 60, -0.03987985104, NULL, TRUE, FALSE),
       (29, 'station', 29, 30, 130, 60, 0, NULL, TRUE, FALSE),
       (30, NULL, 30, 31, 180, 60, -0.03987985104, NULL, TRUE, FALSE),
       (31, NULL, 31, 32, 290, 30, -0.03987985104, 123, TRUE, FALSE),
       (32, NULL, 32, 33, 775, 60, -5.161313238e-3, NULL, TRUE, FALSE),
       (33, NULL, 33, 34, 472.5, 45, -5e-5, 337, TRUE, FALSE),
       (34, NULL, 34, 35, 472.5, 45, -0.03178501274, 337, TRUE, FALSE),
       (35, 'station', 35, 36, 140, 60, 0, NULL, TRUE, FALSE),
       (36, 'end_parking', 36, 37, 150, 5, 0, NULL, TRUE, TRUE),
       (37, 'station', 36, 38, 140, 60, 0, NULL, TRUE, FALSE),
       (38, NULL, 38, 39, 472.5, 45, 0.03178501274, 337, TRUE, FALSE),
       (39, NULL, 39, 40, 472.5, 45, 5e-5, 337, TRUE, FALSE),
       (40, NULL, 40, 41, 775, 60, 5.161313238e-3, NULL, TRUE, FALSE),
       (41, NULL, 41, 42, 290, 30, 0.03987985104, 123, TRUE, FALSE),
       (42, NULL, 42, 43, 180, 60, 0.03987985104, NULL, TRUE, FALSE),
       (43, 'station', 43, 44, 130, 60, 0, NULL, TRUE, FALSE),
       (44, NULL, 44, 45, 1530, 60, 0.03987985104, NULL, TRUE, FALSE),
       (45, 'station', 45, 46, 162, 60, 0, NULL, TRUE, FALSE),
       (46, NULL, 46, 47, 845, 60, 0.02367084949, NULL, TRUE, FALSE),
       (47, NULL, 47, 48, 714, 60, 0, 642, TRUE, FALSE),
       (48, NULL, 48, 49, 730, 60, 0.02328977662, NULL, TRUE, FALSE),
       (49, 'station', 49, 50, 140, 60, 0, NULL, TRUE, FALSE),
       (50, NULL, 50, 51, 1470, 60, 2.040817743e-3 , NULL, TRUE, FALSE),
       (51, 'station', 51, 52, 138, 60, 0, NULL, TRUE, FALSE),
       (52, NULL, 52, 53, 611, 60, -0.04092795571, NULL, TRUE, FALSE),
       (53, 'station', 53, 54, 155, 60, 0, NULL, TRUE, FALSE),
       (54, NULL, 54, 55, 680, 60, -0.02941600681, NULL, TRUE, FALSE),
       (55, NULL, 55, 56, 76, 30, -0.016211692702, 73, TRUE, FALSE),
       (56, NULL, 56, 57, 370, 60, -0.016211692702, NULL, TRUE, FALSE),
       (57, NULL, 57, 58, 105, 30, 0, 92, TRUE, FALSE),
       (58, NULL, 58, 59, 500, 60, 0.04801845114, NULL, TRUE, FALSE),
       (59, NULL, 59, 60, 136, 60, -0.01470641246, 89, TRUE, FALSE),
       (60, NULL, 60, 61, 290, 30, 0, NULL, TRUE, FALSE),
       (61, 'station', 61, 62, 134.5, 60, 0, NULL, TRUE, FALSE),
       (62, NULL, 62, 63, 1380, 60, -0.02319048438, NULL, TRUE, FALSE),
       (63, NULL, 63, 64, 310, 60, -0.0372813629, 340, TRUE, FALSE),
       (64, NULL, 64, 65, 1100, 60, -0.0372813629, NULL, TRUE, FALSE),
       (65, 'station', 65, 66, 135, 60, 0, NULL, TRUE, FALSE),
       (66, NULL, 66, 67, 500, 60, -0.01200028802 , NULL, TRUE, FALSE),
       (67, NULL, 67, 68, 290, 60, -0.02666982817, 216, TRUE, FALSE),
       (68, NULL, 68, 69, 1050, 60, -0.02666982817, NULL, TRUE, FALSE),
       (69, 'station', 69, 70, 135, 60, 0, NULL, TRUE, FALSE),
       (70, NULL, 70, 71, 1350, 60, -0.01851957712, NULL, TRUE, FALSE),
       (71, 'station', 71, 72, 140, 60, 0, NULL, TRUE, FALSE),
       (72, 'heading_to_parking', 72, 1, 15, 60, 0, NULL, TRUE, FALSE);

INSERT INTO station (id, alias)
VALUES (0, 'alias_0'), (1, 'alias_1'), (2, 'alias_2'), (3, 'alias_3'),
       (4, 'alias_4'), (5, 'alias_5'), (6, 'alias_6'), (7, 'alias_7'),
       (8, 'alias_8'), (9, 'alias_9');

INSERT INTO station_platforms(id, station_id, railroad_id, capacity) 
VALUES ( 0, 0,  1, 1700), ( 1, 1,  3, 1100), ( 2, 2,  7, 1000),
       ( 3, 3, 11, 1220), ( 4, 4, 19, 3000), ( 5, 5, 21, 2500),
       ( 6, 6, 23,  950), ( 7, 7, 27, 1000), ( 8, 8, 29, 1360),
       ( 9, 9, 35, 1700), (10, 9, 37, 1700), (11, 8, 43, 1360),
       (12, 7, 45, 1000), (13, 6, 49,  950), (14, 5, 51, 2500),
       (15, 4, 53, 3000), (16, 3, 61, 1220), (17, 2, 65, 1000),
       (18, 1, 69, 1100), (19, 0, 71, 1700);

INSERT INTO semaphores (node_id, railroad_id)
VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), 
       (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16),
       (17, 17), (18, 18), (19, 19), (20, 20), (21, 21), (22, 22), (23, 23),
       (24, 24), (25, 25), (26, 26), (27, 27), (28, 28), (29, 29), (30, 30),
       (31, 31), (32, 32), (33, 33), (34, 34), (35, 35), (36, 36), (36, 37),
       (38, 38), (39, 39), (40, 40), (41, 41), (42, 42), (43, 43), (44, 44),
       (45, 45), (46, 46), (47, 47), (48, 48), (49, 49), (50, 50), (51, 51),
       (52, 52), (53, 53), (54, 54), (55, 55), (56, 56), (57, 57), (58, 58),
       (59, 59), (60, 60), (61, 61), (62, 62), (63, 63), (64, 64), (65, 65),
       (66, 66), (67, 67), (68, 68), (69, 69), (70, 70), (71, 71), (72, 72);

INSERT INTO train (id, alias, model, mass, mass_factor, units, capacity, length, max_traction,
                   max_brake, emergency_brake, resistance_lin, resistance_qua)
VALUES (1, 'Test', 'SBB Re 460', 5.07e5, 1.06, 5, 5 * 250, 5 * 25, 3e5,
        4.475e5, 5.96666e5, 0.014 / 5.07e5, 2.564e-5 / 5.07e5);
