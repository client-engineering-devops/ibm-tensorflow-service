# ibm-tensorflow-service


To run the Makefile, you need configure the following environment variables

```
# Edge Application Manager HUB location and credentials
HZN_EXCHANGE_USER_AUTH=iamapikey:<api-key>
HZN_ORG_ID=<your-exchange-organization>
HZN_EXCHANGE_URL=https://<ieam-management-hub-ingress>/edge-exchange/v1
HZN_FSS_CSSURL=https://<ieam-management-hub-ingress>/edge-css/

# Registry Location and Credentials
QUAY_REGISTRY_HOST=<registry host, i.e. quay.io>
QUAY_USER=<user-id>
QUAY_USER_TOKEN=<user-token>
```