<?php
include 'db.php';

// Check if ID is set
if (isset($_GET['id'])) {
    $id = $_GET['id'];

    // SQL DELETE COMMAND
    $sql = "DELETE FROM Call_Log WHERE Call_ID = $id";

    if ($conn->query($sql) === TRUE) {
        // Success: Redirect back to dashboard
        echo "<script>
                alert('Record Deleted Successfully');
                window.location.href = 'index.php';
              </script>";
    } else {
        echo "Error deleting record: " . $conn->error;
    }
} else {
    echo "No ID provided!";
}
?>