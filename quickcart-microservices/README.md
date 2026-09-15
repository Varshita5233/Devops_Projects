# QuickCart – Microservices E-Commerce Backend Application

![Java](https://img.shields.io/badge/Java-21-blue)
![Spring Boot](https://img.shields.io/badge/SpringBoot-3.x-brightgreen)
![Spring Cloud](https://img.shields.io/badge/SpringCloud-Microservices-blue)
![API](https://img.shields.io/badge/API-REST-orange)
![Security](https://img.shields.io/badge/Security-OAuth2%2FJWT-purple)
![Tool](https://img.shields.io/badge/Tested-Postman-purple)

---

## Overview

QuickCart is a microservices-based e-commerce backend application built using Spring Boot and Spring Cloud.

The system is designed using distributed architecture principles and includes authentication, service discovery, API gateway routing, and independent business services.

---

The application follows a microservices architecture:

Client → API Gateway → Microservices → Database  

- API Gateway: Routes requests to appropriate services  
- Discovery Server: Service registration and lookup (Eureka)  
- Auth Server: Handles authentication using OAuth2/JWT  
- Product Service: Manages product data  
- Order Service: Handles order processing  

---

## Application Flow

### Authentication Flow

Client → Auth Server → Generate JWT Token  

---

### Product Flow

Client → API Gateway → Product Service → Database  

---

### Order Flow

Client → API Gateway → Order Service → Process Order → Database  

---

### Service Discovery Flow

All services → Register with Discovery Server (Eureka)  
API Gateway → Fetch service instances dynamically  

---

## Core Features

- Microservices-based architecture  
- API Gateway for centralized routing  
- Service discovery using Eureka  
- OAuth2/JWT-based authentication  
- Product management service  
- Order processing service  
- Inter-service communication  

---

## Tech Stack

| Category | Technology |
|----------|-----------|
| Language | Java 21 |
| Framework | Spring Boot |
| Architecture | Microservices (Spring Cloud) |
| API | REST |
| Security | OAuth2 / JWT |
| Service Discovery | Eureka |
| Gateway | Spring Cloud Gateway |
| Build Tool | Maven |
| Containerization | Docker |

---

## API Endpoints (Sample via Gateway)

| Method | Endpoint | Description |
|-------|----------|------------|
| GET | /products | Get all products |
| POST | /products | Create product |
| POST | /orders | Place an order |
| POST | /auth/token | Generate JWT token |

---

## Project Structure
```
QuickCart_Application/
├── auth-server/
├── products-service/
├── order-service/
├── apigateway/
├── discovery-server/
├── docker-compose.yml
└── README.md
```


---

## Running the Application

### Prerequisites

- Java 21  
- Maven  
- Docker (optional)

---

### Steps (Manual Run Order)

Start all services or 
Run using Docker
docker-compose up --build

## Highlights

- Designed distributed microservices architecture  
- Implemented service discovery using Eureka  
- Secured APIs using OAuth2 and JWT  
- Centralized routing using API Gateway  
- Built scalable and independently deployable services  

---

## Future Improvements

- Add centralized logging (ELK Stack)  
- Implement distributed tracing (Zipkin)  
- Add circuit breaker (Resilience4j)  
- Introduce Kafka for event-driven communication  
- Add Kubernetes deployment  

---

## Author

**Tejesh Ankem**  
Backend Developer | Java | Spring Boot  

