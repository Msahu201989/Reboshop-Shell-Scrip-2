LOG_FILE=/tmp/mysql
source common.sh

echo setting up MY SQL repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>LOG_FILE
statuscheck $?

echo Disable Mysql Default Module to enable 5.7 MYQL
dnf module disable mysql -y &>>LOG_FILE
statuscheck $?

echo Installing Mysql
yum install mysql-community-server -y &>>LOG_FILE
statuscheck $?

echo Starting MYQL service
systemctl enable mysqld &>>LOG_FILE
statuscheck $?
systemctl start mysqld &>>LOG_FILE
statuscheck $?

echo seting up password
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
statuscheck $?

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROBOSHOP_MYSQL_PASSWORD}');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "show databases;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>>LOG_FILE
if [ $? -ne 0 ; then
echo "Change the default password "
mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>LOG_FILE
statuscheck $?
fi











