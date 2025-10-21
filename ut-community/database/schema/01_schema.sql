-- 사용자 테이블
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE NOT NULL,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 갤러리(게시판) 테이블
CREATE TABLE galleries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 게시글 테이블
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gallery_id UUID REFERENCES galleries(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT,
  view_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 댓글 테이블
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE, -- 대댓글 기능
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 게시글 추천/비추천 테이블
CREATE TABLE post_votes (
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vote_type INT NOT NULL CHECK (vote_type IN (1, -1)), -- 1: 추천, -1: 비추천
  PRIMARY KEY (post_id, user_id) -- 사용자는 게시글 하나에 한 번만 투표 가능
);

-- 댓글 추천/비추천 테이블
CREATE TABLE comment_votes (
  comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vote_type INT NOT NULL CHECK (vote_type IN (1, -1)), -- 1: 추천, -1: 비추천
  PRIMARY KEY (comment_id, user_id) -- 사용자는 댓글 하나에 한 번만 투표 가능
);