LOG_FILE=/tmp/mongodb

source common.sh

echo downloading mogodb repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
statuscheck $?

echo installing mongodb
yum install -y mongodb-org &>>$LOG_FILE
statuscheck $?

echo enabling mongodb and starting mongodb
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE

statuscheck $?

echo updating ipaddress for mongodb
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statuscheck $?

  echo restarting mongodb
  systemctl restart mongod &>>$LOG_FILE
    statuscheck $?


      echo downloading Database Schema
      curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
      statuscheck $?

              cd /tmp
              echo unzip mongodb
              #unzip mongodb.zip &>>$LOG_FILE
             statuscheck $?

                      echo lodaing schema database
              cd mongodb-main
              mongo < catalogue.js &>>$LOG_FILE
              mongo < users.js &>>$LOG_FILE
statuscheck $?
