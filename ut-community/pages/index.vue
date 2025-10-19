<template>
  <v-container>
    <v-card>
      <v-card-title>
        Posts
        <v-spacer></v-spacer>
        <v-btn color="primary" @click="openNewDialog">New Post</v-btn>
      </v-card-title>
      <v-card-text>
        <v-list lines="two">
          <v-list-item
            v-for="post in posts"
            :key="post.id"
            :title="post.title"
            :subtitle="post.content"
          >
            <template v-slot:append>
              <v-btn color="blue-grey" class="mr-2" icon="mdi-pencil" @click="openEditDialog(post)"></v-btn>
              <v-btn color="error" icon="mdi-delete" @click="openDeleteDialog(post)"></v-btn>
            </template>
          </v-list-item>
        </v-list>
      </v-card-text>
    </v-card>

    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title>
          <span class="text-h5">{{ formTitle }}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field v-model="editedItem.title" label="Title"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea v-model="editedItem.content" label="Content"></v-textarea>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue-darken-1" variant="text" @click="closeDialog">Cancel</v-btn>
          <v-btn color="blue-darken-1" variant="text" @click="save">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="deleteDialog" max-width="500px">
      <v-card>
        <v-card-title class="text-h5">Are you sure you want to delete this post?</v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue-darken-1" variant="text" @click="closeDeleteDialog">Cancel</v-btn>
          <v-btn color="blue-darken-1" variant="text" @click="deleteItemConfirm">OK</v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>

  </v-container>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';

const posts = ref([]);
const dialog = ref(false);
const deleteDialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({
  id: null,
  title: '',
  content: ''
});
const defaultItem = {
  id: null,
  title: '',
  content: ''
};

const formTitle = computed(() => (editedIndex.value === -1 ? 'New Post' : 'Edit Post'));

onMounted(() => {
  fetchPosts();
});

async function fetchPosts() {
  try {
    const response = await fetch('/api/posts');
    if (!response.ok) throw new Error('Failed to fetch posts');
    posts.value = await response.json();
  } catch (error) {
    console.error(error);
  }
}

function openNewDialog() {
  editedIndex.value = -1;
  editedItem.value = { ...defaultItem };
  dialog.value = true;
}

function openEditDialog(item) {
  editedIndex.value = posts.value.indexOf(item);
  editedItem.value = { ...item };
  dialog.value = true;
}

function openDeleteDialog(item) {
  editedIndex.value = posts.value.indexOf(item);
  editedItem.value = { ...item };
  deleteDialog.value = true;
}

function closeDialog() {
  dialog.value = false;
  editedItem.value = { ...defaultItem };
  editedIndex.value = -1;
}

function closeDeleteDialog() {
  deleteDialog.value = false;
  editedItem.value = { ...defaultItem };
  editedIndex.value = -1;
}

async function save() {
  if (editedIndex.value > -1) {
    // Update
    try {
      const response = await fetch(`/api/posts/${editedItem.value.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editedItem.value)
      });
      if (!response.ok) throw new Error('Failed to update post');
      Object.assign(posts.value[editedIndex.value], editedItem.value);
    } catch (error) {
      console.error(error);
    }
  } else {
    // Create
    try {
      const response = await fetch('/api/posts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editedItem.value)
      });
      if (!response.ok) throw new Error('Failed to create post');
      const newPost = await response.json();
      posts.value.push(newPost[0]);
    } catch (error) {
      console.error(error);
    }
  }
  closeDialog();
}

async function deleteItemConfirm() {
  try {
    const response = await fetch(`/api/posts/${editedItem.value.id}`, {
      method: 'DELETE'
    });
    if (!response.ok) throw new Error('Failed to delete post');
    posts.value.splice(editedIndex.value, 1);
  } catch (error) {
    console.error(error);
  }
  closeDeleteDialog();
}
</script>