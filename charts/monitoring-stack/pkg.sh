repo_dir=~/Projets/helm
repo_url=https://data354.github.io/helm/

helm package . -d ~/Projets/helm/monitoring-stack
helm repo index $repo_dir --url $repo_url