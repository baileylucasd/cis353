SPOOL project.out
SET ECHO ON 
/* 
CIS 353 - Database Design Project 
Lucas Bailey
Sam Petrarca
*/ 
SET sqlblanklines ON

DROP TABLE clownCars;
DROP TABLE clown;
DROP TABLE clownCourse;
DROP TABLE clownProfessor;
DROP TABLE sponsor;
DROP TABLE award;
DROP TABLE locations;
DROP TABLE enrolledIn;
DROP TABLE teaches;

CREATE TABLE clownCars
(
vIN INTEGER PRIMARY KEY,
make CHAR(15) NOT NULL,
model CHAR(15) NOT NULL,
cSSN INTEGER NOT NULL,

CONSTRAINT ccIC1 FOREIGN KEY (cSSN) REFERENCES clown(cSSN)
    ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE clown
(
cSSN INTEGER PRIMARY KEY,
name CHAR(15) NOT NULL,
age INTEGER,

CONSTRAINT Carl CHECK (name != 'Carl')

);

CREATE TABLE clownCourse
(
cID INTEGER PRIMARY KEY,
subject CHAR(15) NOT NULL,
credits INTEGER
);

CREATE TABLE clownProfessor
(
pSSN INTEGER PRIMARY KEY,
name CHAR(15) NOT NULL,
age INTEGER
);

CREATE TABLE sponsor
(
sID INTEGER PRIMARY KEY,
sName CHAR(15) NOT NULL
);

CREATE TABLE award
(
cSSN INTEGER,
sID INTEGER,
date DATE,
type CHAR(15),
amount INTEGER,
PRIMARY KEY(cSSN, sID, date),

CONSTRAINT cSSN1 FOREIGN KEY (cSSN)
    REFERENCES clown(cSSN),

CONSTRAINT sID1 FOREIGN KEY (sID)
    REFERENCES sponsor(sID),

CONSTRAINT a1 CHECK( NOT (type=='Participation' AND amount>500 ))
);

CREATE TABLE locations
(
cID INTEGER,
location char(20),
PRIMARY KEY(cID, location),

CONSTRAINT cID1 FOREIGN KEY (cID)
    REFERENCES clownCourse(cID)
);

CREATE TABLE enrolledIn
(
cSSN INTEGER,
cID INTEGER,
sem CHAR(10),
year INTEGER,
PRIMARY KEY(cSSN, cID),

CONSTRAINT cID2 FOREIGN KEY (cID)
    REFERENCES clownCourse(cID),
CONSTRAINT cSSN2 FOREIGN KEY (cSSN)
    REFERENCES clown(cSSN)
);

CREATE TABLE teaches
(
pSSN INTEGER,
cID INTEGER,
sem CHAR(10),
year INTEGER,
PRIMARY KEY(pSSN, cID),

CONSTRAINT pSSN1 FOREIGN KEY (pSSN) 
    REFERENCES clownProfessor(pSSN),
CONSTRAINT cID3 FOREIGN KEY (cID)
    REFERENCCES clownCourse (cID)
);




-- 
SET FEEDBACK OFF 

INSERT INTO clownCar VALUES (1, 'clowny', 'silverado', 1);
INSERT INTO clownCar VALUES (2, 'bozo', 'prius', 2);
INSERT INTO clown VALUES (1, 'Jef', 20);
INSERT INTO clown VALUES (2, 'Cam', 40);
INSERT INTO clown VALUES (3, 'Carl', 12);
INSERT INTO clownCourse VALUES (1, 'Juggling', 3);
INSERT INTO clownProfessor VALUES (1, 'Jesus!', 35);
INSERT INTO sponsor VALUES (1, 'macDangles');
INSERT INTO award VALUES (1, 1, 2019-01-30, 'Participation', 300);
INSERT INTO award VALUES (2, 1, 2019-02-10, 'Participation', 900);
INSERT INTO locations VALUES (1, 'Allendale');
INSERT INTO enrolledIn VALUES (1, 1, 'Winter', 2020);
INSERT INTO teaches VALUES (1, 1, 'Winter', 2020);

/*< The INSERT statements that populate the tables> 
Important: Keep the number of rows in each table small enough so that the results of your queries can be verified by hand. See the Sailors database as an example. */
SET FEEDBACK ON 
COMMIT; 
-- 
/*< One query (per table) of the form: SELECT * FROM table; in order to print out your database > */

SELECT * FROM clownCar;
SELECT * FROM clown;
SELECT * FROM clownCourse;
SELECT * FROM clownProfessor;
SELECT * FROM sponsor;
SELECT * FROM award;
SELECT * FROM locations;
SELECT * FROM enrolledIn;
SELECT * FROM teaches;

-- 
< The SQL queries>. Include the following for each query: 
6. A comment line stating the query number and the feature(s) it demonstrates (e.g. – Q25 – correlated subquery). 
7. A comment line stating the query in English. 
8. The SQL code for the query. 
-- 
< The insert/delete/update statements to test the enforcement of ICs > 
Include the following items for every IC that you test (Important: see the next section titled “Submit a final report” regarding which ICs to test).  
A comment line stating: Testing: < IC name> 
A SQL INSERT, DELETE, or UPDATE that will test the IC. 
COMMIT; 
-- 
SPOOL OFF
