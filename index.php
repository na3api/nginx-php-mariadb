<?php

try {
    $dbh = new PDO('mysql:host=mariadb;dbname=new_db', 'root', 'root');

    echo '<h1>DB connection works correct!</h1>';

    echo '<pre>';
    foreach($_ENV as $key => $env){
        echo '<b>' . $key . '</b>: ' . $env . PHP_EOL;
    }

    $dbh = null;
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}