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
	,database_name text
	,CONSTRAINT toppk PRIMARY KEY (id)  
);

-- -------------------------------------------------------------------------------------------
CREATE TABLE tweets (
	 id bigint 
	,topicid integer
	,creator text
	,createdat timestamp
	,rawtweet json
	,CONSTRAINT tspk PRIMARY KEY (id) 
	,CONSTRAINT tsfk FOREIGN KEY (topicid) REFERENCES public.topics(id) 
);
-- -------------------------------------------------------------------------------------------
CREATE TABLE tweetmetas (  
	 id serial 
	,lexcategory text
	,relevance double precision
	,sentiment text
	,sentiment_value double precision
	,tweetid bigint
	,CONSTRAINT twpk PRIMARY KEY (id)
	,CONSTRAINT twfk FOREIGN KEY (tweetid ) REFERENCES public.tweets (id) 
);
-- ===========================================================================================
-- insert data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_into_topics(_topic text,_category text,_searchterm text,_database_name text)
      RETURNS integer AS 
      $BODY$
	  DECLARE
		newid integer;
          BEGIN
		INSERT INTO topics(topic, category, searchterm,database_name)		
		VALUES (_topic, _category, _searchterm,_database_name) RETURNING id INTO newid;
		RETURN newid;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from insert_into_topics('bla','blabla','blablabla','postgre');
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_into_tweets(_id bigint,_topicid integer,_creator text,_createdat timestamp,_rawtweet json)
      RETURNS void AS
      $BODY$
          BEGIN
		INSERT INTO tweets(id,topicid, creator, createdat, rawtweet)
		VALUES (_id,_topicid,_creator,_createdat,_rawtweet);
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from insert_into_tweets(112,(SELECT id from topics limit 1),'blabla1',TIMESTAMP '2011-05-16 15:36:38','{ "customer": "Joe Smoe", "items": {"product": "Beer","qty": 6}}');
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_into_tweetmetas(_lexcategory text,_relevance double precision,_sentiment text,_sentiment_value double precision,_tweetid bigint)
      RETURNS integer AS
      $BODY$
	  DECLARE
		newid integer;
          BEGIN
		INSERT INTO tweetmetas(lexcategory, relevance, sentiment, sentiment_value,tweetid)
		VALUES (_lexcategory, _relevance, _sentiment, _sentiment_value,_tweetid) RETURNING id INTO newid;
		RETURN newid;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from insert_into_tweetmetas('bla12',0.5,'superduper',0.5,(SELECT id from tweets limit 1));
-- ===========================================================================================
-- replace data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_topics(_id integer,_topic text,_category text,_searchterm text,_database_name text)
	RETURNS void AS
	$BODY$
	    BEGIN
		UPDATE public.topics
		SET 
			  topic = _topic
			, category = _category
			, searchterm =_searchterm
			, database_name = _database_name
		WHERE 	id = _id;
	   END
	$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
select * from update_topics((SELECT id from topics limit 1),'fufu','gugu','lulu','mongo');
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_tweets(_id bigint,_topicid integer,_creator text,_createdat timestamp,_rawtweet json)
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
CREATE OR REPLACE FUNCTION update_tweetmetas(_id integer,_lexcategory text,_relevance double precision,_sentiment text,_sentiment_value double precision,_tweetid bigint)
      RETURNS void AS
      $BODY$
          BEGIN
		UPDATE tweetmetas
		SET
			  lexcategory = _lexcategory
			, relevance = _relevance
			, sentiment = _sentiment
			, sentiment_value = _sentiment_value
			, tweetid = _tweetid
		WHERE 	id = _id;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
select * from update_tweetmetas((SELECT id from tweetmetas limit 1),'mumu',0.7,'great',2.5,(SELECT id from tweets limit 1));
-- ===========================================================================================
-- drop data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_tweetmetas(_id integer)
	RETURNS void AS
	$BODY$
	    BEGIN
		DELETE FROM tweetmetas
		WHERE id = _id;
	   END
	$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
select * from delete_tweetmetas((SELECT id from tweetmetas limit 1));
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_tweets(_id bigint)
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
