
import { supabase } from '../../../lib/supabaseClient';
import { defineEventHandler, getMethod, readBody, setResponseStatus, getQuery } from 'h3';

export default defineEventHandler(async (event) => {
  const method = getMethod(event);
  const query = getQuery(event);
  const id = query.id;

  // Authentication logic
  const { data: { session }, error: sessionError } = await supabase.auth.getSessionFromCookie(event.node.req);

  if (sessionError || !session) {
    setResponseStatus(event, 401);
    return { error: 'Unauthorized' };
  }

  const user = session.user;

  const { data: post, error: postError } = await supabase
    .from('posts')
    .select('user_id')
    .eq('id', id)
    .single();

  if (postError) {
    setResponseStatus(event, 500);
    return { error: postError.message };
  }

  if (!post) {
    setResponseStatus(event, 404);
    return { error: 'Post not found' };
  }

  // TODO: Implement a proper admin role check
  const isAdmin = false; // user.email === 'admin@example.com';

  if (post.user_id !== user.id && !isAdmin) {
    setResponseStatus(event, 403);
    return { error: 'Forbidden' };
  }

  if (method === 'PUT') {
    const body = await readBody(event);
    const { title, content } = body;
    const { data, error } = await supabase
      .from('posts')
      .update({ title, content })
      .eq('id', id);

    if (error) {
      setResponseStatus(event, 500);
      return { error: error.message };
    }

    return data;
  } else if (method === 'DELETE') {
    const { data, error } = await supabase
      .from('posts')
      .delete()
      .eq('id', id);

    if (error) {
      setResponseStatus(event, 500);
      return { error: error.message };
    }

    return data;
  }

  setResponseStatus(event, 405);
  return { error: `Method ${method} Not Allowed` };
});
