<?php
include 'db.php';

// Check if an ID was sent via the link
if (isset($_GET['id'])) {
    $id = $_GET['id'];

    // 1. UPDATE QUERY
    $sql = "UPDATE Call_Log SET Status='Closed' WHERE Call_ID=$id";

    if ($conn->query($sql) === TRUE) {
        // SUCCESS: Use JavaScript to redirect (Safe way)
        echo "<script>
                alert('Job Closed Successfully!');
                window.location.href = 'index.php';
              </script>";
        exit();
    } else {
        echo "Error updating record: " . $conn->error;
    }
} else {
    echo "No ID provided!";
}
?>