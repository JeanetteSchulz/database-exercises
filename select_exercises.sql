-- Use the albums_db database
USE albums_db;

-- Explore the structure of the albums table.
Describe albums;

-- a. How many rows are in the albums table? 31, also can be seen in 'Table Information' in lower left
SELECT COUNT(*) FROM albums;

-- b. How many unique artist names are in the albums table? 23
SELECT DISTINCT artist FROM albums; 

-- c. What is the primary key for the albums table? id
SHOW KEYS FROM albums WHERE Key_name = 'PRIMARY';

-- d. What is the oldest release date for any album in the albums table? What is the most recent release date?
	-- Looks like the oldest is Sgt. Pepper's Lonely Hearts Club Band by The Beatles in 1967
	-- The most recent release date is 21 by Adele in 2011
SELECT 	release_date, name, artist
FROM albums
ORDER BY release_date;

-- Write queries to find the following information:

-- a. The name of all albums by Pink Floyd
SELECT DISTINCT artist, name
FROM albums
WHERE artist ='Pink Floyd';

-- b. The year Sgt. Pepper's Lonely Hearts Club Band was released
SELECT release_date
FROM albums
WHERE name= "Sgt. Pepper's Lonely Hearts Club Band";

-- c. The genre for the album Nevermind
SELECT genre
FROM albums
WHERE name = 'Nevermind';

-- d. Which albums were released in the 1990s
SELECT name
FROM albums
WHERE release_date = 1990;

-- e. Which albums had less than 20 million certified sales
SELECT name
FROM albums
WHERE sales < 20 ;

-- f. All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"? If you use equals, it will look for only rock. To find the substring, use LIKE
SELECT name, genre
FROM albums
WHERE genre LIKE "%rock%";
