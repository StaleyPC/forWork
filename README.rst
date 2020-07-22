# Deploy
helm install staging mayan

# Update/Upgrade
helm upgrade staging mayan

# Destroy
helm uninstall staging

# Default constelation
- 2 front end pods, .75 cores, 750MB, port 8000, host: mayan.k8s
- 2 fast workers, unrestricted
- 1 mediumd worker, .5 cores, 1GB
- 1 slow worker, .125 cores, 1.25GB
- 2 Celery flower dashboard, .125 cores, 128MB, port 5555, host: flower.mayan.k8s

# Default layout
Main chart: mayan
Frontend subchart: frontend
Workers subchart: workers
Celery Flower dashboard subchart: flower
