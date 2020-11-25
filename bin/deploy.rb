REGISTER = false
TYPE = "deployer"
require_relative('../lib/core')

system("kubectl delete deployments wcl-deployment")
system("kubectl delete deployments essentials-deployment")
system("kubectl delete deployments collections-deployment")
system("kubectl delete deployments keystones-deployment")
system("kubectl delete deployments raiderio-deployment")

sleep 5
Audit::Schedule.all.each(&:destroy)

system("docker build . -t shedi/wowaudit")
system("docker push shedi/wowaudit:latest")

Audit::Schedule.all.each(&:destroy)

system("kubectl apply -f config/deploy/essentials-deployment.yml")
system("kubectl apply -f config/deploy/collections-deployment.yml")

# Don't deploy Raids & Mythic+ scrapers before they are available
# system("kubectl apply -f config/deploy/keystones-deployment.yml")
# system("kubectl apply -f config/deploy/wcl-deployment.yml")
# system("kubectl apply -f config/deploy/raiderio-deployment.yml")
