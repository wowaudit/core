REGISTER = false
TYPE = "deployer"
require_relative('../lib/core')

system("kubectl config use-context do-nyc3-wowaudit-scrapers")

system("kubectl delete deployments wcl-deployment-acc")
system("kubectl delete deployments blizzard-deployment-acc")
system("kubectl delete deployments keystones-deployment-acc")
system("kubectl delete deployments historical-keystones-deployment-acc")
system("kubectl delete deployments raiderio-deployment-acc")

sleep 5
Audit::Schedule.all.each(&:destroy)

system("docker build . --platform linux/amd64 -t shedi/wowaudit")
system("docker push shedi/wowaudit-acc:latest")

Audit::Schedule.all.each(&:destroy)

system("kubectl apply -f config/deploy/blizzard-deployment-acc.yml")
system("kubectl apply -f config/deploy/keystones-deployment-acc.yml")
system("kubectl apply -f config/deploy/historical-keystones-deployment-acc.yml")
system("kubectl apply -f config/deploy/wcl-deployment-acc.yml")
system("kubectl apply -f config/deploy/raiderio-deployment-acc.yml")
