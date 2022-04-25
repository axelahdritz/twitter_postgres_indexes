SELECT
    '#' || jnd.tag as tag,
    count(*)
FROM (
    SELECT DISTINCT
        data ->>'id' as id_tweets,
        jsonb_array_elements(data->'entities'->'hashtags')->>'text' as tag
        FROM tweets_jsonb
        WHERE to_tsvector('english',data->>'text')@@to_tsquery('english','coronavirus')
        AND data->>'lang'='en'
     UNION
     SELECT DISTINCT
        data ->>'id' as id_tweets,
        jsonb_array_elements(data->'extended_tweet'->'entities'->'hashtags')->>'text' as tag
        FROM tweets_jsonb
        WHERE to_tsvector('english',data->'extended_tweet'->>'full_text')@@to_tsquery('english','coronavirus')
        AND data ->>'lang'='en'
    ) jnd
GROUP by jnd.tag 
ORDER BY count DESC, jnd.tag
LIMIT 1000;
