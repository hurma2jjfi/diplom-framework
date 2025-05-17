-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Май 17 2025 г., 12:30
-- Версия сервера: 8.0.30
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `diplom`
--

-- --------------------------------------------------------

--
-- Структура таблицы `cars`
--

CREATE TABLE `cars` (
  `id` bigint UNSIGNED NOT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `license_plate` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year` int DEFAULT NULL,
  `transmission` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fuel_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seats` int NOT NULL DEFAULT '4',
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `status` enum('Доступен','Занят','В ремонте','Зарезервирован') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Доступен',
  `price_per_hour` decimal(8,2) NOT NULL DEFAULT '0.00',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `cars`
--

INSERT INTO `cars` (`id`, `brand`, `model`, `license_plate`, `color`, `year`, `transmission`, `fuel_type`, `seats`, `city`, `latitude`, `longitude`, `status`, `price_per_hour`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 'Toyota', 'Camry', 'A123BC77', 'Белый', 2019, 'Автомат', 'Бензин', 5, 'Москва', '55.7558000', '37.6173000', 'Доступен', '500.00', '/storage/cars/toyota_camry.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(2, 'Mazda', 'RX-7', 'B456DE77', 'Серый', 2018, 'Механика', 'Бензин', 5, 'Санкт-Петербург', '59.9343000', '30.3351000', 'Доступен', '450.00', '/storage/cars/rx7.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(4, 'Audi', 'RS-7', 'D012HI77', 'Синий', 2017, 'Механика', 'Бензин', 5, 'Екатеринбург', '56.8389000', '60.6057000', 'Доступен', '470.00', '/storage/cars/audi-rs7.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(6, 'Audi', 'RS6', 'F678LM77', 'Серая', 2018, 'Механика', 'Бензин', 5, 'Нижний Новгород', '56.2965000', '43.9361000', 'Доступен', '430.00', '/storage/cars/audi-rs6.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(7, 'Bmw', 'M3', 'G901NO77', 'Зелёный', 2021, 'Автомат', 'Бензин', 5, 'Самара', '53.1959000', '50.1000000', 'Доступен', '600.00', '/storage/cars/bmwm3.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(8, 'Mazda', 'CX-5', 'H234PQ77', 'Красный', 2020, 'Автомат', 'Бензин', 5, 'Ростов-на-Дону', '47.2357000', '39.7015000', 'Доступен', '580.00', '/storage/cars/mazda-cx-5.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(9, 'Audi', 'A4', 'I567RS77', 'Черный', 2019, 'Автомат', 'Бензин', 5, 'Уфа', '54.7388000', '55.9721000', 'Доступен', '750.00', '/storage/cars/audi_a4.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20'),
(10, 'BMW', 'X3', 'J890TU77', 'Синий', 2021, 'Автомат', 'Бензин', 5, 'Краснодар', '45.0355000', '38.9753000', 'Доступен', '800.00', '/storage/cars/bmw_x3.jpg', '2025-05-16 11:55:20', '2025-05-16 11:55:20');

-- --------------------------------------------------------

--
-- Структура таблицы `car_images`
--

CREATE TABLE `car_images` (
  `id` bigint UNSIGNED NOT NULL,
  `car_id` bigint UNSIGNED NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `car_images`
--

INSERT INTO `car_images` (`id`, `car_id`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 7, '/storage/cars/bmwm3dop.jpg', '2025-05-17 09:09:11', '2025-05-17 09:15:04'),
(2, 7, '/storage/cars/bekha.jpg', '2025-05-17 09:09:39', '2025-05-17 12:25:15'),
(3, 7, '/storage/cars/bmwm3three.jpg', '2025-05-17 09:09:48', '2025-05-17 09:26:59');

-- --------------------------------------------------------

--
-- Структура таблицы `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_05_13_090122_add_is_verified_to_users_table', 2),
(6, '2025_05_13_090825_add_email_verification_token_to_users_table', 3),
(7, '2025_05_16_114706_create_cars_table', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '3f3d254e797d062d8afc26b73d10ae1de52306a12f8a5c29c36382561bc16eb9', '[\"*\"]', NULL, NULL, '2025-05-12 08:02:48', '2025-05-12 08:02:48'),
(2, 'App\\Models\\User', 2, 'auth_token', '42acf2cb4392db219cf8db4bca78b3ab194ca472631d01a673688a13791febeb', '[\"*\"]', NULL, NULL, '2025-05-12 08:04:39', '2025-05-12 08:04:39'),
(3, 'App\\Models\\User', 2, 'auth_token', 'b388db6590ba847f50571fc722e0c13fca03342da260e82894018c3b52b8ff43', '[\"*\"]', NULL, NULL, '2025-05-12 08:15:57', '2025-05-12 08:15:57'),
(4, 'App\\Models\\User', 2, 'auth_token', 'ab3dee1293a0370aca9e384f5efc4bf3175799cf1fcfe092f024aa951172cd92', '[\"*\"]', NULL, NULL, '2025-05-12 08:16:05', '2025-05-12 08:16:05'),
(5, 'App\\Models\\User', 2, 'auth_token', '6d1bfca980c5e8613b2d6704ff286f52b450e10d4f552092cd67b44582e7d28b', '[\"*\"]', NULL, NULL, '2025-05-12 08:16:09', '2025-05-12 08:16:09'),
(6, 'App\\Models\\User', 2, 'auth_token', '19c389923723048c3accc663d79699c4fc1f5d71d5269cfaaaa516716d99eb0d', '[\"*\"]', NULL, NULL, '2025-05-12 08:16:16', '2025-05-12 08:16:16'),
(7, 'App\\Models\\User', 2, 'auth_token', '1a5231925af103e3bde95c4752f7a7d06947861fbd519ec686d005e53a66b760', '[\"*\"]', NULL, NULL, '2025-05-12 08:18:26', '2025-05-12 08:18:26'),
(8, 'App\\Models\\User', 2, 'auth_token', '4e1f4bfa90513fca90f546c6c3bbbf2398981bb3dae97c60d62b8c12baeaf5a3', '[\"*\"]', NULL, NULL, '2025-05-12 08:20:34', '2025-05-12 08:20:34'),
(9, 'App\\Models\\User', 2, 'auth_token', 'e51c685118017ac584f0da6a7364d22561a30c11a33d1f147dc4b004d4024200', '[\"*\"]', NULL, NULL, '2025-05-12 08:21:06', '2025-05-12 08:21:06'),
(10, 'App\\Models\\User', 2, 'auth_token', '02c3bbc551ee1b2e3c5f0a6cffb8279ed753ec8821ff70011aae7dc16b22d8c2', '[\"*\"]', NULL, NULL, '2025-05-12 08:21:15', '2025-05-12 08:21:15'),
(11, 'App\\Models\\User', 2, 'auth_token', '346e4fd47852efdf6afa1e139bf9565d26fe9911dd42ede9b240307cf9bfae64', '[\"*\"]', NULL, NULL, '2025-05-12 08:21:42', '2025-05-12 08:21:42'),
(12, 'App\\Models\\User', 2, 'auth_token', 'b7d393eccbc2a804e31eccc314b8bb9a5b9104228958855ef06241f0455ac874', '[\"*\"]', NULL, NULL, '2025-05-12 08:23:13', '2025-05-12 08:23:13'),
(13, 'App\\Models\\User', 2, 'auth_token', 'cc0ba131da4c4ed125448f980b045b45e317e392d1e7e913bb612792b8375127', '[\"*\"]', NULL, NULL, '2025-05-12 08:23:48', '2025-05-12 08:23:48'),
(14, 'App\\Models\\User', 1, 'auth_token', 'f459cae2349ba28c03a2d430dd296f4a58636556e97aab283b2cdaf9ddb38730', '[\"*\"]', NULL, NULL, '2025-05-12 08:23:57', '2025-05-12 08:23:57'),
(15, 'App\\Models\\User', 1, 'auth_token', 'efe10ae37ec84a2c516997c4a1c4a444f969c80d1465e2fd25a3cfe1f96043c2', '[\"*\"]', NULL, NULL, '2025-05-12 08:24:27', '2025-05-12 08:24:27'),
(17, 'App\\Models\\User', 1, 'auth_token', 'e5d06c04af517b0c95c46e2c5a7091ebbd637ab103976768d387f7ee1283bf7e', '[\"*\"]', '2025-05-12 08:32:21', NULL, '2025-05-12 08:30:53', '2025-05-12 08:32:21'),
(18, 'App\\Models\\User', 1, 'auth_token', '10ccbd22338480c6e6dbf8c01d094cb1e67ea25950eb880939cbb10a82716e94', '[\"*\"]', '2025-05-12 08:34:36', NULL, '2025-05-12 08:32:48', '2025-05-12 08:34:36'),
(19, 'App\\Models\\User', 1, 'auth_token', '3be9a48cb9f24bbea55480ec769ba2b3753ed272e80dc68d661d1e26c17f0fd6', '[\"*\"]', '2025-05-12 08:35:55', NULL, '2025-05-12 08:35:01', '2025-05-12 08:35:55'),
(20, 'App\\Models\\User', 1, 'auth_token', 'be90ad17bcfecfc7b65c601a2ea24bc96735fa3d057c287860dba810d48cbd6e', '[\"*\"]', '2025-05-12 08:37:38', NULL, '2025-05-12 08:36:01', '2025-05-12 08:37:38'),
(21, 'App\\Models\\User', 1, 'auth_token', '917ab6876f8f79ae33b4d6142afc672bbec3298fbae32adff459535595886c00', '[\"*\"]', '2025-05-13 02:16:20', NULL, '2025-05-12 08:37:41', '2025-05-13 02:16:20'),
(22, 'App\\Models\\User', 1, 'auth_token', '74192eb00937d81cd945b55031e4823276f8912ddfafa63ba94fb38c896b3c02', '[\"*\"]', '2025-05-13 02:23:52', NULL, '2025-05-13 02:16:29', '2025-05-13 02:23:52'),
(23, 'App\\Models\\User', 1, 'auth_token', '8296aa78aef0b91bd79f6a4c0add95256d305a28e4e67305d1798c6573daae32', '[\"*\"]', NULL, NULL, '2025-05-13 02:29:37', '2025-05-13 02:29:37'),
(24, 'App\\Models\\User', 1, 'auth_token', '54fc5aa2e7f87971a1daf1764a40f71df8ad8f26767df149166a5fad5169448e', '[\"*\"]', NULL, NULL, '2025-05-13 02:29:39', '2025-05-13 02:29:39'),
(25, 'App\\Models\\User', 1, 'auth_token', '53f909f7178b4ec66488f32b7094757a4eb1d06da368e96ed023a5e8581385af', '[\"*\"]', NULL, NULL, '2025-05-13 02:29:40', '2025-05-13 02:29:40'),
(26, 'App\\Models\\User', 1, 'auth_token', 'a45783ce2c02b770017b93b1fe052a64b3f3e931dfc66f229ce381d40de14771', '[\"*\"]', '2025-05-13 02:29:47', NULL, '2025-05-13 02:29:43', '2025-05-13 02:29:47'),
(27, 'App\\Models\\User', 3, 'auth_token', '865ad13e993690f65c58d9f6d7a9e7d93cbf3d1ad0653e91583fe7bcbfe92c24', '[\"*\"]', '2025-05-13 02:30:06', NULL, '2025-05-13 02:30:05', '2025-05-13 02:30:06'),
(28, 'App\\Models\\User', 3, 'auth_token', '13f9964d89f2039bf39758c11b219a9830046b36898b734728e97174f0b36875', '[\"*\"]', '2025-05-13 02:30:22', NULL, '2025-05-13 02:30:08', '2025-05-13 02:30:22'),
(29, 'App\\Models\\User', 3, 'auth_token', 'd957aa2717bfb5e807ac4e8d4ea26e028fdaa2c7e9e6ce84550d6a457abb8caf', '[\"*\"]', NULL, NULL, '2025-05-13 02:33:11', '2025-05-13 02:33:11'),
(30, 'App\\Models\\User', 3, 'auth_token', '5d525e94767b298bc5a87add1ddfdce986f421c574f2742602e77955dc245153', '[\"*\"]', NULL, NULL, '2025-05-13 02:33:12', '2025-05-13 02:33:12'),
(31, 'App\\Models\\User', 3, 'auth_token', '16851c19c1db727557929f64a4c078981cae0355e159eb153a8736d549577487', '[\"*\"]', NULL, NULL, '2025-05-13 02:33:13', '2025-05-13 02:33:13'),
(32, 'App\\Models\\User', 3, 'auth_token', '36a32d9c5c85c63ba879126bdcc4612ecd8c9e32b99bfa3f89882d779b2e85b5', '[\"*\"]', '2025-05-13 02:34:54', NULL, '2025-05-13 02:33:14', '2025-05-13 02:34:54'),
(33, 'App\\Models\\User', 3, 'auth_token', '568b174e8294d1fa724cfb8ceaf2b4228077555d535c0364343aa318fd7b4133', '[\"*\"]', '2025-05-13 02:35:00', NULL, '2025-05-13 02:35:00', '2025-05-13 02:35:00'),
(34, 'App\\Models\\User', 4, 'auth_token', 'fbf8da73dfd3b473f570a73c689f75b3274c4de86db4cb0df683a81bd57d8ff6', '[\"*\"]', '2025-05-13 02:38:12', NULL, '2025-05-13 02:35:37', '2025-05-13 02:38:12'),
(35, 'App\\Models\\User', 4, 'auth_token', 'd440b5aa932883e41a5720a4ece4234e33ad758cdf2da5929345e5cd47238ec6', '[\"*\"]', '2025-05-13 02:38:17', NULL, '2025-05-13 02:38:15', '2025-05-13 02:38:17'),
(36, 'App\\Models\\User', 4, 'auth_token', 'c806a55dc9b78516b066f30b5f7dcc17bd08ac12820e9a804100b05a79340c7b', '[\"*\"]', '2025-05-13 02:39:42', NULL, '2025-05-13 02:39:41', '2025-05-13 02:39:42'),
(37, 'App\\Models\\User', 4, 'auth_token', '547dda3d20b5e75d3c111cd33225337150544c0d59508a1a32aa848b12f0a52a', '[\"*\"]', '2025-05-13 02:44:33', NULL, '2025-05-13 02:43:38', '2025-05-13 02:44:33'),
(38, 'App\\Models\\User', 4, 'auth_token', '70bf57e99028369715c321a9453d7a3788baef6a414a66c18dd3637082cc2beb', '[\"*\"]', '2025-05-13 02:47:58', NULL, '2025-05-13 02:44:52', '2025-05-13 02:47:58'),
(39, 'App\\Models\\User', 4, 'auth_token', 'e951648c5d6e59aa67c1878294449509d4602c0b25f1c1be196fdc49c1f88b90', '[\"*\"]', '2025-05-13 02:51:07', NULL, '2025-05-13 02:49:54', '2025-05-13 02:51:07'),
(40, 'App\\Models\\User', 4, 'auth_token', 'c5b17ef052ad39553ff451fbe75f868dd54f1eff56cdf0e86e593099791741c2', '[\"*\"]', '2025-05-13 02:57:15', NULL, '2025-05-13 02:51:37', '2025-05-13 02:57:15'),
(41, 'App\\Models\\User', 4, 'auth_token', '20459ad641eb91a47d4e812d30dcd8ba95a94cf92e07087ebaa8e675270f6a0b', '[\"*\"]', '2025-05-13 03:05:07', NULL, '2025-05-13 02:58:38', '2025-05-13 03:05:07'),
(42, 'App\\Models\\User', 4, 'auth_token', 'faed74290ed35487e61eafec5c705dc39b0711ef04ab08f718b32bbe37d2f951', '[\"*\"]', '2025-05-13 03:09:50', NULL, '2025-05-13 03:09:50', '2025-05-13 03:09:50'),
(43, 'App\\Models\\User', 4, 'auth_token', 'c53d37541c57c5463d75c23f83ca9ab0902e4eb847bdafe69de4cc8a58cebfd8', '[\"*\"]', '2025-05-13 03:11:40', NULL, '2025-05-13 03:10:34', '2025-05-13 03:11:40'),
(44, 'App\\Models\\User', 4, 'auth_token', '84f41716b5c58e2d874e13ce408f7c03c0f00560e82a87fcafb882439bef07df', '[\"*\"]', '2025-05-13 03:17:02', NULL, '2025-05-13 03:14:40', '2025-05-13 03:17:02'),
(45, 'App\\Models\\User', 4, 'auth_token', '0c27b87e42414dc9740f7ee77696fbeabb92bb6670d0a2a704884e3a39a7966d', '[\"*\"]', '2025-05-13 03:17:48', NULL, '2025-05-13 03:17:48', '2025-05-13 03:17:48'),
(46, 'App\\Models\\User', 4, 'auth_token', '1c95f261a6faa55b93327ab0994b6df2203cc6ea61fdd9ea68f6b5c8815c57e2', '[\"*\"]', '2025-05-13 03:37:16', NULL, '2025-05-13 03:18:57', '2025-05-13 03:37:16'),
(47, 'App\\Models\\User', 4, 'auth_token', '18d2092b585c64574999fc41a8957a030fef889f3fac9a2e2f004a399deacdd1', '[\"*\"]', '2025-05-13 03:49:02', NULL, '2025-05-13 03:40:11', '2025-05-13 03:49:02'),
(48, 'App\\Models\\User', 4, 'auth_token', '507ca6b33d108de5b3c07711c9e8fa1ba69bb300e0ce21fa262d54826299c662', '[\"*\"]', '2025-05-13 03:51:03', NULL, '2025-05-13 03:50:01', '2025-05-13 03:51:03'),
(49, 'App\\Models\\User', 4, 'auth_token', '728994e8f6ffd0f02130df9f82abbde4d7fb28c6242d6943f2d44a38f0d4eb10', '[\"*\"]', '2025-05-13 03:57:11', NULL, '2025-05-13 03:51:14', '2025-05-13 03:57:11'),
(50, 'App\\Models\\User', 5, 'auth_token', 'd337c981f708236b150655353bb752ba50d1917064c5391c9a8bf7d6420e5788', '[\"*\"]', '2025-05-13 03:59:30', NULL, '2025-05-13 03:59:30', '2025-05-13 03:59:30'),
(51, 'App\\Models\\User', 5, 'auth_token', 'e8bb61bb2aed691a7679e24257a9e12f10e961e637c6c4eba0716c08a82a6cb8', '[\"*\"]', '2025-05-13 03:59:38', NULL, '2025-05-13 03:59:34', '2025-05-13 03:59:38'),
(52, 'App\\Models\\User', 6, 'auth_token', '526f34daafe140fa4db1f3d816b7ad1f9ab49313fa6c2fbfa9e1dd5699ce28f9', '[\"*\"]', '2025-05-13 04:01:09', NULL, '2025-05-13 04:01:08', '2025-05-13 04:01:09'),
(53, 'App\\Models\\User', 6, 'auth_token', 'e878f447107b560b7f79b8365b31960cd59646ebb01e18c75d94eaedc015a419', '[\"*\"]', '2025-05-13 04:01:41', NULL, '2025-05-13 04:01:16', '2025-05-13 04:01:41'),
(54, 'App\\Models\\User', 7, 'auth_token', 'fa84c53656f0365935f6cb989accfb2b38c973fdf7cd379234a1d39dfa98e119', '[\"*\"]', '2025-05-13 04:02:57', NULL, '2025-05-13 04:01:56', '2025-05-13 04:02:57'),
(55, 'App\\Models\\User', 7, 'auth_token', '9128e6323bfa4da04135f86f129e0f48d7b3a2a753f989b8b98fb80dd8ee0a4e', '[\"*\"]', '2025-05-13 04:05:38', NULL, '2025-05-13 04:05:37', '2025-05-13 04:05:38'),
(56, 'App\\Models\\User', 7, 'auth_token', '1f2e97add1738a14a6b0875ab4b4ad53d92e1045d0dce9824981ad1840c926a8', '[\"*\"]', '2025-05-13 04:06:53', NULL, '2025-05-13 04:06:50', '2025-05-13 04:06:53'),
(57, 'App\\Models\\User', 7, 'auth_token', 'ebd6881e8950eafe757e8c660959ddd7ee0859b7d00481c7553197c50ea271ad', '[\"*\"]', '2025-05-13 04:07:03', NULL, '2025-05-13 04:06:57', '2025-05-13 04:07:03'),
(58, 'App\\Models\\User', 7, 'auth_token', '4ae92f5bfa6b76e62f0752b721d1bdc5892edeb18727378b7708e4d40f9a1c84', '[\"*\"]', '2025-05-13 04:07:42', NULL, '2025-05-13 04:07:06', '2025-05-13 04:07:42'),
(59, 'App\\Models\\User', 7, 'auth_token', 'bfa46e2e27f5a8765c3348ea1c0ec7935b6a4ebad5ad0e6baa975968cca64165', '[\"*\"]', '2025-05-13 04:07:50', NULL, '2025-05-13 04:07:50', '2025-05-13 04:07:50'),
(60, 'App\\Models\\User', 8, 'auth_token', '6903e6ec4c6c5b1a1efa7c54a8d143965553fd2d84a49c3b04d64f4bed8e2528', '[\"*\"]', '2025-05-13 04:48:54', NULL, '2025-05-13 04:09:21', '2025-05-13 04:48:54'),
(61, 'App\\Models\\User', 8, 'auth_token', '3f2a74eeff78490e0eacb551ccf7fdbd7bd6dbcdaf096a286a5cd2a2ccf7e857', '[\"*\"]', '2025-05-13 05:41:31', NULL, '2025-05-13 04:48:58', '2025-05-13 05:41:31'),
(62, 'App\\Models\\User', 8, 'auth_token', 'fdf640181d4cbe5970bf35c4f52527ec1f9e3ebf5b0f129bc54b983fa7a3f586', '[\"*\"]', '2025-05-13 06:39:10', NULL, '2025-05-13 05:43:47', '2025-05-13 06:39:10'),
(63, 'App\\Models\\User', 8, 'auth_token', '26e4be39f30c1cd6a8f6f9cff81e646e0d0a6e7a6bde89d8e09570da3b693433', '[\"*\"]', '2025-05-13 06:39:28', NULL, '2025-05-13 06:39:16', '2025-05-13 06:39:28'),
(64, 'App\\Models\\User', 8, 'auth_token', '11f650021e2d670647006e4cc6a2ec1951506add1568ada183b3548c200395fb', '[\"*\"]', '2025-05-13 06:57:38', NULL, '2025-05-13 06:43:35', '2025-05-13 06:57:38'),
(65, 'App\\Models\\User', 11, 'auth_token', '689e0e9d2ae55340dc3bd5bd6eedf994ebb8e26d586c7cf0e29ff018c11bdc8e', '[\"*\"]', '2025-05-13 07:32:57', NULL, '2025-05-13 07:02:40', '2025-05-13 07:32:57'),
(66, 'App\\Models\\User', 11, 'auth_token', 'f07d4c72eb377d3925340e54958b2ad23f18ea185b6170055f1d578c8a5ba172', '[\"*\"]', '2025-05-13 08:03:53', NULL, '2025-05-13 07:35:00', '2025-05-13 08:03:53'),
(67, 'App\\Models\\User', 11, 'auth_token', 'f15e4bf41dd64abab247947c566c6432da5ff206cb1d176ec9072b9ed6e80b38', '[\"*\"]', '2025-05-16 04:07:03', NULL, '2025-05-16 04:05:44', '2025-05-16 04:07:03'),
(68, 'App\\Models\\User', 12, 'auth_token', '002b31c465b107679da1606588f87eb9fe5fd4162dbb13780f90e8ec8f59fe07', '[\"*\"]', '2025-05-16 04:08:48', NULL, '2025-05-16 04:08:32', '2025-05-16 04:08:48'),
(69, 'App\\Models\\User', 12, 'auth_token', 'f4787cb6ce621a46d20b3c09b24691a1f535a4f475a0a0beb424a533ef377609', '[\"*\"]', '2025-05-16 04:11:07', NULL, '2025-05-16 04:09:45', '2025-05-16 04:11:07'),
(70, 'App\\Models\\User', 13, 'auth_token', '5f6fcd27530e6f9cb975598f756be5bcc0861a64750aac2011fdfb9c96fa7ccc', '[\"*\"]', '2025-05-16 04:13:14', NULL, '2025-05-16 04:11:42', '2025-05-16 04:13:14'),
(71, 'App\\Models\\User', 11, 'auth_token', 'ad0968c3eeb22d8a0e99a4a299e12c779b98000702d8a5b8597ee3ca9cdfdeae', '[\"*\"]', '2025-05-16 04:14:14', NULL, '2025-05-16 04:13:36', '2025-05-16 04:14:14'),
(72, 'App\\Models\\User', 13, 'auth_token', 'f4a9f6dc65fa38571428c7781bc0a44b963d041bc659c11b644af4012b8e4b3c', '[\"*\"]', '2025-05-16 04:15:32', NULL, '2025-05-16 04:14:25', '2025-05-16 04:15:32'),
(73, 'App\\Models\\User', 11, 'auth_token', '5667634ae5feda4aca32dd585e8f83250bd714d4c60b209af034e2f332fc2635', '[\"*\"]', '2025-05-16 04:31:18', NULL, '2025-05-16 04:15:39', '2025-05-16 04:31:18'),
(74, 'App\\Models\\User', 11, 'auth_token', '7a72341864c53efeddd01ab895c993f27bb8eb5a14aecb0a17690d2bba6fd510', '[\"*\"]', '2025-05-16 04:31:50', NULL, '2025-05-16 04:31:48', '2025-05-16 04:31:50'),
(75, 'App\\Models\\User', 11, 'auth_token', '86ec78903680d21cb7f6ff24e53bb8c68c9494412b2af37e6dbba23676b1e242', '[\"*\"]', '2025-05-16 04:35:19', NULL, '2025-05-16 04:34:44', '2025-05-16 04:35:19'),
(76, 'App\\Models\\User', 11, 'auth_token', '704f9240047a88703f2ebe34915a045613bd4f4185bf3efcfd50d8461aae6c02', '[\"*\"]', '2025-05-16 04:37:18', NULL, '2025-05-16 04:35:23', '2025-05-16 04:37:18'),
(77, 'App\\Models\\User', 11, 'auth_token', 'f9d11a5ac4cd0b0dee339387eb811ba105521b448912ff817cad0439c4db20ae', '[\"*\"]', '2025-05-16 04:37:26', NULL, '2025-05-16 04:37:19', '2025-05-16 04:37:26'),
(78, 'App\\Models\\User', 11, 'auth_token', '5ce0c02b713565dfe792b7de830aa23c115ab06d80615e826b5404384c79486f', '[\"*\"]', '2025-05-16 04:59:08', NULL, '2025-05-16 04:37:54', '2025-05-16 04:59:08'),
(79, 'App\\Models\\User', 13, 'auth_token', '98646e3d11d8f748fba83405e43e424f6acf8964ec56b75ab07fcc618ed176a1', '[\"*\"]', '2025-05-16 04:59:36', NULL, '2025-05-16 04:59:26', '2025-05-16 04:59:36'),
(80, 'App\\Models\\User', 11, 'auth_token', '393ba4fc637268ce66a8c8e20066df22a67a8a6ad44887cc243f931233bb327e', '[\"*\"]', '2025-05-16 06:50:55', NULL, '2025-05-16 05:01:51', '2025-05-16 06:50:55'),
(81, 'App\\Models\\User', 11, 'auth_token', '8373420debb0c1893d5887a2b6d84e8f076dc6c1ed4ea56e56673d22ab2977f5', '[\"*\"]', NULL, NULL, '2025-05-16 06:52:41', '2025-05-16 06:52:41'),
(82, 'App\\Models\\User', 11, 'auth_token', '89e29ceeccdbb67d51631341dc2e8061a4f389df90089ad9c413eac46e5bbed2', '[\"*\"]', '2025-05-16 06:52:56', NULL, '2025-05-16 06:52:53', '2025-05-16 06:52:56'),
(83, 'App\\Models\\User', 11, 'auth_token', '6c0a68d2359e825bae65f561a8dfe32acff48ae3c8a78242fc05170a8f303fb4', '[\"*\"]', '2025-05-16 06:53:07', NULL, '2025-05-16 06:53:03', '2025-05-16 06:53:07'),
(84, 'App\\Models\\User', 11, 'auth_token', '8b1b6118f710bdd9630ae4ade0f65cfeb5a4087651a924b9db6fffd2ebaf23c5', '[\"*\"]', '2025-05-16 06:55:44', NULL, '2025-05-16 06:55:44', '2025-05-16 06:55:44'),
(85, 'App\\Models\\User', 11, 'auth_token', '4274068f95adb40d44e4bb96ee93769efdda9a080116ece7c6a99cbaf7215e41', '[\"*\"]', '2025-05-16 06:56:06', NULL, '2025-05-16 06:56:04', '2025-05-16 06:56:06'),
(86, 'App\\Models\\User', 11, 'auth_token', '24fda28bf3fb0406627f2f9b267fea83632cac08dedcf49d9151aece8dedcf20', '[\"*\"]', '2025-05-16 07:14:29', NULL, '2025-05-16 06:56:11', '2025-05-16 07:14:29'),
(87, 'App\\Models\\User', 11, 'auth_token', '3aaa2fabeb4328dfe1e8d706954cbe871772e2f4f23e65258432aa9312139fb2', '[\"*\"]', '2025-05-16 07:37:58', NULL, '2025-05-16 07:14:40', '2025-05-16 07:37:58'),
(88, 'App\\Models\\User', 11, 'auth_token', '874ef633b0d19286d20e87a0d917ff5fe3e583c275b601103da8ab6d4d39c70d', '[\"*\"]', '2025-05-16 08:37:15', NULL, '2025-05-16 07:38:25', '2025-05-16 08:37:15'),
(89, 'App\\Models\\User', 1, 'auth_token', '4d12408f671590ee3af32dbf0ce696908aedc708663f8d5ac31c8dc7aef2bc59', '[\"*\"]', '2025-05-16 16:25:54', NULL, '2025-05-16 15:28:38', '2025-05-16 16:25:54'),
(90, 'App\\Models\\User', 1, 'auth_token', '99f1de50a98ac317f59bb2b5b35029070c7858b8e1f49bd1f06ddce5d7590e47', '[\"*\"]', '2025-05-17 02:53:13', NULL, '2025-05-16 16:35:34', '2025-05-17 02:53:13'),
(91, 'App\\Models\\User', 1, 'auth_token', 'aceb85679d93eea8f580556ff9d9a08c0acfdbbc905f85c396aa6f4a121ba9a9', '[\"*\"]', '2025-05-17 05:59:09', NULL, '2025-05-17 02:54:25', '2025-05-17 05:59:09'),
(92, 'App\\Models\\User', 1, 'auth_token', '1aab74d2ffd2727094823b3ff37cf7c486ef73f88d4ad6352eeda6ca7136b042', '[\"*\"]', '2025-05-17 06:25:19', NULL, '2025-05-17 06:11:34', '2025-05-17 06:25:19');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `email_verification_token` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `avatar_url`, `is_verified`, `email_verification_token`, `phone`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Kirill', 'kirik@mail.ru', NULL, '$2y$10$cJliuQa6Sqdu8UV9bFVdRO0/UWeQYw8s0lnip9iQtc6VLGSDhvVtO', '/storage/avatars/TD1cPdhegiHwsUGdhcQYXybx7eOJBtjFURuKTIN6.png', 1, NULL, NULL, NULL, '2025-05-12 08:02:48', '2025-05-17 01:08:32'),
(2, 'kirill', 'ki2rik@mail.ru', NULL, '$2y$10$/xte9F7rr1DbFaLDvnYCm.pwPEeRwkfbFOK13IRHIkuFfBIbAub2q', '/storage/avatars/xQFyrR7OnoytpaPRtBF0oa4RcIky41HLnGxQhomG.jpg', 0, NULL, NULL, NULL, '2025-05-12 08:04:39', '2025-05-12 08:04:39'),
(4, 'Паша', 'kirik21@mail.ru', NULL, '$2y$10$Shyd6tYhj/qh8tTtPvX2ResieIgKG1/3BBXtqbLu7CFmqWeV6uIRu', '/storage/avatars/8diBBPCXcPwaBnmiLnlgjaKCgAXQI7zDCyYpEaDD.png', 0, NULL, NULL, NULL, '2025-05-13 02:35:37', '2025-05-13 02:35:37'),
(5, 'Kirill Afanasev', 'kirik2551@mail.ru', NULL, '$2y$10$fPhjsAYCfZs0A7l8qF.y1OVqzGIxLq/H3liKyocWGxItzTUMMt7R.', '/storage/avatars/dZsMjVLs77bF35u5CtLkwYpF1x6rahyFKDwD1MCh.png', 0, NULL, NULL, NULL, '2025-05-13 03:59:30', '2025-05-13 03:59:30'),
(6, 'марк', 'mark1@mail.ru', NULL, '$2y$10$TUca6AERC07KcYTsqVARh.eK4UDpP1cxaqbivYP4BcLV0yW/RXOtG', '/storage/avatars/7FS6J1QkRweCuRqjISkQuafNgb53aagAjAyiB4lA.png', 0, NULL, '89093730622', NULL, '2025-05-13 04:01:08', '2025-05-13 04:01:08'),
(7, 'марк2', 'mark11@mail.ru', NULL, '$2y$10$UiSBxSg0nLarHcvxYee3R.6IdwB9428t1y7cbT5qvuX/VcjmFeIQ6', '/storage/avatars/Rx2Xj3H82UGYVPxYjFV92HmoKCtQRCZ2hs6jAloe.jpg', 0, NULL, '89093730622', NULL, '2025-05-13 04:01:56', '2025-05-13 04:01:56'),
(8, 'Kirill Afanasev', 'mark112@mail.ru', NULL, '$2y$10$3tZOkPxpINA51Bd5/sWbAeSfFPnyCz40PXER1ruIaOqachO9Iu0EW', '/storage/avatars/jPQno7LjF2lv6NGmLi6fw9jgtUL1T5S4nibpwSF6.jpg', 0, 'te50XW3YhGFOzUefvooZBvQkYLV2FRGPTkSjN4tN2VKRcM70UwGPSwyiLvMgemqq', '+7-909-393-99-39', NULL, '2025-05-13 04:09:21', '2025-05-13 05:11:29'),
(9, 'Kirill Afanasev тест', 'mark2112@mail.ru', NULL, '$2y$10$kmwabAU2vdYo4upA4vOa2edMeTni1cs0x.vqAvFHwe94Dj0hOI6ly', '/storage/avatars/T5hOXxVb7C8BixWPGZMtaRqeH3JW7zK4hRFaByJU.jpg', 0, NULL, '+7-909-393-93-99', NULL, '2025-05-13 07:01:42', '2025-05-13 07:01:42'),
(10, 'Kirill Afanasev тест', 'mark112112@mail.ru', NULL, '$2y$10$.0kOe/axUgbailMNSjhyHeU2yD.UCtxtNyJqITM18P4XuHg2DVZES', '/storage/avatars/I92C5fuCXk7fzk1GLMkC6ztfAlahazJ3zEuAgYSR.jpg', 0, NULL, '+7-909-393-93-99', NULL, '2025-05-13 07:01:49', '2025-05-13 07:01:49'),
(11, 'Тест', 'utipov36@gmail.com', NULL, '$2y$10$lv0mC4S4sXKbCpkYsS2UXu.1sDdJbvpSp3KC.G21uxNVD5S9k3xq6', '/storage/avatars/eF1uYZhAR1FuORRK0eTB0ZiYC8B6nqDo0r7rBL0y.jpg', 1, NULL, '+7-909-393-93-80', NULL, '2025-05-13 07:02:38', '2025-05-16 07:51:03');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cars_license_plate_unique` (`license_plate`);

--
-- Индексы таблицы `car_images`
--
ALTER TABLE `car_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `car_id` (`car_id`);

--
-- Индексы таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Индексы таблицы `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Индексы таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cars`
--
ALTER TABLE `cars`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `car_images`
--
ALTER TABLE `car_images`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `car_images`
--
ALTER TABLE `car_images`
  ADD CONSTRAINT `car_images_ibfk_1` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
