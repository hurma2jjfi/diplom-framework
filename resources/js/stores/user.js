import { defineStore } from 'pinia';
import axios from 'axios';

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    isAuthenticated: false,
  }),
  getters: {
    avatarUrl(state) {
      if (!state.user?.avatar_url) return '';
      if (state.user.avatar_url.startsWith('http')) return state.user.avatar_url;
      return `${window.location.origin}${state.user.avatar_url}`;
    },
    name(state) {
      return state.user?.name || '';
    },
  },
  actions: {
    async fetchUser() {
      const token = localStorage.getItem('token');
      if (!token) {
        this.isAuthenticated = false;
        this.user = null;
        return;
      }
      try {
        const response = await axios.get('/api/me', {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.user = response.data.content;
        this.isAuthenticated = true;
      } catch {
        this.isAuthenticated = false;
        this.user = null;
      }
    },
    setUser(user) {
      this.user = user;
      this.isAuthenticated = !!user;
    },
    logout() {
      localStorage.removeItem('token');
      this.user = null;
      this.isAuthenticated = false;
    }
  }
});
