<template>
    <footer class="footer">
        <div class="wrapper__footer">
            <nav class="navigation">
                <div class="logo">
                    <img src="../../public/img/logo.svg" alt="Logo">
                </div>
                <ul class="ul">
                    <li><a href="#">Главная</a></li>
                    <li><a href="#">Галерея</a></li>
                    <li><a href="#">О нас</a></li>
                    <li><a href="#">Интерактивная карта</a></li>
                </ul>
                <button class="application__send">Оставить заявку</button>
            </nav>
        </div>
    </footer>
</template>

<script>
export default {

}
</script>

<style>
footer {
  background: #111111;
  width: 100%;
  min-height: 322px;
  color: #fff;
  font-size: 24px;
  margin-top: 6rem;
  padding: 107px 0; /* Убираем горизонтальные паддинги, чтобы не влияли на ширину */
  box-sizing: border-box;

  display: flex;
  justify-content: center; /* Центрируем внутренний контейнер */
  align-items: center;
}

.wrapper__footer {
  max-width: 1200px; /* Уменьшаем максимальную ширину */
  width: 100%;
  margin: 0 20px; /* Добавляем небольшой отступ слева и справа */
  
  display: grid;
  grid-template-columns: 1fr 2fr 1fr; /* 3 колонки: логотип, меню, кнопка */
  align-items: center;
  column-gap: 40px;
  box-sizing: border-box;
}

/* Логотип */
.logo img {
  max-height: 60px;
  display: block;
  justify-self: start; /* Логотип слева */
}

/* Навигация */
.navigation {
  display: contents; /* Чтобы ul и кнопка были в grid */
}

.ul {
  grid-column: 2; /* Меню во второй колонке */
  display: flex;
  justify-content: center;
  gap: 70px;
  padding: 0;
  margin: 0;
  list-style: none;
}

.ul li a {
  color: #fff;
  text-decoration: none;
  font-weight: 500;
  font-size: 18px;
  transition: color 0.3s ease;
}

.ul li a:hover {
  color: #ff0b8f;
}

/* Кнопка */
.application__send {
  grid-column: 3; /* Кнопка в третьей колонке */
  justify-self: end;
  padding: 20px 40px;
  border: none;
  font-size: 20px;
  color: #fff;
  border-radius: 34px;
  background: linear-gradient(to left, #FF0B8F, #F46767);
  cursor: pointer;
  transition: background 0.3s ease;
  white-space: nowrap;
}

.application__send:hover {
  background: linear-gradient(to left, #F46767, #FF0B8F);
}

/* Убираем лишние паддинги */
.logo {
  padding-right: 0;
}


</style>