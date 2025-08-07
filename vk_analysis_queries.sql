USE vk_analysis;

-- Анализ зависимости от времени суток (час публикации)
SELECT
    HOUR(post_date) AS publication_hour,
    ROUND(AVG(likes_count), 2) AS avg_likes
FROM
    posts
GROUP BY
    publication_hour
ORDER BY
    avg_likes DESC;


-- Анализ зависимости от дня недели
SELECT
    DAYNAME(post_date) AS day_of_week,
    ROUND(AVG(likes_count), 2) AS avg_likes
FROM
    posts
GROUP BY
    day_of_week, DAYOFWEEK(post_date)
ORDER BY
    DAYOFWEEK(post_date);


-- Анализ зависимости от интервала между постами
WITH posts_with_lag AS (
    SELECT
        post_date,
        likes_count,
        LAG(post_date, 1) OVER (ORDER BY post_date) AS previous_post_date
    FROM
        posts
)
SELECT
    CASE
        WHEN DATEDIFF(post_date, previous_post_date) < 1 THEN 'Менее 1 дня'
        WHEN DATEDIFF(post_date, previous_post_date) BETWEEN 1 AND 3 THEN 'От 1 до 3 дней'
        WHEN DATEDIFF(post_date, previous_post_date) > 3 THEN 'Более 3 дней'
        ELSE 'Первый пост'
    END AS posting_frequency,
    ROUND(AVG(likes_count), 2) AS avg_likes
FROM
    posts_with_lag
GROUP BY
    posting_frequency
ORDER BY
    avg_likes DESC;