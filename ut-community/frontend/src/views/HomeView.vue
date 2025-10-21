<script setup lang="ts">
import { ref, onMounted } from 'vue';

// Define the types for our data
interface Post {
  id: string;
  title: string;
  created_at: string;
  author_name: string;
}

interface GalleryWithPosts {
  gallery_id: string;
  gallery_name: string;
  posts: Post[];
}

const galleriesWithPosts = ref<GalleryWithPosts[]>([]);
const loading = ref(true);
const error = ref<string | null>(null);

// Fetch data from the backend
onMounted(async () => {
  try {
    // Assuming the backend is running on localhost:3000
    const response = await fetch('http://localhost:3000/api/posts/recent-by-gallery');
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    galleriesWithPosts.value = await response.json();
  } catch (e: any) {
    error.value = e.message || 'Failed to fetch data.';
  } finally {
    loading.value = false;
  }
});
</script>

<template>
  <div v-if="loading">
    <v-progress-circular indeterminate color="primary"></v-progress-circular>
    <span>Loading...</span>
  </div>
  <div v-else-if="error">
    <v-alert type="error">{{ error }}</v-alert>
  </div>
  <div v-else>
    <div v-for="gallery in galleriesWithPosts" :key="gallery.gallery_id" class="mb-8">
      <h2 class="text-h4 mb-4">{{ gallery.gallery_name }}</h2>
      <v-list lines="one">
        <v-list-item
          v-for="post in gallery.posts"
          :key="post.id"
          :title="post.title"
          :subtitle="`by ${post.author_name} on ${new Date(post.created_at).toLocaleDateString()}`"
          :to="`/post/${post.id}`"
        >
        </v-list-item>
      </v-list>
      <v-divider v-if="gallery.posts.length === 0" class="my-4"></v-divider>
      <p v-if="gallery.posts.length === 0">No recent posts in this gallery.</p>
    </div>
  </div>
</template>

<style scoped>
.mb-8 {
  margin-bottom: 3rem;
}
.mb-4 {
  margin-bottom: 1rem;
}
.my-4 {
  margin-top: 1rem;
  margin-bottom: 1rem;
}
.text-h4 {
    font-size: 1.5rem;
    font-weight: 400;
    line-height: 2rem;
    letter-spacing: 0.0073529412em;
    text-transform: none;
}
</style>