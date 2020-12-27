DROP TABLE IF EXISTS Bat_Raw;
DROP TABLE IF EXISTS BatStats;
DROP TABLE IF EXISTS Pitch_Raw;
DROP TABLE IF EXISTS PitchStats;
DROP TABLE IF EXISTS Field_Raw;
DROP TABLE IF EXISTS FieldStats;
DROP TABLE IF EXISTS HOF;
DROP TABLE IF EXISTS output;

-- Batting Stats -Taking the sum of data FROM both The Batting AND BattingPost Relational Instances
CREATE TABLE Bat_Raw 
AS SELECT playerID, yearID, G, R, H, 2B, 3B, HR , SO 
FROM Batting 
UNION ALL 
SELECT  playerID, yearID, G, R, H, 2B, 3B, HR , SO 
FROM BattingPost;

CREATE TABLE BatStats 
AS SELECT playerID, COUNT(DISTINCT yearID) AS Years_Batted , sum(G) AS totGB, sum(R) AS totRB, sum(H) AS totHB, sum(2B) AS tot2B, sum(3B) AS tot3B, 
sum(HR) AS totHRB, sum(SO) AS totSOB 
FROM Bat_Raw 
GROUP BY playerID;

-- Pitching Stats - Taking the sum of data from both The Pitching and PitchingPost Relational Instances
CREATE TABLE Pitch_Raw 
AS SELECT playerID, yearID, G, W, L, IPOuts, H , R, ER , BB , SO , HR 
FROM Pitching 
UNION ALL 
SELECT  playerID, yearID, G, W, L, IPOuts, H , R, ER , 
BB , SO , HR 
FROM PitchingPost;

CREATE TABLE PitchStats 
AS SELECT playerID, COUNT(DISTINCT yearID) AS Years_Pitched , sum(G) AS totGP, sum(W) ASs totW, sum(L) AS totL, sum(IPOuts) AS totIPOuts, sum(H) AS totHP, sum(R) AS totRP, 
sum(ER) AS totER, sum(BB) AS totBB, sum(SO) AS totSOP, sum(HR) AS totHRP 
FROM Pitch_Raw 
GROUP BY playerID;

-- Fielding Stats - Taking the sum of data FROM both The Fielding AND FieldingPost Relational Instances
CREATE TABLE Field_Raw 
AS SELECT playerID, yearID, G, A, PO, E, DP, PB , CS, InnOuts, SB 
FROM Fielding 
UNION ALL 
SELECT  playerID, yearID, G, A, PO, E, DP, PB , CS, InnOuts, SB 
FROM FieldingPost;

CREATE TABLE FieldStats 
AS SELECT playerID, COUNT(DISTINCT yearID) AS Years_Fielded , sum(G) AS totGF, sum(A) AS totA, sum(PO) AS totPO, sum(E) AS totE, sum(DP) 
AS totDP, sum(PB) AS totPB, sum(CS) AS totCS, sum(InnOuts) AS totInnOuts, sum(SB) AS totSB 
FROM Field_Raw 
GROUP BY playerID;

-- HOF data - all that were nominated (inducted = Y or N) or elected (inducted = Y)
CREATE TABLE HOF 
AS SELECT playerID, inducted 
FROM HallOfFame 
WHERE (category = 'Player' AND inducted = 'Y');
-- add the rest of the nominated who were not inducted
INSERT INTO HOF (SELECT DISTINCT playerID, inducted 
                 FROM HallOfFame 
                 WHERE (category = 'Player' 
                        AND playerID 
                        NOT IN (
                          SELECT playerID 
                          FROM HallOfFame 
                          WHERE (category = 'Player' AND inducted = 'Y'))));

-- Table for Task 1
CREATE TABLE taska_out AS SELECT m.playerID, 
bs.Years_Batted , bs.totGB, bs.totRB, bs.totHB, bs.tot2B, bs.tot3B, bs.totHRB, bs.totSOB,
ps.Years_Pitched, ps.totGP, ps.totRP, ps.totHP, ps.totW, ps.totL, ps.totHRP, ps.totSOP, ps.totIPOuts, ps.totER, ps.totBB,   
fs.Years_Fielded, fs.totGF, fs.totA, fs.totPO, fs.totE, fs.totDP, fs.totPB, fs.totCS, fs.totInnOuts, fs.totSB , 
m.debut, m.finalGame, m.deathYear, 
h.inducted
FROM Master m 
LEFT JOIN BatStats bs USING (playerID) 
LEFT JOIN PitchStats ps USING (playerID) 
LEFT JOIN FieldStats fs USING (playerID) 
LEFT JOIN HOF h USING (playerID);

-- Data Cleansing for the Task 1 table
-- #1 Ensuring that the Classes are made to showcase whethere someone was notimated and/or inducted into HOF (1) or wasn't (0)
UPDATE taska_out 
SET inducted = 1
WHERE inducted = 'Y';
UPDATE taska_out
SET inducted = 1 
WHERE inducted = 'N';
UPDATE taska_out 
SET inducted = 0 
WHERE inducted IS null;

-- #2 Replacing any null values with 0. 
UPDATE taska_out
SET totGB= 0 WHERE totGB IS null;
UPDATE taska_out
SET totRB= 0 WHERE totRB IS null;
UPDATE taska_out
SET totHB= 0 WHERE totHB IS null;
UPDATE taska_out
SET tot2B= 0 WHERE tot2B IS null;
UPDATE taska_out
SET tot3B= 0 WHERE tot3B IS null;
UPDATE taska_out
SET totHRB= 0 WHERE totHRB IS null;
UPDATE taska_out
SET totSOB= 0 WHERE totSOB IS null;
UPDATE taska_out
SET Years_Pitched= 0 WHERE Years_Pitched IS null;
UPDATE taska_out
SET totGP= 0 WHERE totGP IS null;
UPDATE taska_out
SET totW= 0 WHERE totW IS null;
UPDATE taska_out
SET totL= 0 WHERE totL IS null;
UPDATE taska_out
SET totIPOuts= 0 WHERE totIPOuts IS null;
UPDATE taska_out
SET totHP= 0 WHERE totHP IS null;
UPDATE taska_out
SET totRP= 0 WHERE totRP IS null;
UPDATE taska_out
SET totER= 0 WHERE totER IS null;
UPDATE taska_out
SET totBB= 0 WHERE totBB IS null;
UPDATE taska_out
SET totSOP= 0 WHERE totSOP IS null;
UPDATE taska_out
SET totHRP= 0 WHERE totHRP IS null;
UPDATE taska_out
SET totGF= 0 WHERE totGF IS null;
UPDATE taska_out
SET totA= 0 WHERE totA IS null;
UPDATE taska_out
SET totPO= 0 WHERE totPO IS null;
UPDATE taska_out
SET totE= 0 WHERE totE IS null;
UPDATE taska_out
SET totDP= 0 WHERE totDP IS null;
UPDATE taska_out
SET totCS= 0 WHERE totCS IS null;
UPDATE taska_out
SET totInnOuts= 0 WHERE totInnOuts IS null;
UPDATE taska_out
SET totSB= 0 WHERE totSB IS null;
UPDATE taska_out
SET Years_Fielded = 0 WHERE Years_Fielded IS null;
UPDATE taska_out
SET debut= 0 WHERE debut IS null;
UPDATE taska_out
SET finalGame= 0 WHERE finalGame IS null;
UPDATE taska_out
SET deathYear= 0 WHERE deathYear IS null;

-- Table for Task 2
CREATE TABLE taskb_out AS SELECT h.playerID, 
bs.Years_Batted , bs.totGB, bs.totRB, bs.totHB, bs.tot2B, bs.tot3B, bs.totHRB, bs.totSOB,
ps.Years_Pitched, ps.totGP, ps.totRP, ps.totHP, ps.totW, ps.totL, ps.totHRP, ps.totSOP, ps.totIPOuts, ps.totER, ps.totBB,   
fs.Years_Fielded, fs.totGF, fs.totA, fs.totPO, fs.totE, fs.totDP, fs.totPB, fs.totCS, fs.totInnOuts, fs.totSB , 
m.debut, m.finalGame, m.deathYear, 
h.inducted
FROM BatStats bs 
LEFT JOIN PitchStats ps
USING (playerID)
LEFT JOIN FieldStats fs
USING (playerID)
LEFT JOIN Master m
USING (playerID)
RIGHT JOIN HOF h
USING (playerID);

-- Data Cleansing for the Task 2 table
-- #1 ensuring that the Classes are made to showcase whethere someone was inducted and(1) or not(0)
UPDATE taskb_out 
SET inducted = 1
WHERE inducted = 'Y';
UPDATE taskb_out 
SET inducted = 0 
WHERE inducted = 'N';


-- #2 Replacing any null values with 0. 
UPDATE taskb_out 
SET totGB= 0 WHERE totGB IS null;
UPDATE taskb_out 
SET totRB= 0 WHERE totRB IS null;
UPDATE taskb_out 
SET totHB= 0 WHERE totHB IS null;
UPDATE taskb_out 
SET tot2B= 0 WHERE tot2B IS null;
UPDATE taskb_out 
SET tot3B= 0 WHERE tot3B IS null;
UPDATE taskb_out 
SET totHRB= 0 WHERE totHRB IS null;
UPDATE taskb_out 
SET totSOB= 0 WHERE totSOB IS null;
UPDATE taskb_out 
SET Years_Pitched= 0 WHERE Years_Pitched IS null;
UPDATE taskb_out 
SET totGP= 0 WHERE totGP IS null;
UPDATE taskb_out 
SET totW= 0 WHERE totW IS null;
UPDATE taskb_out 
SET totL= 0 WHERE totL IS null;
UPDATE taskb_out 
SET totIPOuts= 0 WHERE totIPOuts IS null;
UPDATE taskb_out 
SET totHP= 0 WHERE totHP IS null;
UPDATE taskb_out 
SET totRP= 0 WHERE totRP IS null;
UPDATE taskb_out 
SET totER= 0 WHERE totER IS null;
UPDATE taskb_out 
SET totBB= 0 WHERE totBB IS null;
UPDATE taskb_out 
SET totSOP= 0 WHERE totSOP IS null;
UPDATE taskb_out 
SET totHRP= 0 WHERE totHRP IS null;
UPDATE taskb_out 
SET totGF= 0 WHERE totGF IS null;
update taska_out
SET totA= 0 WHERE totA IS null;
UPDATE taskb_out 
SET totPO= 0 WHERE totPO IS null;
UPDATE taskb_out 
SET totE= 0 WHERE totE IS null;
UPDATE taskb_out 
SET totDP= 0 WHERE totDP IS null;
UPDATE taskb_out 
SET totCS= 0 WHERE totCS IS null;
UPDATE taskb_out 
SET totInnOuts= 0 WHERE totInnOuts IS null;
UPDATE taskb_out 
SET totSB= 0 WHERE totSB IS null;
UPDATE taskb_out 
SET Years_Fielded = 0WHERE Years_Fielded IS null;
UPDATE taskb_out 
SET debut= 0 WHERE debut IS null;
UPDATE taskb_out 
SET finalGame= 0 WHERE finalGame IS null;
UPDATE taskb_out 
SET deathYear= 0 WHERE deathYear IS null;

-- Extracting csv files for Task 1 and Task 2 respectively. Had to extract the csv code through virtual machine because of file priviledge problems
-- For Task 1: mysql -B -h manta.uwaterloo.ca -u user_mm4siddi -p ece356db_mm4siddi -e "select * from taska_out" | sed 's/\t/,/g' > task1_extracted.csv
-- For Task 2: mysql -B -h manta.uwaterloo.ca -u user_mm4siddi -p ece356db_mm4siddi -e "select * from taskb_out" | sed 's/\t/,/g' > task2_extracted.csv

/*
-- If no issues would be made, try this code to extract the files
SELECT * FROM taska_out
INTO OUTFILE 'C:/Users/mushi/Downloads/lahman/task1_extracted.csv'
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';

SELECT * FROM taskb_out
INTO OUTFILE 'C:/Users/mushi/Downloads/lahman/task2_extracted.csv'
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';
*/
