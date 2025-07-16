<?php
define('ROOT_PATH', __DIR__ . DIRECTORY_SEPARATOR);


try {
    $server = "localhost";
    $port = "1433";
    $dbname = "LendingClub";
    $username = "LoginPHP";
    $password = "PHPTest12345";

    $con = new PDO("sqlsrv:Server=$server,$port;Database=$dbname", $username, $password);

    $name_data = ROOT_PATH . 'data\loan_end.csv';

    $gestor = fopen($name_data, 'r');
    $delimiter = ',';

    if ($gestor) {
        $i = 0;

        $stmt = $con->prepare("EXEC InsertLoanComplete @Name= :nam, @Lastname= :lstnam, @Sex= :sex,
                                    @Log_annual_inc= :log, @Dti= :dti, @Pub_rec= :pub,
                                    @FICO= :fico, @Name_Purpose= :purp, @Credit_policy= :credit,
                                    @Int_rate= :intrate, @Fee= :fee, @Date_loan= :date, @Days_with_cr_line= :days_cr_line,
                                    @Revol_bal= :bal, @Revol_util= :util, @Inq_last_6mths= :inq, @Delinq_2yrs= :delinq,
                                    @Fully_paid= :paid");
        /* fgetcsv($file_open, cant_characters (null = unlimited), $delimiter (delimitier of csv))      Devolverá False cuando se termine el archivo*/
        while (($data = fgetcsv($gestor, null, $delimiter)) != FALSE) {
            $i++;
            if ($i == 1) {
                continue;
            }

            $name = $data[0];
            $lastname = $data[1];
            $sex = $data[2];
            $credit_policy = $data[3];
            $purpose = $data[4];
            $int_rate = $data[5];
            $fee = $data[6];
            $log_annual_inc = $data[7];
            $dti = $data[8];
            $fico = $data[9];
            $days_with_cr_line = $data[10];
            $revol_bal = $data[11];
            $revol_util = $data[12];
            $inq_last_6mths = $data[13];
            $delinq_2yrs = $data[14];
            $pub_rec = $data[15];
            $Fully_paid = $data[16];
            $date_loan = $data[17];

            if ($i == 2) {
                $stmt->bindParam(":nam", $name, PDO::PARAM_STR);
                $stmt->bindParam(":lstnam", $lastname, PDO::PARAM_STR);
                $stmt->bindParam(":sex", $sex, PDO::PARAM_STR); //CHAR
                $stmt->bindParam(":log", $log_annual_inc, PDO::PARAM_STR); //FLOAT
                $stmt->bindParam(":dti", $dti, PDO::PARAM_STR); //FLOAT
                $stmt->bindParam(":pub", $pub_rec, PDO::PARAM_INT);
                $stmt->bindParam(":fico", $fico, PDO::PARAM_INT);
                $stmt->bindParam(":purp", $purpose, PDO::PARAM_STR);
                $stmt->bindParam(":credit", $credit_policy, PDO::PARAM_STR); //CHAR
                $stmt->bindParam(":intrate", $int_rate, PDO::PARAM_STR); //FLOAT
                $stmt->bindParam(":fee", $fee, PDO::PARAM_STR); //FLOAT
                $stmt->bindParam(":date", $date_loan, PDO::PARAM_STR); //DATE
                $stmt->bindParam(":days_cr_line", $days_with_cr_line, PDO::PARAM_INT);
                $stmt->bindParam(":bal", $revol_bal, PDO::PARAM_INT);
                $stmt->bindParam(":util", $revol_util, PDO::PARAM_STR); //FLOAT
                $stmt->bindParam(":inq", $inq_last_6mths, PDO::PARAM_INT);
                $stmt->bindParam(":delinq", $delinq_2yrs, PDO::PARAM_INT);
                $stmt->bindParam(":paid", $Fully_paid, PDO::PARAM_STR); //CHAR
            }
            $stmt->execute();

            $value = $stmt->fetch(PDO::FETCH_ASSOC);
            if (null != $value){
                // $value = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                echo "<br><br>";
                var_dump($value);
                echo "<br><br>";

            }
            // $error = $stmt->fetch(PDO::FETCH_ASSOC);
            // print_r($error);

            echo "$i rows affected" . "<br>";
        }
        $nfile = basename($name_data);

        echo "Se insertaron todas las filas {$i} del archivo: $nfile";

        fclose($gestor);
    }
} catch (PDOException $e) {
    echo "Sucedió un error: \n$e";
}
