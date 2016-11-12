-- ===========================================================================================
-- connect with twitter
-- ===========================================================================================
-- create tables
-- -------------------------------------------------------------------------------------------
CREATE TABLE topics (
	 id serial
	,topic text
	,category text
	,searchterm text
	,CONSTRAINT toppk PRIMARY KEY (id)  
);

-- -------------------------------------------------------------------------------------------
CREATE TABLE tweets (
	 id serial 
	,topicid integer
	,creator text
	,createdat timestamp
	,rawtweet json
	,CONSTRAINT tspk PRIMARY KEY (id) 
	,CONSTRAINT tsfk FOREIGN KEY (topicid) REFERENCES public.topics(id) 
);
-- -------------------------------------------------------------------------------------------
CREATE TABLE twitterdata (  
	 id serial 
	,lexcategory text
	,relevance double precision
	,sentiment text
	,tweetid integer
	,CONSTRAINT twpk PRIMARY KEY (id)
	,CONSTRAINT twfk FOREIGN KEY (tweetid ) REFERENCES public.tweets (id) 
);
-- ===========================================================================================
-- insert data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_into_topics(_topic text,_category text,_searchterm text)
      RETURNS integer AS 
      $BODY$
	  DECLARE
		newid integer;
          BEGIN
		INSERT INTO topics(topic, category, searchterm)		
		VALUES (_topic, _category, _searchterm) RETURNING id INTO newid;
		RETURN newid;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from insert_into_topics('bla','blabla','blablabla');
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_into_tweets(_topicid integer,_creator text,_createdat timestamp,_rawtweet json)
      RETURNS integer AS
      $BODY$
	  DECLARE
		newid integer;
          BEGIN
		INSERT INTO tweets(topicid, creator, createdat, rawtweet)
		VALUES (_topicid, _creator, _createdat, _rawtweet) RETURNING id INTO newid;
		RETURN newid;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from insert_into_tweets(14,'blabla1',TIMESTAMP '2011-05-16 15:36:38','{ "customer": "Joe Smoe", "items": {"product": "Beer","qty": 6}}');
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_into_twitterdata(_lexcategory text,_relevance double precision,_sentiment text,_tweetid integer)
      RETURNS integer AS
      $BODY$
	  DECLARE
		newid integer;
          BEGIN
		INSERT INTO twitterdata(lexcategory, relevance, sentiment, tweetid)
		VALUES (_lexcategory, _relevance, _sentiment, _tweetid) RETURNING id INTO newid;
		RETURN newid;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from insert_into_twitterdata('bla12',0.5,'superduper',2);
-- ===========================================================================================
-- replace data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_topics(_id integer,_topic text,_category text,_searchterm text)
	RETURNS void AS
	$BODY$
	    BEGIN
		UPDATE public.topics
		SET 
			topic	= _topic, 
			category= _category, 
			searchterm =_searchterm
		WHERE 	id = _id;
	   END
	$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
select * from update_topics((SELECT id from topics limit 1),'fufu','gugu','lulu');
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_tweets(_id integer,_topicid integer,_creator text,_createdat timestamp,_rawtweet json)
      RETURNS void AS
      $BODY$
          BEGIN
		UPDATE tweets
		SET
			topicid = _topicid, 
			creator = _creator, 
			createdat = _createdat, 
			rawtweet = _rawtweet
		WHERE 	id = _id;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
select * from update_tweets((SELECT id from tweets limit 1),(SELECT id from topics limit 1),'blabla1',TIMESTAMP '2011-06-16 15:36:38','{ "customers": "Joe Smoex", "items": {"product": "Beer","qty": 6}}');
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_twitterdata(_id integer,_lexcategory text,_relevance double precision,_sentiment text,_tweetid integer)
      RETURNS void AS
      $BODY$
          BEGIN
		UPDATE twitterdata
		SET
			lexcategory = _lexcategory, 
			relevance = _relevance, 
			sentiment = _sentiment, 
			tweetid = _tweetid
		WHERE 	id = _id;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
select * from update_twitterdata((SELECT id from twitterdata limit 1),'mumu',0.7,'great',(SELECT id from tweets limit 1));
-- ===========================================================================================
-- drop data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_twitterdata(_id integer)
	RETURNS void AS
	$BODY$
	    BEGIN
		DELETE FROM twitterdata
		WHERE id = _id;
	   END
	$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
select * from delete_twitterdata((SELECT id from twitterdata limit 1));
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_tweets(_id integer)
	RETURNS void AS
	$BODY$
	    BEGIN
		DELETE FROM tweets
		WHERE id = _id;
	   END
	$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
select * from delete_tweets((SELECT id from tweets limit 1));
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_topics(_id integer)
	RETURNS void AS
	$BODY$
	    BEGIN
		DELETE FROM topics
		WHERE id = _id;
	   END
	$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
select * from delete_topics((SELECT id from topics limit 1));
-- ===========================================================================================
