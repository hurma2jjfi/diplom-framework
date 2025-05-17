<template>
    <div class="orders">
      <h1>Заявки</h1>
  
      <div v-if="loading" class="spinner-wrapper">
        <div class="lds-spinner">
          <div></div><div></div><div></div><div></div><div></div>
          <div></div><div></div><div></div><div></div><div></div>
          <div></div><div></div>
        </div>
      </div>
  
      <div v-if="error" class="error">{{ error }}</div>
      <div v-if="success" class="success">{{ success }}</div>
  
      <table v-if="!loading && bookings.length" class="orders-table">
        <thead>
          <tr>
            <th>Автомобиль</th>
            <th>Период</th>
            <th>Цена (₽)</th>
            <th>Статус</th>
            <th>Серия В/П</th>
            <th>Номер В/П</th>
            <th>Дата создания</th>
            <th>Действия</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="booking in bookings" :key="booking.id">
            <td>{{ booking.car?.model || 'Автомобиль удалён' }}</td>
            <td>{{ formatDate(booking.start_time) }} - {{ formatDate(booking.end_time) }}</td>
            <td>{{ Number(booking.total_price).toFixed(2) }}</td>
            <td>
           <span :class="['status-badge', statusClass(booking.status)]">
           {{ booking.status }}
            </span>
            </td>
            <td>{{ booking.license_series }}</td>
            <td>{{ booking.license_number }}</td>
            <td>{{ formatDate(booking.created_at) }}</td>
            <td>
                <div class="guttons">
              <button
                v-if="canCancel(booking)"
                @click="confirmCancel(booking.id)"
                class="btn-cancel"
                :disabled="loadingAction === booking.id"
              >
                {{ loadingAction === booking.id && actionType === 'cancel' ? 'Отмена...' : 'Отменить' }}
              </button>
              <button
                @click="confirmDelete(booking.id)"
                class="btn-delete"
                :disabled="loadingAction === booking.id"
              >
                {{ loadingAction === booking.id && actionType === 'delete' ? 'Удаление...' : 'Удалить' }}
              </button></div>
            </td>
          </tr>
        </tbody>
      </table>
  
      <div v-if="!loading && bookings.length === 0">У вас пока нет заявок.</div>
  
      <!-- Простое кастомное окно подтверждения -->
      <div v-if="modalVisible" class="modal-overlay">
        <div class="modal">
          <p>{{ modalMessage }}</p>
          <div class="modal-buttons">
            <button @click="modalConfirm" class="btn-confirm">Да</button>
            <button @click="modalCancel" class="btn-cancel">Нет</button>
          </div>
        </div>
      </div>
    </div>



  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    name: 'Orders',
    data() {
      return {
        bookings: [],
        loading: false,
        error: null,
        success: null,
        loadingAction: null, // id заявки, для которой сейчас идет действие
        actionType: null, // 'cancel' или 'delete'
        modalVisible: false,
        modalMessage: '',
        modalResolve: null,
        modalReject: null,
        modalBookingId: null,
      };
    },
    methods: {
        statusClass(status) {
    if (!status) return '';
    const s = status.trim().toLowerCase();
    if (s === 'в ожидании') return 'status-pending';
    if (s === 'отклонено') return 'status-rejected';
    if (s === 'подтверждено') return 'status-confirmed';
    return 'status-default';
  },
      canCancel(booking) {
        if (!booking.status) return false;
        return booking.status.trim().toLowerCase() === 'в ожидании';
      },
  
      async fetchBookings() {
        this.loading = true;
        this.error = null;
        this.success = null;
  
        try {
          const token = localStorage.getItem('token');
          const response = await axios.get('/api/car-bookings/user', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
  
          this.bookings = response.data;
        } catch (e) {
          this.error = e.response?.data?.message || 'Ошибка при загрузке заявок';
        } finally {
          this.loading = false;
        }
      },
  
      formatDate(dateStr) {
        if (!dateStr) return '-';
        const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
        return new Date(dateStr).toLocaleString('ru-RU', options);
      },
  
      // Кастомное окно подтверждения
      confirmAction(message) {
        this.modalMessage = message;
        this.modalVisible = true;
        return new Promise((resolve, reject) => {
          this.modalResolve = resolve;
          this.modalReject = reject;
        });
      },
  
      modalConfirm() {
        this.modalVisible = false;
        if (this.modalResolve) this.modalResolve(true);
      },
  
      modalCancel() {
        this.modalVisible = false;
        if (this.modalReject) this.modalReject(false);
      },
  
      async confirmCancel(id) {
        try {
          await this.confirmAction('Вы действительно хотите отменить эту заявку?');
          await this.cancelBooking(id);
        } catch {
          // Отмена подтверждения - ничего не делаем
        }
      },
  
      async confirmDelete(id) {
        try {
          await this.confirmAction('Вы действительно хотите удалить эту заявку? Это действие необратимо.');
          await this.deleteBooking(id);
        } catch {
          // Отмена подтверждения - ничего не делаем
        }
      },
  
      async cancelBooking(id) {
  this.loadingAction = id;
  this.actionType = 'cancel';
  this.error = null;
  this.success = null;

  try {
    const token = localStorage.getItem('token');
    await axios.post(`/api/car-bookings/${id}/cancel`, null, {
      headers: { Authorization: `Bearer ${token}` },
    });
    this.success = 'Заявка успешно отменена';
    await this.fetchBookings();
    window.dispatchEvent(new CustomEvent('orders-updated')); // <-- вот здесь
  } catch (e) {
    this.error = e.response?.data?.error || 'Ошибка при отмене заявки';
  } finally {
    this.loadingAction = null;
    this.actionType = null;
  }
},

async deleteBooking(id) {
  this.loadingAction = id;
  this.actionType = 'delete';
  this.error = null;
  this.success = null;

  try {
    const token = localStorage.getItem('token');
    await axios.delete(`/api/car-bookings/${id}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    this.success = 'Заявка успешно удалена';
    await this.fetchBookings();
    window.dispatchEvent(new CustomEvent('orders-updated')); // <-- и здесь
  } catch (e) {
    this.error = e.response?.data?.error || 'Ошибка при удалении заявки';
  } finally {
    this.loadingAction = null;
    this.actionType = null;
  }
},

    },
    mounted() {
      this.fetchBookings();
    },
  };
  </script>
  
  <style scoped>
  .status-badge {
  display: inline-block;
  min-width: 90px;
  padding: 6px 18px;
  font-size: 15px;
  font-weight: 600;
  border-radius: 18px;
  text-align: center;
  letter-spacing: 0.02em;
  user-select: none;
  box-shadow: 0 2px 8px rgba(0,0,0,0.10);
  border: 1.5px solid transparent;
  transition: background 0.2s, color 0.2s;
}

.status-pending {
  background: rgba(255, 191, 0, 0.15);
  color: #ffbf00;
  border-color: #ffbf00;
}

.status-rejected {
  background: rgba(255, 80, 80, 0.13);
  color: #ff4c4c;
  border-color: #ff4c4c;
}

.status-confirmed {
  background: rgba(44, 222, 120, 0.13);
  color: #2ecc40;
  border-color: #2ecc40;
}

.status-default {
  background: #343a40;
  color: #e5e5e5;
  border-color: #444950;
}

.spinner-wrapper {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80px;
}
.lds-spinner {
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
  background: #ffffff; /* Темный цвет для темной темы */
}
.lds-spinner div:nth-child(1) { transform: rotate(0deg); animation-delay: -1.1s; }
.lds-spinner div:nth-child(2) { transform: rotate(30deg); animation-delay: -1s; }
.lds-spinner div:nth-child(3) { transform: rotate(60deg); animation-delay: -0.9s; }
.lds-spinner div:nth-child(4) { transform: rotate(90deg); animation-delay: -0.8s; }
.lds-spinner div:nth-child(5) { transform: rotate(120deg); animation-delay: -0.7s; }
.lds-spinner div:nth-child(6) { transform: rotate(150deg); animation-delay: -0.6s; }
.lds-spinner div:nth-child(7) { transform: rotate(180deg); animation-delay: -0.5s; }
.lds-spinner div:nth-child(8) { transform: rotate(210deg); animation-delay: -0.4s; }
.lds-spinner div:nth-child(9) { transform: rotate(240deg); animation-delay: -0.3s; }
.lds-spinner div:nth-child(10) { transform: rotate(270deg); animation-delay: -0.2s; }
.lds-spinner div:nth-child(11) { transform: rotate(300deg); animation-delay: -0.1s; }
.lds-spinner div:nth-child(12) { transform: rotate(330deg); animation-delay: 0s; }
@keyframes lds-spinner {
  0% { opacity: 1; }
  100% { opacity: 0; }
}

/* Основные стили для контейнера заказов */
.orders {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  color: #e5e5e5;
}

.guttons {
    display: flex;
    gap: 20px;
}

h1 {
    margin-bottom: 2rem;
}

/* Кнопка удаления */
.btn-delete {
  background-color: transparent;
  border: 2px solid #555a66;
  color: #aebac1;
  padding: 10px 28px;
  border-radius: 12px;
  cursor: pointer;
  font-weight: 600;
  font-size: 15px;
  transition: border-color 0.3s ease, color 0.3s ease;
}

.btn-delete:hover {
  border-color: #ff0000;
  color: #ff0000;
}

/* Таблица заказов */
.orders-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #1e1e1e;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 0 10px rgba(0,0,0,0.7);
}

.orders-table th,
.orders-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #2c2c2c;
}

.orders-table th {
  background-color: #2a2a2a;
  color: #aebac1;
  font-weight: 600;
  text-transform: uppercase;
}

.orders-table tr:hover {
  background-color: #333840;
}

/* Сообщения об ошибках и успехе */
.error {
  color: #ff6b6b;
  margin-bottom: 15px;
  font-weight: 600;
  text-align: center;
}

.success {
  color: #2ecc40;
  margin-bottom: 15px;
  font-weight: 600;
  text-align: center;
}

/* Модальное окно */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(18, 18, 18, 0.85);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10000;
  padding: 20px;
}

/* Само модальное окно */
.modal {
  background-color: #242526;
  color: #e5e5e5;
  border-radius: 16px;
  max-width: 420px;
  width: 100%;
  box-shadow: 0 8px 24px rgba(0,0,0,0.8);
  padding: 30px 25px;
  text-align: center;
  font-size: 16px;
  user-select: none;
  font-weight: 500;
}

/* Кнопки в модальном окне */
.modal-buttons {
  margin-top: 25px;
  display: flex;
  justify-content: center;
  gap: 16px;
}

/* Кнопка подтверждения */
.btn-confirm {
  background-color: #2f80ed; /* Синий Telegram стиль */
  border: none;
  color: white;
  padding: 10px 28px;
  border-radius: 12px;
  cursor: pointer;
  font-weight: 700;
  font-size: 15px;
  box-shadow: 0 4px 12px rgba(47, 128, 237, 0.6);
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.btn-confirm:hover {
  background-color: #1c5edb;
  box-shadow: 0 6px 16px rgba(28, 94, 219, 0.8);
}

/* Кнопка отмены */
.btn-cancel {
  background-color: transparent;
  border: 2px solid #555a66;
  color: #aebac1;
  padding: 10px 28px;
  border-radius: 12px;
  cursor: pointer;
  font-weight: 600;
  font-size: 15px;
  transition: border-color 0.3s ease, color 0.3s ease;
}

.btn-cancel:hover {
  border-color: #2f80ed;
  color: #2f80ed;
}

/* Кнопки в неактивном состоянии */
.btn-cancel:disabled {
  border-color: #3a3f47;
  color: #555a66;
  cursor: not-allowed;
}

.btn-confirm:disabled {
  background-color: #6a8bd5;
  box-shadow: none;
  cursor: not-allowed;
}

  </style>
  