<?php
// 1. SETTINGS
$servername = "127.0.0.1"; // We use IP instead of 'localhost' to force TCP connection
$username = "root";
$password = ""; 
$dbname = "Manzaneque_Helpdesk"; 
$port = 3306; // <--- CHECK XAMPP! Is this 3306 or 3307? Change this number if needed.

// 2. CREATE CONNECTION
// We add the $port variable to the end
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// 3. CHECK CONNECTION
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
//echo "<h1>Connected successfully to Manzaneque Database!</h1>";
?>