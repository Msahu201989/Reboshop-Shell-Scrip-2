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

echo "update roboshop config files"
sed -i -e '/catalogue s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping s/localhost/shipping.roboshop.internal/' /etc/nginx//default.d/roboshop.conf
statuscheck $?


echo restarting nginx service
systemctl restart nginx &>>$LOG_FILE
statuscheck $?