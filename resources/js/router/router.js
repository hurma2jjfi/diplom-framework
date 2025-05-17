import { createRouter, createWebHistory } from 'vue-router';
import Main from '../views/Main.vue';
import Register from '../views/Register.vue';
import Login from '../views/Login.vue';
import Settings from '../views/Settings.vue';
import CarDetails from '../../components/pages/CarDetails.vue';
import Orders from '../../components/pages/Orders.vue';

const routes = [
  { path: '/', component: Main },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  { path: '/settings', component: Settings, meta: { requiresAuth: true } }, // добавляем мета-флаг
  { path: '/car/:id', component: CarDetails, name: 'CarDetails' }, // 
  { path: '/orders', component: Orders, meta: { requiresAuth: true } }, // добавляем мета-флаг

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
  const loggedIn = isAuthenticated();

  if (to.meta.requiresAuth && !loggedIn) {
    // Если маршрут требует авторизации, но пользователь не авторизован - перенаправляем на логин
    next('/login');
  } else if ((to.path === '/login' || to.path === '/register') && loggedIn) {
    // Если пользователь авторизован и пытается зайти на /login или /register - перенаправляем на главную
    next('/');
  } else {
    next(); // Иначе разрешаем переход
  }
});


export default router;
