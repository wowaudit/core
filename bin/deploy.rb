REGISTER = false
TYPE = "deployer"
require_relative('../lib/core')

system("kubectl config use-context do-nyc3-wowaudit-scrapers")

system("kubectl delete deployments wcl-deployment")
system("kubectl delete deployments blizzard-deployment")
system("kubectl delete deployments keystones-deployment")
system("kubectl delete deployments historical-keystones-deployment")
system("kubectl delete deployments raiderio-deployment")

sleep 5
Audit::Schedule.all.each(&:destroy)

system("docker build . -t shedi/wowaudit")
system("docker push shedi/wowaudit:latest")

Audit::Schedule.all.each(&:destroy)

system("kubectl apply -f config/deploy/blizzard-deployment.yml")
system("kubectl apply -f config/deploy/keystones-deployment.yml")
system("kubectl apply -f config/deploy/historical-keystones-deployment.yml")
system("kubectl apply -f config/deploy/wcl-deployment.yml")
system("kubectl apply -f config/deploy/raiderio-deployment.yml")
