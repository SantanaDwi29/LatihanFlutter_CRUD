<?php
// ========== Delete.php ==========
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
$id = isset($_POST['id']) ? trim($_POST['id']) : '';

// Validate input
if (empty($id) || !is_numeric($id)) {
    echo json_encode(array(
        "status" => "error", 
        "message" => "Valid ID is required"
    ));
    exit;
}

// Convert to integer untuk keamanan
$id = intval($id);

// Delete query
$sql = "DELETE FROM books WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    if ($conn->affected_rows > 0) {
        echo json_encode(array(
            "status" => "success", 
            "message" => "Record deleted successfully"
        ));
    } else {
        echo json_encode(array(
            "status" => "error", 
            "message" => "No record found with that ID"
        ));
    }
} else {
    echo json_encode(array(
        "status" => "error", 
        "message" => "Error: " . $conn->error
    ));
}

$conn->close();
?>