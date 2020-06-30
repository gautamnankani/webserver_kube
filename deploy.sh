#!/bin/bash
if [ -n $(ls | grep test555) ]
then
rm -rf test555/ 
fi

echo "Cloning.........................................."
sudo git clone --single-branch --branch master https://github.com/gautamnankani/test555.git

launch_container(){
	file_name=$1
	echo "deployng $file_name ......................................"
	$(sudo kubectl get -f $file_name &> err)
	if [[ -n $(cat err | grep NotFound) ]]
	then
		echo "Launching server......................................."
		sudo kubectl create -f $file_name
	else	
	        echo "server already present"
	fi
}


dir="test555"

if [[ -n $(ls $dir | grep [.]html) ]]
then
	launch_container webserver_kube/jen_html.yml
fi

if [[ -n $(ls $dir | grep [.]php) ]]
then
	launch_container webserver_kube/jen_php.yml
fi


