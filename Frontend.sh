LOG_FILE=/tmp/frontend
source common.sh

echo Installing Nginx
yum install nginx -y &>>$LOG_FILE

statuscheck $?


  echo Enabling nginx &>>$LOG_FILE
systemctl enable nginx

statuscheck $?

   echo starting nginx
systemctl start nginx

statuscheck $?
echo downloading nginx content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statuscheck $?
echo deploying nginx conent to default location
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip &>>$LOG_FILE
mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
statuscheck $?

echo restarting nginx service
systemctl restart nginx &>>$LOG_FILE
statuscheck $?