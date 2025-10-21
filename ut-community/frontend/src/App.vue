<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { RouterView, RouterLink } from 'vue-router';

// Define the type for a gallery
interface Gallery {
  id: string;
  name: string;
  description: string;
}

const galleries = ref<Gallery[]>([]);

// Fetch galleries from the backend
onMounted(async () => {
  try {
    // Assuming the backend is running on localhost:3000
    // In a real app, this URL should be in an environment variable
    const response = await fetch('http://localhost:3000/api/galleries');
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    galleries.value = await response.json();
  } catch (error) {
    console.error('Failed to fetch galleries:', error);
  }
});
</script>

<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <v-toolbar-title>
        <RouterLink to="/" class="white--text text-decoration-none">커뮤니티</RouterLink>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-tabs>
        <v-tab v-for="gallery in galleries" :key="gallery.id" :to="`/gallery/${gallery.id}`">
          {{ gallery.name }}
        </v-tab>
      </v-tabs>
    </v-app-bar>

    <v-main>
      <v-container>
        <RouterView />
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped>
.white--text {
  color: white !important;
}
.text-decoration-none {
  text-decoration: none;
}
</style>