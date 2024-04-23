#!/bin/bash    

source ./common.sh

check_root


echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing MySQL"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enablelling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql server"

# mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
# VALIDATE $? "setting up root password"

#below code will be idempotence in nature

mysql -h db.b12nagafacebook.xyz -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "mysql root password set up"
else 
    echo -e "MySQL root password already setup...$Y SKIPPING $N"
fi
    
