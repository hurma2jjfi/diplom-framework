import { createRouter, createWebHistory } from 'vue-router';
import Main from '../views/Main.vue';
import Register from '../views/Register.vue';
import Login from '../views/Login.vue';
import Settings from '../views/Settings.vue';
import CarDetails from '../../components/pages/CarDetails.vue';

const routes = [
  { path: '/', component: Main },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  { path: '/settings', component: Settings, meta: { requiresAuth: true } }, // добавляем мета-флаг
  { path: '/car/:id', component: CarDetails, name: 'CarDetails' }, // 

];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Функция проверки аутентификации
function isAuthenticated() {
  return !!localStorage.getItem('token');
}

// Глобальный охранник
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !isAuthenticated()) {
    // Если маршрут требует авторизации, но пользователь не авторизован - перенаправляем на логин
    next('/login');
  } else {
    next(); // Иначе разрешаем переход
  }
});

export default router;
