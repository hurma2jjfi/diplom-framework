<template>
    <div v-if="car" class="car-details">
      <h1>{{ car.brand }} {{ car.model }}</h1>
      <img v-if="car.image_url" :src="car.image_url" alt="Car image" class="car-image" />
  
      <!-- Дополнительные фото -->
      <div v-if="car.images && car.images.length" class="additional-images">
        <div class="images-list">
          <img
            v-for="(img, index) in car.images"
            :key="img.id"
            :src="img.image_url"
            alt="Additional car photo"
            class="additional-image"
            @click="openModal(index)"
          />
        </div>
      </div>
  
      <ul>
        <li><strong>Номерной знак:</strong> {{ car.license_plate }}</li>
        <li><strong>Цвет:</strong> {{ car.color }}</li>
        <li><strong>Год выпуска:</strong> {{ car.year }}</li>
        <li><strong>Коробка передач:</strong> {{ car.transmission }}</li>
        <li><strong>Тип топлива:</strong> {{ car.fuel_type }}</li>
        <li><strong>Количество мест:</strong> {{ car.seats }}</li>
        <li><strong>Город:</strong> {{ car.city }}</li>
        <li><strong>Статус:</strong> {{ car.status }}</li>
        <li><strong>Цена за час:</strong> {{ car.price_per_hour }}₽</li>
      </ul>
  
      <!-- Модальное окно -->
      <transition name="fade">
        <div v-if="modalOpen" class="modal-overlay" @click.self="closeModal">
          <div
            class="modal-content"
            @keydown.left.prevent="prevImage"
            @keydown.right.prevent="nextImage"
            tabindex="0"
            ref="modalContent"
          >
            <button class="close-btn" @click="closeModal" aria-label="Закрыть">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18" />
                <line x1="6" y1="6" x2="18" y2="18" />
              </svg>
            </button>
  
            <img
              :src="car.images[currentIndex].image_url"
              alt="Large car photo"
              class="modal-image"
              @dragstart.prevent
            />
  
            <button class="nav-btn prev" @click.stop="prevImage" aria-label="Предыдущее фото">
              <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="15 18 9 12 15 6" />
              </svg>
            </button>
  
            <button class="nav-btn next" @click.stop="nextImage" aria-label="Следующее фото">
              <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="9 18 15 12 9 6" />
              </svg>
            </button>
  
            <div class="counter">{{ currentIndex + 1 }} / {{ car.images.length }}</div>
          </div>
        </div>
      </transition>
    </div>
  
    <div v-else class="spinner-wrapper">
      <div class="lds-spinner">
        <div></div><div></div><div></div><div></div><div></div>
        <div></div><div></div><div></div><div></div><div></div>
        <div></div><div></div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    name: 'CarDetails',
    data() {
      return {
        car: null,
        error: null,
        modalOpen: false,
        currentIndex: 0,
      };
    },
    async created() {
      const carId = this.$route.params.id;
      try {
        const response = await axios.get(`/api/cars/${carId}`);
        this.car = response.data;
      } catch (err) {
        this.error = 'Не удалось загрузить детали автомобиля.';
        console.error(err);
      }
    },
    methods: {
      openModal(index) {
        this.currentIndex = index;
        this.modalOpen = true;
        this.$nextTick(() => {
          this.$refs.modalContent.focus();
        });
        document.body.style.overflow = 'hidden'; // Запретить скролл страницы
      },
      closeModal() {
        this.modalOpen = false;
        document.body.style.overflow = ''; // Вернуть скролл
      },
      prevImage() {
        if (!this.car || !this.car.images) return;
        this.currentIndex = (this.currentIndex - 1 + this.car.images.length) % this.car.images.length;
      },
      nextImage() {
        if (!this.car || !this.car.images) return;
        this.currentIndex = (this.currentIndex + 1) % this.car.images.length;
      },
    },
  };
  </script>
  
  <style scoped>
  .car-details {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
  }
  .car-image {
    max-width: 100%;
    height: auto;
    margin-bottom: 20px;
  }
  .additional-images {
    margin-bottom: 20px;
  }
  .images-list {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    justify-content: flex-start;
  }
  .additional-image {
    width: 100px;
    height: 70px;
    object-fit: cover;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    cursor: pointer;
    transition: transform 0.2s ease
  }
  .additional-image:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(0,0,0,0.25);
  }
  
  /* Модальное окно */
  .modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5); /* Сделайте фон чуть прозрачнее для лучшего эффекта */
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  overflow: hidden;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px); /* Для Safari */
}

  
  .modal-content {
    position: relative;
    max-width: 90vw;
    max-height: 90vh;
    outline: none;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .modal-image {
    max-width: 100%;
    max-height: 100%;
    user-select: none;
    pointer-events: none;
    box-shadow: 0 0 20px rgba(255, 255, 255, 0.3);
  }
  
  /* Кастомная кнопка закрытия */
  .close-btn {
    position: absolute;
    top: 15px;
    right: 15px;
    background: rgba(255, 255, 255, 0.1);
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: background 0.3s;
    z-index: 10;
  }
  .close-btn:hover {
    background: rgba(0, 0, 0, 0.8);
  }
  .close-btn svg {
    stroke: #fff;
    width: 24px;
    height: 24px;
  }
  
  /* Кастомные кнопки навигации */
  .nav-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(255, 255, 255, 0.1);
    border: none;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: background 0.3s;
    user-select: none;
    z-index: 10;
  }
  .nav-btn:hover {
    background: rgba(0, 0, 0, 0.8);
  }
  .nav-btn svg {
    stroke: #fff;
    width: 30px;
    height: 30px;
  }
  .nav-btn.prev {
    left: 15px;
  }
  .nav-btn.next {
    right: 15px;
  }
  
  /* Счётчик */
  .counter {
    position: absolute;
    bottom: 15px;
    left: 50%;
    transform: translateX(-50%);
    color: #fff;
    font-size: 16px;
    font-weight: 500;
    user-select: none;
  }
  
  /* Плавное появление/исчезновение */
  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.3s ease;
  }
  .fade-enter-from,
  .fade-leave-to {
    opacity: 0;
  }
  
  /* Спиннер */
  .spinner-wrapper {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 80px;
  }
  .lds-spinner {
    color: official;
    display: inline-block;
    position: relative;
    width: 64px;
    height: 64px;
  }
  .lds-spinner div {
    transform-origin: 32px 32px;
    animation: lds-spinner 1.2s linear infinite;
  }
  .lds-spinner div:after {
    content: " ";
    display: block;
    position: absolute;
    top: 3px;
    left: 29px;
    width: 6px;
    height: 18px;
    border-radius: 20%;
    background: #ffffff;
  }
  .lds-spinner div:nth-child(1) {
    transform: rotate(0deg);
    animation-delay: -1.1s;
  }
  .lds-spinner div:nth-child(2) {
    transform: rotate(30deg);
    animation-delay: -1s;
  }
  .lds-spinner div:nth-child(3) {
    transform: rotate(60deg);
    animation-delay: -0.9s;
  }
  .lds-spinner div:nth-child(4) {
    transform: rotate(90deg);
    animation-delay: -0.8s;
  }
  .lds-spinner div:nth-child(5) {
    transform: rotate(120deg);
    animation-delay: -0.7s;
  }
  .lds-spinner div:nth-child(6) {
    transform: rotate(150deg);
    animation-delay: -0.6s;
  }
  .lds-spinner div:nth-child(7) {
    transform: rotate(180deg);
    animation-delay: -0.5s;
  }
  .lds-spinner div:nth-child(8) {
    transform: rotate(210deg);
    animation-delay: -0.4s;
  }
  .lds-spinner div:nth-child(9) {
    transform: rotate(240deg);
    animation-delay: -0.3s;
  }
  .lds-spinner div:nth-child(10) {
    transform: rotate(270deg);
    animation-delay: -0.2s;
  }
  .lds-spinner div:nth-child(11) {
    transform: rotate(300deg);
    animation-delay: -0.1s;
  }
  .lds-spinner div:nth-child(12) {
    transform: rotate(330deg);
    animation-delay: 0s;
  }
  @keyframes lds-spinner {
    0% {
      opacity: 1;
    }
    100% {
      opacity: 0;
    }
  }
  </style>
  