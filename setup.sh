
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

host_machine_update_hosts $@
