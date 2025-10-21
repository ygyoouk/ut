-- 경고: 아래 정책들은 개발 초기 단계를 위해 모든 권한을 허용하도록 설정되어 있습니다.
-- 실제 프로덕션 환경에서는 반드시 로그인 기능과 연동하여 보안을 강화해야 합니다.

-- RLS(Row Level Security) 활성화
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE galleries ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comment_votes ENABLE ROW LEVEL SECURITY;

-- users 테이블 정책
DROP POLICY IF EXISTS "Allow public access to users" ON users;
CREATE POLICY "Allow public access to users" ON users FOR ALL USING (true) WITH CHECK (true);

-- galleries 테이블 정책
DROP POLICY IF EXISTS "Allow public access to galleries" ON galleries;
CREATE POLICY "Allow public access to galleries" ON galleries FOR ALL USING (true) WITH CHECK (true);

-- posts 테이블 정책
DROP POLICY IF EXISTS "Allow public access to posts" ON posts;
CREATE POLICY "Allow public access to posts" ON posts FOR ALL USING (true) WITH CHECK (true);

-- comments 테이블 정책
DROP POLICY IF EXISTS "Allow public access to comments" ON comments;
CREATE POLICY "Allow public access to comments" ON comments FOR ALL USING (true) WITH CHECK (true);

-- post_votes 테이블 정책
DROP POLICY IF EXISTS "Allow public access to post_votes" ON post_votes;
CREATE POLICY "Allow public access to post_votes" ON post_votes FOR ALL USING (true) WITH CHECK (true);

-- comment_votes 테이블 정책
DROP POLICY IF EXISTS "Allow public access to comment_votes" ON comment_votes;
CREATE POLICY "Allow public access to comment_votes" ON comment_votes FOR ALL USING (true) WITH CHECK (true);
