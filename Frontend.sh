LOG_FILE=/tmp/frontend
echo Installing Nginx
yum install nginx &>>$LOG_FILE

if [ $? -eq 0 ] ;
then
  echo status = Success
  else
    echo status = Failure
    exit 1
    fi


  echo Enabling nginx
systemctl enable nginx

if [ $? -eq 0 ] ;
then
  echo status = Success
  else
    echo status = Failure
    exit 1
    fi

   echo starting nginx
systemctl start nginx

if [ $? -eq 0 ] ;
then
  echo status = Success
  else
    echo status = Failure
    exit 1
    fi
echo downloading nginx content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ] ;
then
  echo status = Success
  else
    echo status = Failure
    exit 1
    fi
Echo deploying nginx conent to default location & removing old conent
cd /usr/share/nginx/html &>>$LOG_FILE
rm -rf * &>>$LOG_FILE
unzip /tmp/frontend.zip &>>$LOG_FILE
mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
if [ $? -eq 0 ] ;
then
  echo status = Success
  else
    echo status = Failure
    exit 1
    fi

echo restarting nginx service
systemctl restart nginx &>>$LOG_FILE
if [ $? -eq 0 ] ;
then
  echo status = Success
  else
    echo status = Failure
    exit 1
    fi