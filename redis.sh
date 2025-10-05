#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
# /var/log/shell-roboshop/redis.log

mkdir -p $LOGS_FOLDER
echo "Script started excuted at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script  with root previlage"
    exit 1
fi

validate(){
    if [ $1 -ne 0 ]; then
       echo -e "$2 .... $R FAILURE $N" | tee -a $LOG_FILE
       exit 1
    else
       echo -e "$2 .... $G SUCCESS $N" | tee -a $LOG_FILE
    fi 
}

dnf module disable redis -y  &>>$LOG_FILE
validate $? "Disable redis"

dnf module enable redis:7 -y  &>>$LOG_FILE
validate $? "Enable redis 7"

dnf install redis -y   &>>$LOG_FILE
validate $? "Installed redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g'  -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Allowing Remote connections to Redis "

systemctl enable redis  &>>$LOG_FILE
validate $? "Enable redis"

systemctl start redis   &>>$LOG_FILE
validate $? "Disable redis"