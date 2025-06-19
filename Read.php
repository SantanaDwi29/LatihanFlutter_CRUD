<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_crud";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM books";
$result = $conn->query($sql);

$books = array();

if ($result->num_rows > 0) {
  while($row = $result->fetch_assoc()) {
    $books[] = $row;
  }
  echo json_encode($books);
} else {
  echo "0 results";
}

$conn->close();
?>