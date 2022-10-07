LOG_FILE=/tmp/catalogue

source common.sh

echo downloading nodejs
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
statuscheck $?
        echo Installing Nodejs
        yum install nodejs -y &>>$LOG_FILE
statuscheck $?

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ] ; then
  echo add roboshop user
  useradd roboshop &>>$LOG_FILE
statuscheck $?
        fi
echo download catalogue app code
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
statuscheck $?
        cd /home/roboshop
        echo removing content from ctalogue
        rm -rf catalogue &>>$LOG_FILE
       statuscheck $?
        echo unzipping catalogue
        unzip /tmp/catalogue.zip &>>$LOG_FILE
      statuscheck $?
             echo moving catalogue data
        mv catalogue-main catalogue &>>$LOG_FILE
         statuscheck $?

        cd /home/roboshop/catalogue &>>$LOG_FILE
        echo installing dependencies
               npm install &>>$LOG_FILE
            statuscheck $?

             echo setting up service in systemd
             mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
             echo daemon reload starting ctalogue service
             systemctl daemon-reload
              statuscheck $?
                 systemctl start catalogue &>>$LOG_FILE
             systemctl enable catalogue &>>$LOG_FILE
       statuscheck $?