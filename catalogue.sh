#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.daws96s.cfd
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
# /var/log/shell-roboshop/catalogue.log

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

dnf module disable nodejs -y &>>$LOG_FILE
validate $? "disable nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
validate $? "enabling nodejs 20"

dnf install nodejs -y &>>$LOG_FILE
validate $? "Installing nodejs"

id roboshop
if [ $? -ne 0 ]; then
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
     validate $? "Creating system user"
else
    echo "User already exists ...$Y SKIPPING $N"
fi

mkdir -p /app 
validate $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE
validate $? "Creating app directory"

cd /app 
validate $? "Changing app directory"

unzip /tmp/catalogue.zip &>>$LOG_FILE
validate $? "Unzip catalogue"

npm install &>>$LOG_FILE
validate $? "Install dependecies"


cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
validate $? "Copy systemctl service"


systemctl daemon-reload
systemctl enable catalogue &>>$LOG_FILE
validate $? "Enable catalogue "


cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo 
validate $? "Copy mongo repo"


dnf install mongodb-mongosh -y &>>$LOG_FILE
validate $? "Install mongodb client"

mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
validate $? "Load catalogue product"

systemctl restart catalogue 
validate $? "Restarted catalogue"