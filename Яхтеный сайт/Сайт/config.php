<?php
// config.php
// Настройки подключения к MySQL (укажи свои!)
$host = 'localhost';          // обычно localhost на Timeweb
$dbname = 'cl76980_freewind';        // имя БД из панели Timeweb
$username = 'cl76980_freewind'; // логин от БД
$password = 'Jhattxrf_006';    // пароль от БД

try {

    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $username,
        $password
    );

    $pdo->setAttribute(
        PDO::ATTR_ERRMODE,
        PDO::ERRMODE_EXCEPTION
    );

    $pdo->setAttribute(
        PDO::ATTR_DEFAULT_FETCH_MODE,
        PDO::FETCH_ASSOC
    );

} catch (PDOException $e) {

    die(
        "Ошибка подключения к базе данных: " .
        htmlspecialchars($e->getMessage())
    );

}

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
?>