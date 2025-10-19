import { supabase } from '../../lib/supabaseClient';
import { defineEventHandler, getMethod, readBody, setResponseStatus } from 'h3';

export default defineEventHandler(async (event) => {
  const method = getMethod(event);

  if (method === 'GET') {
    try {
      const { data, error } = await supabase
        .from('posts')
        .select('id, title, content, created_at')
        .order('created_at', { ascending: false });

      if (error) {
        throw error;
      }

      return data; // H3 automatically sends JSON
    } catch (error) {
      setResponseStatus(event, 500);
      return { error: error.message };
    }
  } else if (method === 'POST') {
    const body = await readBody(event);
    const { title, content } = body;

    const { data: { session }, error: sessionError } = await supabase.auth.getSessionFromCookie(event.node.req);

    if (sessionError || !session) {
      setResponseStatus(event, 401);
      return { error: 'Unauthorized' };
    }

    const user = session.user;

    const { data, error } = await supabase
      .from('posts')
      .insert([{ title, content, user_id: user.id }]);

    if (error) {
      setResponseStatus(event, 500);
      return { error: error.message };
    }

    setResponseStatus(event, 201);
    return data;
  }

  setResponseStatus(event, 405);
  return { error: `Method ${method} Not Allowed` };
});
