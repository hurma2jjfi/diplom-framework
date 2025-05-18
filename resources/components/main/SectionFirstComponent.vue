<template>
  <div class="wrapper">
    <div class="select__flex__items">
      <h1 id="share">
        Делитесь, арендуйте, <br />
        путешествуйте: <br />
        Удобный каршеринг
      </h1>
      <h1 id="select__txt">ВОТ МАШИНЫ В ВАШЕМ ГОРОДЕ -</h1>

      <!-- Фильтры с кастомными селектами -->
      <form @submit.prevent class="filters-form">
        <div class="filters-grid">
          <CustomSelect
           v-model="filters.brand"
          :options="brandOptions"
          placeholder="Марка"
          @update:modelValue="fetchCars"
          :showImg="true"
           />
          <CustomSelect
            v-model="filters.model"
            :options="modelOptions"
            placeholder="Модель"
            @update:modelValue="fetchCars"
          />
          <!-- Цвет с кружком -->
          <CustomSelect
            v-model="filters.color"
            :options="colorOptions"
            placeholder="Цвет"
            @update:modelValue="fetchCars"
            :showColorDot="true"
          />
          <CustomSelect
            v-model="filters.year"
            :options="yearOptions"
            placeholder="Год"
            @update:modelValue="fetchCars"
          />
          <CustomSelect
            v-model="filters.transmission"
            :options="transmissionOptions"
            placeholder="Трансмиссия"
            @update:modelValue="fetchCars"
          />
          <CustomSelect
            v-model="filters.fuel_type"
            :options="fuelTypeOptions"
            placeholder="Топливо"
            @update:modelValue="fetchCars"
          />
          <CustomSelect
            v-model="filters.seats"
            :options="seatsOptions"
            placeholder="Мест"
            @update:modelValue="fetchCars"
          />
          <CustomSelect
            v-model="filters.city"
            :options="cityOptions"
            placeholder="Город"
            @update:modelValue="fetchCars"
          />
          <CustomSelect
            v-model="filters.status"
            :options="statusOptions"
            placeholder="Статус"
            @update:modelValue="fetchCars"
          />
        </div>
        <button type="button" class="btn-clear" @click="clearFilters">Сбросить фильтры</button>
      </form>

      <div v-if="loading" class="spinner-wrapper">
        <div class="lds-spinner">
          <div></div><div></div><div></div><div></div><div></div>
          <div></div><div></div><div></div><div></div><div></div>
          <div></div><div></div>
        </div>
      </div>

      <div v-if="error" class="error">{{ error }}</div>

       <div class="catalog">НАШИ АВТОМОБИЛИ</div>

      <div v-if="cars.length" class="car-list">
  <router-link style="text-decoration: none; color: none;"
    v-for="car in cars"
    :key="car.id"
    :to="{ name: 'CarDetails', params: { id: car.id } }"
    class="car-card"
  >
    <img :src="car.image_url || defaultImage" alt="Фото машины" class="car-image" />
    <div class="car-info">
      <h2>{{ car.brand }} {{ car.model }}</h2>
      <p><strong>Год:</strong> {{ car.year || '-' }}</p>
      <p><strong>Цвет:</strong> {{ car.color || '-' }}</p>
      <p><strong>Трансмиссия:</strong> {{ car.transmission || '-' }}</p>
      <p><strong>Топливо:</strong> {{ car.fuel_type || '-' }}</p>
      <p><strong>Мест:</strong> {{ car.seats }}</p>
      <p><strong>Город:</strong> {{ car.city || '-' }}</p>
      <p><strong>Цена в час:</strong> {{ car.price_per_hour }} ₽</p>
      <p><strong>Статус:</strong> {{ car.status }}</p>
    </div>
  </router-link>
</div>
<div v-else class="no-cars">Машины не найдены.</div>


<div class="why__carshering">
            ПОЧЕМУ КАРШЕРИНГ?
        </div>

   <div class="box-1">
    <div class="box__inner-1">
      <img
        id="img1"
        src="../../../public/img/mask1.svg"
        alt=""
        @click="toggleInfo(1)"
        :class="{ rotating: rotatingIndex === 1 }"
      />
      <img
        id="img2"
        src="../../../public/img/mask2.svg"
        alt=""
        @click="toggleInfo(2)"
        :class="{ rotating: rotatingIndex === 2 }"
      />
    </div>

    <transition name="fade">
      <div v-if="showInfo" class="popover" :style="popoverStyle">
        <ul>
          <li v-for="(advantage, index) in advantages" :key="index" :style="flyStyle(index)">
            {{ advantage }}
          </li>
        </ul>
      </div>
    </transition>
  </div>


  <div class="next__block__register">


    <div class="wrap__register">
    <h1>ВАШ КЛЮЧ ОТ <br>МАШИНЫ — НАШ <br>СЕРВИС</h1>
    <p>Зарегистрируйтесь и авторизуйтесь для оформления заявки</p>
    <router-link to="/register">
    <button class="register">Регистрация</button></router-link>
    <img class="phone__img" src="../../../public//img/phone.png" alt="">

  </div>

  </div>






    </div>

    <AIAssistant
  :filters="filters"
  :loading="loading"
  :carsCount="cars.length"
  :error="error"
/>
    <div class="circle"></div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch, nextTick } from 'vue';
import CustomSelect from '../ui/CustomSelect.vue';
import AIAssistant from '../ui/AIAssistant.vue';
import axios from 'axios';

const cars = ref([]);
const loading = ref(false);
const error = ref(null);
const defaultImage = '/storage/cars/default_car.jpg';





const rotatingIndex = ref(null);
const showInfo = ref(false);
const popoverStyle = reactive({});

const advantages = [
  '+ Экономия времени и денег',
  '+ Свобода передвижения',
  '+ Отсутствие забот о техническом обслуживании',
  '+ Экологичность и современные технологии',
  '+ Удобство аренды без лишних документов',
];

// Позиция поповера рядом с картинкой
function toggleInfo(index) {
  if (rotatingIndex.value === index) {
    // Закрываем если повторно кликнули
    rotatingIndex.value = null;
    showInfo.value = false;
  } else {
    rotatingIndex.value = index;
    showInfo.value = false;
    nextTick(() => {
      showInfo.value = true;
      setPopoverPosition(index);
    });
  }
}

function setPopoverPosition(index) {
  const img = document.getElementById(`img${index}`);
  if (!img) return;
  const rect = img.getBoundingClientRect();
  popoverStyle.top = `${rect.bottom + window.scrollY + 10}px`;
  popoverStyle.left = `${rect.left + window.scrollX}px`;
}

// Анимация "летающих" преимуществ
function flyStyle(i) {
  return {
    animationDelay: `${i * 150}ms`,
  };
}



const filters = reactive({
  brand: '',
  model: '',
  color: '',
  year: '',
  transmission: '',
  fuel_type: '',
  seats: '',
  city: '',
  status: '',
});

// Функция для получения цвета по названию (можно расширить)
function getColorCode(name) {
  const map = {
    'Белый': '#FFFFFF',
    'Серый': '#808080',
    'Синий': '#0000FF',
    'Красный': '#FF0000',
    'Зелёный': '#008000',
    'Черный': '#000000',
    'Серая': '#A9A9A9',
  };
  return map[name] || '#ccc'; // fallback серый
}

// Опции для селектов
const brandOptions = [
  { value: '', label: 'Все марки' },
  { value: 'Toyota', label: 'Toyota', img: 'https://east-auto.su/upload/iblock/d5b/d5b36b581978bfa876deb8c90f57b67c.png' },
  { value: 'Mazda', label: 'Mazda', img: 'https://filearchive.cnews.ru/img/cnews/2021/10/19/logos/58/581a153d2e6ca47b8e67cafb8d9445fe.png' },
  { value: 'Audi', label: 'Audi', img: 'https://i.pinimg.com/originals/41/7f/11/417f11936859a8d4b561fecdd10f37e4.png' },
  { value: 'BMW', label: 'BMW', img: 'https://upload.wikimedia.org/wikipedia/commons/4/44/BMW.svg' },
  { value: 'Mercedes-Benz', label: 'Mercedes-Benz', img: 'https://main-cdn.sbermegamarket.ru/big1/hlr-system/-15/902/575/815/191/527/100053570831b0.png' },
  // Добавьте другие бренды по необходимости
];

const modelOptions = [
  { value: '', label: 'Все модели' },
  { value: 'Camry', label: 'Camry' },
  { value: 'RX-7', label: 'RX-7' },
  { value: 'RS-7', label: 'RS-7' },
  { value: 'RS6', label: 'RS6' },
  { value: 'M3', label: 'M3' },
  { value: 'CX-5', label: 'CX-5' },
  { value: 'A4', label: 'A4' },
  { value: 'X3', label: 'X3' },
];
// Для цвета добавляем colorCode
const colorOptions = [
  { value: '', label: 'Все цвета', colorCode: '' },
  { value: 'Белый', label: 'Белый', colorCode: getColorCode('Белый') },
  { value: 'Серый', label: 'Серый', colorCode: getColorCode('Серый') },
  { value: 'Синий', label: 'Синий', colorCode: getColorCode('Синий') },
  { value: 'Красный', label: 'Красный', colorCode: getColorCode('Красный') },
  { value: 'Зелёный', label: 'Зелёный', colorCode: getColorCode('Зелёный') },
  { value: 'Черный', label: 'Черный', colorCode: getColorCode('Черный') },
  { value: 'Серая', label: 'Серая', colorCode: getColorCode('Серая') },
];
const yearOptions = [
  { value: '', label: 'Все года' },
  { value: 2017, label: '2017' },
  { value: 2018, label: '2018' },
  { value: 2019, label: '2019' },
  { value: 2020, label: '2020' },
  { value: 2021, label: '2021' },
];
const transmissionOptions = [
  { value: '', label: 'Любая' },
  { value: 'Автомат', label: 'Автомат' },
  { value: 'Механика', label: 'Механика' },
];
const fuelTypeOptions = [
  { value: '', label: 'Любое топливо' },
  { value: 'Бензин', label: 'Бензин' },
  { value: 'Дизель', label: 'Дизель' },
  { value: 'Электро', label: 'Электро' },
];
const seatsOptions = [
  { value: '', label: 'Мест' },
  { value: 2, label: '2' },
  { value: 4, label: '4' },
  { value: 5, label: '5' },
  { value: 7, label: '7' },
];
const cityOptions = [
  { value: '', label: 'Все города' },
  { value: 'Москва', label: 'Москва' },
  { value: 'Санкт-Петербург', label: 'Санкт-Петербург' },
  { value: 'Екатеринбург', label: 'Екатеринбург' },
  { value: 'Нижний Новгород', label: 'Нижний Новгород' },
  { value: 'Самара', label: 'Самара' },
  { value: 'Ростов-на-Дону', label: 'Ростов-на-Дону' },
  { value: 'Уфа', label: 'Уфа' },
  { value: 'Краснодар', label: 'Краснодар' },
];
const statusOptions = [
  { value: '', label: 'Все статусы' },
  { value: 'Доступен', label: 'Доступен' },
  { value: 'Занят', label: 'Занят' },
  { value: 'В ремонте', label: 'В ремонте' },
  { value: 'Зарезервирован', label: 'Зарезервирован' },
];

function buildQueryParams(filters) {
  const params = {};
  for (const key in filters) {
    const value = filters[key];
    if (value !== '' && value !== null && value !== undefined) {
      params[key] = value;
    }
  }
  return params;
}

async function fetchCars() {
  loading.value = true;
  error.value = null;
  try {
    const token = localStorage.getItem('token');
    const params = buildQueryParams(filters);
    const response = await axios.get('/api/cars', {
      headers: {
        Authorization: `Bearer ${token}`,
      },
      params,
    });
    cars.value = response.data.data || response.data;
  } catch (e) {
    error.value = 'Ошибка загрузки данных машин';
  } finally {
    loading.value = false;
  }
}

function clearFilters() {
  for (const key in filters) {
    filters[key] = '';
  }
  fetchCars();
}

onMounted(() => {
  fetchCars();
});
</script>


<style scoped>
/* Родитель должен иметь position: relative */
.parent-container {
  position: relative;
  overflow: visible; /* чтобы круг не обрезался */
  height: 100px; /* пример высоты */
}

/* Круг */
.circle {
  position: absolute;
  top: 10px;           /* строго сверху */
  left: 110%;       /* старт справа за пределами */
  width: 50px;
  height: 50px;
  background-color: #FF0B8F;
  border-radius: 50%;
  animation: chaoticMove 8s linear infinite;
  transform-origin: center;
  pointer-events: none;
  z-index: 10;
  margin-top: 120px;
}

@keyframes chaoticMove {
  0% {
    left: 50%;
    top: 0;
    opacity: 0;
    transform: rotate(0deg);
  }
  10% {
    opacity: 1;
  }
  30% {
    left: 80%;
    top: 3px; /* небольшой хаотичный сдвиг */
    transform: rotate(15deg);
  }
  50% {
    left: 50%;
    top: 0;
    transform: rotate(-15deg);
  }
  70% {
    left: 20%;
    top: 2px;
    transform: rotate(10deg);
  }
  90% {
    opacity: 1;
  }
  100% {
    left: -10%;
    top: 0;
    opacity: 0;
    transform: rotate(0deg);
  }
}

.wrapper {
  max-width: 1100px;
  margin: 0 auto;
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr;
  justify-items: center;
  box-sizing: border-box;
  position: relative;
  padding-top: 100px;
  gap: 40px;
  color: #fff;
  font-family: 'DrykWideCyr', sans-serif;
}

.select__flex__items {
  width: 100%;
  max-width: 1080px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

#share {
  font-size: 56px;
  margin-bottom: 40px;
  z-index: 1;
  text-align: center;
}

#select__txt {
  font-size: 32px;
  margin-bottom: 40px;
  text-align: center;
  z-index: 1000;
}

.filters-form {
  width: 100%;
  max-width: 1080px;
  margin-bottom: 32px;
}

.filters-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
  margin-bottom: 12px;
}

.filters-grid select {
  width: 100%;
  padding: 8px 10px;
  border-radius: 6px;
  border: 1px solid #ccc;
  font-size: 14px;
  box-sizing: border-box;
  background-color: white;
  color: #000;
  cursor: pointer;
}

.btn-clear {
  padding: 10px 20px;
  font-size: 16px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  background-color: #555;
  color: white;
  transition: background-color 0.3s ease;
}

.btn-clear:hover {
  background-color: #333;
}

.loading,
.error,
.no-cars {
  font-size: 18px;
  margin-top: 20px;
  color: #ff0b8f;
  text-align: center;
  width: 100%;
}

.car-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
  gap: 44px;
  width: 100%;
  max-width: 1080px;
  justify-items: center;
}

.car-card {
  background: #1a1a1a;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgb(255 11 143 / 0.3);
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  transition: transform 0.3s ease;
  cursor: pointer;
  width: 100%;
  max-width: 320px;
}

.car-card:hover {
  transform: scale(1.03);
  box-shadow: 0 8px 32px rgb(255 11 143 / 0.6);
}

.car-image {
  width: 100%;
  height: 130px;
  object-fit: cover;
  border-radius: 12px;
}

.car-info h2 {
  font-size: 22px;
  color: #fff;
  margin: 0;
  text-align: center;
}

.car-info p {
  margin: 2px 0;
  font-size: 14px;
  color: #ccc;
  text-align: center;
}

.circle {
  width: 341px;
  height: 268px;
  background: linear-gradient(to left, #FF0B8F, #F46767);
  border-radius: 50%;
  filter: blur(50.3px);
  position: absolute;
  right: 180px;
  top: 80px;
  z-index: 0;
}

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

.no-cars {
  color: red;
}


.why__carshering {
  font-size: 32px;
  padding-top: 5rem;
}

.box-1 {
  width: 980px;
  height: 517px;
  border-radius: 16px;
  background-color: #E2EAFF;
  margin-top: 5rem;
  padding: 50px 50px 0px 50px;
}

.box__inner-1 {
  height: 413px;
  display: flex;
  justify-content: center;
  position: relative;

}

.box__inner-1 #img1 {
  position: absolute;
  top: 0;
  left: 0;
}

.box__inner-1 #img2 {
  position: absolute;
  bottom: 0;
  right: 0;
}

.box__inner-1 img {
  cursor: pointer;
  transition: transform 1s ease;
  display: inline-block;
  margin-right: 20px;
}

.rotating {
  transform: rotate(360deg);
  transition: transform 1s ease;
}

.popover {
  position: absolute;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  padding: 20px 24px;
  max-width: 280px;
  font-weight: 600;
  font-size: 12px;
  color: #333;
  z-index: 1000;
}

.popover ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.popover li {
  opacity: 0;
  transform: translateY(-20px);
  animation: flyIn 0.5s forwards;
  margin-bottom: 10px;
}

.popover li:last-child {
  margin-bottom: 0;
}

@keyframes flyIn {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Плавное появление/исчезновение поповера */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.next__block__register {
  width: 980px;
  height: 517px;
  background: linear-gradient(to left, #FF0B8F, #F46767);
  margin-top: 5rem;
  border-radius: 16px;
  padding: 0px 50px 0px 50px;
  position: relative;
}

p {
  font-family: 'Oswald';
}

.register {
  padding: 16px 50px;
  font-size: 20px;
  color: #fff;
  border: 1px solid #fff;
  background: none;
  border-radius: 12px;
  cursor: pointer;
}

.wrap__register {
  padding: 100px 424px 102px 70px;
}

.wrap__register p {
  margin-top: 25px;
}

.wrap__register button {
  margin-top: 83px;
}

.phone__img {
  position: absolute;
  top: 0;
  right: 60px;
}

.catalog {
  font-size: 32px;
  margin-bottom: 5rem;
}


</style>
