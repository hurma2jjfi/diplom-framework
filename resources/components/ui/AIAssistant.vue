<template>
  <div v-if="aiEnabled" class="ai-assistant" :class="{ 'ai-active': visible }" @mouseenter="cancelHide" @mouseleave="startHideTimer">
    <transition name="assistant-fade-slide">
      <div v-if="visible" class="ai-bubble assistant-blur-bg" role="alert" aria-live="polite">
        <div class="ai-message" v-html="displayedMessage"></div>
        <div v-if="showTyping" class="typing-indicator" aria-hidden="true">
          <span></span><span></span><span></span>
        </div>
        <div class="ai-actions" v-if="actions.length">
          <button v-for="(action, i) in actions" :key="i" @click="onActionClick(action)" type="button">
            {{ action.label }}
          </button>
        </div>
        <!-- Кнопка микрофона -->
        <div class="ai-mic-container">
          <button class="ai-mic" :class="{ listening }" @click="toggleListening" :aria-pressed="listening" aria-label="Голосовой ввод">
            <svg width="24" height="24" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10" :fill="listening ? '#0078d4' : '#eee'" />
              <rect x="10" y="7" width="4" height="8" rx="2" :fill="listening ? '#fff' : '#888'" />
              <rect x="11" y="15" width="2" height="3" rx="1" :fill="listening ? '#fff' : '#888'" />
            </svg>
          </button>
          <span v-if="listening" class="ai-mic-hint">Говорите...</span>
        </div>
        <transition-group name="toast" tag="div" class="toast-container" aria-live="assertive" aria-atomic="true">
          <div v-for="toast in toasts" :key="toast.id" class="toast-message" role="alert">
            {{ toast.text }}
            <button class="toast-close" @click="removeToast(toast.id)" aria-label="Закрыть уведомление">×</button>
          </div>
        </transition-group>
        <button class="assistant-close" @click="visible = false" aria-label="Закрыть">×</button>
      </div>
    </transition>
  </div>
</template>


<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';

const greetings = [
  "👋 Привет! Я помогу подобрать идеальную машину. Используйте фильтры сверху.",
  "Здравствуйте! Готов помочь вам найти машину мечты.",
  "Добро пожаловать! Я подберу для вас лучший авто-вариант."
];
const idlePrompts = [
  "Если нужна помощь - просто спросите!",
  "Могу подсказать, как пользоваться фильтрами.",
  "Если что-то не понятно, я всегда рядом!"
];

const props = defineProps({
  filters: { type: Object, default: () => ({}) },
  loading: { type: Boolean, default: false },
  carsCount: { type: Number, default: 0 },
  error: { type: String, default: '' },
});

const visible = ref(false);
const fullMessage = ref(greetings[0]);
const displayedMessage = ref('');
const showTyping = ref(false);
const typingSpeed = ref(40);

const actions = ref([]);
const toasts = ref([]);
let hideTimeout = null;
let typingTimeout = null;
let toastId = 0;
let idleTimeout = null;

// === Голосовой ввод ===
const listening = ref(false);
let recognition = null;
let recognitionActive = false;
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition || null;

if (SpeechRecognition) {
  recognition = new SpeechRecognition();
  recognition.lang = 'ru-RU';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;

  recognition.onstart = () => {
    listening.value = true;
    recognitionActive = true;
  };
  recognition.onend = () => {
    listening.value = false;
    recognitionActive = false;
  };
  recognition.onerror = (event) => {
    addToast('Ошибка распознавания: ' + event.error);
    listening.value = false;
    recognitionActive = false;
  };
  recognition.onresult = (event) => {
    listening.value = false;
    recognitionActive = false;
    const transcript = event.results[0][0].transcript.trim();
    if (transcript) {
      handleUserSpeech(transcript);
    }
  };
}

function toggleListening() {
  if (!recognition) {
    addToast('Голосовой ввод не поддерживается вашим браузером');
    return;
  }
  if (recognitionActive) {
    recognition.stop();
    listening.value = false;
    recognitionActive = false;
  } else {
    recognition.start();
  }
}

function handleUserSpeech(text) {
  addToast('Вы сказали: ' + text);

  const lower = text.toLowerCase();
  if (lower.includes('привет') || lower.includes('здравств')) {
    showMessage('Привет! Чем могу помочь?');
  } else if (lower.includes('подбери') || lower.includes('машин')) {
    showMessage('Конечно! Используйте фильтры сверху, чтобы выбрать параметры автомобиля.');
  } else if (lower.includes('фильтр') || lower.includes('сброс')) {
    showMessage('Сбрасываю фильтры...', [
      { label: 'Сбросить фильтры', onClick: () => window.location.reload(), response: 'Фильтры сброшены.', toast: 'Фильтры успешно сброшены!' }
    ]);
  } else if (lower.includes('спасибо')) {
    showMessage('Пожалуйста! Если нужна помощь - обращайтесь.');
  } else if (lower.includes('помощь') || lower.includes('что делать')) {
    showMessage('Я могу помочь подобрать машину по параметрам. Просто скажите, что вас интересует!');
  } else {
    showMessage('Извините, я пока понимаю только простые команды. Попробуйте по-другому или используйте фильтры.');
  }
}

function speakText(text) {
  if (!('speechSynthesis' in window)) return;
  let cleanText = text.replace(/[\u{1F300}-\u{1FAFF}\u200D\uFE0F]/gu, '');
  cleanText = cleanText.replace(/([.,!?])\s*/g, '$1 [пауза] ');
  window.speechSynthesis.cancel();
  const utterance = new SpeechSynthesisUtterance(cleanText.replace(/\[пауза\]/g, ''));
  utterance.lang = 'ru-RU';
  utterance.rate = 0.93 + Math.random() * 0.07;
  utterance.pitch = 1.08 + Math.random() * 0.12;
  let voices = window.speechSynthesis.getVoices();
  if (!voices.length) {
    window.speechSynthesis.onvoiceschanged = () => {
      voices = window.speechSynthesis.getVoices();
      setVoiceAndSpeak(voices, utterance);
    };
  } else {
    setVoiceAndSpeak(voices, utterance);
  }
}
function setVoiceAndSpeak(voices, utterance) {
  const preferredVoices = voices.filter(v => v.lang.startsWith('ru'));
  const voice = preferredVoices.find(v => /Yandex|Anna|Google/i.test(v.name)) || preferredVoices[0] || voices[0];
  if (voice) utterance.voice = voice;
  window.speechSynthesis.speak(utterance);
}

async function typeMessage(text) {
  visible.value = true;
  showTyping.value = true;
  displayedMessage.value = '';
  clearTimeout(typingTimeout);

  const tmpDiv = document.createElement('div');
  tmpDiv.innerHTML = text;
  const plainText = tmpDiv.textContent || tmpDiv.innerText || '';

  let index = 0;
  while (index < plainText.length) {
    displayedMessage.value = escapeHtml(plainText.slice(0, index + 1));
    const delay = typingSpeed.value + Math.floor(Math.random() * 30 - 10);
    index++;
    await new Promise(r => typingTimeout = setTimeout(r, delay));
  }
  displayedMessage.value = text;
  showTyping.value = false;
  startHideTimer();
  speakText(plainText);
}

function startIdlePrompt() {
  clearTimeout(idleTimeout);
  idleTimeout = setTimeout(() => {
    showMessage(idlePrompts[Math.floor(Math.random() * idlePrompts.length)]);
  }, 20000);
}
function cancelIdlePrompt() {
  clearTimeout(idleTimeout);
}

function showMessage(newMessage, newActions = []) {
  fullMessage.value = newMessage;
  actions.value = newActions;
  typeMessage(newMessage);
  cancelIdlePrompt();
  startIdlePrompt();
}
function startHideTimer() {
  clearTimeout(hideTimeout);
  hideTimeout = setTimeout(() => {
    visible.value = false;
    actions.value = [];
  }, 8000);
}
function cancelHide() {
  clearTimeout(hideTimeout);
}
function onActionClick(action) {
  if (action.onClick) action.onClick();
  if (action.toast) {
    addToast(action.toast);
  } else {
    showMessage(action.response || 'Вы выбрали: ' + action.label);
  }
}
function addToast(text) {
  const id = ++toastId;
  toasts.value.push({ id, text });
  setTimeout(() => removeToast(id), 4000);
}
function removeToast(id) {
  toasts.value = toasts.value.filter(t => t.id !== id);
}
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
function getFilterSummary(filters) {
  if (!filters) return '';
  const active = Object.entries(filters)
    .filter(([_, v]) => v)
    .map(([k, v]) => {
      switch (k) {
        case 'brand': return `марка <b>${v}</b>`;
        case 'model': return `модель <b>${v}</b>`;
        case 'city': return `город <b>${v}</b>`;
        case 'color': return `цвет <b>${v}</b>`;
        case 'year': return `год <b>${v}</b>`;
        case 'transmission': return `трансмиссия <b>${v}</b>`;
        case 'fuel_type': return `топливо <b>${v}</b>`;
        case 'seats': return `<b>${v}</b> мест`;
        case 'status': return `статус <b>${v}</b>`;
        default: return '';
      }
    })
    .filter(Boolean);
  return active.length ? 'Вы выбрали: ' + active.join(', ') + '.' : '';
}

// === AI ассистент свич ===
const aiEnabled = ref(true);

function updateAIEnabled(val) {
  aiEnabled.value = val;
  if (!aiEnabled.value) {
    visible.value = false;
  }
  localStorage.setItem('aiEnabled', aiEnabled.value);
}

function onAISwitchEvent(e) {
  updateAIEnabled(e.detail);
}

// === Слежение за фильтрами и состоянием ===
watch(
  () => [
    props.filters ?? {},
    props.loading ?? false,
    props.carsCount ?? 0,
    props.error ?? ''
  ],
  ([filters, loading, carsCount, error]) => {
    if (error) {
      showMessage(`⚠️ <b>Ошибка:</b> ${error}`);
      return;
    }
    if (loading) {
      showMessage('🔄 Подбираю машины по вашим фильтрам...');
      return;
    }
    const summary = getFilterSummary(filters);
    if (carsCount === 0) {
      showMessage(summary
        ? `😕 Нет машин по вашим фильтрам.<br>${summary} Попробуйте изменить параметры.`
        : '😕 Нет доступных машин. Попробуйте позже!');
    } else if (summary) {
      showMessage(`✅ Найдено <b>${carsCount}</b> машин.<br>${summary}`, [
        { label: 'Сбросить фильтры', onClick: () => window.location.reload(), response: 'Фильтры сброшены.', toast: 'Фильтры успешно сброшены!' },
        { label: 'Подробнее', onClick: () => addToast('Здесь будет подробная информация'), response: 'Показываю подробности...' },
      ]);
    } else {
      showMessage(`🚗 В вашем городе доступно <b>${carsCount}</b> машин.<br>Используйте фильтры для поиска!`, [
        { label: 'Помощь', onClick: () => addToast('Вы можете использовать фильтры для поиска.'), response: 'Чем могу помочь?' }
      ]);
    }
  },
  { immediate: true, deep: true }
);

// === Монтирование и размонтирование ===
onMounted(() => {
  const saved = localStorage.getItem('aiEnabled');
  aiEnabled.value = saved === null ? true : saved === 'true';
  window.addEventListener('ai-switch', onAISwitchEvent);

  showMessage(greetings[Math.floor(Math.random() * greetings.length)]);
  startIdlePrompt();
});

onUnmounted(() => {
  clearTimeout(hideTimeout);
  clearTimeout(typingTimeout);
  clearTimeout(idleTimeout);
  if (recognition) recognition.abort();
  window.removeEventListener('ai-switch', onAISwitchEvent);
});
</script>


<style scoped>
.ai-assistant {
  position: fixed;
  left: 50%;
  bottom: 32px;
  transform: translateX(-50%);
  z-index: 1000;
  pointer-events: none;
  max-width: 350px;
  user-select: none;
}
.ai-bubble {
  background: rgba(255,255,255,0.38);
  border-radius: 18px;
  box-shadow:
    0 8px 32px 0 rgba(31,38,135,0.18), /* исходная тень */
    0 0 15px 5px rgba(255, 255, 255, 0.6); /* добавленное свечение */
  padding: 16px 20px;
  min-width: 260px;
  max-width: 330px;
  pointer-events: auto;
  cursor: default;
  user-select: text;
  position: relative;
  overflow: hidden;
  border: 1.5px solid rgba(255,255,255,0.22);
  backdrop-filter: blur(14px) saturate(160%);
  -webkit-backdrop-filter: blur(18px) saturate(160%);
  animation: none;
}

.ai-bubble:hover {
  box-shadow: 0 12px 32px 0 rgba(31,38,135,0.28);
}
.assistant-blur-bg {
  /* для совместимости, если вдруг понадобится отдельный слой */
}
.ai-message {
  font-size: 14px;
  color: #ffffff;
  line-height: 14px;
  white-space: pre-wrap;
  text-shadow: 0 1px 2px rgba(255,255,255,0.12);
}
.typing-indicator {
  display: flex;
  align-items: center;
  margin-top: 8px;
  height: 18px;
}
.typing-indicator span {
  display: inline-block;
  width: 6px;
  height: 6px;
  margin-right: 4px;
  background: #ffffff;
  border-radius: 50%;
  opacity: 0.4;
  animation: blink 1.4s infinite;
}
.typing-indicator span:nth-child(2) {
  animation-delay: 0.2s;
}
.typing-indicator span:nth-child(3) {
  animation-delay: 0.4s;
}
.ai-actions {
  margin-top: 12px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.ai-actions button {
  background: #F46767;
  border: none;
  color: white;
  padding: 6px 14px;
  border-radius: 20px;
  cursor: pointer;
  font-weight: 600;
  font-size: 0.9em;
  transition: background-color 0.3s;
}
.ai-actions button:hover {
  background: #f15b5b;
}
.ai-mic-container {
  margin-top: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}
.ai-mic {
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  outline: none;
  border-radius: 50%;
  transition: box-shadow 0.2s;
  box-shadow: 0 0 0 0 rgba(0,120,212,0.3);
}
.ai-mic.listening {
  box-shadow: 0 0 0 4px rgba(0,120,212,0.15);
  animation: mic-pulse 1.5s infinite;
}
@keyframes mic-pulse {
  0% { box-shadow: 0 0 0 4px rgba(0,120,212,0.15);}
  70% { box-shadow: 0 0 0 12px rgba(0,120,212,0.10);}
  100% { box-shadow: 0 0 0 4px rgba(0,120,212,0.15);}
}
.ai-mic-hint {
  font-size: 0.9em;
  color: #0078d4;
  user-select: none;
}
.toast-container {
  position: absolute;
  bottom: 100%;
  right: 0;
  margin-bottom: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-width: 320px;
  pointer-events: auto;
  user-select: none;
  z-index: 1100;
}
.toast-message {
  background: #0078d4;
  color: white;
  padding: 10px 16px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 120, 212, 0.6);
  font-size: 0.9em;
  position: relative;
  overflow: hidden;
  opacity: 1;
  transition: opacity 0.3s ease;
  user-select: text;
}
.toast-close {
  position: absolute;
  top: 2px;
  right: 6px;
  background: transparent;
  border: none;
  color: white;
  font-size: 14px;
  cursor: pointer;
  font-weight: bold;
  line-height: 1;
  padding: 0;
  user-select: none;
}

/* --- Новая анимация появления как в Telegram --- */
.assistant-fade-slide-enter-from,
.assistant-fade-slide-leave-to {
  opacity: 0;
  transform: translateY(40px) scale(0.97);
  filter: blur(8px);
}
.assistant-fade-slide-enter-active,
.assistant-fade-slide-leave-active {
  transition:
    opacity 0.38s cubic-bezier(.33,1.02,.58,1),
    transform 0.38s cubic-bezier(.33,1.02,.58,1),
    filter 0.33s cubic-bezier(.33,1.02,.58,1);
}
.assistant-fade-slide-enter-to,
.assistant-fade-slide-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1);
  filter: blur(0);
}

@keyframes blink {
  0%, 80%, 100% { opacity: 0.4; }
  40% { opacity: 1; }
}
.toast-enter-from, .toast-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
.toast-enter-active, .toast-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

/* Кнопка закрытия */
.assistant-close {
  position: absolute;
  top: 8px;
  right: 10px;
  background: none;
  border: none;
  font-size: 1.3rem;
  color: #ffffff;
  cursor: pointer;
  z-index: 2;
  padding: 0;
  line-height: 1;
  transition: color 0.2s;
}
.assistant-close:hover {
  color: #d33;
}
</style>
