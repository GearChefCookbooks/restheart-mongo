docker_image 'mongo:2.6' do
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

if `sudo docker ps -a | grep mongodb`.size > 0
  execute('stop container') { command "docker stop -t 60 mongodb" }
  execute('remove container') { command "docker rm -f mongodb" }
end

docker_container 'mongodb' do
  container_name 'mongodb'
  image 'mongo:2.6'
  detach true
  port '27017:27017'
  volume '/var/lib/mongodb:/data/db'
end

if `sudo docker ps -a | grep restheart`.size > 0
  execute('stop container') { command "docker stop -t 60 restheart" }
  execute('remove container') { command "docker rm -f restheart" }
end




#if `sudo docker ps -a | grep postgres`.size == 0
#  docker_container 'postgres' do
#    image 'austenito/postgres:9.3'
#    container_name 'postgres'
#    port "5432:5432"
#    detach true
#    env ["POSTGRES_USER=#{node['postgresql']['user']}",
#         "POSTGRES_PASSWORD=#{node['postgresql']['password']}"
#        ]
#    volumes_from 'gem-cache'
#    action :run
#  end
#end
#
#
#if `sudo docker ps -a | grep rails-example`.size > 0
#  execute('stop container') { command "docker stop -t 60 rails-example" }
#  execute('remove container') { command "docker rm -f rails-example" }
#end
#
#docker_container 'rails-example' do
#  image 'austenito/rails-example'
#  container_name 'rails-example'
#  detach true
#  link ['postgres:db']
#  volumes_from 'gem-cache'
#  action :run
#  port '3000:3000'
#end
#
#docker_image 'austenito' do
#  retries 0
#  retry_delay 2
#  source '/tmp/nginx'
#  tag 'nginx'
#  action :build_if_missing
#  cmd_timeout 900
#end
#
#if `sudo docker ps -a | grep nginx`.size > 0
#  execute('stop container') { command "docker stop -t 60 nginx" }
#  execute('remove container') { command "docker rm -f nginx" }
#end
#
#docker_container 'nginx' do
#  image 'austenito:nginx'
#  container_name 'nginx'
#  port "80:80"
#  link ['rails-example:rails_example']
#  volumes_from 'gem-cache'
#  detach true
#  action :run
#end
