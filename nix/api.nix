{ pkgs, imageName }:
pkgs.writeText "trivial-k8s.yaml" ''
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: trivial
      namespace: trivial
      labels:
        app.kubernetes.io/name: trivial
        app.kubernetes.io/component: api
        app.kubernetes.io/part-of: fyfaen
        app.kubernetes.io/managed-by: nix
      annotations:
        cluster.fyfaen.as/owner: carl
        cluster.fyfaen.as/purpose: "trivial api that exists to make deployments happen"
    spec:
      replicas: 1
      selector:
        matchLabels:
          app.kubernetes.io/name: trivial
      template:
        metadata:
          labels:
            app.kubernetes.io/name: trivial
        spec:
          containers:
            - name: trivial
              image: ${imageName}
              ports:
                - containerPort: 3000
  ---
    apiVersion: v1
    kind: Service
    metadata:
      name: trivial
      namespace: trivial
      labels:
        app.kubernetes.io/name: trivial
      annotations:
        cluster.fyfaen.as/owner: carl
        cluster.fyfaen.as/visible: "true"
    spec:
      selector:
        app.kubernetes.io/name: trivial
      ports:
        - protocol: TCP
          port: 3000
          targetPort: 3000
  ---
    apiVersion: gateway.networking.k8s.io/v1beta1
    kind: HTTPRoute
    metadata:
      name: trivial
      namespace: trivial
      labels:
        app.kubernetes.io/name: trivial
      annotations:
        cluster.fyfaen.as/owner: carl
        cluster.fyfaen.as/https: "true"
        cluster.fyfaen.as/external: "true"
    spec:
      parentRefs:
        - name: fyfaen-gw
          namespace: gateway-namespace
      hostnames:
        - api.fyfaen.as
      rules:
        - matches:
            - path:
                type: PathPrefix
                value: /trivial
          backendRefs:
            - name: trivial
              port: 3000
''
