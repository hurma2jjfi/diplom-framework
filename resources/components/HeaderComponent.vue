<template>
  <div class="container">
    <header>
      <div class="logo">
        <router-link to="/"><img src="/public/img/logo.svg" alt="Логотип" /></router-link>
      </div>
      <nav class="nav">
        <router-link
          to="/orders"
          class="nav-link-orders"
          v-if="userStore.isAuthenticated"
        >
          Заказы
          <span class="orders-badge" v-if="ordersCount > 0">{{ ordersCount }}</span>
        </router-link>
        <router-link to="/">О нас</router-link>
        <router-link to="/">Прайс-лист</router-link>
        <router-link to="/">Забронировать</router-link>
      </nav>

      <div v-if="!userStore.isAuthenticated" class="auth-buttons">
        <router-link to="/register" class="btn register-btn">Зарегистрироваться</router-link>
        <router-link to="/login" class="btn login-btn">Войти</router-link>
      </div>

      <div v-else class="user-profile" ref="profileMenu">
        <img
          v-if="userStore.avatarUrl"
          :src="userStore.avatarUrl"
          alt="Аватар"
          class="avatar"
        />
        <span class="user-name">{{ userStore.name }}</span>
        <button class="menu-toggle" @click="toggleMenu" aria-label="Меню пользователя" :aria-expanded="menuOpen">
          <img width="14" height="14" src="/public/img/dots.svg" alt="">
        </button>
        <transition name="slide">
          <div v-if="menuOpen" class="menu-overlay" @click.self="closeMenu">
            <div class="menu-content">
              <div class="menu-user-info" v-if="userStore.user">
                <img
                  v-if="userStore.avatarUrl"
                  :src="userStore.avatarUrl"
                  alt="Аватар"
                  class="menu-avatar"
                />
                <div class="menu-username">{{ userStore.name }}</div>
              </div>

              <router-link to="/settings" class="menu-item compact" @click="closeMenu">
                <img width="18" height="18" src="../../public/img/settings.svg" alt="Настройки" />
                Настройки
              </router-link>

              <div class="menu-item compact">
                <img src="../../public/img/ai.svg" alt="">
                Искусственный интеллект
                <label class="switch">
                  <input type="checkbox" v-model="aiEnabled" @change="onAISwitchChange" />
                  <span class="slider"></span>
                </label>
              </div>

              <div class="menu-item compact" @click="handleLogout">
                <img width="18" height="18" src="../../public/img/logout.svg" alt="">
                Выйти
              </div>
            </div>
          </div>
        </transition>
      </div>
    </header>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue';
import { useUserStore } from '@/stores/user';
import axios from 'axios';

// AI переключатель
const aiEnabled = ref(true);
onMounted(() => {
  const saved = localStorage.getItem('aiEnabled');
  aiEnabled.value = saved === null ? true : saved === 'true';
});
function onAISwitchChange() {
  localStorage.setItem('aiEnabled', aiEnabled.value);
  window.dispatchEvent(new CustomEvent('ai-switch', { detail: aiEnabled.value }));
}

// User store и меню
const userStore = useUserStore();
const menuOpen = ref(false);
const profileMenu = ref(null);

// Счётчик заказов
const ordersCount = ref(0);

// Функция получения количества заказов
async function fetchOrdersCount() {
  if (userStore.isAuthenticated) {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('/api/car-bookings/user', {
        headers: { Authorization: `Bearer ${token}` },
      });
      ordersCount.value = Array.isArray(response.data) ? response.data.length : 0;
    } catch (e) {
      ordersCount.value = 0;
    }
  } else {
    ordersCount.value = 0;
  }
}

// Логика меню пользователя
function toggleMenu() {
  menuOpen.value = !menuOpen.value;
}
function closeMenu() {
  menuOpen.value = false;
}
function handleClickOutside(event) {
  if (!menuOpen.value) return;
  if (profileMenu.value && !profileMenu.value.contains(event.target)) {
    closeMenu();
  }
}

// Выход из аккаунта
const handleLogout = () => {
  userStore.logout();
  menuOpen.value = false;
  window.location.href = '/';
};

// При монтировании
onMounted(async () => {
  await userStore.fetchUser();
  fetchOrdersCount();
  document.addEventListener('click', handleClickOutside);
});

// При размонтировании
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});

// Следим за изменением авторизации, чтобы обновлять счётчик заказов
watch(() => userStore.isAuthenticated, (newVal) => {
  if (newVal) {
    fetchOrdersCount();
  } else {
    ordersCount.value = 0;
  }
});


onMounted(() => {
  // ...ваш код...
  window.addEventListener('orders-updated', fetchOrdersCount);
  // ...
});
onBeforeUnmount(() => {
  // ...ваш код...
  window.removeEventListener('orders-updated', fetchOrdersCount);
});

</script>





<style lang="scss" scoped>
.nav-link-orders {
  position: relative;
  display: inline-flex;
  align-items: center;
  color: #fff;
  margin-right: 18px;
  text-decoration: none;
  transition: color 0.2s;
}

.nav-link-orders:hover {
  color: #4fa3f7;
}

.orders-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-left: 7px;
  min-width: 28px;
  height: 28px;
  background: linear-gradient(to left, #FF0B8F, #F46767);
  color: #fff;
  border-radius: 50%;
  font-size: 13px;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(80,140,255,0.13);
  border: 2px solid #222b3a;
  letter-spacing: 0.01em;
  transition: background 0.2s;
  animation: popIn 0.5s;
}

@keyframes popIn {
  0% { transform: scale(0.6); opacity: 0; }
  70% { transform: scale(1.1); opacity: 1; }
  100% { transform: scale(1); }
}

.ai-switch-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.switch {
  position: relative;
  display: inline-block;
  width: 40px;
  height: 22px;
  margin-left: 10px;
}
.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}
.slider {
  position: absolute;
  cursor: pointer;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: #ccc;
  transition: .4s;
  border-radius: 22px;
}
.slider:before {
  position: absolute;
  content: "";
  height: 18px; width: 18px;
  left: 2px; bottom: 2px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
}
input:checked + .slider {
  background-color: #ff0b8f;
}
input:checked + .slider:before {
  transform: translateX(18px);
}


.menu-user-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 12px;
  background: transparent;
}

.menu-avatar {
  width: 364px;
  height: 364px;
  border-radius: 0%;
  object-fit: cover;
  margin-bottom: 10px;
}


.menu-username {
  color: #fff;
  font-weight: 700;
  font-size: 20px;
  text-align: center;
  word-break: break-all;
}

:root {
  --color-background-compact-menu: rgb(33, 33, 33, 0.867);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}

header {
  margin-top: 60px;
  font-size: 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;

  .nav {
    display: flex;
    gap: 70px;

    a {
      color: white;
      text-decoration: none;
      transition: color 0.3s ease;

      &:hover {
        color: #ff0b8f;
      }
    }
  }

  .menu-toggle {
  width: 32px;          /* например, 32x32 */
  height: 32px;
  border-radius: 50%;
  background-color: transparent; /* по умолчанию прозрачный */
  border: none;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.3s ease;
  cursor: pointer;
}



  .auth-buttons {
    display: flex;
    gap: 15px;

    .btn {
      padding: 8px 20px;
      border-radius: 8px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: background 0.3s ease, color 0.3s ease;
      user-select: none;
      border: none;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .register-btn {
      background: transparent;
      border: 2px solid #ff0b8f;
      color: #ff0b8f;

      &:hover {
        background: #ff0b8f;
        color: white;
      }
    }

    .login-btn {
      background: transparent;
      border: 2px solid #ff0b8f;
      color: #ff0b8f;

      &:hover {
        background: #ff0b8f;
        color: white;
      }
    }
  }

  .user-profile {
    display: flex;
    align-items: center;
    gap: 12px;
    position: relative;

    .avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid #ff0b8f;
      flex-shrink: 0;
    }

    .user-name {
      color: white;
      font-weight: 600;
      font-size: 18px;
      white-space: nowrap;
    }

    // .menu-toggle {
    //   background: transparent;
    //   border: none;
    //   cursor: pointer;
    //   padding: 5px;
    //   display: flex;
    //   flex-direction: column;
    //   justify-content: space-between;
    //   height: 20px;
    //   width: 20px;

    //   .dot {
    //     width: 4px;
    //     height: 4px;
    //     background-color: white;
    //     border-radius: 50%;
    //   }

    //   &:hover .dot {
    //     background-color: #ff0b8f;
    //   }
    // }
  }
}

/* Меню и блюр */

.menu-overlay {
  position: fixed;
  inset: 0;
  backdrop-filter: blur(6px);
  background: rgba(0, 0, 0, 0.4);
  z-index: 1001;
  display: flex;
  justify-content: flex-end;
}

.menu-content {
  background: rgba(34, 34, 34, 0.5); /* прозрачный фон для размытия */
  -webkit-backdrop-filter: blur(10px);
  backdrop-filter: blur(10px);
  min-width: 220px;
  box-shadow: 0 8px 24px rgba(255, 11, 143, 0.09), 0 1.5px 5px rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  gap: 0;
  
}



.menu-item,
.MenuItem,
.MenuItem.compact {
  width: auto;
  min-width: 160px;
  background: none;
  border: none !important;
  box-shadow: none !important;
  outline: none !important;
  display: flex;
  align-items: center;
  font-size: .875rem;
  font-weight: 500;
  margin: .125rem .25rem;
  padding: .25rem;
  padding-inline-end: .75rem;
  border-radius: .375rem;
  line-height: 1.5rem;
  white-space: nowrap;
  color: #fff;
  cursor: pointer;
  transition: background 0.15s ease-in-out, transform 0.15s ease-in-out;
  will-change: transform;
  unicode-bidi: plaintext;
  position: relative;
  gap: 10px;
  
}

.menu-item .icon,
.MenuItem.compact .icon {
  font-size: 1.1rem;
  margin-right: 8px;
  display: inline-flex;
  align-items: center;
}

.menu-divider {
  height: 1px;
  background: #333;
  margin: 0.15rem 0;
  width: 100%;
  border: none;
}

.menu-item {
  padding: 14px 20px;
  color: white;
  font-weight: 600;
  cursor: pointer;
  background: transparent;
  text-align: left;
  transition: background 0.3s ease;

  &:last-child {
    border-bottom: none;
  }

  &:hover {
    background: #3f3f3f93;
    color: white;
  }
}

.logout-btn {
  background: transparent;
  border: none;
  width: 100%;
  text-align: left;
  font-family: inherit;
  font-size: inherit;
  padding: 14px 20px;
  cursor: pointer;
  font-weight: 600;
  color: white;
  transition: background 0.3s ease;

  &:hover {
    background: #f46767;
  }
}

/* Анимация slide-in справа */

.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.slide-enter-from {
  transform: translateX(100%);
  opacity: 0;
}

.slide-enter-to {
  transform: translateX(0);
  opacity: 1;
}

.slide-leave-from {
  transform: translateX(0);
  opacity: 1;
}

.slide-leave-to {
  transform: translateX(100%);
  opacity: 0;
}

.menu-item {
  text-decoration: none;
}
</style>
