CREATE OR REPLACE FUNCTION get_recent_posts_by_gallery()
RETURNS TABLE (
  id UUID,
  title TEXT,
  created_at TIMESTAMPTZ,
  gallery_id UUID,
  gallery_name TEXT,
  author_name TEXT
)
AS $$
BEGIN
  RETURN QUERY
  WITH ranked_posts AS (
    SELECT
      p.id,
      p.title,
      p.created_at,
      p.gallery_id,
      g.name as gallery_name,
      u.username as author_name,
      ROW_NUMBER() OVER(PARTITION BY p.gallery_id ORDER BY p.created_at DESC) as rn
    FROM
      posts p
    JOIN
      galleries g ON p.gallery_id = g.id
    JOIN
      users u ON p.user_id = u.id
  )
  SELECT
    ranked_posts.id,
    ranked_posts.title,
    ranked_posts.created_at,
    ranked_posts.gallery_id,
    ranked_posts.gallery_name,
    ranked_posts.author_name
  FROM ranked_posts
  WHERE rn <= 5;
END;
$$ LANGUAGE plpgsql;
