CREATE USER 'ambari' IDENTIFIED BY 'hortonworks';
GRANT ALL PRIVILEGES ON *.* TO 'ambari';

CREATE USER 'hive' IDENTIFIED BY 'hortonworks';
GRANT ALL PRIVILEGES ON *.* TO 'hive';

CREATE USER 'oozie' IDENTIFIED BY 'hortonworks';
GRANT ALL PRIVILEGES ON *.* TO 'oozie';

CREATE USER 'ranger' IDENTIFIED BY 'hortonworks';
GRANT ALL PRIVILEGES ON *.* TO 'ranger';

CREATE USER 'ranger_kms' IDENTIFIED BY 'hortonworks';
GRANT ALL PRIVILEGES ON *.* TO 'ranger_kms';

FLUSH PRIVILEGES;
