use Spotify;

select * from data;

select *
from data
where Duration_min = 0;

select distinct Channel from data;

-- Retrive the names of all tracks that have more than one billion streams

select *
  from data 
where Stream > 1000000000;

-- List all albums along with their respective artist

select 
   Distinct Album,Artist
from data;

-- Get the total number of comments for tracks where licensed = TRUE

select sum(Comments) as "Total_Comments"
  from data
where Licensed = 'TRUE';

-- Find all tracks that belong to the album type sinngle
select 
 Track
from data
 where Album_type = 'Single';

-- count total number of tracks by each artist
select Artist,
  count(Track) as "Total_tracks"
from data
  group by Artist
  order by Total_tracks desc;
  

-- Calculate the average danceability of tracks in each album
select  album,
  avg(Danceability) as "Average_Danceability"
from data
  group by album;

-- find top 5 tracks with the highest energy values
select 
    avg(Energy) as "Highest_energy",
    Track
from data
  group by Track
  order by 1 desc
  limit 5;

-- List all tracks along with their view and likes where official_video = TRUE.
select 
    Track,
	avg(Views) as "Total_Views",
	avg(Likes) as "Total_Likes"
from data
   where official_video = 'TRUE'
   group by 1;
   
-- for each album , Calculate the total views of all associated tracks
select
  album,
  Track,
  sum(views) as "Total_Views"
from data
group by 1,2;

-- Retrive the track names that have been streamed on Spotify more than Youtube
select Track,Streamed_on_Spotify from 
(select 
   Track,
   coalesce(sum(Case When most_playedon = "Spotify" Then stream End),0) as "Streamed_on_Spotify",
   coalesce(sum(Case When most_playedon = "Youtube" Then stream End),0) as "Streamed_on_Youtube"
from data
group by 1) as t1
where Streamed_on_Spotify>streamed_on_Youtube;
-- AND 
-- streamed_on_Youtube != 0;


-- Find the top 3 most-viewed tracks for each artist using window function
with ranking_artist
AS
(select 
    artist,
    track,
    sum(Views) as "Total_views", 
    dense_rank() over (partition by artist order by sum(Views) DESC) as "ranks"
from data
group by 1,2
order by 1,3 DESC)

select *
from ranking_artist 
where ranks <=3;

-- write a query to find the tracks where the liveness score is above the average
select 
  artist,
  Track,
  Liveness
from data
where Liveness>(select avg(Liveness) from data);

-- Use a with clause to calculate the difference between the highest and lowest energy values for tracks in each album

with cte
AS
(select
    album,
    max(energy) as "Highest_Energy",
    min(energy) as "Lowest_Energy"
from data
group by 1)

select 
  album,
  (Highest_Energy-Lowest_Energy) as "energy_diff"
from cte;


select * from data;

-- Second Most Streamed Track per Artist
select 
 stream,Artist,Track
From(
select 
     Artist,
     Stream,
     Track,
rank() over(partition by Artist order by Stream DESC) as Track_rank
from data) ranked
where Track_rank = 2
order by 1,2,3
limit 1;

