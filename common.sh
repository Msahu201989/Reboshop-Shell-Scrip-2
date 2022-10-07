

statuscheck() {
  if [ $1 -eq 0 ] ; then
       echo status = Success
               else
                  echo status = Failure
                  exit 1
                  fi
                  }

APP_PREREQ() {
     id roboshop &>>$LOG_FILE
     if [ $? -ne 0 ] ; then
       echo add roboshop user
       useradd roboshop &>>$LOG_FILE
     statuscheck $?
             fi
     echo download ${COMPONENT} app code
     curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
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
}
SYSTEMD_SETUP(){
      echo Updating Systemd service file
       sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/'/home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
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

 NODEJS () {
   echo downloading nodejs
   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
   statuscheck $?
           echo Installing Nodejs
           yum install nodejs -y &>>$LOG_FILE
   statuscheck $?

APP_PREREQ

           echo installing dependencies
                  npm install &>>$LOG_FILE
               statuscheck $?

 SYSTEMD_SETUP
 }

 JAVA() {
   echo "INSTALL MAVEN"
   yum install maven -y &>>${LOG_FILE}
   statuscheck $?
   APP_PREREQ

   echo "download dependencies and make packages "


 mvn clean package &>>${LOG_FILE}
 mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
  statuscheck $?

SYSTEMD_SETUP
 }

 PYTHON() {
   echo "INSTALLING PYTHON 3"
   yum install python36 gcc python3-devel -y &>>${LOG_FILE}
   statuscheck $?
   APP_PREREQ

   cd /home/roboshop/${COMPONENT}

   echo "INstall Python dependenscie "
   pip3 install -r requirements.txt &>>${LOG_FILE}
   statuscheck $?

   APP_UID=$(id -u roboshop)
   APP_GID=$(id -g roboshop)

   echo "Update Payment configuration file"
   sed -i -e "/uid/ c uid = ${APP_UID}" -e "/gid/ c gid = ${APP_GID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>${LOG_FILE}
    statuscheck $?
 }