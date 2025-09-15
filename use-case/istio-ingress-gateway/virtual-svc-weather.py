apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: weather-app
  namespace: default
spec:
  hosts:
  - "weather.internal.local"
  gateways:
  - istio-system/internal-gateway
  http:
  - route:
    - destination:
        host: weather-python-api.default.svc.cluster.local
        port:
          number: 8080

apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: weather-python-api
  namespace: default
spec:
  hosts:
    - weather.internal.local
  gateways:
    - istio-system/python-api-gateway
  http:
    - route:
        - destination:
            host: weather-python-api.default.svc.cluster.local
            port:
              number: 8080