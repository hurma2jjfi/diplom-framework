<template>
  <div class="auth-container">
    <h1>Регистрация</h1>
    <form @submit.prevent="handleRegister" class="auth-form" enctype="multipart/form-data" novalidate>
      <div class="form-group">
        <label for="name">Имя</label>
        <input v-model="name" type="text" id="name" required placeholder="Введите имя" />
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input v-model="email" type="email" id="email" required placeholder="Введите email" />
      </div>
      
      <div class="form-group">
        <label for="phone">Телефон</label>
        <input
          ref="phoneInput"
          v-model="phone"
          type="tel"
          id="phone"
          placeholder="+7-___-___-__-__"
          @input="onPhoneInput"
          maxlength="18"
          autocomplete="tel"
        />
      </div>

      <div class="form-group">
        <label for="password">Пароль</label>
        <input v-model="password" type="password" id="password" required placeholder="Введите пароль" />
      </div>

      <div class="form-group">
        <label for="passwordConfirm">Подтвердите пароль</label>
        <input v-model="passwordConfirm" type="password" id="passwordConfirm" required placeholder="Подтвердите пароль" />
      </div>

      <div class="form-group avatar-upload">
        <label>Аватарка (опционально)</label>
        <input
          type="file"
          id="avatar"
          accept="image/*"
          @change="onFileChange"
          ref="avatarInput"
          class="file-input"
        />
        <div class="custom-file-upload" @click="triggerFileInput">
          <span v-if="!avatarPreview && !loading">Выберите файл или перетащите сюда</span>
          <img v-if="avatarPreview" :src="avatarPreview" alt="Предпросмотр аватарки" />
          <button v-if="avatarPreview" type="button" @click.stop="removeAvatar" class="remove-btn">×</button>
        </div>
      </div>

      <button type="submit" class="btn-submit" :disabled="loading">
        <template v-if="loading">
          <span class="spinner"></span>
        </template>
        <template v-else>
          Зарегистрироваться
        </template>
      </button>

      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>

      <router-link to="/login" class="login-link">Уже есть аккаунт? Войти</router-link>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'Register',
  data() {
    return {
      name: '',
      email: '',
      phone: '+7-',
      password: '',
      passwordConfirm: '',
      avatarFile: null,
      avatarPreview: null,
      loading: false,
      errorMessage: '',
      lastCursorPos: null,
    };
  },
  methods: {
    onPhoneInput(event) {
      let input = event.target;
      let value = input.value;
      let cursorPos = input.selectionStart;
      let digits = value.replace(/\D/g, '');

      if (!digits.startsWith('7')) {
        digits = '7' + digits;
      }
      digits = digits.substring(0, 11);

      let formatted = '+7-';
      if (digits.length > 1) {
        formatted += digits.substring(1, 4);
      }
      if (digits.length >= 4) {
        formatted += '-' + digits.substring(4, 7);
      }
      if (digits.length >= 7) {
        formatted += '-' + digits.substring(7, 9);
      }
      if (digits.length >= 9) {
        formatted += '-' + digits.substring(9, 11);
      }

      this.phone = formatted;

      this.$nextTick(() => {
        let newPos = cursorPos;
        if (cursorPos === this.lastCursorPos + 1) {
          if (formatted[cursorPos - 1] === '-') {
            newPos = cursorPos + 1;
          }
        }
        if (newPos > formatted.length) newPos = formatted.length;
        input.setSelectionRange(newPos, newPos);
        this.lastCursorPos = newPos;
      });
    },

    async handleRegister() {
      this.errorMessage = '';
      if (this.password !== this.passwordConfirm) {
        this.errorMessage = 'Пароли не совпадают!';
        return;
      }
      this.loading = true;
      try {
        const formData = new FormData();
        formData.append('name', this.name);
        formData.append('email', this.email);
        formData.append('phone', this.phone);
        formData.append('password', this.password);
        formData.append('password_confirmation', this.passwordConfirm);
        if (this.avatarFile) {
          formData.append('avatar', this.avatarFile);
        }
        const response = await axios.post('/api/register', formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
        localStorage.setItem('token', response.data.access_token);
        this.$router.push('/');
      } catch (error) {
        if (error.response && error.response.data) {
          if (error.response.data.errors) {
            this.errorMessage = Object.values(error.response.data.errors).flat().join(' ');
          } else if (error.response.data.message) {
            this.errorMessage = error.response.data.message;
          } else {
            this.errorMessage = 'Ошибка регистрации';
          }
        } else {
          this.errorMessage = 'Ошибка сети или сервера';
        }
      } finally {
        this.loading = false;
      }
    },

    onFileChange(event) {
      const file = event.target.files[0];
      if (file && file.type.startsWith('image/')) {
        this.avatarFile = file;
        this.avatarPreview = URL.createObjectURL(file);
      } else {
        this.avatarFile = null;
        this.avatarPreview = null;
      }
    },

    removeAvatar() {
      this.avatarFile = null;
      this.avatarPreview = null;
      this.$refs.avatarInput.value = null;
    },

    triggerFileInput() {
      this.$refs.avatarInput.click();
    },
  },
};
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

input[type="text"],
input[type="email"],
input[type="password"],
input[type="tel"] {
  padding: 10px;
  border-radius: 6px;
  border: none;
  font-size: 16px;
}

input[type="text"]:focus,
input[type="email"]:focus,
input[type="password"]:focus,
input[type="tel"]:focus {
  outline: 2px solid #ff0b8f;
  background-color: #333;
  color: #fff;
}

.file-input {
  display: none;
}

.custom-file-upload {
  border: 2px dashed #ff0b8f;
  border-radius: 8px;
  text-align: center;
  color: #ff0b8f;
  cursor: pointer;
  position: relative;
  user-select: none;
  min-height: 60px;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}

.custom-file-upload span {
  font-size: 16px;
  font-weight: 600;
}

.custom-file-upload img {
  max-width: 100%;
  max-height: 100%;
  border-radius: 50%;
  object-fit: cover;
}

.remove-btn {
  position: absolute;
  top: 6px;
  right: 6px;
  background: rgba(0, 0, 0, 0.6);
  border: none;
  color: #fff;
  font-size: 20px;
  line-height: 1;
  padding: 0 6px;
  border-radius: 50%;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.remove-btn:hover {
  background-color: #ff0b8f;
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

.login-link {
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
