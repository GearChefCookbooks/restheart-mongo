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
if `sudo docker ps -a | grep restheart`.size > 0
  execute('remove container') { command "docker rm -f restheart" }
end

docker_container 'restheart' do
  image 'restheart:latest'
  container_name 'restheart'
  port ['443:443']
  #link ['mongodb:mongodb']
  detach true
  action :run
end

