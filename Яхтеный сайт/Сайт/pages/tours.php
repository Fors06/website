<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../includes/header.php';

?>
<!DOCTYPE html>

<html lang="ru">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        Туры — Вольный ветер
    </title>

    <link
        rel="stylesheet"
        href="../assets/css/base.css"
    >

    <link
        rel="stylesheet"
        href="../assets/css/tours.css"
    >

</head>

<body>


<main>

    <section class="tours-hero">

        <div class="container hero-inner">

            <span class="eyebrow">
                ВОЛЬНЫЙ ВЕТЕР
            </span>

            <h1>
                Найди свой
                <em>маршрут.</em>
            </h1>

            <p>
                Круизы, прогулки и речные
                путешествия от организаторов
                нашей платформы.
            </p>

        </div>

    </section>


    <section class="catalog">

        <div class="container catalog-layout">

            <aside class="filters">

                <div class="filters-header">

                    <div>

                        <span class="section-kicker">
                            ПОИСК
                        </span>

                        <h2>
                            Фильтры
                        </h2>

                    </div>

                    <button
                        id="resetFilters"
                        class="reset-button"
                        type="button"
                    >
                        Сбросить
                    </button>

                </div>


                <label class="filter-search">

                    <span>
                        Поиск
                    </span>

                    <input
                        id="search"
                        type="search"
                        placeholder="Название или маршрут"
                    >

                </label>


                <label class="filter-search">

                    <span>
                        Направление
                    </span>

                    <input
                        id="destination"
                        type="search"
                        placeholder="Например, Турция"
                    >

                </label>


                <div class="filter-group">

                    <div class="filter-title">
                        Тип тура
                    </div>

                    <div
                        id="tourTypes"
                        class="checkbox-list"
                    ></div>

                </div>


                <div class="filter-group">

                    <div class="filter-title">
                        Валюта
                    </div>

                    <div
                        id="currencies"
                        class="checkbox-list"
                    ></div>

                </div>


                <div class="filter-group">

                    <div class="filter-title-row">

                        <div class="filter-title">
                            Цена
                        </div>

                        <span
                            id="priceRangeLabel"
                            class="range-summary"
                        >
                            —
                        </span>

                    </div>


                    <div
                        id="priceHistogram"
                        class="price-histogram"
                    ></div>


                    <div class="range-slider">

                        <div
                            class="range-track"
                        ></div>

                        <div
                            id="priceRangeActive"
                            class="range-active"
                        ></div>

                        <input
                            id="priceMin"
                            class="range-input"
                            type="range"
                            min="0"
                            max="100"
                            value="0"
                            step="1"
                        >

                        <input
                            id="priceMax"
                            class="range-input"
                            type="range"
                            min="0"
                            max="100"
                            value="100"
                            step="1"
                        >

                    </div>


                    <div class="range-values">

                        <span id="priceMinValue">
                            —
                        </span>

                        <span id="priceMaxValue">
                            —
                        </span>

                    </div>

                </div>


                <div class="filter-group">

                    <div class="filter-title-row">

                        <div class="filter-title">
                            Длительность
                        </div>

                        <span
                            id="durationLabel"
                            class="range-summary"
                        >
                            —
                        </span>

                    </div>


                    <div class="simple-range">

                        <input
                            id="durationMin"
                            type="range"
                            min="1"
                            max="30"
                            value="1"
                        >

                        <input
                            id="durationMax"
                            type="range"
                            min="1"
                            max="30"
                            value="30"
                        >

                    </div>


                    <div class="range-values">

                        <span id="durationMinValue">
                            1 день
                        </span>

                        <span id="durationMaxValue">
                            30 дней
                        </span>

                    </div>

                </div>


                <div class="filter-group">

                    <div class="filter-title-row">

                        <div class="filter-title">
                            Участники
                        </div>

                        <span
                            id="participantsLabel"
                            class="range-summary"
                        >
                            —
                        </span>

                    </div>


                    <div class="simple-range">

                        <input
                            id="participantsMin"
                            type="range"
                            min="1"
                            max="20"
                            value="1"
                        >

                        <input
                            id="participantsMax"
                            type="range"
                            min="1"
                            max="20"
                            value="20"
                        >

                    </div>


                    <div class="range-values">

                        <span id="participantsMinValue">
                            1
                        </span>

                        <span id="participantsMaxValue">
                            20
                        </span>

                    </div>

                </div>


                <div class="filter-group">

                    <div class="filter-title">
                        Дата путешествия
                    </div>

                    <input
                        id="availableDate"
                        class="date-input"
                        type="date"
                    >

                </div>

            </aside>


            <div class="results">

                <div class="results-header">

                    <div>

                        <span class="section-kicker">
                            КАТАЛОГ
                        </span>

                        <h2>
                            Путешествия
                        </h2>

                    </div>


                    <div class="results-controls">

                        <span
                            id="resultsCount"
                            class="results-count"
                        >
                            Загрузка...
                        </span>

                        <select
                            id="sort"
                            class="sort-select"
                        >

                            <option value="newest">
                                Сначала новые
                            </option>

                            <option value="price_asc">
                                Цена по возрастанию
                            </option>

                            <option value="price_desc">
                                Цена по убыванию
                            </option>

                            <option value="duration_asc">
                                Сначала короткие
                            </option>

                            <option value="duration_desc">
                                Сначала длинные
                            </option>

                            <option value="rating_desc">
                                Высокий рейтинг
                            </option>

                        </select>

                    </div>

                </div>


                <div
                    id="tourGrid"
                    class="tour-grid"
                ></div>


                <div
                    id="emptyState"
                    class="empty-state hidden"
                >

                    <div class="empty-icon">
                        ≋
                    </div>

                    <h3>
                        Ничего не найдено
                    </h3>

                    <p>
                        Попробуйте изменить
                        параметры фильтрации.
                    </p>

                    <button
                        id="emptyReset"
                        class="button button-primary"
                        type="button"
                    >
                        Сбросить фильтры
                    </button>

                </div>

            </div>

        </div>

    </section>

</main>


<script
    src="../assets/js/tours.js"
></script>

</body>

</html>