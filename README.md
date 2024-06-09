# GitHub Actions

**GitHub Actions** is a CI/CD service provided by GitHub that allows you to automate workflows directly in your repository. Here's how you can set it up to monitor a repository for changes to a Dockerfile, build the Docker image, and push it to Docker Hub:

1. **Create a GitHub Actions Workflow**:
   - In your GitHub repository, create a directory called `.github/workflows`.
   - Inside this directory, create a file named `docker-build.yml` (or any name you prefer).

2. **Define the Workflow**:
   - Edit `docker-build.yml` with the following content:

```yaml
name: Build and Push Docker Image

on:
  push:
    paths:
      - Dockerfile
      - '**/Dockerfile'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker image
      uses: docker/build-push-action@v2
      with:
        context: .
        push: true
        tags: username/repository:tag
```

3. **Configure Secrets**:
   - Go to your GitHub repository settings.
   - Navigate to "Secrets and variables" -> "Actions".
   - Add the following secrets:
     - `DOCKER_USERNAME`: Your Docker Hub username.
     - `DOCKER_PASSWORD`: Your Docker Hub password.

4. **Customize the Workflow**:
   - Replace `username/repository:tag` with your actual Docker Hub repository and tag name.

This setup will trigger the workflow whenever a change is pushed to any Dockerfile in the repository. The workflow will:
1. Check out the repository.
2. Set up Docker Buildx.
3. Log in to Docker Hub.
4. Build and push the Docker image.

Using GitHub Actions is a straightforward and integrated way to automate this process directly within your GitHub repository.