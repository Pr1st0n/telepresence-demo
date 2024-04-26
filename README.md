# Telepresence Demo [MacOS]

This repository contains a demonstration project showcasing the usage of Telepresence with two microservices, Ping and Pong, running in a local Minikube cluster. The purpose of this project is to demonstrate how local development can be seamlessly integrated with services running in a Kubernetes environment.

## Overview

This project leverages Telepresence to allow developers to debug and develop services locally as if they were running in a Kubernetes cluster. It includes a basic setup where the Ping service calls the Pong service. With Telepresence, developers can intercept these calls to route them to a local instance of the Pong service, enabling easier testing and development.

## Prerequisites

Before setting up this project, please ensure you have the following installed on your MacOS system:

- Docker
- Minikube
- Telepresence
- kubectl
- curl (for testing HTTP requests)
- Node.js (to run the Pong service locally)

## Installation

Follow these steps to set up the necessary components and deploy the Ping and Pong services to your local Kubernetes cluster using Minikube:

### Install Telepresence

Install Telepresence by following the [Telepresence Installation Guide](https://www.telepresence.io/docs/latest/quick-start/).

### Install Minikube

Follow the [Minikube Installation Guide](https://minikube.sigs.k8s.io/docs/start/) to install Minikube.

### Start Minikube

Start your Minikube cluster with the following command:

```zsh
minikube start
```

## Project Setup

### Initialize Services

1. **Initialize the project:**

   Make the initialization and cleanup scripts executable:

   ```zsh
   chmod +x init.sh
   chmod +x cleanup.sh
   ```

   Run the initialization script:

   ```zsh
   ./init.sh
   ```

2. **Enable access to the Ping service:**

   In a new terminal window, forward the Ping service port to access it locally:

   ```zsh
   kubectl port-forward svc/ping 30000:3000
   ```

   In the initial terminal window, test the Ping service; it should return "pong":

   ```zsh
   curl localhost:30000/ping
   ```

## Using Telepresence

Here’s how to use Telepresence to debug and develop locally:

1. **Set up Telepresence:**

   ```zsh
   telepresence helm install
   telepresence connect
   ```

   Verify the setup:

   ```zsh
   telepresence status
   telepresence list
   ```

2. **Intercept and modify the Pong service:**

   Intercept traffic to the Pong service:

   ```zsh
   telepresence intercept pong --port 3000:3000
   ```

   Before running the Pong service locally, modify the response handler:

   - Open `./pong/index.js`
   - Comment out the line `res.send('pong');`
   - Uncomment the line `// res.send('foobar');`

   Start the local Pong service:

   ```zsh
   node ./pong/index.js
   ```

   Test the Ping service again; it should now return "foobar":

   ```zsh
   curl localhost:30000/ping
   ```

3. **Revert to cluster-managed service:**

   Stop intercepting traffic:

   ```zsh
   telepresence leave pong
   ```

   Test the Ping service to confirm it's routing through the cluster; it should return "pong" again:

   ```zsh
   curl localhost:30000/ping
   ```

## Cleanup

To remove the deployed services and stop using resources, follow these steps:

1. Switch to the terminal window where port forwarding is running and terminate it by pressing `CTRL+C`.

2. In your initial terminal window, execute:

   ```zsh
   ./cleanup.sh
   telepresence helm uninstall
   telepresence quit
   minikube stop
   ```

## Contributing

Contributions are welcome! For more information on how to contribute, please refer to the CONTRIBUTING.md file.

## License

This project is distributed under the MIT License. See the LICENSE file for more details.