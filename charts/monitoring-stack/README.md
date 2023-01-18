<img src="https://static.wixstatic.com/media/84b0cf_beb914d4ae1c4a67a943e2a56de2b767~mv2.png/v1/fill/w_216,h_65,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/logo-data354_CL.png"/>

<img src="https://github.com/data354/monitoring-stack/raw/main/technoSet.png" />

MS54 is a set of monitoring and logging tools (Loki, Grafana, Prometheus, FLuentd) that aims to facilitate the management of logs and the monitoring of metrics of several applications.

- Grafana is an open-source tool for creating and displaying interactive dashboards of metric data. It can be used to monitor the performance of systems and applications, and to identify trends and patterns that may indicate issues or problems.
- Prometheus is an open-source monitoring tool that is designed to be horizontally scalable and highly available. It is used to monitor the performance of systems and applications, and can be configured to send alerts when certain thresholds are breached.
- Loki is an open-source log aggregation and analysis tool that is designed to be used in conjunction with Grafana. It is designed to be horizontally scalable and can handle large volumes of log data.
- Fluentd is an open-source log aggregation and analysis tool that is designed to be used in distributed systems. It is used to collect, parse, and store log data from a variety of sources, and can be used to monitor the performance of systems and applications.

## **Prerequisites**

```
Kubernetes 1.16+
Helm 3+
```

## **Managing package**

### Get Helm Repository Info

```bash
helm repo add data354-helm https://data354.github.io/helm
helm repo update
```

### Installing Helm Chart

```bash
helm install [RELEASE_NAME] data354-helm/monitoring-stack
```

Note that the above command will install Superset into current namespace of your Kubernetes cluster. If you want to use another namespace specify it:

```bash
helm install [RELEASE_NAME] data354-helm/monitoring-stack  --namesape monitoring-stack 
```

``monitoring-stack`` namespace which must exist before.

### Uninstalling Helm Chart

```bash
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

See [*helm uninstall*](https://helm.sh/docs/helm/helm_uninstall/) for command documentation.

### Upgrading Helm Chart

```bash
helm upgrade [RELEASE_NAME] data354-helm/data-fair
```
