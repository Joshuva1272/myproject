<?php include 'db.php'; ?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Log New Call</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container" style="max-width: 600px;">
    <h1>📝 Log New Fault</h1>
    
    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $caller = $_POST['caller_id'];
        $equip = $_POST['equipment_id'];
        $tech = $_POST['tech_id'];
        $prob = $_POST['problem'];

        $sql = "INSERT INTO Call_Log (Caller_ID, Equipment_Serial, Assigned_Tech_ID, Problem_Description) 
                VALUES ('$caller', '$equip', '$tech', '$prob')";

        if ($conn->query($sql) === TRUE) {
            echo "<div style='background:#D1FAE5; color:#065F46; padding:15px; border-radius:8px; margin-bottom:20px;'>
                    ✅ <b>Success!</b> Call has been logged. <a href='index.php'>Return to Dashboard</a>
                  </div>";
        } else {
            echo "<div style='color:red'>Error: " . $conn->error . "</div>";
        }
    }
    ?>

    <form method="post" action="">
        <div class="form-group">
            <label>Caller ID (Employee)</label>
            <input type="number" name="caller_id" placeholder="e.g., 501" required>
        </div>

        <div class="form-group">
            <label>Equipment Serial No</label>
            <input type="text" name="equipment_id" placeholder="e.g., LPT-001" required>
        </div>

        <div class="form-group">
            <label>Assign Technician</label>
            <select name="tech_id">
                <?php
                $sql = "SELECT Tech_ID, Full_Name FROM Technician";
                $result = $conn->query($sql);
                while($row = $result->fetch_assoc()) {
                    echo "<option value='" . $row['Tech_ID'] . "'>" . $row['Full_Name'] . "</option>";
                }
                ?>
            </select>
        </div>

        <div class="form-group">
            <label>Problem Description</label>
            <textarea name="problem" rows="4" placeholder="Describe the issue in detail..." required></textarea>
        </div>

        <div style="margin-top: 20px;">
            <button type="submit" class="btn btn-primary" style="width:100%">Submit Ticket</button>
            <br><br>
            <center><a href="index.php" style="color:#6B7280; text-decoration:none;">Cancel and Go Back</a></center>
        </div>
    </form>
</div>

</body>
</html>