# Ensure Helm repositories are up-to-date
helm repo add appsmith https://helm.appsmith.com
helm repo update

# Deploy or upgrade Appsmith with Helm in the appsmith namespace
helm upgrade --install appsmith appsmith/appsmith --namespace appsmith --create-namespace -f values.yml
