LOG_FILE=/tmp/catalogue

source common.sh

echo Downloading Redis Content
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
statuscheck $?

echo Installing Redis
yum install redis-6.2.7 -y &>>$LOG_FILE
statuscheck $?

echo updating ipaddress for Redis
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>$LOG_FILE
statuscheck $?

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>$LOG_FILE
statuscheck $?


echo Starting Redis Database

systemctl enable redis &>>$LOG_FILE
 statuscheck $?

systemctl start redis  &>>$LOG_FILE
 statuscheck $?

