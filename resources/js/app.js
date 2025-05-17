import './bootstrap';
import { createApp } from 'vue';
import Index from './views/Index.vue';
import router from './router/router';
import * as VeeValidate from 'vee-validate';
import moment from 'moment';
import { createPinia } from 'pinia';

createApp(Index)
  .use(router)
  .use(createPinia())
  .use(VeeValidate)
  .use(moment)
  .mount('#app');
