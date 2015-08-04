#Decided to use a different mongo docker from tutum
#docker_image 'mongo:2.6' do
#  retries 3
#  retry_delay 2
#  cmd_timeout 900
#end

docker_image 'gear2000/mongodb-10gen:2.6' do
  retries 3
  retry_delay 2
  cmd_timeout 900
end

#Destroy container at every run
if `sudo docker ps -a | grep mongodb`.size > 0
  execute('remove container') { command "docker rm -f mongodb" }
end

docker_container 'mongodb' do
  container_name 'mongodb'
  image 'gear2000/mongodb-10gen:2.6'
  detach true
  env ["MONGODB_PASS=#{node['mongodb']['password']}"]
  port ['27017:27017','28017:28017']
  volume '/var/lib/mongodb:/data/db'
end

