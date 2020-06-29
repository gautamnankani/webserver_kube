#!/bin/bash

html_pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=html-webserver)
php_pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=php-webserver)

dir="test555"
html_files=$(ls $dir | grep [.]html)
php_files=$(ls $dir | grep [.]php)

stat="false"
echo "waiting for html container to start"
while [ $stat != "true" ]
do
        stat=$(kubectl get pods -o=jsonpath={.items[*].status.containerStatuses[0].started} -l app=html-webserver)
	sleep 1
	echo -n "."
done
echo " html Server Started "

echo -n "Copying html files: "
for file in $html_files
do
  echo -n "."
  kubectl cp test555/$file $html_pod_name:/usr/local/apache2/htdocs/
done
echo " "

stat="false"
echo "waiting for php container to start"
while [ $stat != "true" ]
do
        stat=$(kubectl get pods -o=jsonpath={.items[*].status.containerStatuses[0].started} -l app=php-webserver)
	sleep 1
	echo -n "."
done
echo "php Server Started"

echo -n "Copying php files: "
for file in $php_files   
do
  echo -n "."
  kubectl cp test555/$file $php_pod_name:/var/www/html/
done
echo " "
