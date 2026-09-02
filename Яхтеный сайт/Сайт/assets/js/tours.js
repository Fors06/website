const state = {

    priceMin: 0,

    priceMax: 0,

    selectedPriceMin: 0,

    selectedPriceMax: 0,

    currency: '',

    histogram: []

};


const elements = {

    search:
        document.getElementById(
            'search'
        ),

    destination:
        document.getElementById(
            'destination'
        ),

    tourTypes:
        document.getElementById(
            'tourTypes'
        ),

    currencies:
        document.getElementById(
            'currencies'
        ),

    priceHistogram:
        document.getElementById(
            'priceHistogram'
        ),

    priceMin:
        document.getElementById(
            'priceMin'
        ),

    priceMax:
        document.getElementById(
            'priceMax'
        ),

    priceMinValue:
        document.getElementById(
            'priceMinValue'
        ),

    priceMaxValue:
        document.getElementById(
            'priceMaxValue'
        ),

    priceRangeLabel:
        document.getElementById(
            'priceRangeLabel'
        ),

    priceRangeActive:
        document.getElementById(
            'priceRangeActive'
        ),

    durationMin:
        document.getElementById(
            'durationMin'
        ),

    durationMax:
        document.getElementById(
            'durationMax'
        ),

    durationMinValue:
        document.getElementById(
            'durationMinValue'
        ),

    durationMaxValue:
        document.getElementById(
            'durationMaxValue'
        ),

    durationLabel:
        document.getElementById(
            'durationLabel'
        ),

    participantsMin:
        document.getElementById(
            'participantsMin'
        ),

    participantsMax:
        document.getElementById(
            'participantsMax'
        ),

    participantsMinValue:
        document.getElementById(
            'participantsMinValue'
        ),

    participantsMaxValue:
        document.getElementById(
            'participantsMaxValue'
        ),

    participantsLabel:
        document.getElementById(
            'participantsLabel'
        ),

    availableDate:
        document.getElementById(
            'availableDate'
        ),

    sort:
        document.getElementById(
            'sort'
        ),

    tourGrid:
        document.getElementById(
            'tourGrid'
        ),

    resultsCount:
        document.getElementById(
            'resultsCount'
        ),

    emptyState:
        document.getElementById(
            'emptyState'
        ),

    resetFilters:
        document.getElementById(
            'resetFilters'
        ),

    emptyReset:
        document.getElementById(
            'emptyReset'
        )

};


const typeNames = {

    cruise:
        'Круизы',

    excursion:
        'Экскурсии',

    river:
        'Речные прогулки'

};


const currencySymbols = {

    RUB:
        '₽',

    EUR:
        '€',

    USD:
        '$'

};


function formatPrice(
    value,
    currency
) {

    const symbol =
        currencySymbols[
            currency
        ] ||
        currency;

    return (
        new Intl.NumberFormat(
            'ru-RU',
            {
                maximumFractionDigits: 0
            }
        ).format(
            value
        )
        +
        ' '
        +
        symbol
    );

}


function formatDuration(
    days
) {

    if (
        days % 10 === 1 &&
        days % 100 !== 11
    ) {

        return `${days} день`;

    }

    if (
        days % 10 >= 2 &&
        days % 10 <= 4 &&
        (
            days % 100 < 10 ||
            days % 100 >= 20
        )
    ) {

        return `${days} дня`;

    }

    return `${days} дней`;

}


function escapeHtml(
    value
) {

    return String(
        value ?? ''
    )
        .replace(
            /&/g,
            '&amp;'
        )
        .replace(
            /</g,
            '&lt;'
        )
        .replace(
            />/g,
            '&gt;'
        )
        .replace(
            /"/g,
            '&quot;'
        )
        .replace(
            /'/g,
            '&#039;'
        );

}


function getSelectedTypes() {

    return [
        ...elements.tourTypes
            .querySelectorAll(
                'input:checked'
            )
    ].map(
        input =>
            input.value
    );

}


function createParams() {

    const params =
        new URLSearchParams();

    const search =
        elements.search.value.trim();

    const destination =
        elements.destination.value.trim();

    if (search) {

        params.set(
            'search',
            search
        );

    }

    if (destination) {

        params.set(
            'destination',
            destination
        );

    }

    getSelectedTypes()
        .forEach(
            type => {

                params.append(
                    'tour_type[]',
                    type
                );

            }
        );

    if (
        state.currency
    ) {

        params.set(
            'currency',
            state.currency
        );

    }

    if (
        state.priceMin > 0
    ) {

        params.set(
            'price_min',
            state.selectedPriceMin
        );

    }

    if (
        state.priceMax >
        state.priceMin
    ) {

        params.set(
            'price_max',
            state.selectedPriceMax
        );

    }

    params.set(
        'duration_min',
        elements.durationMin.value
    );

    params.set(
        'duration_max',
        elements.durationMax.value
    );

    params.set(
        'participants_min',
        elements.participantsMin.value
    );

    params.set(
        'participants_max',
        elements.participantsMax.value
    );

    if (
        elements.availableDate.value
    ) {

        params.set(
            'available_date',
            elements.availableDate.value
        );

    }

    params.set(
        'sort',
        elements.sort.value
    );

    return params;

}


async function loadTours() {

    elements.tourGrid.classList.add(
        'is-loading'
    );

    try {

        const params =
            createParams();

        const response =
            await fetch(
                `../api/tours.php?${params.toString()}`,
                {
                    headers: {
                        Accept:
                            'application/json'
                    }
                }
            );

        if (
            !response.ok
        ) {

            throw new Error(
                'Ошибка сервера'
            );

        }

        const data =
            await response.json();

        if (
            !data.success
        ) {

            throw new Error(
                data.message ||
                'Ошибка загрузки'
            );

        }

        renderTourTypes(
            data.filters.tour_types
        );

        renderCurrencies(
            data.filters.currencies
        );

        updatePriceState(
            data.price
        );

        renderHistogram(
            data.price.histogram
        );

        renderTours(
            data.tours
        );

        elements.resultsCount.textContent =
            `Найдено ${data.total_count}`;

    } catch (error) {

        console.error(
            error
        );

        elements.tourGrid.innerHTML = `
            <div class="error-state">
                Не удалось загрузить туры.
            </div>
        `;

    } finally {

        elements.tourGrid.classList.remove(
            'is-loading'
        );

    }

}


function renderTourTypes(
    types
) {

    if (
        elements.tourTypes.children.length > 0
    ) {

        return;

    }

    elements.tourTypes.innerHTML =
        types
            .map(
                type => `
                    <label class="check-item">

                        <input
                            type="checkbox"
                            value="${escapeHtml(type)}"
                        >

                        <span class="check-box"></span>

                        <span>
                            ${
                                escapeHtml(
                                    typeNames[type] ||
                                    type
                                )
                            }
                        </span>

                    </label>
                `
            )
            .join('');

    elements.tourTypes
        .querySelectorAll(
            'input'
        )
        .forEach(
            input => {

                input.addEventListener(
                    'change',
                    loadTours
                );

            }
        );

}


function renderCurrencies(
    currencies
) {

    if (
        elements.currencies.children.length > 0
    ) {

        return;

    }

    elements.currencies.innerHTML =
        currencies
            .map(
                currency => `
                    <label class="check-item">

                        <input
                            type="radio"
                            name="currency"
                            value="${escapeHtml(currency)}"
                        >

                        <span class="check-box radio"></span>

                        <span>
                            ${
                                escapeHtml(
                                    currency
                                )
                            }
                        </span>

                    </label>
                `
            )
            .join('');

    elements.currencies
        .querySelectorAll(
            'input'
        )
        .forEach(
            input => {

                input.addEventListener(
                    'change',
                    () => {

                        state.currency =
                            input.value;

                        loadTours();

                    }
                );

            }
        );

}


function updatePriceState(
    price
) {

    state.priceMin =
        Number(
            price.min
        );

    state.priceMax =
        Number(
            price.max
        );

    if (
        state.priceMax <=
        state.priceMin
    ) {

        state.selectedPriceMin =
            state.priceMin;

        state.selectedPriceMax =
            state.priceMax;

    } else {

        if (
            !state.selectedPriceMin ||
            state.selectedPriceMin <
            state.priceMin
        ) {

            state.selectedPriceMin =
                state.priceMin;

        }

        if (
            !state.selectedPriceMax ||
            state.selectedPriceMax >
            state.priceMax
        ) {

            state.selectedPriceMax =
                state.priceMax;

        }

    }

    elements.priceMin.min =
        state.priceMin;

    elements.priceMin.max =
        state.priceMax;

    elements.priceMax.min =
        state.priceMin;

    elements.priceMax.max =
        state.priceMax;

    elements.priceMin.value =
        state.selectedPriceMin;

    elements.priceMax.value =
        state.selectedPriceMax;

    updatePriceSlider();

}


function updatePriceSlider() {

    const min =
        Number(
            elements.priceMin.min
        );

    const max =
        Number(
            elements.priceMin.max
        );

    const currentMin =
        Number(
            elements.priceMin.value
        );

    const currentMax =
        Number(
            elements.priceMax.value
        );

    if (
        currentMin >
        currentMax
    ) {

        return;

    }

    const left =
        max === min
            ? 0
            : (
                (
                    currentMin -
                    min
                )
                /
                (
                    max -
                    min
                )
            ) * 100;

    const right =
        max === min
            ? 100
            : (
                (
                    currentMax -
                    min
                )
                /
                (
                    max -
                    min
                )
            ) * 100;

    elements.priceRangeActive.style.left =
        `${left}%`;

    elements.priceRangeActive.style.right =
        `${100 - right}%`;

    elements.priceMinValue.textContent =
        formatPrice(
            currentMin,
            state.currency
        );

    elements.priceMaxValue.textContent =
        formatPrice(
            currentMax,
            state.currency
        );

    elements.priceRangeLabel.textContent =
        `${formatPrice(
            currentMin,
            state.currency
        )} — ${formatPrice(
            currentMax,
            state.currency
        )}`;

}


function renderHistogram(
    histogram
) {

    state.histogram =
        histogram;

    const max =
        Math.max(
            ...histogram,
            1
        );

    elements.priceHistogram.innerHTML =
        histogram
            .map(
                count => {

                    const height =
                        (
                            count /
                            max
                        ) * 100;

                    return `
                        <span
                            class="histogram-bar"
                            style="height:${Math.max(
                                height,
                                2
                            )}%"
                            title="${count} туров"
                        ></span>
                    `;

                }
            )
            .join('');

}


function renderTours(
    tours
) {

    if (
        tours.length === 0
    ) {

        elements.tourGrid.innerHTML =
            '';

        elements.emptyState.classList.remove(
            'hidden'
        );

        return;

    }

    elements.emptyState.classList.add(
        'hidden'
    );

    elements.tourGrid.innerHTML =
        tours
            .map(
                tour =>
                    createTourCard(
                        tour
                    )
            )
            .join('');

}


function createTourCard(
    tour
) {

    const image =
        tour.main_image
            ? `
                <img
                    src="${escapeHtml(
                        tour.main_image
                    )}"
                    alt="${escapeHtml(
                        tour.title
                    )}"
                    loading="lazy"
                >
            `
            : `
                <div class="image-placeholder">
                    ВОЛЬНЫЙ ВЕТЕР
                </div>
            `;

    const rating =
        tour.average_rating !== null
            ? `
                <div class="tour-rating">
                    <span>★</span>
                    ${escapeHtml(
                        tour.average_rating
                    )}
                    <small>
                        (${escapeHtml(
                            tour.reviews_count
                        )})
                    </small>
                </div>
            `
            : '';

    const organizer =
        escapeHtml(
            tour.organizer_name ||
            'Организатор тура'
        );

    return `
        <article class="tour-card">

            <a
                href="tour.php?id=${encodeURIComponent(
                    tour.id
                )}"
                class="tour-image"
            >

                ${image}

                <span class="tour-type">
                    ${escapeHtml(
                        typeNames[
                            tour.tour_type
                        ] ||
                        tour.tour_type
                    )}
                </span>

                <span
                    class="favorite-button"
                    aria-hidden="true"
                >
                    ♡
                </span>

            </a>


            <div class="tour-body">

                <div class="tour-location">
                    ●
                    ${escapeHtml(
                        tour.destination
                    )}
                </div>

                <h3>
                    <a
                        href="tour.php?id=${encodeURIComponent(
                            tour.id
                        )}"
                    >
                        ${escapeHtml(
                            tour.title
                        )}
                    </a>
                </h3>

                <p class="tour-description">
                    ${escapeHtml(
                        (
                            tour.description ||
                            ''
                        ).slice(
                            0,
                            150
                        )
                    )}
                </p>

                <div class="tour-meta">

                    <span>
                        ${formatDuration(
                            Number(
                                tour.duration_days
                            )
                        )}
                    </span>

                    <span>
                        до
                        ${escapeHtml(
                            tour.max_participants
                        )}
                        участников
                    </span>

                </div>

                <div class="tour-divider"></div>

                <div class="tour-footer">

                    <div>

                        <span class="price-label">
                            от
                        </span>

                        <strong class="tour-price">
                            ${formatPrice(
                                Number(
                                    tour.price
                                ),
                                tour.currency
                            )}
                        </strong>

                    </div>

                    ${rating}

                </div>

                <div class="organizer">

                    ${
                        tour.organizer_photo
                            ? `
                                <img
                                    src="${escapeHtml(
                                        tour.organizer_photo
                                    )}"
                                    alt=""
                                >
                            `
                            : `
                                <div class="organizer-avatar">
                                    ${escapeHtml(
                                        organizer
                                            .charAt(0)
                                            .toUpperCase()
                                    )}
                                </div>
                            `
                    }

                    <div>

                        <span>
                            Организатор
                        </span>

                        <strong>
                            ${organizer}
                        </strong>

                    </div>

                </div>

            </div>

        </article>
    `;

}


function keepRangesValid() {

    let durationMin =
        Number(
            elements.durationMin.value
        );

    let durationMax =
        Number(
            elements.durationMax.value
        );

    if (
        durationMin >
        durationMax
    ) {

        if (
            document.activeElement ===
            elements.durationMin
        ) {

            durationMax =
                durationMin;

            elements.durationMax.value =
                durationMax;

        } else {

            durationMin =
                durationMax;

            elements.durationMin.value =
                durationMin;

        }

    }


    elements.durationMinValue.textContent =
        formatDuration(
            durationMin
        );

    elements.durationMaxValue.textContent =
        formatDuration(
            durationMax
        );

    elements.durationLabel.textContent =
        `${durationMin}–${durationMax} дней`;


    let participantsMin =
        Number(
            elements.participantsMin.value
        );

    let participantsMax =
        Number(
            elements.participantsMax.value
        );

    if (
        participantsMin >
        participantsMax
    ) {

        if (
            document.activeElement ===
            elements.participantsMin
        ) {

            participantsMax =
                participantsMin;

            elements.participantsMax.value =
                participantsMax;

        } else {

            participantsMin =
                participantsMax;

            elements.participantsMin.value =
                participantsMin;

        }

    }

    elements.participantsMinValue.textContent =
        participantsMin;

    elements.participantsMaxValue.textContent =
        participantsMax;

    elements.participantsLabel.textContent =
        `${participantsMin}–${participantsMax}`;

}


function debounce(
    callback,
    delay
) {

    let timer;

    return (
        ...args
    ) => {

        clearTimeout(
            timer
        );

        timer =
            setTimeout(
                () => {

                    callback(
                        ...args
                    );

                },
                delay
            );

    };

}


function resetFilters() {

    elements.search.value =
        '';

    elements.destination.value =
        '';

    elements.availableDate.value =
        '';

    elements.sort.value =
        'newest';

    document
        .querySelectorAll(
            '#tourTypes input'
        )
        .forEach(
            input => {

                input.checked =
                    false;

            }
        );

    document
        .querySelectorAll(
            '#currencies input'
        )
        .forEach(
            input => {

                input.checked =
                    false;

            }
        );

    state.currency =
        '';

    state.selectedPriceMin =
        state.priceMin;

    state.selectedPriceMax =
        state.priceMax;

    elements.durationMin.value =
        1;

    elements.durationMax.value =
        30;

    elements.participantsMin.value =
        1;

    elements.participantsMax.value =
        20;

    keepRangesValid();

    updatePriceState(
        {
            min:
                state.priceMin,

            max:
                state.priceMax
        }
    );

    loadTours();

}


elements.priceMin.addEventListener(
    'input',
    () => {

        let min =
            Number(
                elements.priceMin.value
            );

        let max =
            Number(
                elements.priceMax.value
            );

        if (
            min > max
        ) {

            min =
                max;

            elements.priceMin.value =
                min;

        }

        state.selectedPriceMin =
            min;

        updatePriceSlider();

    }
);


elements.priceMax.addEventListener(
    'input',
    () => {

        let min =
            Number(
                elements.priceMin.value
            );

        let max =
            Number(
                elements.priceMax.value
            );

        if (
            max < min
        ) {

            max =
                min;

            elements.priceMax.value =
                max;

        }

        state.selectedPriceMax =
            max;

        updatePriceSlider();

    }
);


elements.priceMin.addEventListener(
    'change',
    loadTours
);


elements.priceMax.addEventListener(
    'change',
    loadTours
);


elements.durationMin.addEventListener(
    'input',
    () => {

        keepRangesValid();

    }
);


elements.durationMax.addEventListener(
    'input',
    () => {

        keepRangesValid();

    }
);


elements.durationMin.addEventListener(
    'change',
    loadTours
);


elements.durationMax.addEventListener(
    'change',
    loadTours
);


elements.participantsMin.addEventListener(
    'input',
    () => {

        keepRangesValid();

    }
);


elements.participantsMax.addEventListener(
    'input',
    () => {

        keepRangesValid();

    }
);


elements.participantsMin.addEventListener(
    'change',
    loadTours
);


elements.participantsMax.addEventListener(
    'change',
    loadTours
);


elements.search.addEventListener(
    'input',
    debounce(
        loadTours,
        400
    )
);


elements.destination.addEventListener(
    'input',
    debounce(
        loadTours,
        400
    )
);


elements.availableDate.addEventListener(
    'change',
    loadTours
);


elements.sort.addEventListener(
    'change',
    loadTours
);


elements.resetFilters.addEventListener(
    'click',
    resetFilters
);


elements.emptyReset.addEventListener(
    'click',
    resetFilters
);


keepRangesValid();

loadTours();