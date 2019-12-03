SPOOL project.out
SET ECHO ON 
SET sqlblanklines ON

/* 
CIS 353 - Database Design Project 
Lucas Bailey
Sam Petrarca
*/ 

DROP TABLE award;
DROP TABLE sponsor;
DROP TABLE locations;
DROP TABLE enrolledIn;
DROP TABLE teaches;
DROP TABLE clownCourse;
DROP TABLE clownCar;
DROP TABLE clownProfessor;
DROP TABLE clown;

CREATE TABLE clown
(
cSSN INTEGER PRIMARY KEY,
name CHAR(15) NOT NULL,
age INTEGER,

CONSTRAINT Carl CHECK (name != 'Carl')

);

CREATE TABLE clownCar
(
vIN INTEGER PRIMARY KEY,
make CHAR(15) NOT NULL,
model CHAR(15) NOT NULL,
cSSN INTEGER NOT NULL,

CONSTRAINT ccIC1 FOREIGN KEY (cSSN) REFERENCES clown(cSSN)
    ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED
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
doa CHAR(10),
type CHAR(15),
amount INTEGER,
PRIMARY KEY(cSSN, sID, doa),

CONSTRAINT cSSN1 FOREIGN KEY (cSSN)
    REFERENCES clown(cSSN),

CONSTRAINT sID1 FOREIGN KEY (sID)
    REFERENCES sponsor(sID),

CONSTRAINT a1 CHECK((NOT (type = 'Participation' AND amount>500 )))

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
    REFERENCES clownCourse (cID)
);




-- 
SET FEEDBACK OFF 

INSERT INTO clownCar VALUES (2, 'clowny', 'silverado', 3);
INSERT INTO clownCar VALUES (3, 'bozo', 'prius', 2);
INSERT INTO clown VALUES (1, 'Jef', 20);
INSERT INTO clown VALUES (2, 'Cam', 25);
INSERT INTO clown VALUES (3, 'Daniel', 70);
INSERT INTO clownCourse VALUES (1, 'Juggling', 3);
INSERT INTO clownCourse VALUES (2, 'Driving', 2);
INSERT INTO clownCourse VALUES (3, 'Lion Wrestling', 4);
INSERT INTO clownProfessor VALUES (1, 'Jarvis', 35);
INSERT INTO sponsor VALUES (1, 'macDangles');
INSERT INTO award VALUES (1, 1, '2019-01-30', 'Participation', 300);
INSERT INTO award VALUES (2, 1, '2019-02-10', 'Great Nose', 300);
INSERT INTO locations VALUES (1, 'Allendale');
INSERT INTO locations VALUES (2, 'Pew');
INSERT INTO enrolledIn VALUES (1, 1, 'Winter', 2020);
INSERT INTO enrolledIn VALUES (1, 2, 'Winter', 2020);
INSERT INTO enrolledIn VALUES (1, 3, 'Summer', 2020);
INSERT INTO enrolledIn VALUES (2, 1, 'Winter', 2020);
INSERT INTO enrolledIN VALUES (2, 3, 'Summer', 2020);
INSERT INTO enrolledIn VALUES (3, 3, 'Summer', 2020);
INSERT INTO teaches VALUES (1, 1, 'Winter', 2020);
INSERT INTO teaches VALUES (1, 2, 'Winter', 2020);

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


/* Q1 - Join with at least 4 relations 
 Finds the awards earned by clowns that are taught by the teacher with an
 SSN of 1
 */
SELECT DISTINCT c.name, a.DOA, a.type, a.amount 
FROM clown c, award a, enrolledIn e, teaches t
WHERE a.cSSN = c.cSSN AND 
c.cSSN = e.cSSN AND
e.CID = t.CID AND
t.pSSN = 1;


/* Q2 - Self Join 
Finds all awards of different types which give the same amount */
SELECT DISTINCT *
FROM award a1, award a2
WHERE a1.type != a2.type AND
a1.amount = a2.amount;


/* Q3 - Union 
Finds all clowns over the age of 30 who are enrolled in the class with CID of 2 */
SELECT *
FROM clown c
WHERE c.age > 30 
UNION
SELECT c.cSSN, c.name, c.age
FROM clown c, enrolledIn e
WHERE c.cSSN = e.cSSN AND 
e.CID = 2;


/* Q4.5 - Sum and Group By / Having / Order By 
 Shows the clowns with more than 4 total credits    */
SELECT c.cSSN, c.name, SUM(cc.credits)
FROM clown c, clownCourse cc, enrolledIn e
WHERE e.cSSN = c.cSSN AND
e.CID = cc.CID
GROUP BY c.cSSN, c.name
HAVING SUM(cc.credits) > 4
ORDER BY c.cSSN;


/* Q5 - Correlated Subquery
 Shows all courses above 2 credits that have a set location.*/
SELECT cc.CID, cc.subject, cc.credits
FROM clownCourse cc 
WHERE cc.credits > 2 AND
EXISTS
    (SELECT *
    FROM locations l
    WHERE l.CID = cc.CID
);


/* Q6 - Non-Correlated Subquery
Selects all clowns under 30 that do not own a car.  */
SELECT c.cSSN, c.name
FROM clown c
WHERE c.age < 30 AND
c.cSSN NOT IN (
    SELECT cr.cSSN
    FROM clownCar cr
);


/* Q7 - Relational DIVISION Query 
Finds the cSSN and name of every clown who has taken every course over 2 credits*/
SELECT c.cSSN, c.name
FROM clown c
WHERE NOT EXISTS(( 
        SELECT cc.CID
        FROM clownCourse cc 
        WHERE cc.credits > 2)
    MINUS
        (SELECT cc.CID 
        FROM enrolledIn e, clownCourse cc
        WHERE e.cSSN = c.cSSN AND
        cc.CID = e.CID AND
        cc.credits > 2));

/* Q8 - Left Outer Join
Selects every clown and displays their information, and if they have a car it displays the information of that clown car    */
SELECT c.cSSN, c.name, cr.VIN, cr.make, cr.model
FROM clown c LEFT OUTER JOIN clownCar cr ON c.cSSN = cr.cSSN;


< The insert/delete/update statements to test the enforcement of ICs > 
Include the following items for every IC that you test (Important: see the next section titled “Submit a final report” regarding which ICs to test).  
A comment line stating: Testing: < IC name>

/* Testing IC carl */
INSERT INTO clown VALUES (3, 'Carl', 12);

/* Testing IC A1 */
INSERT INTO award VALUES (2, 1, '2019-02-10', 'Participation', 900);

/* Testing clown primary key */
INSERT INTO clown VALUES (1, 'Doofus', 45);

/* Testing IC cSSN1 */
DELETE FROM clown WHERE cSSN = 1;

COMMIT; 
-- 
SPOOL OFF
