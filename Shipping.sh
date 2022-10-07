


echo "Installing Maven as we need JAVA"

yum install maven -y &>>LOG_FILE

echo "AS per process Adding user robohop to run this app"
useradd roboshop

echo "downloading repo"
cd /home/roboshop
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
echo "unzipping data"
unzip /tmp/shipping.zip
$ mv shipping-main shipping
$ cd shipping
$ mvn clean package
$ mv target/shipping-1.0.jar shipping.jar



