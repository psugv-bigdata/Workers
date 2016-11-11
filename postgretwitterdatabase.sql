-- run this as a different user ftom "twitter"
-- one needs to disconnect from the database "twitter"

DROP DATABASE IF EXISTS twitter;
DROP USER IF EXISTS twitter;

CREATE USER twitter WITH PASSWORD 'twitter';
CREATE DATABASE twitter OWNER twitter;
    
DROP TABLE IF EXISTS twitterdata;
DROP TABLE IF EXISTS tweets;
DROP TABLE IF EXISTS topics;

-- change the password after you finish
-- re-connect with twitter

CREATE TABLE topics (
	 id serial
	,topic text
	,category text
	,searchterm text
	,CONSTRAINT toppk PRIMARY KEY (id)  
);
CREATE TABLE tweets (
	 id serial 
	,topicid integer
	,creator text
	,createdat timestamp
	,rawtweet json
	,CONSTRAINT tspk PRIMARY KEY (id) 
	,CONSTRAINT tsfk FOREIGN KEY (topicid) REFERENCES public.topics(id) 
);
CREATE TABLE twitterdata (  
	 id serial 
	,lexcategory text
	,relevance double precision
	,sentiment text
	,tweetid integer
	,CONSTRAINT twpk PRIMARY KEY (id)
	,CONSTRAINT twfk FOREIGN KEY (tweetid ) REFERENCES public.tweets (id) 
);
