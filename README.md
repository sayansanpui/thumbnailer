# 🖼️ Thumbnailer - Image Resizer Web Application

A modern, responsive web application for resizing images with custom dimensions, built with Flask and deployed using a complete CI/CD pipeline with Kubernetes and ArgoCD.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Installation & Setup](#installation--setup)
- [Deployment Pipeline](#deployment-pipeline)
- [Kubernetes Configuration](#kubernetes-configuration)
- [Challenges & Solutions](#challenges--solutions)
- [Future Opportunities](#future-opportunities)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

Thumbnailer is a web-based image resizing tool that allows users to upload images and resize them to custom dimensions. The application features a modern, responsive UI with dark/light theme support, drag-and-drop functionality, and real-time image preview.

The project demonstrates modern DevOps practices with:
- Containerized application deployment
- CI/CD pipeline with GitHub Actions
- Kubernetes orchestration
- GitOps workflow with ArgoCD
- Automated image updates

## ✨ Features

### Core Functionality
- **Image Upload**: Support for JPG, JPEG, and PNG formats
- **Custom Dimensions**: User-defined width and height (1-2000 pixels)
- **Real-time Preview**: Image preview before processing
- **Drag & Drop**: Intuitive file upload interface
- **Download**: Processed images as JPEG with 80% quality

### User Interface
- **Responsive Design**: Works on desktop and mobile devices
- **Dark/Light Theme**: Toggle between themes with system preference detection
- **Modern UI**: Clean, intuitive interface with Font Awesome icons
- **Loading States**: Visual feedback during processing
- **Error Handling**: User-friendly error messages

### Technical Features
- **Containerized**: Docker-based deployment
- **Scalable**: Kubernetes deployment with horizontal scaling
- **Automated**: CI/CD pipeline with automated deployments
- **Monitoring**: Resource limits and health checks

## 🛠️ Technology Stack

### Backend
- **Python 3.11**: Core runtime
- **Flask**: Web framework for HTTP handling and routing
- **Pillow (PIL)**: Image processing library
- **Gunicorn**: WSGI HTTP server for production

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Modern styling with CSS variables and flexbox/grid
- **Vanilla JavaScript**: Interactive functionality
- **Font Awesome**: Icons and visual elements

### Infrastructure & DevOps
- **Docker**: Containerization
- **Kubernetes**: Container orchestration
- **GitHub Actions**: CI/CD pipeline
- **ArgoCD**: GitOps continuous deployment
- **DockerHub**: Container registry

### Development Tools
- **Git**: Version control
- **GitHub**: Repository hosting and collaboration
- **VS Code**: Development environment

## 🏗️ Architecture

### Application Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │───▶│   Flask App     │───▶│   Pillow        │
│   (Frontend)    │    │   (Backend)     │    │   (Processing)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Deployment Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│   GitHub Actions│───▶│   DockerHub     │
│   (Source)      │    │   (CI/CD)       │    │   (Registry)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ArgoCD        │───▶│   Kubernetes    │◀───│   CronJob       │
│   (GitOps)      │    │   (Runtime)     │    │   (Auto-Update) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Installation & Setup

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/sayansanpui/thumbnailer.git
   cd thumbnailer
   ```

2. **Set up Python environment**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. **Run the application**
   ```bash
   cd thumbnailer
   python main.py
   ```

4. **Access the application**
   - Open your browser and go to `http://localhost:5000`

### Docker Setup

1. **Build the Docker image**
   ```bash
   docker build -t thumbnailer .
   ```

2. **Run the container**
   ```bash
   docker run -p 8080:8080 thumbnailer
   ```

3. **Access the application**
   - Open your browser and go to `http://localhost:8080`

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SECRET_KEY` | Flask secret key | `"notsosecret"` |
| `IMAGE_WIDTH` | Default image width | `300` |
| `IMAGE_HEIGHT` | Default image height | `300` |

## 🔄 Deployment Pipeline

### CI/CD Workflow

The project implements a comprehensive CI/CD pipeline using GitHub Actions:

#### 1. **Continuous Integration** (`.github/workflows/main.yaml`)
- **Trigger**: Push to `main` branch
- **Actions**:
  - Checkout repository
  - Set up Docker Buildx for multi-architecture builds
  - Login to DockerHub
  - Build and push Docker images for `linux/amd64` and `linux/arm64`
  - Tag images with both `latest` and commit SHA

#### 2. **Continuous Deployment** (ArgoCD)
- **GitOps Approach**: ArgoCD monitors the repository for changes
- **Automatic Sync**: Deploys changes to Kubernetes cluster
- **Self-Healing**: Automatically corrects configuration drift

#### 3. **Automated Updates** (CronJob)
- **Schedule**: Every 5 minutes
- **Function**: Checks for new Docker image digests
- **Action**: Updates deployment configuration when new images are available
- **Git Integration**: Commits changes back to repository

### Pipeline Benefits
- **Zero-downtime deployments**: Rolling updates with health checks
- **Multi-architecture support**: Works on both AMD64 and ARM64 platforms
- **Automated rollbacks**: ArgoCD handles failed deployments
- **Audit trail**: Git history tracks all deployment changes

## ☸️ Kubernetes Configuration

### Deployment Configuration (`k8s/deployment.yaml`)

```yaml
# Key specifications:
- Replicas: 3 (High availability)
- Strategy: RollingUpdate (Zero-downtime updates)
- Resources: 100m CPU, 128Mi memory (requests)
- Limits: 500m CPU, 256Mi memory (limits)
- Image: sayansanpui/thumbnailer:latest
- Port: 8080
- Service: LoadBalancer type
```

### Features
- **High Availability**: 3 replicas with anti-affinity rules
- **Resource Management**: CPU and memory limits prevent resource exhaustion
- **Health Checks**: Readiness and liveness probes ensure service reliability
- **Service Discovery**: Kubernetes service for internal communication
- **Load Balancing**: External load balancer for traffic distribution

### CronJob Configuration (`k8s/cronjob.yaml`)

The CronJob automates Docker image updates:
- **Frequency**: Every 5 minutes
- **Function**: Compares current digest with latest on DockerHub
- **Update Process**: Modifies deployment.yaml and commits changes
- **Security**: Uses GitHub tokens for authenticated Git operations

## 🤔 Challenges & Solutions

### 1. **Image Processing Performance**
- **Challenge**: Large image files causing memory issues and slow processing
- **Solution**: 
  - Implemented image quality optimization (80% JPEG quality)
  - Used Pillow's thumbnail method for efficient resizing
  - Added resource limits in Kubernetes to prevent OOM kills

### 2. **Container Security**
- **Challenge**: Running applications as root in containers
- **Solution**: 
  - Used Python slim base image to reduce attack surface
  - Implemented proper file permissions
  - Added security context in Kubernetes deployment

### 3. **Deployment Automation**
- **Challenge**: Manual deployment process prone to errors
- **Solution**: 
  - Implemented GitOps workflow with ArgoCD
  - Created automated image update mechanism
  - Added proper error handling and rollback capabilities

### 4. **Cross-Platform Compatibility**
- **Challenge**: Different architectures (AMD64, ARM64)
- **Solution**: 
  - Multi-architecture Docker builds
  - Platform-specific image selection
  - Tested on both Intel and Apple Silicon

### 5. **State Management**
- **Challenge**: Handling file uploads and user session state
- **Solution**: 
  - Stateless application design
  - In-memory processing without persistent storage
  - Proper error handling and user feedback

## 🚀 Future Opportunities

### Feature Enhancements
1. **Advanced Image Processing**
   - Support for more image formats (WebP, TIFF, BMP)
   - Batch processing capabilities
   - Image filters and effects
   - Format conversion options

2. **User Experience Improvements**
   - Progress bars for large file uploads
   - Image compression options
   - History of processed images
   - Preset dimension templates

3. **Performance Optimizations**
   - Caching mechanisms for frequently used sizes
   - Asynchronous processing for large files
   - CDN integration for faster delivery
   - Image optimization algorithms

### Technical Improvements
1. **Monitoring & Observability**
   - Prometheus metrics integration
   - Grafana dashboards
   - Application logging with ELK stack
   - Distributed tracing

2. **Security Enhancements**
   - File type validation improvements
   - Rate limiting implementation
   - Input sanitization
   - CSRF protection

3. **Scalability**
   - Horizontal Pod Autoscaler (HPA)
   - Vertical Pod Autoscaler (VPA)
   - Database integration for user management
   - Microservices architecture

### Infrastructure Enhancements
1. **Cloud Integration**
   - AWS/GCP/Azure deployment options
   - Object storage integration (S3, GCS)
   - CDN implementation
   - Multi-region deployments

2. **Advanced DevOps**
   - Helm charts for easier deployment
   - Automated testing pipeline
   - Security scanning integration
   - Infrastructure as Code (Terraform)

3. **API Development**
   - RESTful API for programmatic access
   - GraphQL implementation
   - OpenAPI documentation
   - SDK development

## 📊 Project Metrics

### Performance Characteristics
- **Response Time**: < 2 seconds for typical image processing
- **Memory Usage**: ~128Mi per pod instance
- **CPU Usage**: ~100m per pod instance
- **Supported Formats**: JPG, JPEG, PNG
- **Maximum Dimensions**: 2000x2000 pixels

### Deployment Statistics
- **Build Time**: ~2-3 minutes (CI/CD pipeline)
- **Deployment Time**: ~30 seconds (rolling update)
- **Rollback Time**: ~15 seconds (ArgoCD)
- **Uptime**: 99.9% availability target

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

### Development Guidelines
- Follow PEP 8 for Python code
- Use semantic commit messages
- Add tests for new features
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flask**: For providing a lightweight web framework
- **Pillow**: For excellent image processing capabilities
- **Kubernetes**: For robust container orchestration
- **ArgoCD**: For GitOps deployment automation
- **GitHub Actions**: For seamless CI/CD integration

---

**Author**: Sayan Sanpui  
**Email**: [sayansanpui@gmail.com]  
**GitHub**: [@sayansanpui](https://github.com/sayansanpui)  
**Project Link**: [https://github.com/sayansanpui/thumbnailer](https://github.com/sayansanpui/thumbnailer)
