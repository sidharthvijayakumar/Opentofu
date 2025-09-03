apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: advisor-app
  namespace: default
spec:
  hosts:
  - "advisor.internal.local"
  gateways:
  - istio-system/internal-gateway
  http:
  - route:
    - destination:
        host: advisor-python-api.default.svc.cluster.local
        port:
          number: 8081