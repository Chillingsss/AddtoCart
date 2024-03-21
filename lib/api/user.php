<?php

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

class UserData
{
    public function getUserData($username, $password)
    {
        global $conn;

        $sql = "SELECT * FROM tbl_users WHERE username=:username AND password=:password";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $password);
        $stmt->execute();
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return $returnValue;
    }
}

$operation = isset ($_GET["operation"]) ? $_GET["operation"] : "Invalid";

$userData = new UserData();
switch ($operation) {
    case "getUserData":
        $username = $_GET['username'];
        $password = $_GET['password'];
        $result = $userData->getUserData($username, $password);
        echo json_encode($result);
        break;
    default:
        echo json_encode(array("status" => -1, "message" => "Invalid operation."));
}
?>