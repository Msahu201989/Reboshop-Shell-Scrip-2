LOG_FILE=/tmp/mongodb
echo downloading mogodb repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
    if [ $? -eq 0 ] ;
 then
    echo status = Success
 else
    echo status = Failure
    exit 1
    fi
echo installing mongodb
yum install -y mongodb-org &>>$LOG_FILE
 if [ $? -eq 0 ] ;
 then
    echo status = Success
 else
    echo status = Failure
    exit 1
    fi
echo enabling mongodb and starting mongodb
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
if [ $? -eq 0 ] ;
 then
    echo status = Success
 else
    echo status = Failure
    exit 1
    fi
echo updating ipaddress for mongodb
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
if [ $? -eq 0 ] ;
 then
    echo status = Success
 else
    echo status = Failure
    exit 1
    fi
  echo restarting mongodb
  systemctl restart mongodb &>>$LOG_FILE
    if [ $? -eq 0 ] ;
     then
        echo status = Success
     else
        echo status = Failure
        exit 1
        fi

      echo downloading Database Schema
      curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
      if [ $? -eq 0 ] ;
           then
              echo status = Success
           else
              echo status = Failure
              exit 1
              fi
              cd /tmp
              echo unzip mongodb
              unzip mongodb.zip &>>$LOG_FILE
              if [ $? -eq 0 ] ;
                   then
                      echo status = Success
                   else
                      echo status = Failure
                      exit 1
                      fi
                      echo lodaing schema database
              cd mongodb-main
              mongo < catalogue.js
              mongo < users.js
if [ $? -eq 0 ] ;
     then
        echo status = Success
     else
        echo status = Failure
        exit 1
        fi
