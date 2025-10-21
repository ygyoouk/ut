-- 기존 데이터 삭제 (선택 사항, 스크립트를 여러 번 실행할 경우)
-- TRUNCATE TABLE users, galleries, posts, comments, post_votes, comment_votes RESTART IDENTITY CASCADE;

-- 샘플 사용자 3명 생성
INSERT INTO users (email, username) VALUES
  ('user1@example.com', '유저1'),
  ('user2@example.com', '유저2'),
  ('user3@example.com', '유저3')
ON CONFLICT (email) DO NOTHING;

-- 갤러리 삽입 (중복 시 무시)
INSERT INTO galleries (name, description) VALUES
  ('자유게시판', '자유롭게 이야기를 나누는 공간입니다.'),
  ('유머게시판', '재미있는 유머와 밈을 공유하는 공간입니다.'),
  ('Q&A', '궁금한 것을 물어보고 답변하는 공간입니다.')
ON CONFLICT (name) DO NOTHING;

-- 게시글 10개 삽입
INSERT INTO posts (gallery_id, user_id, title, content)
SELECT
  (SELECT id FROM galleries ORDER BY random() LIMIT 1),
  (SELECT id FROM users ORDER BY random() LIMIT 1),
  '샘플 제목 ' || i,
  '샘플 내용입니다. ' || i
FROM generate_series(1, 10) AS i;

-- 댓글 10개 삽입
INSERT INTO comments (post_id, user_id, content)
SELECT
  (SELECT id FROM posts ORDER BY random() LIMIT 1),
  (SELECT id FROM users ORDER BY random() LIMIT 1),
  '샘플 댓글 내용입니다. ' || i
FROM generate_series(1, 10) AS i;

-- 게시글 투표 10개 삽입 (중복 시 무시)
INSERT INTO post_votes (post_id, user_id, vote_type)
SELECT
  (SELECT id FROM posts ORDER BY random() LIMIT 1),
  (SELECT id FROM users ORDER BY random() LIMIT 1),
  (CASE WHEN random() > 0.5 THEN 1 ELSE -1 END)
FROM generate_series(1, 10) AS i
ON CONFLICT (post_id, user_id) DO NOTHING;

-- 댓글 투표 10개 삽입 (중복 시 무시)
INSERT INTO comment_votes (comment_id, user_id, vote_type)
SELECT
  (SELECT id FROM comments ORDER BY random() LIMIT 1),
  (SELECT id FROM users ORDER BY random() LIMIT 1),
  (CASE WHEN random() > 0.5 THEN 1 ELSE -1 END)
FROM generate_series(1, 10) AS i
ON CONFLICT (comment_id, user_id) DO NOTHING;
