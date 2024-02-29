USE magist;


SELECT 
    *
FROM
    magist.order_reviews;


-- distribution of reviews
SELECT 
    review_score, COUNT(review_score) AS number_of_scores
FROM
    order_reviews
GROUP BY review_score
ORDER BY review_score DESC;
    
    
-- time of response on review
SELECT 
    review_score,
    review_creation_date,
    review_answer_timestamp,
    TIMESTAMPDIFF(DAY,
        review_creation_date,
        review_answer_timestamp) AS response_duration_days
FROM
    order_reviews;


-- average score by response time

SELECT 
    TIMESTAMPDIFF(DAY,
        review_creation_date,
        review_answer_timestamp) AS response_duration_days,
    AVG(review_score) AS average_review_score,
    COUNT(*) AS review_count
FROM
    order_reviews
WHERE
    review_answer_timestamp IS NOT NULL
GROUP BY response_duration_days
ORDER BY response_duration_days;
    
    
    -- clustered by cases of response time
SELECT 
    CASE
        WHEN response_duration_days = 0 THEN 'super fast'
        WHEN response_duration_days BETWEEN 1 AND 2 THEN 'fast'
        WHEN response_duration_days BETWEEN 3 AND 5 THEN 'ok'
        WHEN response_duration_days > 5 THEN 'long'
        ELSE 'unknown'
    END AS response_duration_category,
    AVG(review_score) AS average_review_score,
    COUNT(*) AS review_count
FROM
    (SELECT 
        TIMESTAMPDIFF(DAY, review_creation_date, review_answer_timestamp) AS response_duration_days,
            review_score
    FROM
        order_reviews
    WHERE
        review_answer_timestamp IS NOT NULL) AS subquery
GROUP BY response_duration_category
ORDER BY average_review_score DESC;
    
  
  -- average response time by score
  
SELECT 
    review_score,
    AVG(TIMESTAMPDIFF(HOUR,
        review_creation_date,
        review_answer_timestamp)) AS average_response_h,
    COUNT(*) AS review_count
FROM
    order_reviews
WHERE
    review_answer_timestamp IS NOT NULL
GROUP BY review_score
ORDER BY review_score DESC;

