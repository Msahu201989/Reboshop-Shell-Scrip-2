

statuscheck() {
  if [ $1 -eq 0 ] ; then
       echo status = Success
               else
                  echo status = Failure
                  exit 1
                  fi
                  }

 NODEJS () {
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
   echo download ${COMPONENT} app code
   curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/${COMPONENT}/main.zip" &>>$LOG_FILE
   statuscheck $?
           cd /home/roboshop
           echo removing content from ctalogue
           rm -rf ${COMPONENT} &>>$LOG_FILE
          statuscheck $?
           echo unzipping ${COMPONENT} APP CODE
           unzip /tmp/${COMPONENT}.zip &>>$LOG_FILE
         statuscheck $?
                echo moving catalogue data
           mv ${COMPONENT}-main ${COMPONENT} &>>$LOG_FILE
            statuscheck $?
           cd /home/roboshop/${COMPONENT} &>>$LOG_FILE
           echo installing dependencies
                  npm install &>>$LOG_FILE
               statuscheck $?

     echo Updating Systemd service file
     sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
     statuscheck $?


      echo setting up ${COMPONENT} service in systemd
                   mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG_FILE
                   echo daemon reload starting ${COMPONENT} service
                   systemctl daemon-reload
                    statuscheck $?
                       systemctl start ${COMPONENT} &>>$LOG_FILE
                   systemctl enable ${COMPONENT} &>>$LOG_FILE
           statuscheck $?

 }