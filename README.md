# Optimizing Event Strategy and Conversion Rates : The Holberton School Case Study

---

## 1. ASK

### Context & Business Task
Holberton School regularly organizes communication events to increase brand awareness and drive student enrollment. The primary objective of this study is to analyze the performance of events in order to optimize future communication strategies. 

Specifically, this analysis aims to determine which types of events, periods of the year, and scheduled time slots maximize the **conversion rate** (defined here as the transition from an event participant to an enrolled student in a training program).

### Guiding Questions
To guide this analysis, five key questions have been defined:
* Which type of event (*Open House*, *Shadow a Student/Vis ma vie*, *Immersive Day*) yields the highest conversion rate?
* Do specific dates (seasonality, month of the year, day of the week) have a significant impact on engagement and registration?
* Do scheduled time slots influence both attendance and conversion rates?
* What is the profile of the participants who convert the most?
* What is the conversion goal for each type of event?
* What concrete, data-driven recommendations can be provided to optimize the planning of future events?

### Stakeholders
* **Alexandra (Communications Officer) :** Primary stakeholder. She will leverage the insights to plan future events and optimize the marketing budget.
* **Holberton School Management :** Interested in driving the overall growth of student enrollments across the school.
* **Admissions & Academic Team / Speakers :** Directly impacted by the scheduling and types of events they need to facilitate.

---

## 2. PREPARE

### 2.1. Data Identification & Provenance
To address the business task, two main data sources are utilized:
* **Internal Data (Primary Source) :** A `.csv` file extracted directly from Holberton School’s CRM and provided by the Communications Officer. This dataset captures the complete history of events organized from **01/08/2025 to 03/14/2026**.
* **External Data (Secondary Source) :** The official school holiday calendar repository for 2025 and 2026, retrieved from the French government website (legifrance.gouv.fr). This data will help analyze how vacation periods impact candidate registration based on the specific academic zone of each campus.

### 2.2. Internal Dataset Structure & Variable Selection
The initial raw file provided by the software includes 12 columns. Following an analysis of the business task, a variable filtering strategy was implemented to focus strictly on key decision-making factors (format and temporality).

#### 2.2.1. Variables Retained for Analysis :
* **Type événement (Event Type)** *(Categorical variable)* : Key variable to identify and compare which event formats (*Open House*, *Shadow a Student*, *Immersive Day*) convert best.
* **Date & Date de fin (Start & End Date)** *(Temporal variables)* : Essential for measuring the impact of seasonality (month of the year), the influence of weekdays, and the effectiveness of scheduled time slots.
* **Campus** *(Categorical variable)* : Required to segment results by geographical location and cross-reference them with the specific school holiday calendar zones.
* **Nb d'inscrits & Nb présents (No. of Registrants & No. of Attendees)** *(Numerical variables)* : Fundamental quantitative metrics used to calculate absolute volume, reach, and actual participation.
* **Genre from Inscription & Genre from Présence (Gender)** *(Categorical variables)* : Data describing the demographic profile of participants (Male/Female).
* **Taux de participation & Taux de transformation (Attendance Rate & Conversion Rate)** *(Numerical/Percentage variables)* : Final Key Performance Indicators (KPIs) to measure user engagement and the success of conversion goals.

#### 2.2.2. Variables Excluded from Analysis:
* **Name** *(Free-text variable)* : The specific event name is a unique text string. Because it does not allow for meaningful statistical grouping compared to the `Type événement` column, it was discarded.
* **Nb présents avec PI signé (No. of Attendees with Signed Registration)** *(Numerical variable)* : This column, which tracks signed registration contracts, is redundant because the ultimate success metric is already accurately captured in relative terms by the `Taux de transformation` variable.

### 2.3. Data Credibility Assessment (ROCCC Test)
* **Reliable :** The data comes directly from the school’s CRM.
* **Original :** Internal source for the events, and an official state repository for the holiday calendars by academic zones.
* **Comprehensive :** The dataset spans over 14 consecutive months, allowing for a thorough analysis of seasonality over a full year cycle.
* **Current :** Data extends until March 2026, providing a highly relevant and up-to-date perspective.
* **Cited:** Sources (Holberton's CRM and data.gouv.fr) are clearly identified and traceable.

### 2.4. Data Governance & Security
In strict compliance with GDPR and data governance best practices, the dataset contains no health-related or sensitive information. All Personally Identifiable Information (PII) such as participants' full names, email addresses, or phone numbers have been excluded prior to analysis to guarantee participants' privacy.