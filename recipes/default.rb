#Decided to use a different mongo docker from tutum
#docker_image 'mongo:2.6' do
#  retries 3
#  retry_delay 2
#  cmd_timeout 900
#end

docker_image 'tutum/mongodb:2.6' do
  retries 3
  retry_delay 2
  cmd_timeout 900
end

docker_image 'java:8u45-jre' do
  retries 3
  retry_delay 2
  cmd_timeout 900
end

docker_image 'restheart' do
  retries 3
  retry_delay 2
  source '/var/tmp/docker/restheart'
  tag 'latest'
  action :build_if_missing
  cmd_timeout 900
end

#Destroy container at every run
if `sudo docker ps -a | grep mongodb`.size > 0
  execute('remove container') { command "docker rm -f mongodb" }
end

docker_container 'mongodb' do
  container_name 'mongodb'
  image 'tutum/mongodb:2.6'
  detach true
  env ["MONGO_PASS=#{node['mongodb']['password']}"]
  port ['27017:27017','28017:28017']
  volume '/var/lib/mongodb:/data/db'
end

#Destroy container at every run
if `sudo docker ps -a | grep restheart`.size > 0
  execute('remove container') { command "docker rm -f restheart" }
end

docker_container 'restheart' do
  image 'restheart:latest'
  container_name 'restheart'
  port ['443:443','80:80']
  env ["MONGO_PASS=#{node['mongodb']['password']}"]
  link ['mongodb:mongodb']
  detach true
  action :run
end

