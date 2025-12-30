# Azure Developer Associate (AZ-204) Anki Flashcards

This directory contains comprehensive Anki flashcards to help you prepare for the **Microsoft Azure Developer Associate (AZ-204)** certification exam.

## 📋 Overview

Each training module folder contains a `flashcards.txt` file with exam-focused questions covering:
- Key concepts and definitions
- Real-world use cases and scenarios
- Service comparisons and when to use each
- Best practices and recommendations
- Limits, quotas, and constraints
- Configuration and implementation details

## 📚 Available Flashcard Sets

| Module | File | Questions | Topics Covered |
|--------|------|-----------|----------------|
| App Service Web Apps | `implement-azure-app-service-web-apps/flashcards.txt` | 50+ | Deployment slots, scaling, pricing tiers, authentication, networking |
| Azure Functions | `implement-azure-functions/flashcards.txt` | 65+ | Triggers, bindings, hosting plans, Durable Functions, scaling |
| Containerized Solutions | `implement-containerized-solutions/flashcards.txt` | 60+ | ACR, ACI, Container Apps, authentication, scaling, networking |
| Cosmos DB | `develop-solutions-that-use-azure-cosmos-db/flashcards.txt` | 65+ | Partitioning, consistency levels, throughput, indexing, queries |
| Blob Storage | `develop-solutions-that-use-blob-storage/flashcards.txt` | 70+ | Access tiers, lifecycle, SAS, versioning, encryption, networking |
| Secure Solutions | `implement-secure-azure-solutions/flashcards.txt` | 65+ | Key Vault, Managed Identity, App Configuration, feature flags |
| Authentication | `implement-user-authentication-and-authorization/flashcards.txt` | 75+ | OAuth, OIDC, MSAL, SAS tokens, Entra ID, service principals |
| API Management | `implement-api-management/flashcards.txt` | 70+ | Policies, products, subscriptions, rate limiting, transformations |
| Event-Based Solutions | `develop-event-based-solutions/flashcards.txt` | 65+ | Event Grid, Event Hubs, event routing, streaming, partitions |
| Message-Based Solutions | `develop-message-based-solutions/flashcards.txt` | 75+ | Service Bus, Queue Storage, queues vs topics, sessions, DLQ |
| Application Insights | `troubleshoot-solutions-by-using-application-insights/flashcards.txt` | 70+ | Monitoring, telemetry, KQL queries, alerts, performance analysis |

**Total: 700+ flashcards covering all AZ-204 exam domains**

## 🚀 How to Import into Anki

### Step 1: Install Anki

Download and install Anki from [https://apps.ankiweb.net/](https://apps.ankiweb.net/)

Available for:
- Windows
- macOS
- Linux
- iOS (AnkiMobile - paid)
- Android (AnkiDroid - free)

### Step 2: Import Flashcards

#### Option A: Import All Flashcards (Recommended)

1. Open Anki
2. Click **File** → **Import**
3. Select the flashcards file (e.g., `implement-azure-functions/flashcards.txt`)
4. Configure import settings:
   - **Type**: Basic (and reversed card)
   - **Deck**: Create new deck (e.g., "AZ-204 - Azure Functions") or use existing
   - **Fields separated by**: Tab
   - **Allow HTML in fields**: Checked
5. Click **Import**
6. Repeat for each module's flashcard file

#### Option B: Import Single Module

Follow the same steps above but import only specific modules you want to study.

### Step 3: Configure Card Settings

For optimal learning:

1. Click on the deck
2. Click the **gear icon** → **Options**
3. Recommended settings:
   - **New cards/day**: 20-30 (adjust based on study time)
   - **Maximum reviews/day**: 200
   - **Learning steps**: 1m 10m 1d
   - **Graduating interval**: 3 days
   - **Easy interval**: 4 days

## 📖 How to Use These Flashcards

### Study Strategy

1. **Start with fundamentals**: Begin with App Service, Functions, and Blob Storage
2. **Build on concepts**: Progress to security, authentication, and messaging
3. **Integration topics**: Study Event Grid, Service Bus, and APIM last
4. **Regular review**: Study 20-30 new cards daily, review due cards daily

### Reading the Cards

**Front of card**: Question or scenario
**Back of card**: Answer with explanation
**Tags**: Help organize and filter cards

### Flashcard Format

All cards follow this tab-separated format:
```
Front Question	Back Answer	Tags
```

### Tags Explained

Tags help you filter and focus study:
- `azure` - General Azure topics
- `{service}` - Specific service (e.g., `functions`, `cosmos-db`)
- `basics` - Fundamental concepts
- `use-case` - Scenario-based questions
- `security` - Security-related topics
- `best-practices` - Recommendations and best practices
- `comparison` - Service/feature comparisons

### Filtering Cards by Tag

1. Click **Browse** in Anki
2. Select your deck
3. In the search box, type: `tag:use-case` (or any tag)
4. Create filtered deck for focused study

## 💡 Study Tips

### For the AZ-204 Exam

1. **Understand use cases**: Many exam questions are scenario-based
2. **Know service limits**: Questions often test knowledge of quotas and limits
3. **Service comparisons**: Understand when to use each service
4. **Hands-on practice**: Flashcards supplement but don't replace hands-on labs
5. **Focus on differences**: Know what distinguishes similar services

### Effective Spaced Repetition

- **Daily consistency** beats cramming
- **Mark cards** you struggle with for extra review
- **Use the "Hard" button** if you barely knew the answer
- **Suspend cards** you've mastered to focus on weak areas
- **Unsuspend before exam** to refresh all topics

### Combining with Other Resources

Flashcards work best with:
1. **Microsoft Learn** - Official learning paths
2. **Hands-on labs** - Azure Portal and CLI practice
3. **Practice exams** - Simulate exam conditions
4. **This repository's notes** - Reference the detailed notes in each module

## 🔍 Question Types Covered

### 1. Definition Questions
*"What is Azure Functions?"*
- Test basic understanding of services and concepts

### 2. Comparison Questions
*"What is the difference between Service Bus queues and topics?"*
- Distinguish between similar services or features

### 3. Scenario Questions
*"A company needs to deploy a web app with zero downtime. What feature should be used?"*
- Apply knowledge to real-world situations

### 4. Best Practice Questions
*"What is the recommended authentication method for accessing Key Vault?"*
- Test knowledge of Azure recommendations

### 5. Technical Details
*"What is the maximum message size in Service Bus Premium tier?"*
- Verify knowledge of limits and constraints

### 6. Use Case Questions
*"When should you use Premium App Service tier over Standard?"*
- Understand appropriate service selection

## 📊 Exam Coverage

These flashcards align with the AZ-204 exam domains:

| Domain | Weight | Flashcard Coverage |
|--------|--------|-------------------|
| Develop Azure compute solutions | 25-30% | App Service, Functions, Containers |
| Develop for Azure storage | 15-20% | Blob Storage, Cosmos DB |
| Implement Azure security | 20-25% | Key Vault, Managed Identity, Authentication |
| Monitor, troubleshoot, and optimize | 15-20% | Application Insights, monitoring |
| Connect to and consume services | 15-20% | Event Grid, Service Bus, API Management |

## 🎯 Study Plan Recommendation

### Week 1-2: Compute Services
- Azure App Service Web Apps (50 cards)
- Azure Functions (65 cards)
- Containerized Solutions (60 cards)

### Week 3-4: Storage & Data
- Blob Storage (70 cards)
- Cosmos DB (65 cards)

### Week 5-6: Security & Identity
- Secure Solutions (65 cards)
- Authentication & Authorization (75 cards)

### Week 7-8: Integration & Messaging
- API Management (70 cards)
- Event-Based Solutions (65 cards)
- Message-Based Solutions (75 cards)

### Week 9-10: Monitoring & Review
- Application Insights (70 cards)
- Review all cards marked as difficult
- Take practice exams

## 🔧 Customization

### Adding Your Own Cards

1. Open any flashcard file in a text editor
2. Add new line: `Question[TAB]Answer[TAB]tags`
3. Save and re-import into Anki

### Creating Cloze Deletions

For fill-in-the-blank style cards:

```
The {{c1::Consumption}} plan in Azure Functions has a {{c2::5 minute}} default timeout.	azure,functions,limits
```

Import using "Cloze" note type in Anki.

### Creating Multiple Choice Questions

Format in flashcard:
```
Which tier is required for deployment slots? A) Free B) Basic C) Standard D) Premium	C) Standard - deployment slots require Standard tier or higher	azure,app-service,deployment-slots
```

## 📱 Mobile Study

### AnkiMobile (iOS)
- Paid app ($24.99)
- Full features
- Sync with desktop

### AnkiDroid (Android)
- Free and open source
- Full features
- Sync with desktop

### AnkiWeb
- Free web version at [https://ankiweb.net](https://ankiweb.net)
- Limited features
- Access anywhere

## 🔄 Syncing Across Devices

1. Create free account at [https://ankiweb.net](https://ankiweb.net)
2. In Anki desktop: **Tools** → **Preferences** → **Network**
3. Enter AnkiWeb ID and password
4. Click **Sync** button
5. Configure mobile app with same credentials

## 📈 Progress Tracking

Anki automatically tracks:
- **Cards studied**
- **Retention rate**
- **Study time**
- **Forecast** (cards due in future)

View statistics: **Stats** button in deck view

## ⚡ Quick Reference

### Keyboard Shortcuts

- **Space / Enter**: Show answer
- **1**: Again (forgot)
- **2**: Hard (difficult)
- **3**: Good (remembered)
- **4**: Easy (very easy)
- **Ctrl+Z**: Undo
- **E**: Edit card
- **@**: Suspend card

## 🤝 Contributing

Found an error or want to add cards?

1. Edit the flashcard file
2. Maintain the tab-separated format
3. Add appropriate tags
4. Submit a pull request

## 📚 Additional Resources

- **Official Study Guide**: [Microsoft AZ-204 Study Guide](https://aka.ms/AZ204-studyguide)
- **Microsoft Learn**: [AZ-204 Learning Path](https://learn.microsoft.com/en-us/credentials/certifications/azure-developer/)
- **Practice Assessment**: [Free Practice Questions](https://learn.microsoft.com/en-us/credentials/certifications/azure-developer/practice/assessment)
- **Exam Sandbox**: [Experience the exam interface](https://go.microsoft.com/fwlink/?linkid=2226877)

## 📝 License

These flashcards are provided under the same license as the repository (MIT License).

## ✅ Final Tips

Before the exam:
1. Review all 700+ flashcards at least once
2. Focus extra time on cards you found difficult
3. Practice with actual Azure services (free tier available)
4. Take official Microsoft practice assessment
5. Ensure 90%+ accuracy on flashcards before exam

**Good luck with your Azure Developer Associate certification! 🎉**

---

*Last updated: 2025-12-30*
*Total flashcards: 700+*
*Exam version: AZ-204 (current)*
