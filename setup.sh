
echo "remove containers"
docker rm -f $(docker ps -aq)

echo "Start updateing host file"

function h1() {
  echo ""
  echo "###########################################################################################################"
  echo "$@"
  echo "###########################################################################################################"
}

function host_machine_update_hosts() {
  h1 "Updating host machine's /etc/hosts file"
  #Updating /etc/hosts file on host machine
  h1 "Updating /etc/hosts file of host machine"
  
  startString="##SNEHA CLUSTER START##"
  endString="##SNEHA CLUSTER END##"
  
  #Build entry to add to /etc/hosts by reading info from Docker
  hostString="$startString\n"
  images=( $(docker ps -a | grep sneha | awk '{print $NF}') )
  for image in "${images[@]}" ; do
    hostname=$(docker inspect -f '{{ .Config.Hostname }}' $image)
    hostString="$hostString$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $hostname)    $hostname\n"
  done
  hostString="$hostString$endString\n"
  
  if [ ! -f /etc/hosts ] ; then
    echo -e "\nERROR!!!\nYou don't have write permissions for /etc/hosts!!!\nManually add this to your /etc/hosts file:"
    echo -e "$hostString"
    return
  fi
  
  #Strip out old entry
  out=`sed "/$startString/,/$endString/d" /etc/hosts`
  #write new hosts file
  echo -e "$out\n$hostString" > /etc/hosts
  echo -e "$hostString"

  #ip_route
}


function container_update_hosts() {
  h1 "Update /etc/hosts file on containers"
  HOSTS=$'## sneha server ##\n'
  HOSTS+=$'127.0.0.1 localhost\n\n'
  images=( $(docker ps -a | grep sneha | awk '{print $NF}') )
  for image in "${images[@]}" ; do
    #extract the container name
    container_name=$(docker inspect -f {{.Config.Hostname}} $image)
    container_domain=$(docker inspect -f {{.Config.Domainname}} $image)
    #extract the container ip
    container_ip=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $image)
    #extract the container running state
    container_running=$(docker inspect -f {{.State.Running}} $image)
    HOSTS+="$container_ip $container_name"
    HOSTS+=$'\n'
    #echo "container id = $image, container name = $container_name, container ip = $container_ip, container running = $container_running"
  done

  echo ""
  echo "Insert Content:"
  echo ""
  echo "-----------------------------------------------------------------------------------------------"
  echo "$HOSTS"
  echo "-----------------------------------------------------------------------------------------------"
  for image in "${images[@]}" ; do
    #extract the container name
    container_name=$(docker inspect -f {{.Config.Hostname}} $image)
    
    #Update ssh key while we're at it
    #echo "ssh-keygen -R $container_name"
    #ssh-keygen -R $container_name
    
    echo "Update /etc/hosts for $container_name"
    ssh -o StrictHostKeyChecking=no root@$container_name "echo '$HOSTS'  > /etc/hosts"
  done
}

host_machine_update_hosts $@
container_update_hosts $@

docker run -d -p 22 -p 2181 --privileged -h zookeeper-1 --name zookeeper-1 zookeeper-1:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-1 --name kafka-1 kafka-1:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-2 --name kafka-2 kafka-2:sneha
docker run -d -p 22 -p 2181 --privileged -h kafka-3 --name kafka-3 kafka-3:sneha

sleep 5

echo "Start Zookeeper"

docker exec -it zookeeper-1 /opt/zookeeper/bin/zkServer.sh start

sleep 5


echo "Start 3 Kafka"
docker exec -it kafka-1 /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
docker exec -it kafka-2 /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
docker exec -it kafka-3 /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
