<template>
  <div class="auth-container">
    <h1>Вход</h1>
    <form @submit.prevent="handleLogin" class="auth-form" novalidate>
      <div class="form-group">
        <label for="email">Email</label>
        <input v-model="email" type="email" id="email" required placeholder="Введите email" />
      </div>

      <div class="form-group">
        <label for="password">Пароль</label>
        <input v-model="password" type="password" id="password" required placeholder="Введите пароль" />
      </div>

      <button type="submit" class="btn-submit" :disabled="loading">
        <template v-if="loading">
          <span class="spinner"></span>
        </template>
        <template v-else>
          Войти
        </template>
      </button>

      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>

      <router-link to="/register" class="register-link">Нету аккаунта? Зарегистрироваться</router-link>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '@/stores/user';
import axios from 'axios';

const userStore = useUserStore();
const router = useRouter();

const email = ref('');
const password = ref('');
const loading = ref(false);
const errorMessage = ref('');

async function handleLogin() {
  errorMessage.value = '';
  loading.value = true;

  try {
    const response = await axios.post('/api/login', {
      email: email.value,
      password: password.value,
    });

    localStorage.setItem('token', response.data.access_token);

    // Обновляем store
    await userStore.fetchUser();

    // Проверяем роль пользователя и редиректим
    if (userStore.user.role === 1) {
      router.push('/admin');
    } else {
      router.push('/');
    }

    // Можно вызвать событие, если есть слушатели
    window.dispatchEvent(new Event('storage'));
  } catch (error) {
    errorMessage.value = error.response?.data?.message || 'Ошибка входа';
  } finally {
    loading.value = false;
  }
}

</script>


<style scoped>
.auth-container {
  max-width: 400px;
  margin: 50px auto;
  background: #222;
  padding: 30px;
  border-radius: 12px;
  color: #fff;
  font-family: 'Oswald', sans-serif;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

label {
  margin-bottom: 6px;
  font-weight: bold;
}

input {
  padding: 10px;
  border-radius: 6px;
  border: none;
  font-size: 16px;
}

input:focus {
  outline: 2px solid #ff0b8f;
  background-color: #333;
  color: #fff;
}

.btn-submit {
  position: relative;
  padding: 12px;
  background: linear-gradient(to right, #ff0b8f, #f46767);
  border: none;
  border-radius: 8px;
  color: #fff;
  font-size: 18px;
  cursor: pointer;
  transition: background 0.3s ease;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 44px;
}

.btn-submit:hover {
  background: linear-gradient(to right, #f46767, #ff0b8f);
}

.btn-submit:disabled {
  cursor: not-allowed;
  opacity: 0.7;
}

/* Спиннер */
.spinner {
  width: 24px;
  height: 24px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  display: inline-block;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

a {
  color: #ff0b8f;
  text-align: center;
  margin-top: 10px;
  display: block;
  font-weight: 600;
  text-decoration: underline;
  cursor: pointer;
}

.error-message {
  color: red;
}
</style>
