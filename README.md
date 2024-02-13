# msk-debezium-aurora
Project configuration files to connect Debezium to Aurora running on RDS with MSK


**Configuration Files**

kafka_connect_source.setup
: this file includes the required configurations for debezium mysql connector 



kafka_connect_destination.setup
: this file includes the required configurations for S3 sink connector


ec2-user-data.txt
: this file includes the all the required dependencies to connect EC2 client to aurora and kafka, copy the user-data when launching ec2 instance

kafka-custom-conf 
: this file includes custom configuration required when creating MSK to enable kafka connect to create topics automatically


kafka-ec2-conn
: this file includes some kafka commands to verify success creation of topics by kafka connect, data dump into topics, etc


