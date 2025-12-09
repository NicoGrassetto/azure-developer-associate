# 🐍 AZ-204: Azure Developer Associate - Python Edition

[![Azure](https://img.shields.io/badge/Azure-Developer_Associate-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://learn.microsoft.com/en-us/credentials/certifications/azure-developer/)
[![Python](https://img.shields.io/badge/Python-First-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

> **A Python-focused study guide for the AZ-204 certification exam** — because not everyone is a C# kind of developer! 🚀

This repository contains comprehensive notes, code samples, and infrastructure deployments based on the official Microsoft Learn paths for the **Azure Developer Associate (AZ-204)** certification. All examples are provided in **Python** flavor, making it perfect for developers who prefer Python over C#/.NET.

---

## 📋 Table of Contents

- [About This Repository](#-about-this-repository)
- [Exam Overview](#-exam-overview)
- [Learning Paths](#-learning-paths)
- [Repository Structure](#-repository-structure)
- [Getting Started](#-getting-started)
- [Study Resources](#-study-resources)
- [Practice Exams & Mock Tests](#-practice-exams--mock-tests)
- [Exam Day Tips](#-exam-day-tips)
- [Contributing](#-contributing)

---

## 📖 About This Repository

This repo is essentially a curated and reorganized version of the official Microsoft Learn learning paths for the AZ-204 certification. What makes it different:

- ✅ **Python First**: All code examples are in Python (since the exam now allows Python!)
- ✅ **Infrastructure as Code**: Bicep templates for deploying Azure resources
- ✅ **Hands-on Labs**: Practical code samples you can run locally or in Azure
- ✅ **Consolidated Notes**: Key concepts distilled from Microsoft Learn documentation

---

## 🎯 Exam Overview

| Attribute | Details |
|-----------|---------|
| **Exam Code** | AZ-204 |
| **Certification** | Microsoft Certified: Azure Developer Associate |
| **Level** | Intermediate |
| **Duration** | 100 minutes |
| **Passing Score** | 700 (out of 1000) |
| **Languages** | English, Japanese, Chinese, Korean, French, German, Spanish, Portuguese, Italian |
| **Renewal** | Required every 12 months |

### Skills Measured

| Domain | Weight |
|--------|--------|
| Develop Azure compute solutions | 25-30% |
| Develop for Azure storage | 15-20% |
| Implement Azure security | 20-25% |
| Monitor, troubleshoot, and optimize Azure solutions | 15-20% |
| Connect to and consume Azure services and third-party services | 15-20% |

---

## 📚 Learning Paths

This repository covers all the official Microsoft Learn paths:

| # | Learning Path | Description |
|---|---------------|-------------|
| 1 | [Implement Azure App Service Web Apps](./trainings/implement-azure-app-service-web-apps/) | Create and deploy web apps, configure settings, scale apps |
| 2 | [Implement Azure Functions](./trainings/implement-azure-functions/) | Develop serverless solutions with triggers and bindings |
| 3 | [Implement Containerized Solutions](./trainings/implement-containerized-solutions/) | Azure Container Registry, Container Instances, Container Apps |
| 4 | [Develop Solutions using Azure Cosmos DB](./trainings/develop-solutions-that-use-azure-cosmos-db/) | NoSQL database operations, partitioning, consistency levels |
| 5 | [Develop Solutions using Blob Storage](./trainings/develop-solutions-that-use-blob-storage/) | Blob lifecycle, access tiers, SDK operations |
| 6 | [Implement Secure Azure Solutions](./trainings/implement-secure-azure-solutions/) | Key Vault, Managed Identities, App Configuration |
| 7 | [Implement User Authentication and Authorization](./trainings/implement-user-authentication-and-authorization/) | Microsoft Identity, MSAL, Shared Access Signatures |
| 8 | [Implement API Management](./trainings/implement-api-management/) | APIM policies, subscriptions, rate limiting |
| 9 | [Develop Event-Based Solutions](./trainings/develop-event-based-solutions/) | Event Grid, Event Hubs, event-driven architectures |
| 10 | [Develop Message-Based Solutions](./trainings/develop-message-based-solutions/) | Service Bus queues, topics, Azure Queue Storage |
| 11 | [Troubleshoot using Application Insights](./trainings/troubleshoot-solutions-by-using-application-insights/) | Monitoring, logging, performance optimization |

---

## 📁 Repository Structure

```
azure-developer-associate/
├── README.md                          # You are here!
├── trainings/
│   ├── implement-azure-app-service-web-apps/
│   │   ├── notes.md                   # Learning notes
│   │   ├── deployment/
│   │   │   ├── code/                  # Sample application code
│   │   │   └── infra/                 # Bicep templates
│   ├── implement-azure-functions/
│   │   └── notes.md
│   ├── implement-containerized-solutions/
│   │   ├── notes.md
│   │   └── assets/
│   ├── develop-solutions-that-use-azure-cosmos-db/
│   │   └── notes.md
│   ├── develop-solutions-that-use-blob-storage/
│   │   └── notes.md
│   ├── implement-secure-azure-solutions/
│   │   └── notes.md
│   ├── implement-user-authentication-and-authorization/
│   │   └── notes.md
│   ├── implement-api-management/
│   │   └── notes.md
│   ├── develop-event-based-solutions/
│   │   └── notes.md
│   ├── develop-message-based-solutions/
│   │   └── notes.md
│   └── troubleshoot-solutions-by-using-application-insights/
│       └── notes.md
```

---

## 🚀 Getting Started

### Prerequisites

- **Azure Subscription**: [Create a free account](https://azure.microsoft.com/free/)
- **Python 3.9+**: [Download Python](https://www.python.org/downloads/)
- **Azure CLI**: [Install Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- **VS Code** (recommended): [Download VS Code](https://code.visualstudio.com/)

### Recommended VS Code Extensions

- Python
- Azure Tools
- Azure Functions
- Bicep
- Azure Resources

### Setup

```bash
# Clone the repository
git clone https://github.com/NicoGrassetto/azure-developer-associate.git
cd azure-developer-associate

# Create a virtual environment
python -m venv .venv

# Activate the virtual environment
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate

# Install Azure SDK packages as needed
pip install azure-identity azure-storage-blob azure-cosmos azure-functions
```

---

## 📖 Study Resources

### Official Microsoft Resources

| Resource | Description | Link |
|----------|-------------|------|
| **Microsoft Learn Path** | Official learning path for AZ-204 | [Start Learning](https://learn.microsoft.com/en-us/credentials/certifications/azure-developer/) |
| **Exam Study Guide** | Official study guide with topic breakdown | [View Guide](https://aka.ms/AZ204-studyguide) |
| **Practice Assessment** | Free practice questions from Microsoft | [Take Assessment](https://learn.microsoft.com/en-us/credentials/certifications/azure-developer/practice/assessment?assessment-type=practice&assessmentId=35) |
| **Exam Sandbox** | Experience the exam interface | [Launch Sandbox](https://go.microsoft.com/fwlink/?linkid=2226877) |
| **Exam Readiness Videos** | Video series with tips and strategies | [Watch Videos](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/preparing-for-az-204-develop-azure-compute-solutions-1-of-5/) |
| **Azure Documentation** | Official Azure docs | [Browse Docs](https://docs.microsoft.com/azure/) |
| **Azure Python SDK Docs** | Python SDK reference | [View Docs](https://learn.microsoft.com/en-us/azure/developer/python/) |

### Community Resources

| Resource | Description | Link |
|----------|-------------|------|
| **AZ-204 GitHub Study Guide** | Excellent community study guide | [arvigeus/AZ-204](https://github.com/arvigeus/AZ-204/) |
| **Merlin Learn** | Interactive learning platform for Azure certifications | [Merlin Learn](https://merlinlearn.com/) |
| **Azure Code Samples** | Official code samples repository | [Azure-Samples](https://github.com/Azure-Samples) |
| **Microsoft Tech Community** | Community discussions and blogs | [Tech Community](https://techcommunity.microsoft.com/) |
| **Stack Overflow** | Q&A for Azure questions | [azure tag](https://stackoverflow.com/questions/tagged/azure) |

---

## 📝 Practice Exams & Mock Tests

### Free Practice Resources

| Resource | Type | Link |
|----------|------|------|
| **Microsoft Practice Assessment** | Official free practice test | [Take Test](https://learn.microsoft.com/en-us/credentials/certifications/azure-developer/practice/assessment?assessment-type=practice&assessmentId=35) |
| **Exam Topics AZ-204** | Community question discussions | [ExamTopics](https://www.examtopics.com/exams/microsoft/az-204/) |

### Paid Practice Exams

| Provider | Description | Link |
|----------|-------------|------|
| **Whizlabs AZ-204** | 400+ practice questions, labs included | [Whizlabs](https://www.whizlabs.com/microsoft-azure-certification-az-204/) |
| **MeasureUp AZ-204** | Official Microsoft practice test partner | [MeasureUp](https://www.measureup.com/az-204-developing-solutions-for-microsoft-azure.html) |
| **Udemy Practice Tests** | Various practice test courses | [Udemy AZ-204](https://www.udemy.com/topic/az-204/) |
| **Tutorials Dojo** | Practice exams and cheat sheets | [Tutorials Dojo](https://tutorialsdojo.com/microsoft-azure-exam-az-204-study-guide/) |
| **Pluralsight** | Video courses with practice exams | [Pluralsight](https://www.pluralsight.com/paths/developing-solutions-for-microsoft-azure-az-204) |

### Video Courses

| Provider | Description | Link |
|----------|-------------|------|
| **Microsoft Learn** | Free official training | [Learn Path](https://learn.microsoft.com/en-us/training/paths/create-azure-app-service-web-apps/) |
| **A Cloud Guru** | Comprehensive video course | [A Cloud Guru](https://acloudguru.com/course/az-204-developing-solutions-for-microsoft-azure) |
| **Scott Duffy (Udemy)** | Popular AZ-204 course | [Udemy Course](https://www.udemy.com/course/70532-azure/) |
| **Alan Rodrigues (Udemy)** | Hands-on labs focused | [Udemy Course](https://www.udemy.com/course/azure-developer-associate-az-204/) |

---

## 💡 Exam Day Tips

Based on real exam experience (passed with 842 on third attempt!):

### Preparation Strategy

1. **Complete the Microsoft Learn paths** — Don't just read, do the labs and truly understand each topic
2. **Use Microsoft Docs heavily** — For each topic, read how the service works, study code examples, learn SDK patterns
3. **Hands-on practice** — Create resources using SDK, CLI, and PowerShell
4. **Take notes and make flowcharts** — Writing in your own words helps retention
5. **Use AI to clarify concepts** — Generate practice examples and summarize confusing topics
6. **Identify weak areas** — Use practice tests to find gaps, then study those topics

### During the Exam

- **Mark uncertain questions** for review
- **You can use Microsoft Learn during the exam** — know how to search quickly!
- **Read questions carefully** — many answers are close but subtly different
- **Manage your time** — 100 minutes for ~40-60 questions
- **Trust your preparation** — understanding beats memorization

### Key Topics to Master

- Azure Functions triggers, bindings, and hosting plans
- Cosmos DB partitioning and consistency levels
- Blob storage access tiers and lifecycle management
- App Service deployment slots and configuration
- Container Registry, Container Instances, and Container Apps
- Key Vault and Managed Identities
- API Management policies
- Event Grid vs Event Hubs vs Service Bus
- Application Insights queries and metrics

---

## 🤝 Contributing

Contributions are welcome! If you find errors, have additional resources, or want to add more Python examples:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new resource'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⭐ Acknowledgments

- Microsoft Learn for the excellent documentation
- The [arvigeus/AZ-204](https://github.com/arvigeus/AZ-204/) repository for inspiration
- The Azure developer community for sharing their exam experiences

---

<p align="center">
  <b>Good luck with your certification! You've got this! 💪</b>
</p>

<p align="center">
  If this repo helped you, consider giving it a ⭐
</p>


