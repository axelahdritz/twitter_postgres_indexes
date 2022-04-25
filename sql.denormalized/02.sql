SELECT 
    '#' || jnd.tag as tag,
    count(*)
FROM (
    SELECT DISTINCT
        data ->>'id' as id_tweets,
        jsonb_array_elements(data->'entities'->'hashtags')->>'text' as tag
        FROM tweets_jsonb
        WHERE data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
     UNION
     SELECT DISTINCT
        data ->>'id' as id_tweets,
        jsonb_array_elements(data->'extended_tweet'->'entities'->'hashtags')->>'text' as tag
        FROM tweets_jsonb
        WHERE data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    ) jnd
GROUP by jnd.tag
ORDER BY count DESC, jnd.tag
LIMIT 1000;
