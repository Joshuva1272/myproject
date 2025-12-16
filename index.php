<?php include 'db.php'; ?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manzaneque Helpdesk | Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container fade-in">
    <div style="margin-bottom: 20px;">
        <a href="welcome.php" style="text-decoration:none; color: white; font-weight:bold;">← Back to Home</a>
    </div>

    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
            <div>
                <h1>IT Operations Dashboard</h1>
                <p>Real-time tracking of all active support tickets.</p>
            </div>
            <a href="log_call.php" class="btn btn-primary">+ Log New Fault</a>
        </div>

        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="🔍 Search issues, names, or IDs..." style="margin: 20px 0; padding: 15px; border-radius: 8px; border: 1px solid #ddd; width: 100%;">

        <div class="table-responsive slide-up">
            <table id="callTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Caller</th>
                        <th>Equipment</th>
                        <th>Issue Description</th>
                        <th>Technician</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    // SQL Query to fetch data
                    $sql = "SELECT 
                                c.Call_ID, 
                                e.Full_Name AS Caller, 
                                eq.Type, 
                                c.Problem_Description, 
                                t.Full_Name AS Tech, 
                                c.Status 
                            FROM Call_Log c
                            JOIN Employee e ON c.Caller_ID = e.Employee_ID
                            JOIN Equipment eq ON c.Equipment_Serial = eq.Serial_No
                            JOIN Technician t ON c.Assigned_Tech_ID = t.Tech_ID
                            ORDER BY c.Call_ID DESC";
                    
                    // CHECK FOR CONNECTION ERRORS
                    if (isset($conn)) {
                        $result = $conn->query($sql);
    
                        if ($result && $result->num_rows > 0) {
                            while($row = $result->fetch_assoc()) {
                                
                                // Color Badge Logic
                                $statusClass = 'status-open';
                                if($row["Status"] == 'Closed') $statusClass = 'status-closed';
                                if($row["Status"] == 'In Progress') $statusClass = 'status-progress';
    
                                echo "<tr>
                                        <td><b>#" . $row["Call_ID"] . "</b></td>
                                        <td>" . $row["Caller"] . "</td>
                                        <td>" . $row["Type"] . "</td>
                                        <td>" . $row["Problem_Description"] . "</td>
                                        <td>" . $row["Tech"] . "</td>
                                        <td><span class='status-badge $statusClass'>" . $row["Status"] . "</span></td>
                                        <td>";
                                
                                // Only show Close button if not already closed
                                if ($row["Status"] != 'Closed') {
                                    echo "<a href='update_call.php?id=" . $row["Call_ID"] . "' class='btn btn-sm btn-close'>Close</a> ";
                                }
                                
                                // Delete button with JS popup
                                echo "<a href='delete_call.php?id=" . $row["Call_ID"] . "' 
                                         class='btn btn-sm btn-delete'
                                         onclick='return confirmDelete(" . $row["Call_ID"] . ")'>Delete</a>
                                        </td>
                                      </tr>";
                            }
                        } else {
                            echo "<tr><td colspan='7' style='text-align:center'>No active calls found. Log one above!</td></tr>";
                        }
                    } else {
                        echo "<tr><td colspan='7' style='color:red; text-align:center'>Error: Database connection failed. Check db.php!</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="script.js"></script>

</body>
</html>