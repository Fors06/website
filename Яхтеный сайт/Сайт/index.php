<?php

require_once __DIR__ . '/config/config.php';

?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#071b2e">
    <title>Вольный ветер — яхтенная платформа</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Manrope:wght@500;600;700;800&display=swap"
        rel="stylesheet"
    >

    <link
    rel="stylesheet"
    href="assets/css/base.css"
>

    <style>
        :root {
            --ink: #071b2e;
            --ink-2: #0d2940;
            --sea: #0c6274;
            --cyan: #5ed6d5;
            --sand: #f4eee2;
            --paper: #f7f9f8;
            --white: #ffffff;
            --muted: #657783;
            --line: #dce5e7;
            --gold: #d8b36a;

            --shadow: 0 20px 60px rgba(7, 27, 46, 0.12);

            --radius: 24px;
            --radius-sm: 14px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: "DM Sans", sans-serif;
            color: var(--ink);
            background: var(--paper);
            line-height: 1.55;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        button,
        input,
        select {
            font: inherit;
        }

        button {
            cursor: pointer;
        }

        .container {
            width: min(1240px, calc(100% - 40px));
            margin: 0 auto;
        }

        /*  HERO */

        .hero {
            min-height: 790px;
            position: relative;
            overflow: hidden;
            color: #ffffff;

            background:
                linear-gradient(
                    90deg,
                    rgba(4, 20, 33, 0.88) 0%,
                    rgba(4, 20, 33, 0.48) 48%,
                    rgba(4, 20, 33, 0.16) 100%
                ),
                url("https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=2200&q=85")
                center / cover;
        }

        .hero::after {
            content: "";
            position: absolute;
            inset: auto 0 0;
            height: 220px;
            background: linear-gradient(
                transparent,
                var(--paper)
            );
        }

        .hero-inner {
            position: relative;
            z-index: 2;
            padding-top: 190px;
            max-width: 800px;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 8px 13px;
            border-radius: 999px;
            border: 1px solid rgba(255, 255, 255, 0.22);
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: #d9eeee;
        }

        .eyebrow i {
            width: 7px;
            height: 7px;
            background: var(--cyan);
            border-radius: 50%;
            display: block;
        }

        h1,
        h2,
        h3 {
            font-family: Manrope, sans-serif;
            letter-spacing: -0.045em;
        }

        .hero h1 {
            font-size: clamp(48px, 7vw, 88px);
            line-height: 0.98;
            margin: 25px 0 24px;
            max-width: 820px;
        }

        .hero h1 em {
            font-style: normal;
            color: #8ce2df;
        }

        .hero-copy {
            font-size: 19px;
            color: rgba(255, 255, 255, 0.78);
            max-width: 630px;
        }

        .hero-ctas {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 34px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 13px 19px;
            border-radius: 13px;
            font-weight: 700;
            font-size: 14px;
            border: 1px solid transparent;
            transition: 0.2s;
        }

        .btn-primary {
            background: #ffffff;
            color: var(--ink);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.16);
        }

        .btn-glass {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.25);
            color: #ffffff;
            backdrop-filter: blur(12px);
        }

        .btn-glass:hover {
            background: rgba(255, 255, 255, 0.18);
        }

        .hero-meta {
            display: flex;
            gap: 32px;
            margin-top: 58px;
            color: rgba(255, 255, 255, 0.72);
            font-size: 13px;
        }

        .hero-meta strong {
            display: block;
            color: #ffffff;
            font: 700 23px Manrope, sans-serif;
            margin-bottom: 2px;
        }

        /* SEARCH */

        .search-panel {
            position: relative;
            z-index: 5;
            margin-top: -82px;
            background: #ffffff;
            border: 1px solid rgba(7, 27, 46, 0.08);
            border-radius: 20px;
            box-shadow: var(--shadow);
            padding: 14px;
            display: grid;
            grid-template-columns: 1.2fr 1fr 1fr 0.8fr auto;
            gap: 8px;
        }

        .field {
            padding: 11px 13px;
            border: 1px solid var(--line);
            border-radius: 13px;
            background: #fbfcfc;
        }

        .field label {
            display: block;
            font-size: 11px;
            color: var(--muted);
            margin-bottom: 3px;
        }

        .field input,
        .field select {
            width: 100%;
            border: 0;
            background: transparent;
            outline: 0;
            color: var(--ink);
            font-weight: 600;
            font-size: 14px;
        }

        .search-panel .btn {
            background: var(--ink);
            color: #ffffff;
            border-radius: 13px;
            padding-inline: 22px;
        }

        /* SECTIONS*/

        .section {
            padding: 105px 0;
        }

        .section-head {
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 30px;
            margin-bottom: 34px;
        }

        .kicker {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.14em;
            color: var(--sea);
            font-weight: 700;
            margin-bottom: 10px;
        }

        .section h2 {
            font-size: clamp(32px, 4vw, 50px);
            line-height: 1.05;
        }

        .section-intro {
            max-width: 560px;
            color: var(--muted);
            font-size: 16px;
        }

        .text-link {
            font-weight: 700;
            font-size: 14px;
            color: var(--sea);
            white-space: nowrap;
        }

        /* CARDS*/

        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .card {
            background: #ffffff;
            border: 1px solid var(--line);
            border-radius: var(--radius);
            overflow: hidden;
            transition: 0.25s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow);
        }

        .card-media {
            height: 245px;
            position: relative;
            background-size: cover;
            background-position: center;
        }

        .card-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(8px);
            border-radius: 999px;
            padding: 7px 10px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .card-fav {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            border: 0;
            background: rgba(255, 255, 255, 0.88);
        }

        .card-body {
            padding: 21px;
        }

        .card h3 {
            font-size: 21px;
            line-height: 1.15;
            margin-bottom: 8px;
        }

        .card p {
            color: var(--muted);
            font-size: 14px;
        }

        .card-foot {
            display: flex;
            align-items: end;
            justify-content: space-between;
            margin-top: 19px;
            gap: 15px;
        }

        .price {
            font: 800 18px Manrope, sans-serif;
        }

        .price small {
            font: 500 12px "DM Sans", sans-serif;
            color: var(--muted);
        }

        .tag {
            font-size: 11px;
            color: var(--sea);
            background: #eaf7f7;
            padding: 6px 9px;
            border-radius: 8px;
            font-weight: 700;
        }

        /* SCHOOL*/

        .education {
            background: var(--sand);
        }

        .edu-grid {
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 18px;
        }

        .edu-card {
            min-height: 450px;
            border-radius: var(--radius);
            overflow: hidden;
            position: relative;
            color: #ffffff;
            background-size: cover;
            background-position: center;
        }

        .edu-card::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(
                0deg,
                rgba(3, 20, 32, 0.82),
                transparent 65%
            );
        }

        .edu-content {
            position: absolute;
            z-index: 2;
            left: 30px;
            right: 30px;
            bottom: 29px;
        }

        .edu-content h3 {
            font-size: 30px;
            margin-bottom: 7px;
        }

        .edu-content p {
            max-width: 550px;
            color: rgba(255, 255, 255, 0.78);
            font-size: 14px;
        }

        .edu-content .btn {
            margin-top: 18px;
        }

        /* COMMUNITY */

        .market {
            background: var(--ink);
            color: #ffffff;
        }

        .market .kicker {
            color: var(--cyan);
        }

        .market .section-intro {
            color: #9db0bb;
        }

        .market .text-link {
            color: var(--cyan);
        }

        .market-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
        }

        .market-item {
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 18px;
            padding: 22px;
            background: rgba(255, 255, 255, 0.045);
        }

        .market-item .num {
            font: 800 32px Manrope, sans-serif;
            color: var(--cyan);
            margin-bottom: 30px;
        }

        .market-item h3 {
            font-size: 18px;
            margin-bottom: 7px;
        }

        .market-item p {
            color: #9db0bb;
            font-size: 13px;
        }

        .market-item a {
            display: inline-block;
            margin-top: 18px;
            font-size: 13px;
            font-weight: 700;
            color: #ffffff;
        }

        /* MAP*/

        .split {
            display: grid;
            grid-template-columns: 0.85fr 1.15fr;
            gap: 70px;
            align-items: center;
        }

        .map {
            min-height: 540px;
            border-radius: 30px;
            position: relative;
            overflow: hidden;
            background:
                linear-gradient(
                    140deg,
                    rgba(12, 98, 116, 0.18),
                    rgba(255, 255, 255, 0.05)
                ),
                url("https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=1600&q=80")
                center / cover;
            box-shadow: var(--shadow);
        }

        .map-ui {
            position: absolute;
            inset: 18px;
            display: flex;
            justify-content: space-between;
            pointer-events: none;
        }

        .map-panel {
            align-self: flex-start;
            background: rgba(255, 255, 255, 0.93);
            border-radius: 16px;
            padding: 14px;
            min-width: 220px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.13);
        }

        .map-panel b {
            font: 700 14px Manrope, sans-serif;
        }

        .weather {
            display: flex;
            gap: 14px;
            margin-top: 10px;
            font-size: 12px;
            color: var(--muted);
        }

        .pin {
            position: absolute;
            width: 16px;
            height: 16px;
            border: 4px solid #ffffff;
            border-radius: 50%;
            background: var(--sea);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.3);
        }

        .pin.one {
            left: 34%;
            top: 38%;
        }

        .pin.two {
            left: 64%;
            top: 53%;
            background: var(--gold);
        }

        .pin.three {
            left: 73%;
            top: 28%;
        }

        .feature-list {
            display: grid;
            gap: 17px;
            margin-top: 31px;
        }

        .feature {
            display: flex;
            gap: 14px;
            padding-bottom: 17px;
            border-bottom: 1px solid var(--line);
        }

        .feature:last-child {
            border: 0;
        }

        .feature-icon {
            flex: 0 0 42px;
            height: 42px;
            border-radius: 12px;
            background: #e8f5f5;
            color: var(--sea);
            display: grid;
            place-items: center;
        }

        .feature h3 {
            font-size: 16px;
            margin-bottom: 3px;
        }

        .feature p {
            font-size: 13px;
            color: var(--muted);
        }

        /* RACES*/

        .races {
            background: #edf3f2;
        }

        .race-grid {
            display: grid;
            grid-template-columns: 1.25fr 0.75fr;
            gap: 18px;
        }

        .race-list {
            background: #ffffff;
            border: 1px solid var(--line);
            border-radius: 22px;
            overflow: hidden;
        }

        .race-row {
            display: grid;
            grid-template-columns: 86px 1fr auto;
            gap: 18px;
            padding: 20px;
            align-items: center;
            border-bottom: 1px solid var(--line);
        }

        .race-row:last-child {
            border: 0;
        }

        .date-box {
            border-radius: 13px;
            background: var(--ink);
            color: #ffffff;
            text-align: center;
            padding: 9px;
        }

        .date-box b {
            display: block;
            font: 800 22px Manrope, sans-serif;
        }

        .date-box span {
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        .race-row h3 {
            font-size: 17px;
            margin-bottom: 4px;
        }

        .race-row p {
            font-size: 12px;
            color: var(--muted);
        }

        .news-card {
            background: var(--ink);
            color: #ffffff;
            border-radius: 22px;
            padding: 26px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .news-card .date {
            font-size: 11px;
            color: var(--cyan);
            text-transform: uppercase;
            letter-spacing: 0.12em;
        }

        .news-card h3 {
            font-size: 29px;
            line-height: 1.1;
            margin: 15px 0;
        }

        .news-card p {
            font-size: 14px;
            color: #9db0bb;
        }

        /* PLATFORM */

        .community {
            background: #ffffff;
        }

        .community-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .community-card {
            padding: 24px;
            border: 1px solid var(--line);
            border-radius: 20px;
        }

        .avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #dceff0;
            display: grid;
            place-items: center;
            font-weight: 800;
            color: var(--sea);
            margin-bottom: 22px;
        }

        .community-card h3 {
            font-size: 18px;
            margin-bottom: 7px;
        }

        .community-card p {
            font-size: 13px;
            color: var(--muted);
        }

        .community-card .btn {
            margin-top: 20px;
        }

        /* FOOTER*/

        footer {
            background: #041321;
            color: #91a4af;
            padding: 65px 0 28px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: 1.5fr repeat(3, 1fr);
            gap: 40px;
            padding-bottom: 50px;
        }

        footer .brand {
            color: #ffffff;
            margin-bottom: 14px;
        }

        .footer-desc {
            font-size: 13px;
            max-width: 330px;
        }

        footer h4 {
            font: 700 13px Manrope, sans-serif;
            color: #ffffff;
            margin-bottom: 14px;
        }

        footer ul {
            list-style: none;
            display: grid;
            gap: 9px;
            font-size: 13px;
        }

        footer li a:hover {
            color: #ffffff;
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 22px;
            display: flex;
            justify-content: space-between;
            gap: 20px;
            font-size: 12px;
        }

        /* RESPONSIVE */

        @media (max-width: 1000px) {
            .navlinks {
                display: none;
            }

            .menu-btn {
                display: grid;
            }

            .search-panel {
                grid-template-columns: 1fr 1fr;
            }

            .search-panel .btn {
                grid-column: 1 / -1;
            }

            .cards {
                grid-template-columns: 1fr 1fr;
            }

            .market-grid {
                grid-template-columns: 1fr 1fr;
            }

            .split,
            .race-grid,
            .edu-grid {
                grid-template-columns: 1fr;
            }

            .map {
                min-height: 430px;
            }

            .footer-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 650px) {
            .container {
                width: min(100% - 28px, 1240px);
            }

            .nav {
                height: 70px;
            }

            .hero {
                min-height: 720px;
            }

            .hero-inner {
                padding-top: 150px;
            }

            .hero-copy {
                font-size: 16px;
            }

            .hero-meta {
                gap: 20px;
                flex-wrap: wrap;
                margin-top: 38px;
            }

            .hero-meta strong {
                font-size: 19px;
            }

            .search-panel {
                margin-top: -55px;
                grid-template-columns: 1fr;
            }

            .cards,
            .market-grid,
            .community-grid {
                grid-template-columns: 1fr;
            }

            .section {
                padding: 72px 0;
            }

            .section-head {
                display: block;
            }

            .section-head .text-link {
                display: inline-block;
                margin-top: 16px;
            }

            .edu-card {
                min-height: 380px;
            }

            .race-row {
                grid-template-columns: 62px 1fr;
            }

            .race-row .btn {
                display: none;
            }

            .footer-grid {
                grid-template-columns: 1fr;
            }

            .footer-bottom {
                display: block;
            }

            .footer-bottom span {
                display: block;
                margin-top: 7px;
            }
        }
    </style>
</head>

<body>

<?php

require_once __DIR__ . '/includes/header.php';

?>

<main>

    <!-- HERO -->

    <section class="hero">

        <div class="container hero-inner">

            <div class="eyebrow">
                <i></i>
                единая платформа для яхтинга
            </div>

            <h1>
                Твой маршрут.
                <br>
                <em>Твои люди. Твоё море.</em>
            </h1>

            <p class="hero-copy">
                Туры, яхты, экипаж, регаты и навигация —
                всё, что нужно для путешествий по воде,
                в одном цифровом пространстве.
            </p>

            <div class="hero-ctas">
                <a
                    class="btn btn-primary"
                    href="#tours"
                >
                    Найти путешествие →
                </a>

                <a
                    class="btn btn-glass"
                    href="#fleet"
                >
                    Смотреть яхты
                </a>
            </div>

            <div class="hero-meta">

                <div>
                    <strong>120+</strong>
                    маршрутов
                </div>

                <div>
                    <strong>340+</strong>
                    яхт в каталоге
                </div>

                <div>
                    <strong>2 800+</strong>
                    яхтсменов
                </div>

            </div>

        </div>

    </section>

    <!-- SEARCH -->

    <section
        class="container search-panel"
        aria-label="Поиск"
    >

        <div class="field">
            <label>Я хочу</label>

            <select>
                <option>Отправиться в тур</option>
                <option>Арендовать яхту</option>
                <option>Найти экипаж</option>
            </select>
        </div>

        <div class="field">
            <label>Направление</label>

            <input
                type="text"
                placeholder="Греция, Сочи, Байкал..."
            >
        </div>

        <div class="field">
            <label>Когда</label>

            <input type="date">
        </div>

        <div class="field">
            <label>Участники</label>

            <select>
                <option>2 человека</option>
                <option>3 человека</option>
                <option>4 человека</option>
            </select>
        </div>

        <button class="btn">
            Найти
        </button>

    </section>

    <!-- TOURS -->

    <section
        class="section"
        id="tours"
    >

        <div class="container">

            <div class="section-head">

                <div>
                    <div class="kicker">
                        Исследуй воду
                    </div>

                    <h2>
                        Популярные путешествия
                    </h2>
                </div>

                <a
                    class="text-link"
                    href="#"
                >
                    Все туры →
                </a>

            </div>

            <div class="cards">

                <article class="card">

                    <div
                        class="card-media"
                        style="
                            background-image:
                            url('https://images.unsplash.com/photo-1530053969600-caed2596d242?auto=format&fit=crop&w=1000&q=80');
                        "
                    >
                        <span class="card-badge">
                            Круиз
                        </span>

                        <button class="card-fav">
                            ♡
                        </button>
                    </div>

                    <div class="card-body">

                        <h3>
                            Средиземное море
                        </h3>

                        <p>
                            7 дней · Греция — Турция ·
                            до 8 участников
                        </p>

                        <div class="card-foot">

                            <span class="price">
                                от 1 200 €
                                <small>/ чел.</small>
                            </span>

                            <span class="tag">
                                Всё включено
                            </span>

                        </div>

                    </div>

                </article>

                <article class="card">

                    <div
                        class="card-media"
                        style="
                            background-image:
                            url('https://images.unsplash.com/photo-1569263979104-865ab7cd8d13?auto=format&fit=crop&w=1000&q=80');
                        "
                    >
                        <span class="card-badge">
                            Прогулка
                        </span>

                        <button class="card-fav">
                            ♡
                        </button>
                    </div>

                    <div class="card-body">

                        <h3>
                            Волга на закате
                        </h3>

                        <p>
                            3 часа · живописные виды ·
                            лёгкий бриз
                        </p>

                        <div class="card-foot">

                            <span class="price">
                                от 3 500 ₽
                            </span>

                            <span class="tag">
                                Сегодня
                            </span>

                        </div>

                    </div>

                </article>

                <article class="card">

                    <div
                        class="card-media"
                        style="
                            background-image:
                            url('https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?auto=format&fit=crop&w=1000&q=80');
                        "
                    >
                        <span class="card-badge">
                            Экспедиция
                        </span>

                        <button class="card-fav">
                            ♡
                        </button>
                    </div>

                    <div class="card-body">

                        <h3>
                            Большой Байкал
                        </h3>

                        <p>
                            10 дней · острова · рыбалка ·
                            дикая природа
                        </p>

                        <div class="card-foot">

                            <span class="price">
                                от 95 000 ₽
                            </span>

                            <span class="tag">
                                8 мест
                            </span>

                        </div>

                    </div>

                </article>

            </div>

        </div>

    </section>

    <!-- SCHOOL -->

    <section class="section education">

        <div class="container">

            <div class="section-head">

                <div>

                    <div class="kicker">
                        Учись управлять
                    </div>

                    <h2>
                        Школа капитанов
                    </h2>

                </div>

                <p class="section-intro">
                    От первого выхода на воду до уверенного
                    самостоятельного плавания. Теория,
                    практика и реальные маршруты.
                </p>

            </div>

            <div class="edu-grid">

                <article
                    class="edu-card"
                    style="
                        background-image:
                        url('https://images.unsplash.com/photo-1567899378494-47b22a2ae96a?auto=format&fit=crop&w=1400&q=85');
                    "
                >

                    <div class="edu-content">

                        <h3>
                            Курс для взрослых
                        </h3>

                        <p>
                            Навигация, манёвры, безопасность
                            и практика на яхте. От новичка
                            до профессионального шкипера.
                        </p>

                        <a
                            class="btn btn-primary"
                            href="#"
                        >
                            Подробнее о школе →
                        </a>

                    </div>

                </article>

                <article
                    class="edu-card"
                    style="
                        background-image:
                        url('https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=85');
                    "
                >

                    <div class="edu-content">

                        <h3>
                            Детский клуб
                        </h3>

                        <p>
                            С 7 лет: безопасное знакомство
                            с парусом, спортом и настоящими
                            приключениями на воде.
                        </p>

                        <a
                            class="btn btn-glass"
                            href="#"
                        >
                            Записать ребёнка →
                        </a>

                    </div>

                </article>

            </div>

        </div>

    </section>

    <!-- CREW -->

    <section
        class="section market"
        id="crew"
    >

        <div class="container">

            <div class="section-head">

                <div>

                    <div class="kicker">
                        Сообщество
                    </div>

                    <h2>
                        Найди свою команду
                    </h2>

                </div>

                <a
                    class="text-link"
                    href="#"
                >
                    Все объявления →
                </a>

            </div>

            <div class="market-grid">

                <article class="market-item">

                    <div class="num">
                        01
                    </div>

                    <h3>
                        Капитан ищет экипаж
                    </h3>

                    <p>
                        Регата в Хорватии.
                        Нужны 3 матроса,
                        опыт приветствуется.
                    </p>

                    <a href="#">
                        Откликнуться →
                    </a>

                </article>

                <article class="market-item">

                    <div class="num">
                        02
                    </div>

                    <h3>
                        Рулевой на сезон
                    </h3>

                    <p>
                        Сочи · май—октябрь.
                        Работа на чартерной компании.
                    </p>

                    <a href="#">
                        Посмотреть →
                    </a>

                </article>

                <article class="market-item">

                    <div class="num">
                        03
                    </div>

                    <h3>
                        Создай анкету
                    </h3>

                    <p>
                        Покажи опыт, сертификаты
                        и мили — капитаны сами
                        найдут тебя.
                    </p>

                    <a href="#">
                        Создать профиль →
                    </a>

                </article>

                <article class="market-item">

                    <div class="num">
                        04
                    </div>

                    <h3>
                        Умный подбор
                    </h3>

                    <p>
                        Алгоритм сопоставит навыки,
                        даты и требования и покажет
                        процент совпадения.
                    </p>

                    <a href="#">
                        Как это работает →
                    </a>

                </article>

            </div>

        </div>

    </section>

    <!-- FLEET -->

    <section
        class="section"
        id="fleet"
    >

        <div class="container">

            <div class="section-head">

                <div>

                    <div class="kicker">
                        Флот
                    </div>

                    <h2>
                        Яхты в аренду и на продажу
                    </h2>

                </div>

                <a
                    class="text-link"
                    href="#"
                >
                    Открыть каталог →
                </a>

            </div>

            <div class="cards">

                <article class="card">

                    <div
                        class="card-media"
                        style="
                            background-image:
                            url('https://images.unsplash.com/photo-1562281302-809108fd533c?auto=format&fit=crop&w=1000&q=80');
                        "
                    >
                        <span class="card-badge">
                            Аренда
                        </span>
                    </div>

                    <div class="card-body">

                        <h3>
                            Bavaria 46
                        </h3>

                        <p>
                            2021 · парусная · 4 каюты
                        </p>

                        <div class="card-foot">

                            <span class="price">
                                2 500 €
                                <small>/ нед.</small>
                            </span>

                            <span class="tag">
                                Доступна
                            </span>

                        </div>

                    </div>

                </article>

                <article class="card">

                    <div
                        class="card-media"
                        style="
                            background-image:
                            url('https://images.unsplash.com/photo-1605281317010-fe5ffe798166?auto=format&fit=crop&w=1000&q=80');
                        "
                    >
                        <span class="card-badge">
                            Продажа
                        </span>
                    </div>

                    <div class="card-body">

                        <h3>
                            Azimut 60
                        </h3>

                        <p>
                            2019 · моторная · 3 каюты ·
                            2 двигателя
                        </p>

                        <div class="card-foot">

                            <span class="price">
                                590 000 €
                            </span>

                            <span class="tag">
                                Проверена
                            </span>

                        </div>

                    </div>

                </article>

                <article class="card">

                    <div
                        class="card-media"
                        style="
                            background-image:
                            url('https://images.unsplash.com/photo-1540946485063-a40da27545f8?auto=format&fit=crop&w=1000&q=80');
                        "
                    >
                        <span class="card-badge">
                            Аренда
                        </span>
                    </div>

                    <div class="card-body">

                        <h3>
                            Lagoon 42
                        </h3>

                        <p>
                            2022 · катамаран · 4 каюты ·
                            с экипажем
                        </p>

                        <div class="card-foot">

                            <span class="price">
                                3 800 €
                                <small>/ нед.</small>
                            </span>

                            <span class="tag">
                                Популярна
                            </span>

                        </div>

                    </div>

                </article>

            </div>

        </div>

    </section>

    <!-- MAP -->

    <section
        class="section"
        id="map"
    >

        <div class="container split">

            <div>

                <div class="kicker">
                    Штурманский помощник
                </div>

                <h2>
                    Море в реальном времени
                </h2>

                <p
                    class="section-intro"
                    style="margin-top: 18px;"
                >
                    Интерактивная карта объединяет
                    погоду, марины, причалы и безопасные
                    стоянки. Маршрут можно строить с учётом
                    внешних условий.
                </p>

                <div class="feature-list">

                    <div class="feature">

                        <div class="feature-icon">
                            ↗
                        </div>

                        <div>

                            <h3>
                                Погода и штормовые предупреждения
                            </h3>

                            <p>
                                Ветер, волна и давление —
                                в едином экране.
                            </p>

                        </div>

                    </div>

                    <div class="feature">

                        <div class="feature-icon">
                            ⌖
                        </div>

                        <div>

                            <h3>
                                Марины и якорные стоянки
                            </h3>

                            <p>
                                Глубины, услуги, контакты
                                и условия стоянки.
                            </p>

                        </div>

                    </div>

                    <div class="feature">

                        <div class="feature-icon">
                            ⌁
                        </div>

                        <div>

                            <h3>
                                Умный маршрут
                            </h3>

                            <p>
                                Перестроение пути при изменении
                                условий и обходе опасных зон.
                            </p>

                        </div>

                    </div>

                </div>

                <a
                    class="btn"
                    style="
                        background: var(--ink);
                        color: #ffffff;
                        margin-top: 28px;
                    "
                    href="#"
                >
                    Открыть карту →
                </a>

            </div>

            <div class="map">

                <div class="map-ui">

                    <div class="map-panel">

                        <b>
                            Сейчас в акватории
                        </b>

                        <div class="weather">
                            <span>↗ 12 уз.</span>
                            <span>≋ 0.8 м</span>
                            <span>◉ 1015</span>
                        </div>

                    </div>

                </div>

                <span class="pin one"></span>
                <span class="pin two"></span>
                <span class="pin three"></span>

            </div>

        </div>

    </section>

    <!-- RACES -->

    <section
        class="section races"
        id="races"
    >

        <div class="container">

            <div class="section-head">

                <div>

                    <div class="kicker">
                        Спортивный календарь
                    </div>

                    <h2>
                        Ближайшие гонки
                    </h2>

                </div>

                <a
                    class="text-link"
                    href="#"
                >
                    Весь календарь →
                </a>

            </div>

            <div class="race-grid">

                <div class="race-list">

                    <div class="race-row">

                        <div class="date-box">

                            <b>
                                15
                            </b>

                            <span>
                                авг
                            </span>

                        </div>

                        <div>

                            <h3>
                                Кубок Чёрного моря
                            </h3>

                            <p>
                                Сочи · 15–20 августа ·
                                100 миль
                            </p>

                        </div>

                        <a
                            class="btn"
                            href="#"
                        >
                            Регистрация
                        </a>

                    </div>

                    <div class="race-row">

                        <div class="date-box">

                            <b>
                                05
                            </b>

                            <span>
                                сен
                            </span>

                        </div>

                        <div>

                            <h3>
                                Крейсерская гонка «Ладога»
                            </h3>

                            <p>
                                Шхеры Ладоги · 5–8 сентября ·
                                командный зачёт
                            </p>

                        </div>

                        <a
                            class="btn"
                            href="#"
                        >
                            Регистрация
                        </a>

                    </div>

                    <div class="race-row">

                        <div class="date-box">

                            <b>
                                12
                            </b>

                            <span>
                                сен
                            </span>

                        </div>

                        <div>

                            <h3>
                                Матчевые поединки
                            </h3>

                            <p>
                                Петербург · каждую субботу ·
                                Финский залив
                            </p>

                        </div>

                        <a
                            class="btn"
                            href="#"
                        >
                            Подробнее
                        </a>

                    </div>

                </div>

                <article
                    class="news-card"
                    id="news"
                >

                    <div>

                        <div class="date">
                            Новости сообщества · сегодня
                        </div>

                        <h3>
                            Итоги «Кубка Балтики»
                        </h3>

                        <p>
                            Команда «Волна» из Калининграда
                            забрала первое место.
                            Следующий этап — в сентябре.
                        </p>

                    </div>

                    <a
                        class="btn btn-glass"
                        href="#"
                    >
                        Читать все новости →
                    </a>

                </article>

            </div>

        </div>

    </section>

    <!-- PLATFORM -->

    <section class="section community">

        <div class="container">

            <div class="section-head">

                <div>

                    <div class="kicker">
                        Платформа
                    </div>

                    <h2>
                        Больше, чем каталог
                    </h2>

                </div>

                <p class="section-intro">
                    Личный кабинет объединяет путешествия,
                    бронирования, финансы, чат, отзывы
                    и накопленные морские мили.
                </p>

            </div>

            <div class="community-grid">

                <article class="community-card">

                    <div class="avatar">
                        01
                    </div>

                    <h3>
                        Личный профиль
                    </h3>

                    <p>
                        Опыт, сертификаты, предпочтения
                        и портфолио пройденных морских миль.
                    </p>

                    <a
                        class="btn"
                        style="
                            background: #eaf3f4;
                        "
                        href="#"
                    >
                        Мой профиль →
                    </a>

                </article>

                <article class="community-card">

                    <div class="avatar">
                        02
                    </div>

                    <h3>
                        Безопасные сделки
                    </h3>

                    <p>
                        Предмодерация объявлений,
                        встроенный чат и отзывы формируют
                        доверие внутри сообщества.
                    </p>

                    <a
                        class="btn"
                        style="
                            background: #eaf3f4;
                        "
                        href="#"
                    >
                        Как это работает →
                    </a>

                </article>

                <article class="community-card">

                    <div class="avatar">
                        03
                    </div>

                    <h3>
                        Бронирование онлайн
                    </h3>

                    <p>
                        Выбор даты, расчёт сервисного сбора,
                        оплата и история операций —
                        в одном кабинете.
                    </p>

                    <a
                        class="btn"
                        style="
                            background: #eaf3f4;
                        "
                        href="#"
                    >
                        Узнать больше →
                    </a>

                </article>

            </div>

        </div>

    </section>

</main>

<!-- FOOTER -->

<footer>

    <div class="container">

        <div class="footer-grid">

            <div>

                <a
                    class="brand"
                    href="#"
                >

                    <span class="brand-mark">

                        <svg
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="1.7"
                        >
                            <path d="M3 18h18M5 18c3-2 5-5 6-10l7 6c-2 2-4 3-7 4"/>
                            <path d="M11 8V4h4"/>
                        </svg>

                    </span>

                    Вольный ветер

                </a>

                <p class="footer-desc">
                    Единая интернет-платформа для яхтсменов,
                    капитанов, владельцев яхт и всех,
                    кто любит воду.
                </p>

            </div>

            <div>

                <h4>
                    Путешествия
                </h4>

                <ul>
                    <li>
                        <a href="#">
                            Туры и прогулки
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            Аренда яхт
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            Купить яхту
                        </a>
                    </li>
                </ul>

            </div>

            <div>

                <h4>
                    Сообщество
                </h4>

                <ul>
                    <li>
                        <a href="#">
                            Найти экипаж
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            Регаты
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            Новости
                        </a>
                    </li>
                </ul>

            </div>

            <div>

                <h4>
                    Сервис
                </h4>

                <ul>
                    <li>
                        <a href="#">
                            Карта
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            Школа капитанов
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            Поддержка
                        </a>
                    </li>
                </ul>

            </div>

        </div>

        <div class="footer-bottom">

            <span>
                © 2026 Вольный ветер
            </span>

            <span>
                О проекте ·
                Политика конфиденциальности ·
                Контакты
            </span>

        </div>

    </div>

</footer>

</body>
</html>