LOG_FILE=/tmp/catalogue
echo downloading nodejs
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
if [ $? -eq 0 ] ;
           then
              echo status = Success
           else
              echo status = Failure
              exit 1
              fi
        echo Installing Nodejs
        yum install nodejs -y &>>$LOG_FILE
        if [ $? -eq 0 ] ;
                   then
                      echo status = Success
                   else
                      echo status = Failure
                      exit 1
                      fi
echo Adding ROBOSHOP APplication USER
useradd roboshop &>>$LOG_FILE
if [ $? -eq 0 ] ;
                   then
                      echo status = Success
                   else
                      echo status = Failure
                      exit 1
                      fi
echo download catalogue app code
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
 if [ $? -eq 0 ] ;
                   then
                      echo status = Success
                   else
                      echo status = Failure
                      exit 1
                      fi
        cd /home/roboshop
        echo unzipping catalogue
        unzip /tmp/catalogue.zip &>>$LOG_FILE
        if [ $? -eq 0 ] ;
                           then
                              echo status = Success
                           else
                              echo status = Failure
                              exit 1
                              fi
             echo moving catalogue data
        mv catalogue-main catalogue &>>$LOG_FILE
         if [ $? -eq 0 ] ;
                                   then
                                      echo status = Success
                                   else
                                      echo status = Failure
                                      exit 1
                                      fi
        cd /home/roboshop/catalogue &>>$LOG_FILE
        echo installing dependencies
               npm install &>>$LOG_FILE
                if [ $? -eq 0 ] ;
                                          then
                                             echo status = Success
                                          else
                                             echo status = Failure
                                             exit 1
                                             fi
             echo setting up service in systemd
             mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
             echo daemon reload starting ctalogue service
             systemctl daemon-reload
                          systemctl start catalogue $>>$LOG_FILE
             systemctl enable catalogue $>>$LOG_FILE
           if [ $? -eq 0 ] ;
                      then
                         echo status = Success
                      else
                         echo status = Failure
                         exit 1
                         fi