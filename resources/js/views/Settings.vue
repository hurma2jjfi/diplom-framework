<template>
  <div class="settings-container" v-if="userStore.user && !loading">
    <h1>Профиль</h1>

    <div class="profile-info">
      <div class="avatar-wrapper">
        <img v-if="userStore.avatarUrl" :src="userStore.avatarUrl" alt="Аватар пользователя" class="avatar" />
        <div v-if="userStore.user.is_verified" class="verified-icon"></div>
      </div>
      <div class="info">
        <p class="name-line"><strong>Имя:</strong> {{ userStore.name }}</p>
        <p><strong>Email:</strong> {{ userStore.user.email }}</p>
        <p><strong>Телефон:</strong> {{ userStore.user.phone || 'Не указан' }}</p>
        <p><strong>Дата регистрации:</strong> {{ formatDate(userStore.user.created_at) }}</p>
        <p><strong>Последнее обновление:</strong> {{ formatDate(userStore.user.updated_at) }}</p>

        <button
          v-if="!userStore.user.is_verified && !verificationSent"
          @click="sendVerification"
          class="btn-verify"
          :disabled="verificationLoading"
        >
          {{ verificationLoading ? 'Отправка...' : 'Подтвердить профиль' }}
        </button>

        <p v-if="userStore.user.is_verified" class="success-message">
          Ваша почта подтверждена успешно!
        </p>

        <p v-if="verificationSent" class="verification-message">
          Запрос на подтверждение отправлен. Проверьте почту.
        </p>
      </div>
    </div>

    <div v-if="error" class="error">{{ error }}</div>

    <!-- Кнопки редактирования и удаления -->
    <div class="profile-actions" v-if="!editMode">
  <button class="edit menu-item compact" @click="startEdit" type="button">
    <img width="16" height="16" src="../../../public/img/edit.svg" alt="Редактировать" />
    Редактировать
  </button>

  <button id="delete" class="danger menu-item compact" @click="deleteProfile" :disabled="deleting" type="button">
    <img width="16" height="16" src="../../../public/img/delete.svg" alt="Удалить" />
    {{ deleting ? 'Удаление...' : 'Удалить профиль' }}
  </button>
</div>


    <!-- Модальное окно редактирования -->
    <transition name="modal-fade">
      <div v-if="editMode" class="modal-overlay" @click.self="cancelEdit">
        <div class="modal-window" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
          <h2 id="modalTitle" class="modal-title">Редактировать профиль</h2>
          <form @submit.prevent="updateProfile" class="edit-profile-form">
            <label>
              Имя:
              <input type="text" v-model="editUser.name" required autocomplete="name" />
            </label>
            <label>
              Email:
              <input v-model="editUser.email" type="email" required autocomplete="email" />
            </label>
            <label>
              Телефон:
              <input v-model="editUser.phone" type="tel" autocomplete="tel" />
            </label>

            <input
              type="file"
              accept="image/*"
              @change="onAvatarSelected"
              ref="avatarInput"
              style="display:none"
            />
            <button
              type="button"
              class="avatar-upload-btn"
              @click="$refs.avatarInput.click()"
              :disabled="uploadingAvatar"
            >
              {{ uploadingAvatar ? 'Загрузка...' : 'Сменить фото' }}
            </button>
            <span v-if="avatarError" class="error">{{ avatarError }}</span>

            <div class="edit-actions">
             <button type="submit" :disabled="saving" class="btn-save">
  <span v-if="saving" class="spinner-button"></span>
  <span v-else>Сохранить</span>
</button>

              <button type="button" @click="cancelEdit" :disabled="saving">Отмена</button>
            </div>

            <div v-if="editError" class="error">{{ editError }}</div>
            <div v-if="editSuccess" class="success-message">{{ editSuccess }}</div>
          </form>
        </div>
      </div>
    </transition>
  </div>

  <div v-else class="loading-wrapper">
    <div class="spinner"></div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useUserStore } from '@/stores/user';
import axios from 'axios';

const userStore = useUserStore();
const loading = ref(false);
const error = ref(null);

const editMode = ref(false);
const editUser = ref(null);
const saving = ref(false);
const editError = ref(null);
const editSuccess = ref(null);

const uploadingAvatar = ref(false);
const avatarFile = ref(null);
const avatarError = ref(null);

const deleting = ref(false);

const verificationLoading = ref(false);
const verificationSent = ref(false);

function formatDate(dateStr) {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  return date.toLocaleDateString('ru-RU', { year: 'numeric', month: 'long', day: 'numeric' });
}

function startEdit() {
  editMode.value = true;
  editUser.value = { ...userStore.user };
  editError.value = null;
  editSuccess.value = null;
}

function cancelEdit() {
  editMode.value = false;
  editUser.value = null;
  editError.value = null;
  editSuccess.value = null;
}

async function updateProfile() {
  saving.value = true;
  editError.value = null;
  editSuccess.value = null;
  try {
    const payload = {
      name: editUser.value.name,
      email: editUser.value.email,
      phone: editUser.value.phone
    };
    const response = await axios.put('/api/me', payload, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    userStore.setUser(response.data.content);
    editSuccess.value = 'Профиль успешно обновлён!';
    editMode.value = false;
  } catch (err) {
    editError.value = 'Ошибка при обновлении профиля';
  } finally {
    saving.value = false;
  }
}

function onAvatarSelected(e) {
  avatarFile.value = e.target.files[0];
  avatarError.value = null;
  if (avatarFile.value) {
    uploadAvatar();
  }
}

async function uploadAvatar() {
  if (!avatarFile.value) return;
  uploadingAvatar.value = true;
  avatarError.value = null;
  try {
    const formData = new FormData();
    formData.append('avatar', avatarFile.value);

    const response = await axios.post('/api/me/avatar', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
    });
    // Обновить пользователя во всех компонентах
    await userStore.fetchUser();
    if (editUser.value) editUser.value.avatar_url = userStore.user.avatar_url;
    avatarFile.value = null;
  } catch (err) {
    avatarError.value = 'Ошибка загрузки аватара';
  } finally {
    uploadingAvatar.value = false;
  }
}

async function deleteProfile() {
  if (!confirm('Вы уверены, что хотите удалить профиль? Это действие необратимо!')) return;
  deleting.value = true;
  try {
    await axios.delete('/api/me', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    userStore.logout();
    window.location.href = '/';
  } catch (err) {
    alert('Ошибка при удалении профиля');
  } finally {
    deleting.value = false;
  }
}

async function sendVerification() {
  verificationLoading.value = true;
  error.value = null;
  try {
    await axios.post('/api/email/verification-notification', {}, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    verificationSent.value = true;
  } catch (err) {
    error.value = 'Ошибка отправки запроса на подтверждение';
  } finally {
    verificationLoading.value = false;
  }
}
</script>
  
  <style scoped>
  
  .profile-actions {
    display: flex;
    gap: 20px;
  }

  .btn-save {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 20px;
  background: #4a90e2;
  color: white;
  border-radius: 8px;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-save:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-save:hover:not(:disabled) {
  background: #357abd;
}

.spinner-button {
  width: 18px;
  height: 18px;
  border: 3px solid rgba(255, 255, 255, 0.6);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  display: inline-block;
  margin-right: 8px;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}


 .edit, #delete {
  padding: 8px 20px;
  border: none;
  cursor: pointer;
  margin-top: 2rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 16px;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  user-select: none;
}

/* Стили для кнопки редактирования */
.edit {
  background: linear-gradient(90deg, #37aee2, #1e96c8);
  color: #fff;
}

.edit:hover {
  background: linear-gradient(90deg, #1e96c8, #0f7bbf);
  box-shadow: 0 4px 12px rgba(30, 150, 200, 0.6);
}

/* Стили для кнопки удаления */
#delete {
  background: #e63946;
  color: #fff;
}

#delete:hover {
  background: #d62828;
  box-shadow: 0 4px 12px rgba(214, 40, 40, 0.6);
}



.edit-profile-form h2 {
  margin-bottom: 1.2rem;
  font-weight: 600;
  font-size: 1.5rem;
  color: #fff;
  text-align: center;
}

.edit-profile-form form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.edit-profile-form label {
  display: flex;
  flex-direction: column;
  font-size: 0.9rem;
  color: #bbb;
  font-weight: 500;
}

.edit-profile-form input[type="text"],
.edit-profile-form input[type="email"],
.edit-profile-form input[type="tel"],
.edit-profile-form input[type="file"] {
  margin-top: 6px;
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  background: #2c2c2c;
  color: #eee;
  font-size: 1rem;
  outline-offset: 2px;
  outline-color: transparent;
  transition: outline-color 0.2s ease;
}

.edit-profile-form input[type="text"]:focus,
.edit-profile-form input[type="email"]:focus,
.edit-profile-form input[type="tel"]:focus {
  outline-color: #4a90e2;
  background: #333;
}

.avatar-upload-btn {
  background: #4a90e2;
  color: #fff;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  max-width: 160px;
  align-self: flex-start;
  transition: background-color 0.3s ease;
}

.avatar-upload-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.avatar-upload-btn:hover:not(:disabled) {
  background: #357abd;
}



.edit-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1rem;
}

.edit-actions button {
  background: #4a90e2;
  color: #fff;
  font-weight: 600;
  padding: 10px 20px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.edit-actions button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.edit-actions button:hover:not(:disabled) {
  background: #357abd;
}

.edit-actions button[type="button"] {
  background: #555;
}

.edit-actions button[type="button"]:hover:not(:disabled) {
  background: #444;
}

.error {
  color: #ff6b6b;
  font-weight: 600;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  text-align: center;
}

.success-message {
  color: #4caf50;
  font-weight: 600;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  text-align: center;
}

/* Модальное окно */
.modal-overlay {
  position: fixed;
  inset: 0;
  background-color: rgba(30, 30, 30, 0.65);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.modal-window {
  background: #232323;
  border-radius: 16px;
  padding: 2rem 2.5rem;
  max-width: 400px;
  width: 90vw;
  max-height: 90vh;
  overflow-y: auto;
  position: relative;
  color: #e0e0e0;
}

.modal-title {
  margin-bottom: 1rem;
  font-weight: 700;
  font-size: 1.5rem;
  text-align: center;
  color: #fff;
}

.edit-profile-form label {
  display: flex;
  flex-direction: column;
  margin-bottom: 1rem;
  font-weight: 600;
  font-size: 0.95rem;
  color: #bbb;
}

.edit-profile-form input[type='text'],
.edit-profile-form input[type='email'],
.edit-profile-form input[type='tel'] {
  margin-top: 6px;
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  background: #2c2c2c;
  color: #eee;
  font-size: 1rem;
  outline-offset: 2px;
  outline-color: transparent;
  transition: outline-color 0.2s ease;
}

.edit-profile-form input[type='text']:focus,
.edit-profile-form input[type='email']:focus,
.edit-profile-form input[type='tel']:focus {
  outline-color: #4a90e2;
  background: #333;
}

.avatar-upload-btn {
  background: #4a90e2;
  color: #fff;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  max-width: 160px;
  margin-bottom: 1rem;
  transition: background-color 0.3s ease;
}

.avatar-upload-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.avatar-upload-btn:hover:not(:disabled) {
  background: #357abd;
}

.edit-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1rem;
}

.edit-actions button {
  background: #4a90e2;
  color: #fff;
  font-weight: 600;
  padding: 10px 20px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.edit-actions button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.edit-actions button:hover:not(:disabled) {
  background: #357abd;
}

.edit-actions button[type='button'] {
  background: #555;
}

.edit-actions button[type='button']:hover:not(:disabled) {
  background: #444;
}

.error {
  color: #ff6b6b;
  font-weight: 600;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  text-align: center;
}

.success-message {
  color: #4caf50;
  font-weight: 600;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  text-align: center;
}

/* Плавные переходы для модального окна */
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.25s ease;
}
.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

 


.avatar-wrapper {
  position: relative;
  width: 100px;
  height: 100px;
  display: inline-block;
}

.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #ff0b8f;
  display: block;
}

.verified-icon {
  position: absolute;
  right: 0;
  bottom: 0;
  background-image: url('/img/verifiedIcon.svg');
  background-repeat: no-repeat;
  background-size: contain;
  background-position: center;
  border-radius: 50%;
  box-shadow: 0 0 4px rgba(0,0,0,0.15);

}


  .settings-container {
    max-width: 600px;
    margin: 40px auto;
    background: #222;
    padding: 30px;
    border-radius: 12px;
    color: #fff;
    font-family: 'Oswald', sans-serif;
  }
  
  h1 {
    margin-bottom: 20px;
    font-weight: 700;
    font-size: 28px;
  }
  
  .profile-info {
    display: grid;
    grid-template-columns: 100px 1fr;
    grid-gap: 20px;
    align-items: start;
  }
  
  .avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #ff0b8f;
    grid-row: 1 / span 2;
  }
  
  .info {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-gap: 12px 40px;
  }
  
  .info p {
    margin: 0;
    font-size: 18px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  .info p strong {
    color: #ff0b8f;
    font-weight: 700;
  }
  
  .name-line {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .verified-icon {
    width: 20px;
    height: 20px;
    stroke: #4caf50;
  }
  
  .btn-verify {
    grid-column: 1 / -1;
    margin-top: 20px;
    padding: 10px 15px;
    background: linear-gradient(to right, #4caf50, #81c784);
    border: none;
    border-radius: 8px;
    color: #fff;
    font-weight: 600;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    justify-self: start;
  }
  
  .btn-verify:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }
  
  .btn-verify:hover:not(:disabled) {
    background: linear-gradient(to right, #388e3c, #66bb6a);
  }
  
  .loading-wrapper {
    display: grid;
    place-items: center;
    height: 200px;
    color: #ff0b8f;
    font-weight: 600;
    font-family: 'Oswald', sans-serif;
  }
  
  .spinner {
    width: 48px;
    height: 48px;
    border: 5px solid rgba(255, 11, 143, 0.3);
    border-top-color: #ff0b8f;
    border-radius: 50%;
    animation: spin 1s linear infinite, fadeIn 0.5s ease-in forwards;
    opacity: 0;
  }
  
  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }
  
  @keyframes fadeIn {
    to {
      opacity: 1;
    }
  }
  
  .error {
    color: #f44336;
    font-weight: 600;
    text-align: center;
    margin-top: 20px;
  }
  
  .success-message {
    color: #4caf50;
    font-weight: 600;
    margin-top: 10px;
  }
  
  .contact-form {
    margin-top: 40px;
    padding-top: 20px;
    border-top: 1px solid #444;
  }
  
  .contact-form h2 {
    margin-bottom: 15px;
    font-weight: 700;
    font-size: 22px;
  }
  
  .contact-form label {
    display: block;
    margin-bottom: 5px;
    font-weight: 600;
  }
  
  .contact-form input,
  .contact-form textarea {
    width: 100%;
    padding: 8px 10px;
    margin-bottom: 15px;
    border-radius: 6px;
    border: none;
    font-size: 16px;
    font-family: inherit;
  }
  
  .contact-form textarea {
    resize: vertical;
    min-height: 100px;
  }
  
  .contact-form button {
    padding: 10px 20px;
    background: linear-gradient(to right, #4caf50, #81c784);
    border: none;
    border-radius: 8px;
    color: #fff;
    font-weight: 700;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }
  
  .contact-form button:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }
  
  .contact-form button:hover:not(:disabled) {
    background: linear-gradient(to right, #388e3c, #66bb6a);
  }

  </style>
  