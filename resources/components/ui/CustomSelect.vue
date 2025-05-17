<template>
  <div class="tg-select" :class="{ open: isOpen }" tabindex="0" @blur="isOpen=false">
    <div class="tg-select__selected" @click="toggleDropdown">
      <span>
        <template v-if="showImg && selectedOption && selectedOption.img">
          <img :src="selectedOption.img" class="brand-thumb" alt="" />
        </template>
        <template v-if="showColorDot && selectedOption && selectedOption.colorCode">
          <span class="color-dot" :style="{ backgroundColor: selectedOption.colorCode }"></span>
        </template>
        {{ selectedLabel }}
      </span>
      <svg class="tg-select__arrow" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M7 10l5 5 5-5z"/></svg>
    </div>
    <transition name="tg-select-fade">
      <ul v-if="isOpen" class="tg-select__dropdown">
        <li
          v-for="option in options"
          :key="option.value"
          :class="{ selected: option.value === modelValue }"
          @click="selectOption(option.value)"
        >
          <template v-if="showImg && option.img">
            <img :src="option.img" class="brand-thumb" alt="" />
          </template>
          <template v-if="showColorDot && option.colorCode">
            <span class="color-dot" :style="{ backgroundColor: option.colorCode }"></span>
          </template>
          {{ option.label }}
        </li>
      </ul>
    </transition>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue';

const props = defineProps({
  modelValue: [String, Number],
  options: { type: Array, required: true },
  placeholder: { type: String, default: 'Выбрать...' },
  showColorDot: { type: Boolean, default: false },
  showImg: { type: Boolean, default: false },
});
const emit = defineEmits(['update:modelValue']);

const isOpen = ref(false);

function toggleDropdown() { isOpen.value = !isOpen.value; }
function selectOption(val) { emit('update:modelValue', val); isOpen.value = false; }

const selectedOption = computed(() => props.options.find(opt => opt.value === props.modelValue));
const selectedLabel = computed(() => selectedOption.value ? selectedOption.value.label : props.placeholder);

function handleClickOutside(event) {
  if (!event.target.closest('.tg-select')) isOpen.value = false;
}
watch(isOpen, open => {
  if (open) document.addEventListener('mousedown', handleClickOutside);
  else document.removeEventListener('mousedown', handleClickOutside);
});
</script>

<style scoped>
.brand-thumb {
  width: 26px;
  height: 26px;
  object-fit: contain;
  border-radius: 4px;
  margin-right: 8px;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  flex-shrink: 0;
  border: 1px solid #eee;
}
.tg-select {
  position: relative;
  user-select: none;
  width: 100%;
  min-width: 120px;
  outline: none;
}
.tg-select__selected {
  background: #23272b;
  color: #fff;
  border-radius: 10px;
  padding: 10px 36px 10px 14px;
  cursor: pointer;
  font-size: 15px;
  border: 1.5px solid #23272b;
  transition: border 0.2s;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.tg-select.open .tg-select__selected {
  border: 1.5px solid #ff0b8f;
}
.tg-select__arrow {
  margin-left: 10px;
  transition: transform 0.3s;
}
.tg-select.open .tg-select__arrow {
  transform: rotate(180deg);
}
.tg-select__dropdown {
  position: absolute;
  left: 0;
  top: 110%;
  z-index: 10;
  background: #23272b;
  border-radius: 10px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.12);
  margin: 0;
  padding: 8px 0;
  width: 100%;
  list-style: none;
  max-height: 220px;
  overflow-y: auto;

  /* Кастомный скроллбар */
  scrollbar-width: thin;               /* Firefox */
  scrollbar-color: #636363 transparent; /* Firefox */
}

/* Chrome, Edge, Safari */
.tg-select__dropdown::-webkit-scrollbar {
  width: 6px;
}
.tg-select__dropdown::-webkit-scrollbar-track {
  background: transparent;
  border-radius: 10px;
}
.tg-select__dropdown::-webkit-scrollbar-thumb {
  background-color: #2c2c2c;
  border-radius: 10px;
  border: 2px solid transparent;
  background-clip: content-box;
  transition: background-color 0.3s;
}
.tg-select__dropdown::-webkit-scrollbar-thumb:hover {
  background-color: #131313;
}

@keyframes tg-select-slide {
  from { opacity: 0; transform: translateY(-8px);}
  to { opacity: 1; transform: translateY(0);}
}
.tg-select__dropdown li {
  padding: 10px 16px;
  color: #fff;
  cursor: pointer;
  transition: background 0.15s;
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
}
.tg-select__dropdown li.selected,
.tg-select__dropdown li:hover {
  background: #1d1c1d;
  color: #fff;
}
.tg-select-fade-enter-active,
.tg-select-fade-leave-active {
  transition: opacity 0.18s;
}
.tg-select-fade-enter-from,
.tg-select-fade-leave-to {
  opacity: 0;
}

/* Кружок цвета */
.color-dot {
  width: 18px; /* Увеличил размер */
  height: 18px;
  border-radius: 50%;
  display: inline-block;
  flex-shrink: 0; /* Не сжимается */
  box-shadow: 0 0 4px rgba(0,0,0,0.4); /* Лёгкая тень для объёма */
  background-clip: content-box;
}
</style>
