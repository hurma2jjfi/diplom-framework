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

    <!-- Кнопка забронировать -->
    <button
  v-if="isAuthenticated"
  class="book-btn"
  @click="openBookingModal"
>
  Забронировать
</button>


    <!-- Модальное окно просмотра фото -->
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

    <!-- Модальное окно бронирования -->
    <transition name="fade">
      <div v-if="bookingModalOpen" class="modal-overlay" @click.self="closeBookingModal">
        <div class="modal-content booking-modal" tabindex="0" ref="bookingModalContent">
          <button class="close-btn" @click="closeBookingModal" aria-label="Закрыть">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>

          <h2>Забронировать {{ car.brand }} {{ car.model }}</h2>

          <form @submit.prevent="submitBooking" class="booking-form">
            <label>
              Дата и время начала:
              <input type="datetime-local" v-model="booking.start_time" required />
            </label>
            <label>
              Дата и время окончания:
              <input type="datetime-local" v-model="booking.end_time" required />
            </label>
            <label>
  Серия водительских прав:
  <input type="text" v-model="booking.license_series" required maxlength="10" />
</label>
<label>
  Номер водительских прав:
  <input type="text" v-model="booking.license_number" required maxlength="20" />
</label>


            <div v-if="totalPrice !== null" class="total-price">
              Итоговая стоимость: <strong>{{ totalPrice }}₽</strong>
            </div>

            <button
  v-if="isAuthenticated"
  class="book-btn"
  @click="openBookingModal"
>
  Забронировать
</button>


            <div v-if="bookingError" class="error-message">{{ bookingError }}</div>
            <transition name="fade">
  <div v-if="bookingSuccess" class="success-checkmark">
    <svg viewBox="0 0 52 52" class="checkmark">
      <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>
      <path class="checkmark__check" fill="none" d="M14 27l7 7 16-16"/>
    </svg>
    <div class="success-text">Бронь успешно создана!</div>
  </div>
</transition>
          </form>
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

      // Для бронирования
      bookingModalOpen: false,
      booking: {
        start_time: '',
        end_time: '',
        license_series: '',
        license_number: '',
      },
      bookingLoading: false,
      bookingError: null,
      bookingSuccess: false,
    };
  },
  computed: {
    isAuthenticated() {
      return !!localStorage.getItem('token');
    },

    totalPrice() {
      if (this.booking.start_time && this.booking.end_time) {
        const start = new Date(this.booking.start_time);
        const end = new Date(this.booking.end_time);
        if (end > start && this.car) {
          const hours = (end - start) / 1000 / 3600;
          return Math.ceil(hours * this.car.price_per_hour);
        }
      }
      return null;
    }
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

    // --- Методы для бронирования ---
    openBookingModal() {
      this.bookingModalOpen = true;
      this.bookingError = null;
      this.bookingSuccess = false;
      // НЕ сбрасываем даты!
      this.$nextTick(() => {
        this.$refs.bookingModalContent.focus();
      });
      document.body.style.overflow = 'hidden';
    },

    closeBookingModal() {
      this.bookingModalOpen = false;
      document.body.style.overflow = '';
    },

    async submitBooking() {
      this.bookingLoading = true;
      this.bookingError = null;
      this.bookingSuccess = false;

      try {
        const payload = {
          car_id: this.car.id,
          start_time: this.booking.start_time,
          end_time: this.booking.end_time,
          license_series: this.booking.license_series,
          license_number: this.booking.license_number,
        };

        await axios.post('/api/car-bookings', payload, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
        });

        this.bookingSuccess = true;
        this.booking.start_time = '';
        this.booking.end_time = '';
        this.booking.license_series = '';
        this.booking.license_number = '';

        // Вызов события для обновления счётчика заказов в шапке
        window.dispatchEvent(new CustomEvent('orders-updated'));

      } catch (e) {
        this.bookingError = e.response?.data?.error || 'Ошибка при бронировании';
      } finally {
        this.bookingLoading = false;
      }
    }
  },
};
</script>


<style scoped>
.success-checkmark {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 24px;
  margin-bottom: 10px;
  animation: fadeIn 0.5s;
}

.checkmark {
  width: 72px;
  height: 72px;
  display: block;
  stroke-width: 3;
  stroke: #34fa0c; /* Telegram blue */
  stroke-miterlimit: 10;
  margin: 0 auto 8px auto;
  background: none;
}

.checkmark__circle {
  stroke-dasharray: 166;
  stroke-dashoffset: 166;
  stroke: #34fa0c;
  stroke-width: 3.5;
  animation: strokeCircle 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
}

.checkmark__check {
  stroke-dasharray: 48;
  stroke-dashoffset: 48;
  stroke: #34fa0c;
  stroke-width: 3.5;
  animation: strokeCheck 0.4s 0.5s cubic-bezier(0.65, 0, 0.45, 1) forwards;
}

.success-text {
  color: #34fa0c;
  font-weight: 600;
  font-size: 1.16em;
  margin-top: 6px;
  letter-spacing: 0.01em;
  text-align: center;
}

@keyframes strokeCircle {
  to {
    stroke-dashoffset: 0;
  }
}
@keyframes strokeCheck {
  to {
    stroke-dashoffset: 0;
  }
}
@keyframes fadeIn {
  from { opacity: 0; transform: scale(0.95);}
  to { opacity: 1; transform: scale(1);}
}

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
  transition: transform 0.2s ease;
  border-radius: 6px;
}
.additional-image:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0,0,0,0.25);
}

.book-btn {
  margin-top: 20px;
  padding: 12px 28px;
  background-color: #ff0b8f;
  border: none;
  border-radius: 10px;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}
.book-btn:hover {
  background-color: #e0097a;
}

/* Модальные окна */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0,0,0,0.85);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  overflow: hidden;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.modal-content {
  position: relative;
  max-width: 90vw;
  max-height: 90vh;
  outline: none;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #23272b;
  border-radius: 14px;
  box-shadow: 0 8px 32px rgba(31,38,135,0.18);
  overflow: hidden;
  padding: 20px;
  flex-direction: column;
}

.modal-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 10px;
  user-select: none;
  pointer-events: none;
}

.close-btn {
  position: absolute;
  top: 15px;
  right: 15px;
  background: rgba(40,40,50,0.85);
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
  background: #ff0b8f;
}
.close-btn svg {
  stroke: #fff;
  width: 24px;
  height: 24px;
}

.nav-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(40,40,50,0.85);
  border: none;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: background 0.3s;
  z-index: 10;
}
.nav-btn:hover {
  background: #ff0b8f;
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

/* Модальное окно бронирования */
.booking-modal {
  max-width: 400px;
  max-height: auto;
  padding: 30px 25px;
  background: #2c2f33;
  flex-direction: column;
  align-items: stretch;
}

.booking-form {
  width: 100%;
  display: flex;
  flex-direction: column;
}

.booking-form label {
  margin-bottom: 15px;
  color: #ddd;
  font-weight: 500;
}

.booking-form input[type="datetime-local"] {
  width: 100%;
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  background: #18181c;
  color: #eee;
  font-size: 14px;
  margin-top: 6px;
}

.booking-form button {
  margin-top: 15px;
  padding: 12px 0;
  background-color: #ff0b8f;
  border: none;
  border-radius: 10px;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.booking-form button:disabled {
  background-color: #7a3a5a;
  cursor: not-allowed;
}

.total-price {
  margin-top: 10px;
  font-size: 16px;
  color: #fff;
  font-weight: 600;
}

.error-message {
  margin-top: 10px;
  color: #ff6b6b;
  font-weight: 600;
}

.success-message {
  margin-top: 10px;
  color: #2ecc40;
  font-weight: 600;
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

/* Плавное появление/исчезновение */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
