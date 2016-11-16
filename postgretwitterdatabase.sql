-- run this as a different user ftom "twitter"
-- one needs to disconnect from the database "twitter"

DROP DATABASE IF EXISTS twitter;
DROP USER IF EXISTS twitter;

CREATE USER twitter WITH PASSWORD 'twitter';
CREATE DATABASE twitter OWNER twitter;

DROP TABLE IF EXISTS twitterdata;
DROP TABLE IF EXISTS tweetmetas;
DROP TABLE IF EXISTS tweets;
DROP TABLE IF EXISTS topics;

-- change the password after you finish
