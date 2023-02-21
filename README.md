# Shop layout

<b>Данные для входа в приложение admin : admin</b>

<div>  
<details>
  <summary><h2>Demo video</h2></summary>

<b>Анимация заполнености поля | Cекретность поля | Ограничение ввода данных</b>

video | video
:-: | :-:
<video src='https://user-images.githubusercontent.com/75171952/220326960-8b2f2620-39c9-4f3b-bc7b-ba76228a7923.mov' /> | <video src='https://user-images.githubusercontent.com/75171952/220326983-9e30e89c-9a16-4d83-8af8-7708de7c0fbf.mov'/>
 
<b>Логика каталога и корзины (с сохраненем данных на бэке)</b>

video | video | video
:-: | :-: | :-: 
<video src='https://user-images.githubusercontent.com/75171952/220327028-471a4041-b130-4351-b3de-d7f533802310.mov'/> | <video src='https://user-images.githubusercontent.com/75171952/220327035-26f56dae-28ca-4943-9355-706abcac7140.mov'/> | <video src='https://user-images.githubusercontent.com/75171952/220357574-c80b2b64-4149-485d-8963-c7450c03bce3.mov'/> 

<b>Логика оплаты корзины (изображения берутся из интернета)</b>

video | video | video
:-: | :-: | :-:
<video src='https://user-images.githubusercontent.com/75171952/220327077-325de91b-92e1-43ff-88ce-f1176a1fe198.mov'/> | <video src='https://user-images.githubusercontent.com/75171952/220327089-29df7a4e-81a8-4a76-827a-b0efdb459550.mov'/> | <video src='https://user-images.githubusercontent.com/75171952/220327092-0dbe3bca-7608-4884-a6e5-1bbcbe29d525.mov'/> 

<b>Кастомный слайдер изображений</b>

<video src='https://user-images.githubusercontent.com/75171952/220327105-e974a01f-ab09-4017-889d-150e79ac7010.mov'/> 
</details>
<img height="600" alt="image" src="https://user-images.githubusercontent.com/75171952/220354008-d568e79b-8ca9-445d-8254-830f48e77f72.png"> <img height="600" alt="image" src="https://user-images.githubusercontent.com/75171952/220359296-d3dbdb6d-2075-426e-acc1-d59d5add18e2.png"> <img height="600" alt="image" src="https://user-images.githubusercontent.com/75171952/220354216-bbe1db07-30ea-45f1-8081-0ab4b5649402.png">
<img height="600" alt="image" src="https://user-images.githubusercontent.com/75171952/220358209-56849cb2-1d3e-46f1-9c2e-b279414585f1.png"> <img height="600" alt="image" src="https://user-images.githubusercontent.com/75171952/220358020-5d304ca5-d70a-448a-87bf-a0c1096c5ea4.png"> <img height="600" alt="image" src="https://user-images.githubusercontent.com/75171952/220358408-136604b3-6bc7-47ef-aaab-d11d474a8325.png">
</div>

# Описание

Данное приложение является демонстрационной версией онлайн магазина товаров.

Работает на лично написанном мок-сервере и использует в себе следующий функционал: 
- авторизация
- регистрация 
- каталог товаров
- информация о товаре и работа с ней
- корзина товаров и работа с ней 

Ограничения мок сервера:
- содержит данные только для одного пользователя. 
- запрос регистрации отправляет всегда одинаковый ответ, если все поля заполнены.

Добавленные товары сохраняются на сервере, что позволяет пользователям продолжить работу с приложением в любое время. В приложениии используется debounce функция для накапливания запросов добавления товара.

Для оплаты корзины была реализована логика с использованием веб-вью. Пользователю нужно просмотреть три фотографии с собаками из интернета, чтобы оплатить покупки.

Приложение включает анимации, которые делают работу с ним более интерактивной и приятной. Также в приложении предусмотрена проверка на заполненность полей и ограничения, что позволяет пользователям избежать ошибок при вводе данных. 

Написан свой кастомный слайдер изображений товаров. Заглушки изображений используются, чтобы сервер не вышел за лимиты бесплатного хостинга.

В качестве примера добавил аналитику Firebase и UI тесты.

В приложении неи спользуется Keychain для хранения токена авторизации, чтобы продемонстрировать все функциональные возможности приложения.

# Технологии
* UIKit (Interface programmatically | Auto Layout Constraint)
* Viper
* [Самописный мок сервер (Vapor)](https://github.com/kecha-the-frog/vapor-shopMock)
* URLSession
* Google Firebase Analytics (в качестве примера покрыто 10%)
* UITests (в качестве примера покрыто 10%)
