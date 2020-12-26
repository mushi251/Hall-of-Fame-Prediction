DROP TABLE IF EXISTS Bat_Raw;
DROP TABLE IF EXISTS BatStats;
DROP TABLE IF EXISTS Pitch_Raw;
DROP TABLE IF EXISTS PitchStats;
DROP TABLE IF EXISTS Field_Raw;
DROP TABLE IF EXISTS FieldStats;
DROP TABLE IF EXISTS HOF;
DROP TABLE IF EXISTS output;

#Batting Stats -Taking the sum of data from both The Batting and BattingPost Relational Instances
CREATE TABLE Bat_Raw AS SELECT playerID, yearID, G, R, H, 2B, 3B, HR , SO from Batting UNION ALL SELECT  playerID, yearID, G, R, H, 2B, 3B, HR , SO from BattingPost;
CREATE TABLE BatStats AS SELECT playerID, count(distinct yearID) as Years_Batted , sum(G) as totGB, sum(R) as totRB, sum(H) as totHB, sum(2B) as tot2B, sum(3B) as tot3B, sum(HR) as totHRB, sum(SO) as totSOB 
FROM Bat_Raw GROUP BY playerID;

#Pitching Stats - Taking the sum of data from both The Pitching and PitchingPost Relational Instances
CREATE TABLE Pitch_Raw AS SELECT playerID, yearID, G, W, L, IPOuts, H , R, ER , BB , SO , HR from Pitching UNION ALL SELECT  playerID, yearID, G, W, L, IPOuts, H , R, ER , BB , SO , HR from PitchingPost;
CREATE TABLE PitchStats AS 
SELECT playerID, count(distinct yearID) as Years_Pitched , sum(G) as totGP, sum(W) as totW, sum(L) as totL, sum(IPOuts) as totIPOuts, 
sum(H) as totHP, sum(R) as totRP, sum(ER) as totER, sum(BB) as totBB, sum(SO) as totSOP, sum(HR) as totHRP 
FROM Pitch_Raw GROUP BY playerID;

#Fielding Stats - Taking the sum of data from both The Fielding and FieldingPost Relational Instances
CREATE TABLE Field_Raw AS SELECT playerID, yearID, G, A, PO, E, DP, PB , CS, InnOuts, SB from Fielding UNION ALL SELECT  playerID, yearID, G, A, PO, E, DP, PB , CS, InnOuts, SB from FieldingPost;
CREATE TABLE FieldStats AS SELECT playerID, count(distinct yearID) as Years_Fielded , sum(G) as totGF, sum(A) as totA, sum(PO) as totPO, sum(E) as totE, sum(DP) as totDP, sum(PB) as totPB, 
sum(CS) as totCS, sum(InnOuts) as totInnOuts, sum(SB) as totSB FROM Field_Raw GROUP BY playerID;

#HOF data - all that were nominated (inducted = Y or N) or elected (inducted = Y)
CREATE TABLE HOF AS SELECT playerID, inducted from HallOfFame where (category = 'Player' and inducted = 'Y');
#add the rest of the nominated who were not inducted
INSERT INTO HOF (SELECT DISTINCT playerID, inducted from HallOfFame where (category = 'Player' AND playerID NOT IN (SELECT playerID from HallOfFame where (category = 'Player' and inducted = 'Y'))));

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
WHERE inducted is null;

-- #2 Replacing any null values with 0. 
update taska_out
set totGB= 0 where totGB is null;
update taska_out
set totRB= 0 where totRB is null;
update taska_out
set totHB= 0 where totHB is null;
update taska_out
set tot2B= 0 where tot2B is null;
update taska_out
set tot3B= 0 where tot3B is null;
update taska_out
set totHRB= 0 where totHRB is null;
update taska_out
set totSOB= 0 where totSOB is null;
update taska_out
set Years_Pitched= 0 where Years_Pitched is null;
update taska_out
set totGP= 0 where totGP is null;
update taska_out
set totW= 0 where totW is null;
update taska_out
set totL= 0 where totL is null;
update taska_out
set totIPOuts= 0 where totIPOuts is null;
update taska_out
set totHP= 0 where totHP is null;
update taska_out
set totRP= 0 where totRP is null;
update taska_out
set totER= 0 where totER is null;
update taska_out
set totBB= 0 where totBB is null;
update taska_out
set totSOP= 0 where totSOP is null;
update taska_out
set totHRP= 0 where totHRP is null;
update taska_out
set totGF= 0 where totGF is null;
update taska_out
set totA= 0 where totA is null;
update taska_out
set totPO= 0 where totPO is null;
update taska_out
set totE= 0 where totE is null;
update taska_out
set totDP= 0 where totDP is null;
update taska_out
set totCS= 0 where totCS is null;
update taska_out
set totInnOuts= 0 where totInnOuts is null;
update taska_out
set totSB= 0 where totSB is null;
update taska_out
set Years_Fielded = 0 where Years_Fielded is null;
update taska_out
set debut= 0 where debut is null;
update taska_out
set finalGame= 0 where finalGame is null;
update taska_out
set deathYear= 0 where deathYear is null;

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
set totGB= 0 where totGB is null;
UPDATE taskb_out 
set totRB= 0 where totRB is null;
UPDATE taskb_out 
set totHB= 0 where totHB is null;
UPDATE taskb_out 
set tot2B= 0 where tot2B is null;
UPDATE taskb_out 
set tot3B= 0 where tot3B is null;
UPDATE taskb_out 
set totHRB= 0 where totHRB is null;
UPDATE taskb_out 
set totSOB= 0 where totSOB is null;
UPDATE taskb_out 
set Years_Pitched= 0 where Years_Pitched is null;
UPDATE taskb_out 
set totGP= 0 where totGP is null;
UPDATE taskb_out 
set totW= 0 where totW is null;
UPDATE taskb_out 
set totL= 0 where totL is null;
UPDATE taskb_out 
set totIPOuts= 0 where totIPOuts is null;
UPDATE taskb_out 
set totHP= 0 where totHP is null;
UPDATE taskb_out 
set totRP= 0 where totRP is null;
UPDATE taskb_out 
set totER= 0 where totER is null;
UPDATE taskb_out 
set totBB= 0 where totBB is null;
UPDATE taskb_out 
set totSOP= 0 where totSOP is null;
UPDATE taskb_out 
set totHRP= 0 where totHRP is null;
UPDATE taskb_out 
set totGF= 0 where totGF is null;
update taska_out
set totA= 0 where totA is null;
UPDATE taskb_out 
set totPO= 0 where totPO is null;
UPDATE taskb_out 
set totE= 0 where totE is null;
UPDATE taskb_out 
set totDP= 0 where totDP is null;
UPDATE taskb_out 
set totCS= 0 where totCS is null;
UPDATE taskb_out 
set totInnOuts= 0 where totInnOuts is null;
UPDATE taskb_out 
set totSB= 0 where totSB is null;
UPDATE taskb_out 
set Years_Fielded = 0 where Years_Fielded is null;
UPDATE taskb_out 
set debut= 0 where debut is null;
UPDATE taskb_out 
set finalGame= 0 where finalGame is null;
UPDATE taskb_out 
set deathYear= 0 where deathYear is null;

-- Extracting csv files for Task 1 and Task 2 respectively. Had to extract the csv code through virtual machine because of file priledge problems
-- For Task A: mysql -B -h manta.uwaterloo.ca -u user_mm4siddi -p ece356db_mm4siddi -e "select * from taska_out" | sed 's/\t/,/g' > task1_extracted.csv
-- For Task A: mysql -B -h manta.uwaterloo.ca -u user_mm4siddi -p ece356db_mm4siddi -e "select * from taskb_out" | sed 's/\t/,/g' > task2_extracted.csv

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
