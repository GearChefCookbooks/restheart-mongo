

docker_image 'mongo:2.6' do
  retries 3
  retry_delay 2
  cmd_timeout 900
end

docker_image 'softinstigate/restheart' do
  retries 3
  retry_delay 2
  cmd_timeout 900
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