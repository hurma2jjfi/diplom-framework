<template>
  <HeaderComponent />
  <router-view />
  <FooterComponent v-if="$route.path === '/'" />
</template>

<script>
import HeaderComponent from '../../components/HeaderComponent.vue';
import FooterComponent from '../../components/FooterComponent.vue';


export default {
  components: {
    HeaderComponent, FooterComponent,  
  }
}
</script>

<style>

</style>


<!-- // С проверкой на скрытие хэдера и футера при авторизации и регистрации -->

<!-- <template>
  <div>
    <HeaderComponent v-if="showHeaderFooter" />
    <router-view />
    <FooterComponent v-if="showHeaderFooter" />
  </div>
</template>

<script>
import HeaderComponent from '../../components/HeaderComponent.vue';
import FooterComponent from '../../components/FooterComponent.vue';

export default {
  components: {
    HeaderComponent,
    FooterComponent,
  },
  computed: {
    showHeaderFooter() {
      // Массив путей, на которых скрываем шапку и подвал
      const hiddenPaths = ['/login', '/register'];
      return !hiddenPaths.includes(this.$route.path);
    }
  }
}
</script>

<style>
/* Твои стили */
</style> -->

  

<!-- // С проверкой на скрытие хэдера и футера при авторизации и регистрации -->

  <!-- <template>
    <div>
      <HeaderComponent v-if="showHeaderFooter" />
      <router-view />
      <FooterComponent v-if="showHeaderFooter" />
    </div>
  </template>
  
  <script>
  import HeaderComponent from '../../components/HeaderComponent.vue';
  import FooterComponent from '../../components/FooterComponent.vue';
  
  export default {
    components: {
      HeaderComponent,
      FooterComponent,
    },
    computed: {
      showHeaderFooter() {
        // Массив путей, на которых скрываем шапку и подвал
        const hiddenPaths = ['/login', '/register'];
        return !hiddenPaths.includes(this.$route.path);
      }
    }
  }
  </script>
  
  <style>
  /* Твои стили */
  </style> -->
  