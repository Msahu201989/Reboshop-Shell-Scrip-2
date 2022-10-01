LOG_FILE=/tmp/catalogue

source common.sh


echo We Need NodeJS
echo Downloading NodeJS
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
statuscheck $?


echo Installing NodeJS NOW
yum install nodejs -y &>>$LOG_FILE
statuscheck $?

echo Creating Roboshop User
id roboshop &>>$LOG_FILE
if [ $? -ne 0 ] ; then
  echo add roboshop user
  useradd roboshop &>>$LOG_FILE
statuscheck $?
        fi

 echo downloading Robohop conent
 curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
 statuscheck $?


echo Installing NodeJS service
 cd /home/roboshop &>>$LOG_FILE
 unzip /tmp/user.zip &>>$LOG_FILE
 statuscheck $?
 mv user-main user &>>$LOG_FILE
 cd /home/roboshop/user &>>$LOG_FILE
 npm install &>>$LOG_FILE
 statuscheck $?

echo Updating Systemd service file
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' /home/roboshop/user/systemd.service &>>$LOG_FILE
statuscheck $?


 echo setting up USER service in systemd
              mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>$LOG_FILE
              echo daemon reload starting ctalogue service
              systemctl daemon-reload
               statuscheck $?
                  systemctl start user &>>$LOG_FILE
              systemctl enable user &>>$LOG_FILE
      statuscheck $?

