<?php
// Header untuk JSON response dan CORS
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_crud";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    // Return JSON error response
    echo json_encode(array(
        "status" => "error", 
        "message" => "Connection failed: " . $conn->connect_error
    ));
    exit;
}

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(array(
        "status" => "error", 
        "message" => "Method not allowed"
    ));
    exit;
}

// Get and validate POST data
$title = isset($_POST['title']) ? trim($_POST['title']) : '';
$author = isset($_POST['author']) ? trim($_POST['author']) : '';
$year = isset($_POST['year']) ? trim($_POST['year']) : '';

// Validate input
if (empty($title)) {
    echo json_encode(array(
        "status" => "error", 
        "message" => "Title is required"
    ));
    exit;
}

if (empty($author)) {
    echo json_encode(array(
        "status" => "error", 
        "message" => "Author is required"
    ));
    exit;
}

if (empty($year) || !is_numeric($year)) {
    echo json_encode(array(
        "status" => "error", 
        "message" => "Valid year is required"
    ));
    exit;
}

// Escape strings to prevent SQL injection
$title = $conn->real_escape_string($title);
$author = $conn->real_escape_string($author);
$year = intval($year);

// Insert query
$sql = "INSERT INTO books (title, author, year) VALUES ('$title', '$author', $year)";

if ($conn->query($sql) === TRUE) {
    // Return success response
    echo json_encode(array(
        "status" => "success", 
        "message" => "New record created successfully",
        "id" => $conn->insert_id
    ));
} else {
    // Return error response
    echo json_encode(array(
        "status" => "error", 
        "message" => "Error: " . $conn->error
    ));
}

$conn->close();
?>