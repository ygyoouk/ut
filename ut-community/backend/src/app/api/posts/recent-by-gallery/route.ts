import { NextResponse } from 'next/server';
import { supabase } from '@/lib/supabaseClient';

// RPC 함수가 반환하는 객체의 타입을 정의합니다.
interface RecentPost {
  id: string;
  title: string;
  created_at: string;
  gallery_id: string;
  gallery_name: string;
  author_name: string;
}

// reduce의 accumulator 타입을 정의합니다.
type GalleryGroup = {
  [key: string]: {
    gallery_id: string;
    gallery_name: string;
    posts: {
      id: string;
      title: string;
      created_at: string;
      author_name: string;
    }[];
  };
};

export async function GET() {
  // 1. RPC를 통해 데이터베이스 함수 호출
  const { data: posts, error } = await supabase.rpc('get_recent_posts_by_gallery');

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  if (!posts) {
    return NextResponse.json([]);
  }

  // 2. 가져온 데이터를 갤러리별로 그룹화 (타입을 명시적으로 지정)
  const postsByGallery = (posts as RecentPost[]).reduce((acc: GalleryGroup, post: RecentPost) => {
    const galleryId = post.gallery_id;
    // acc에 해당 gallery_id가 없으면 초기화
    if (!acc[galleryId]) {
      acc[galleryId] = {
        gallery_id: galleryId,
        gallery_name: post.gallery_name,
        posts: [],
      };
    }
    // 해당 갤러리에 게시물 추가
    acc[galleryId].posts.push({
      id: post.id,
      title: post.title,
      created_at: post.created_at,
      author_name: post.author_name,
    });
    return acc;
  }, {} as GalleryGroup);

  // 3. 객체를 배열로 변환하여 최종 결과 반환
  const result = Object.values(postsByGallery);

  return NextResponse.json(result);
}