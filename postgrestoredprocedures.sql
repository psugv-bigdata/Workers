-- ===========================================================================================
-- connect with twitter
-- DROP TABLE IF EXISTS tweetmetas;
-- DROP TABLE IF EXISTS tweets;
-- DROP TABLE IF EXISTS topics;
-- DROP TABLE IF EXISTS cleantext; *** avoid deleting this one!!!!!!!
-- ===========================================================================================
-- create tables
-- -------------------------------------------------------------------------------------------
CREATE TABLE topics (
	 topic text
	,category text
	,searchterm text
	,CONSTRAINT twitter_tppk1 PRIMARY KEY (topic,category)  
);

-- -------------------------------------------------------------------------------------------
CREATE TABLE tweets (
	 id bigint 
	,creator text
	,createdat timestamp
	,rawtweet json
	,CONSTRAINT twitter_twpk1 PRIMARY KEY (id) 
);
-- -------------------------------------------------------------------------------------------
CREATE TABLE tweetmetas (  
	 topic text
	,category text
	,tweetid bigint
	,lexcategory text
	,relevance double precision
	,sentiment text
	,sentiment_value double precision
	,CONSTRAINT twitter_tmpk1 PRIMARY KEY (topic,category,tweetid,lexcategory)
	,CONSTRAINT twitter_tmfk1 FOREIGN KEY (tweetid) REFERENCES public.tweets (id) 
);
-- -------------------------------------------------------------------------------------------
CREATE TABLE cleantext (
	 pattern text
	,replacement text
	,CONSTRAINT twitter_ctpk1 PRIMARY KEY (pattern,replacement)
);
-- ===========================================================================================
-- process data
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION process_topics(_topic text,_category text,_searchterm text = NULL)
      RETURNS void AS 
      $BODY$
        BEGIN
		IF _searchterm IS NULL THEN
			DELETE FROM topics WHERE  category = _category AND topic = _topic;
		ELSIF (SELECT count(*) FROM topics WHERE category = _category AND topic = _topic) > 0 THEN
			UPDATE	topics
			SET 	searchterm =_searchterm
			WHERE 	category = _category AND topic = _topic;
		ELSE
			INSERT INTO topics(topic, category, searchterm)		
			VALUES (_topic, _category, _searchterm);
		END IF;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from process_topics('bla','blabla','blablabla');
SELECT * from process_topics('bla','blabla','blablabla1');
SELECT * from process_topics('bla','blabla');
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION process_tweets(_id bigint,_creator text = NULL,_createdat timestamp = NULL,_rawtweet json = NULL)
      RETURNS void AS
      $BODY$
          BEGIN
		IF _rawtweet IS NULL THEN
			DELETE FROM tweets WHERE  id = _id;
		ELSIF (SELECT count(*) FROM tweets WHERE id = _id) > 0 THEN
			UPDATE	tweets
			SET 	 creator = _creator
				,createdat = _createdat
				,rawtweet = _rawtweet
			WHERE 	id = _id;
		ELSE
			INSERT INTO tweets(id,creator,createdat,rawtweet)
			VALUES (_id,_creator,_createdat,_rawtweet);
		END IF;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from process_tweets(112,'blabla1',TIMESTAMP '2011-05-16 15:36:38','{ "customer": "Joe Smoe", "items": {"product": "Beer","qty": 6}}');
SELECT * from process_tweets(112,'blabla2',TIMESTAMP '2011-05-17 15:36:38','{ "customer": "Joe Smoe", "items": {"product": "Beer","qty": 6}}');
SELECT * from process_tweets(112);
-- -------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION process_tweetmetas(_topic text,_category text,_tweetid bigint,_lexcategory text,_relevance double precision = NULL,_sentiment text = NULL,_sentiment_value double precision = NULL)
      RETURNS void AS
      $BODY$
          BEGIN
		IF _sentiment IS NULL THEN
			DELETE FROM tweetmetas WHERE topic=_topic AND category=_category AND tweetid=_tweetid AND lexcategory=_lexcategory;
		ELSIF (SELECT count(*) FROM tweetmetas WHERE topic=_topic AND category=_category AND tweetid=_tweetid AND lexcategory=_lexcategory) > 0 THEN
			UPDATE	tweetmetas
			SET 	 relevance	= _relevance
				,sentiment	= _sentiment
				,sentiment_value	= _sentiment_value
			WHERE 	topic=_topic AND category=_category AND tweetid=_tweetid AND lexcategory=_lexcategory;
		ELSE
			INSERT INTO tweetmetas(topic,category,tweetid,lexcategory,relevance,sentiment,sentiment_value)
			VALUES (_topic,_category,_tweetid,_lexcategory,_relevance,_sentiment,_sentiment_value);
		END IF;
          END;
      $BODY$
      LANGUAGE 'plpgsql' VOLATILE
      COST 100;
SELECT * from process_tweets(112,'creator',TIMESTAMP '2011-05-16 15:36:38','{ "customer": "Joe Smoe", "items": {"product": "Beer","qty": 6}}');
SELECT * from process_tweetmetas('topic1','cat1',112,'social',0.5,'Positive',3.5);
SELECT * from process_tweetmetas('topic1','cat1',112,'social',0.6,'Negative',1.5);
SELECT * from process_tweetmetas('topic1','cat1',112,'social');
-- ===========================================================================================
