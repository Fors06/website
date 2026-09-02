<?php

require_once __DIR__ . '/../config/config.php';

header('Content-Type: application/json; charset=utf-8');

function jsonResponse(
    array $data,
    int $status = 200
): never {

    http_response_code($status);

    echo json_encode(
        $data,
        JSON_UNESCAPED_UNICODE |
        JSON_UNESCAPED_SLASHES
    );

    exit;

}

function cleanString(
    mixed $value
): string {

    return trim(
        (string) $value
    );

}

function positiveNumber(
    mixed $value
): ?float {

    if (
        $value === null ||
        $value === '' ||
        !is_numeric($value)
    ) {

        return null;

    }

    $number = (float) $value;

    return $number >= 0
        ? $number
        : null;

}

function positiveInteger(
    mixed $value
): ?int {

    if (
        $value === null ||
        $value === '' ||
        !ctype_digit(
            (string) $value
        )
    ) {

        return null;

    }

    $number = (int) $value;

    return $number > 0
        ? $number
        : null;

}

function getTourTypes(
    PDO $pdo
): array {

    $stmt = $pdo->query("
        SELECT DISTINCT tour_type
        FROM Tours
        WHERE status = 'active'
        ORDER BY tour_type
    ");

    return $stmt->fetchAll(
        PDO::FETCH_COLUMN
    );

}

function getCurrencies(
    PDO $pdo
): array {

    $stmt = $pdo->query("
        SELECT DISTINCT currency
        FROM Tours
        WHERE status = 'active'
        ORDER BY currency
    ");

    return $stmt->fetchAll(
        PDO::FETCH_COLUMN
    );

}

$search = cleanString(
    $_GET['search'] ?? ''
);

$destination = cleanString(
    $_GET['destination'] ?? ''
);

$tourTypes = $_GET['tour_type'] ?? [];

if (!is_array($tourTypes)) {

    $tourTypes = [
        $tourTypes
    ];

}

$allowedTypes = [
    'cruise',
    'excursion',
    'river'
];

$tourTypes = array_values(
    array_intersect(
        $tourTypes,
        $allowedTypes
    )
);

$currency = cleanString(
    $_GET['currency'] ?? ''
);

$priceMin = positiveNumber(
    $_GET['price_min'] ?? null
);

$priceMax = positiveNumber(
    $_GET['price_max'] ?? null
);

$durationMin = positiveInteger(
    $_GET['duration_min'] ?? null
);

$durationMax = positiveInteger(
    $_GET['duration_max'] ?? null
);

$participantsMin = positiveInteger(
    $_GET['participants_min'] ?? null
);

$participantsMax = positiveInteger(
    $_GET['participants_max'] ?? null
);

$availableDate = cleanString(
    $_GET['available_date'] ?? ''
);

$sort = cleanString(
    $_GET['sort'] ?? 'newest'
);

$allowedSorts = [
    'newest',
    'price_asc',
    'price_desc',
    'duration_asc',
    'duration_desc',
    'rating_desc'
];

if (
    !in_array(
        $sort,
        $allowedSorts,
        true
    )
) {

    $sort = 'newest';

}

$where = [
    "t.status = 'active'"
];

$params = [];

if ($search !== '') {

    $where[] = "
        (
            t.title LIKE :search
            OR t.description LIKE :search
            OR t.destination LIKE :search
        )
    ";

    $params[':search'] =
        '%' . $search . '%';

}

if ($destination !== '') {

    $where[] = "
        t.destination LIKE :destination
    ";

    $params[':destination'] =
        '%' . $destination . '%';

}

if (
    count($tourTypes) > 0
) {

    $typePlaceholders = [];

    foreach (
        $tourTypes as $index => $type
    ) {

        $placeholder =
            ':tour_type_' . $index;

        $typePlaceholders[] =
            $placeholder;

        $params[$placeholder] =
            $type;

    }

    $where[] = "
        t.tour_type IN (
            " .
            implode(
                ',',
                $typePlaceholders
            ) .
            "
        )
    ";

}

if ($currency !== '') {

    $where[] = "
        t.currency = :currency
    ";

    $params[':currency'] =
        $currency;

}

if (
    $priceMin !== null
) {

    $where[] = "
        t.price >= :price_min
    ";

    $params[':price_min'] =
        $priceMin;

}

if (
    $priceMax !== null
) {

    $where[] = "
        t.price <= :price_max
    ";

    $params[':price_max'] =
        $priceMax;

}

if (
    $durationMin !== null
) {

    $where[] = "
        t.duration_days >= :duration_min
    ";

    $params[':duration_min'] =
        $durationMin;

}

if (
    $durationMax !== null
) {

    $where[] = "
        t.duration_days <= :duration_max
    ";

    $params[':duration_max'] =
        $durationMax;

}

if (
    $participantsMin !== null
) {

    $where[] = "
        t.max_participants >= :participants_min
    ";

    $params[':participants_min'] =
        $participantsMin;

}

if (
    $participantsMax !== null
) {

    $where[] = "
        t.max_participants <= :participants_max
    ";

    $params[':participants_max'] =
        $participantsMax;

}

if ($availableDate !== '') {

    $date = DateTime::createFromFormat(
        'Y-m-d',
        $availableDate
    );

    if (
        $date &&
        $date->format('Y-m-d') ===
        $availableDate
    ) {

        $where[] = "
            t.available_from <= :available_date
            AND t.available_to >= :available_date
        ";

        $params[':available_date'] =
            $availableDate;

    }

}

$whereSql =
    implode(
        ' AND ',
        $where
    );

$orderBy = match ($sort) {

    'price_asc' =>
        't.price ASC',

    'price_desc' =>
        't.price DESC',

    'duration_asc' =>
        't.duration_days ASC',

    'duration_desc' =>
        't.duration_days DESC',

    'rating_desc' =>
        'average_rating DESC',

    default =>
        't.created_at DESC'

};

$ratingJoin = "
    LEFT JOIN (
        SELECT
            tour_id,
            COUNT(*) AS reviews_count,
            ROUND(
                AVG(rating),
                1
            ) AS average_rating
        FROM Reviews
        WHERE tour_id IS NOT NULL
        GROUP BY tour_id
    ) r
        ON r.tour_id = t.id
";

$sql = "
    SELECT

        t.id,
        t.organizer_id,
        t.title,
        t.description,
        t.destination,
        t.tour_type,
        t.price,
        t.currency,
        t.duration_days,
        t.included_services,
        t.max_participants,
        t.available_from,
        t.available_to,
        t.created_at,

        CONCAT(
            COALESCE(
                u.first_name,
                ''
            ),
            ' ',
            COALESCE(
                u.last_name,
                ''
            )
        ) AS organizer_name,

        u.photo_url AS organizer_photo,

        (
            SELECT
                m.file_url
            FROM Media m
            WHERE m.tour_id = t.id
                AND m.file_type = 'image'
                AND m.is_main = 1
            ORDER BY m.id ASC
            LIMIT 1
        ) AS main_image,

        COALESCE(
            r.reviews_count,
            0
        ) AS reviews_count,

        r.average_rating

    FROM Tours t

    LEFT JOIN Users u
        ON u.id = t.organizer_id

    $ratingJoin

    WHERE $whereSql

    ORDER BY $orderBy

    LIMIT 100
";

try {

    $stmt = $pdo->prepare(
        $sql
    );

    $stmt->execute(
        $params
    );

    $tours =
        $stmt->fetchAll();

} catch (
    PDOException $e
) {

    jsonResponse(
        [
            'success' => false,
            'message' =>
                'Ошибка выполнения запроса.'
        ],
        500
    );

}

$histogramWhere = [
    "t.status = 'active'"
];

$histogramParams = [];

if ($search !== '') {

    $histogramWhere[] = "
        (
            t.title LIKE :h_search
            OR t.description LIKE :h_search
            OR t.destination LIKE :h_search
        )
    ";

    $histogramParams[':h_search'] =
        '%' . $search . '%';

}

if ($destination !== '') {

    $histogramWhere[] = "
        t.destination LIKE :h_destination
    ";

    $histogramParams[':h_destination'] =
        '%' . $destination . '%';

}

if (
    count($tourTypes) > 0
) {

    $typePlaceholders = [];

    foreach (
        $tourTypes as $index => $type
    ) {

        $placeholder =
            ':h_type_' . $index;

        $typePlaceholders[] =
            $placeholder;

        $histogramParams[$placeholder] =
            $type;

    }

    $histogramWhere[] = "
        t.tour_type IN (
            " .
            implode(
                ',',
                $typePlaceholders
            ) .
            "
        )
    ";

}

if ($currency !== '') {

    $histogramWhere[] = "
        t.currency = :h_currency
    ";

    $histogramParams[':h_currency'] =
        $currency;

}

if (
    $durationMin !== null
) {

    $histogramWhere[] = "
        t.duration_days >= :h_duration_min
    ";

    $histogramParams[':h_duration_min'] =
        $durationMin;

}

if (
    $durationMax !== null
) {

    $histogramWhere[] = "
        t.duration_days <= :h_duration_max
    ";

    $histogramParams[':h_duration_max'] =
        $durationMax;

}

if (
    $participantsMin !== null
) {

    $histogramWhere[] = "
        t.max_participants >= :h_participants_min
    ";

    $histogramParams[':h_participants_min'] =
        $participantsMin;

}

if (
    $participantsMax !== null
) {

    $histogramWhere[] = "
        t.max_participants <= :h_participants_max
    ";

    $histogramParams[':h_participants_max'] =
        $participantsMax;

}

if ($availableDate !== '') {

    $date = DateTime::createFromFormat(
        'Y-m-d',
        $availableDate
    );

    if (
        $date &&
        $date->format('Y-m-d') ===
        $availableDate
    ) {

        $histogramWhere[] = "
            t.available_from <= :h_date
            AND t.available_to >= :h_date
        ";

        $histogramParams[':h_date'] =
            $availableDate;

    }

}

$histogramWhereSql =
    implode(
        ' AND ',
        $histogramWhere
    );

$statsSql = "
    SELECT

        MIN(t.price) AS min_price,

        MAX(t.price) AS max_price,

        COUNT(*) AS total_count

    FROM Tours t

    WHERE $histogramWhereSql
";

try {

    $statsStmt =
        $pdo->prepare(
            $statsSql
        );

    $statsStmt->execute(
        $histogramParams
    );

    $stats =
        $statsStmt->fetch();

} catch (
    PDOException $e
) {

    jsonResponse(
        [
            'success' => false,
            'message' =>
                'Ошибка расчёта диапазона цены.'
        ],
        500
    );

}

$minPriceDb =
    $stats['min_price'] !== null
        ? (float) $stats['min_price']
        : 0;

$maxPriceDb =
    $stats['max_price'] !== null
        ? (float) $stats['max_price']
        : 0;

$totalCount =
    (int) $stats['total_count'];

$binCount = 30;

$histogram =
    array_fill(
        0,
        $binCount,
        0
    );

if (
    $totalCount > 0
) {

    if (
        $maxPriceDb <=
        $minPriceDb
    ) {

        $histogram[0] =
            $totalCount;

    } else {

        $histogramSql = "
            SELECT

                FLOOR(
                    (
                        t.price - :hist_min
                    )
                    /
                    NULLIF(
                        :hist_max -
                        :hist_min,
                        0
                    )
                    *
                    :hist_bins
                ) AS price_bin,

                COUNT(*) AS bin_count

            FROM Tours t

            WHERE $histogramWhereSql

            GROUP BY price_bin

            ORDER BY price_bin
        ";

        $histogramParams[
            ':hist_min'
        ] =
            $minPriceDb;

        $histogramParams[
            ':hist_max'
        ] =
            $maxPriceDb;

        $histogramParams[
            ':hist_bins'
        ] =
            $binCount - 1;

        try {

            $histogramStmt =
                $pdo->prepare(
                    $histogramSql
                );

            $histogramStmt->execute(
                $histogramParams
            );

            $histogramRows =
                $histogramStmt->fetchAll();

            foreach (
                $histogramRows as $row
            ) {

                $bin =
                    (int) $row['price_bin'];

                $bin =
                    max(
                        0,
                        min(
                            $binCount - 1,
                            $bin
                        )
                    );

                $histogram[$bin] =
                    (int) $row['bin_count'];

            }

        } catch (
            PDOException $e
        ) {

            jsonResponse(
                [
                    'success' => false,
                    'message' =>
                        'Ошибка построения гистограммы.'
                ],
                500
            );

        }

    }

}

jsonResponse(
    [
        'success' => true,

        'tours' => $tours,

        'count' =>
            count($tours),

        'total_count' =>
            $totalCount,

        'price' => [

            'min' =>
                $minPriceDb,

            'max' =>
                $maxPriceDb,

            'histogram' =>
                $histogram

        ],

        'filters' => [

            'tour_types' =>
                getTourTypes(
                    $pdo
                ),

            'currencies' =>
                getCurrencies(
                    $pdo
                )

        ]

    ]
);