--------------------LAB-1
-- Create Tables
CREATE TABLE Artists (
    Artist_id INT PRIMARY KEY,
    Artist_name VARCHAR(50)
);

CREATE TABLE Albums (
    Album_id INT PRIMARY KEY,
    Album_title VARCHAR(50),
    Artist_id INT,
    Release_year INT,
    FOREIGN KEY (Artist_id) REFERENCES Artists(Artist_id)
);

CREATE TABLE Songs (
    Song_id INT PRIMARY KEY,
    Song_title VARCHAR(50),
    Duration DECIMAL(4, 2),
    Genre VARCHAR(50),
    Album_id INT,
    FOREIGN KEY (Album_id) REFERENCES Albums(Album_id)
);

-- Insert Data into Artists Table
INSERT INTO Artists (Artist_id, Artist_name) VALUES
(1, 'Aparshakti Khurana'),
(2, 'Ed Sheeran'),
(3, 'Shreya Ghoshal'),
(4, 'Arijit Singh'),
(5, 'Tanishk Bagchi');

-- Insert Data into Albums Table
INSERT INTO Albums (Album_id, Album_title, Artist_id, Release_year) VALUES
(1001, 'Album1', 1, 2019),
(1002, 'Album2', 2, 2015),
(1003, 'Album3', 3, 2018),
(1004, 'Album4', 4, 2020),
(1005, 'Album5', 2, 2020),
(1006, 'Album6', 1, 2009);

-- Insert Data into Songs Table
INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id) VALUES
(101, 'Zaroor', 2.55, 'Feel good', 1001),
(102, 'Espresso', 4.10, 'Rhythmic', 1002),
(103, 'Shayad', 3.20, 'Sad', 1003),
(104, 'Roar', 4.05, 'Pop', 1002),
(105, 'Everybody Talks', 3.35, 'Rhythmic', 1003),
(106, 'Dwapara', 3.54, 'Dance', 1002),
(107, 'Sa Re Ga Ma', 4.20, 'Rhythmic', 1004),
(108, 'Tauba', 4.05, 'Rhythmic', 1005),
(109, 'Perfect', 4.23, 'Pop', 1002),
(110, 'Good Luck', 3.55, 'Rhythmic', 1004);

SELECT *From Albums
SELECT *From Artists
SELECT *From Songs

--Part-A
-- 1. Retrieve a unique genre of songs.
SELECT DISTINCT Genre FROM Songs;

-- 2. Find top 2 albums released before 2010.
SELECT TOP 2 Album_title, Release_year
FROM Albums
WHERE Release_year < 2010;

-- 3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)
INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id)
VALUES (1245, 'Zaroor', 2.55, 'Feel good', 1005);

-- 4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
UPDATE Songs
SET Genre = 'Happy'
WHERE Song_title = 'Zaroor';

-- 5. Delete an Artist ‘Ed Sheeran’
DELETE FROM Artists
WHERE Artist_name = 'Ed Sheeran';

-- 6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]
ALTER TABLE Songs
ADD Rating DECIMAL(3, 2);

-- 7. Retrieve songs whose title starts with 'S'.
SELECT * FROM Songs
WHERE Song_title LIKE 'S%';

-- 8. Retrieve all songs whose title contains 'Everybody'.
SELECT * FROM Songs
WHERE Song_title LIKE '%Everybody%';

-- 9. Display Artist Name in Uppercase.
SELECT UPPER(Artist_name) AS Artist_Name_Uppercase
FROM Artists;

-- 10. Find the Square Root of the Duration of a Song ‘Good Luck’
SELECT Song_title, SQRT(Duration) AS Duration_SquareRoot
FROM Songs
WHERE Song_title = 'Good Luck';

-- 11. Find Current Date.
SELECT GETDATE() AS CurrentDate;

-- 12. Retrieve the total duration of songs by each artist where total duration exceeds 100 minutes.
SELECT AL.Artist_id, SUM(S.Duration) AS Total_Duration
FROM Songs S
Left JOIN Albums AL ON S.Album_id = AL.Album_id
GROUP BY AL.Artist_id
HAVING SUM(S.Duration) > 100;

-- 13. Find the number of albums for each artist.
SELECT Artist_id, COUNT(Album_id) AS Album_Count
FROM Albums
GROUP BY Artist_id;

-- 14. Retrieve the Album_id which has more than 5 songs in it.
SELECT Album_id
FROM Songs
GROUP BY Album_id
HAVING COUNT(Song_id) > 5;

-- 15. Retrieve all songs from the album 'Album1'. (using Subquery)
SELECT * FROM Songs
WHERE Album_id = (SELECT Album_id FROM Albums WHERE Album_title = 'Album1');

-- 16. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
SELECT Album_title FROM Albums
WHERE Artist_id = (SELECT Artist_id FROM Artists WHERE Artist_name = 'Aparshakti Khurana');

-- 17. Find all the songs which are released in 2020.
SELECT S.*
FROM Songs S
JOIN Albums AL ON S.Album_id = AL.Album_id
WHERE AL.Release_year = 2020;

-- 18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
CREATE VIEW Fav_Songs AS
SELECT * FROM Songs
WHERE Song_id BETWEEN 101 AND 105;

-- 19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
UPDATE Fav_Songs
SET Song_title = 'Jannat'
WHERE Song_id = 101;

-- 20. Find all artists who have released an album in 2020. (using Joins)
SELECT DISTINCT A.Artist_name
FROM Artists A
JOIN Albums AL ON A.Artist_id = AL.Artist_id
WHERE AL.Release_year = 2020;

-- 21. Retrieve all songs by 'Artist1' and order them by duration. (using Joins)
SELECT S.*
FROM Songs S
Left JOIN Albums AL ON S.Album_id = AL.Album_id
Left JOIN Artists A ON AL.Artist_id = A.Artist_id
WHERE A.Artist_name='Arijit Singh'
ORDER BY S.Duration;

-- 22. Retrieve all song titles by artists who have more than one album. (using Joins)
SELECT S.Song_title
FROM Songs S
JOIN Albums AL ON S.Album_id = AL.Album_id
JOIN Artists A ON AL.Artist_id = A.Artist_id
WHERE A.Artist_id IN (
    SELECT Artist_id
    FROM Albums
    GROUP BY Artist_id
    HAVING COUNT(Album_id) > 1
);

--Part-B

-- 23. Retrieve all albums along with the total number of songs. (using Joins)
SELECT AL.Album_title, COUNT(S.Song_id) AS Total_Songs
FROM Albums AL
LEFT JOIN Songs S 
ON AL.Album_id = S.Album_id
GROUP BY AL.Album_title;

-- 24. Retrieve all songs and release year and sort them by release year. (using Joins)
SELECT S.Song_title, AL.Release_year
FROM Songs S
JOIN Albums AL 
ON S.Album_id = AL.Album_id
ORDER BY AL.Release_year;

-- 26. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
SELECT Genre, COUNT(Song_id) AS Song_Count
FROM Songs
GROUP BY Genre
HAVING COUNT(Song_id) > 2;

-- 27. List all artists who have albums that contain more than 3 songs.
SELECT A.Artist_name
FROM Artists A
JOIN Albums AL ON A.Artist_id = AL.Artist_id
JOIN Songs S ON AL.Album_id = S.Album_id
GROUP BY A.Artist_name, AL.Album_id
HAVING COUNT(S.Song_id) > 3;

--Part-C
-- 28. Retrieve albums that have been released in the same year as 'Album2'
SELECT AL2.Album_title
FROM Albums AL1
JOIN Albums AL2 
ON AL1.Release_year = AL2.Release_year
WHERE AL1.Album_title = 'Album4' AND AL1.Album_id <> AL2.Album_id;

-- 29. Find the longest song in each genre
SELECT Genre, MAX(Duration) AS Longest_Duration
FROM Songs
GROUP BY Genre;

-- 30. Retrieve the titles of songs released in albums that contain the word 'Album' in the title
SELECT S.Song_title
FROM Songs S
JOIN Albums AL ON S.Album_id = AL.Album_id
WHERE AL.Album_title LIKE '%Album%';
