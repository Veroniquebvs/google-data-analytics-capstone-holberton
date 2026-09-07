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
To address the business task, three main data sources are utilized :
* **Internal Data (Primary Source) :** A `.csv` file extracted directly from Holberton School’s CRM and provided by the Communications Officer. This dataset captures the complete history of events organized from **01/08/2025 to 03/14/2026**.
* **External Data (Secondary Source) :** The official school holiday calendar repository for 2025 and 2026, retrieved from the French government website (legifrance.gouv.fr). This data will help analyze how vacation periods impact candidate registration based on the specific academic zone of each campus.
* **External Data - Public Holidays (Secondary Source) :** The official French public holiday calendar database, retrieved from [data.gouv.fr](https://www.data.gouv.fr/datasets/jours-feries-en-france). This dataset is used to identify and measure the impact of national holidays on event attendance and conversion rates.

### 2.2. Internal Dataset Structure & Variable Selection
The initial raw file provided by the software includes 12 columns. Following an analysis of the business task, a variable filtering strategy was implemented to focus strictly on key decision-making factors (format and temporality).

#### 2.2.1. Variables Retained for Analysis :
* **Type événement (Event Type)** *(Categorical variable)* : Key variable to identify and compare which event formats (*Open House*, *Shadow a Student*, *Immersive Day*) convert best.
* **Date & Date de fin (Start & End Date)** *(Temporal variables)* : Essential for measuring the impact of seasonality (month of the year), the influence of weekdays, and the effectiveness of scheduled time slots.
* **Campus** *(Categorical variable)* : Required to segment results by geographical location and cross-reference them with the specific school holiday calendar zones.
* **Nb d'inscrits & Nb présents (No. of Registrants & No. of Attendees)** *(Numerical variables)* : Fundamental quantitative metrics used to calculate absolute volume, reach, and actual participation.
* **Genre from Inscription & Genre from Présence (Gender)** *(Categorical variables)* : Data describing the demographic profile of participants (Male/Female).
* **Taux de participation & Taux de transformation (Attendance Rate & Conversion Rate)** *(Numerical/Percentage variables)* : Final Key Performance Indicators (KPIs) to measure user engagement and the success of conversion goals.

#### 2.2.2. Variables Excluded from Analysis :
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

---

## 3. PROCESS (Data Cleaning & Transformation)

This phase details all the cleaning, normalization, and data enrichment steps applied to the raw file provided by Holberton School, making it fully operational for the upcoming analysis phase.

### 3.1. Tools Used & Export Format
* **Google Sheets :** Used for initial data exploration, creating transformation formulas, and building the data quality monitoring dashboard.
* **Target Format :** Exported as a `.csv` file (UTF-8 encoding) to ensure seamless compatibility with the IDE, SQL databases, and analytical scripts.

### 3.2. Data Cleaning & Normalization
To resolve technical inconsistencies within the raw dataset, the following data cleaning procedures were executed :

* **Initial Integrity Check :** First, an automated check was performed across all columns to detect and count any empty lines or structural gaps.
* **KPI Standardization:** The `Taux de Participation` (Participation Rate) and `Taux de transformation` (Conversion Rate) columns initially contained a mix of regional formats—specifically US points (`3.50%`) and French commas (`10,00%`). Text strings using points were identified, corrected using a global find-and-replace (`.` to `,`), and reformatted into consistent numerical `Percentage` fields.
* **Handling Missing Data (Gender Omissions) :** The original demographic columns contained blank cells representing instances where users chose not to disclose their gender (39 omissions at registration, 53 at attendance). To prevent analytical bias, these empty cells were standardized under a distinct `"Non spécifié"` (Unspecified) label using the following logical formula :
  `=SI(ESTVIDE(Original_Gender); "Non spécifié"; Original_Gender)`

### 3.3. Feature Engineering & Data Enrichment
To meet the specific business requirements of this Capstone project, the dataset was enriched with new calculated variables :
 
* **Time Attribute Fragmentation :** The single initial column combining both date and time was split to isolate `Date` as an independent field, along with distinct `Start Time` and `End Time` attributes, utilizing the `=ENT()` function and standard time subtractions.
* **Day Segmentation :** In response to the initial business assumption that all events only last half a day, calculating the actual event duration `(End_Time - Start_Time)` invalidated this belief by revealing long-format sessions (Average = 3h51, Max = 8h00). Consequently, events were dynamically segmented into 3 time slots (`Matin`, `Après-midi`, `Journée`) using the following nested formula:
  `=SI(Duration_Hours > 5; "Journée"; SI(Start_Time < TIME(13;0;0); "Matin"; "Après-midi"))`
* **Geographical Mapping of School Holiday Zones :** Utilizing a custom reference table of French academic regions built within the `Synthèse` tab, each campus location code was mapped to its official school holiday calendar (Zone A, B, or C) via a dynamic lookup function :
  `=RECHERCHEV(Campus; Synthèse; 2; FALSE)`
* **Weekend Classification :** Identified if an event occurred on a weekend (Saturday or Sunday) to analyze weekend vs. weekday student engagement, using the `JOURSEM` function :
  `=SI(JOURSEM(Date_seule; 2) > 5; 1; 0)`
* **Public Holiday Flagging :** Determined whether an event fell on a French national public holiday by cross-referencing event dates with the official public holiday repository ([public_holidays_mainland_france.csv](public_holidays_mainland_france.csv)) using a search and matching function:
  `=SI(NB.SI(Synthèse; Date seule) > 0; 1; 0)`

* **Text-to-Numeric Parsing Algorithm :** Complex text strings listing individual attendee genders per event were converted into clean, discrete numerical metrics (`Nb_hommes_presents`, `Nb_femmes_presents`, `Nb_non_specifie`) by calculating character length differentials :
  `(NBCAR(Genre_Presence_nettoye) - NBCAR(SUBSTITUE(Genre_Presence_nettoye; "homme"; ""))) / NBCAR("homme")`

### 3.4. Data Quality Check
A data quality control dictionary was implemented in the "Synthèse" sheet to continuously monitor file integrity.

**Final Result :** 100% of strategic columns (`Type événement`, `Date`, `Campus`, and all cleaned variables) now display **0 missing values (NULL)**. All numbers are correctly aligned and typed, confirming that the dataset is verified, clean, and ready for the **ANALYZE** phase.

---

## 4. ANALYZE

### 4.1 Conversion Performance by Event Type

> **Associated SQL Script:** [`sql/01_conversion_by_event_type.sql`](sql/01_conversion_by_event_type.sql)

| Event Type | Total Events | Total Registered | Total Attendees | Total Converted (Signed PI) | Attendance Rate (%) | Transformation Rate (Attendees) (%) | Global Conversion Rate (Registered) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Vis-ma-vie** | 43 | 32 | 18 | 8 | **56.25%** | **44.44%** | **25.00%** |
| **JPO** | 150 | 1,683 | 622 | 195 | 36.96% | 31.35% | 11.59% |
| **Journee_immersive** | 4 | 3 | 12 | 1 | 400.00% | 8.33% | 33.33% |

**Key Insights:**
* **Highest In-Person Conversion:** The *Vis-ma-vie* format achieves the highest attendee transformation rate (**44.44%** vs. 31.35% for Open Days / JPO), confirming that immersion drives strong commitment.
* **Volume Driver:** Open Days (*JPO*) account for nearly all total signed contracts (**195 out of 204**), despite a lower show-up rate (36.96%).
* **Data Discrepancy Note:** The *Journee_immersive* category shows a data entry anomaly with more reported attendees than registered leads (12 attendees vs. 3 registered), making this segment statistically unreliable.

### 4.2 Temporal Impact

#### 4.2.1 Week vs Weekend Comparison

> **Associated SQL script:** [`sql/02_conversion_by_specifiq_day.sql`](sql/02_conversion_by_specifiq_day.sql)

| Type de période | Total Événements | Inscrits | Présents | Convertis (PI signés) | Taux de présence (%) | Taux de transformation (sur présents) (%) | Taux de conversion global (sur inscrits) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Semaine** | 132 | 897 | 374 | 130 | **41,69 %** | **34,76 %** | **14,49 %** |
| **Week-end** | 65 | 821 | 278 | 74 | 33,86 % | 26,62 % | 9,01 % |

**Key observations:**
* **Overall performance for the week:** Sessions held from Monday to Friday outperformed those at the weekend: +7.8 percentage points in attendance (41.69 per cent versus 33.86 per cent) and +8.1 percentage points in conversion rate amongst those present (34.76 per cent versus 26.62 per cent).
* **Greater engagement on weekdays:** Although Saturdays attract a massive volume of registrations per session (around 12.6 registrants per event compared with 6.8 on weekdays), the audience on weekdays is significantly more likely to complete a registration contract.

#### 4.2.2 Breakdown by day of the week

> **Related SQL script:** [`sql/02_conversion_by_specifiq_day.sql`](sql/02_conversion_by_specifiq_day.sql)

| Jour de la semaine | Événements | Inscrits | Présents | Convertis (PI signés) | Taux de présence (%) | Taux de transformation (sur présents) (%) | Taux de conversion global (sur inscrits) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Mardi** | 7 | 4 | 15 | 4 | 375,00 % | 26,67 % | 100,00 % |
| **Jeudi** | 42 | 55 | 28 | 13 | 50,91 % | **46,43 %** | **23,64 %** |
| **Mercredi** | 82 | 838 | 331 | 113 | 39,50 % | 34,14 % | 13,48 % |
| **Samedi** | 65 | 821 | 278 | 74 | 33,86 % | 26,62 % | 9,01 % |
| **Lundi** | 1 | 0 | 0 | 0 | — | — | — |

**Key observations:**
* **Wednesdays perform better than Saturdays:** The number of registered visitors is almost identical on these two days; however, there is a higher attendance rate (39.50 per cent compared with 33.86 per cent) and a higher on-site conversion rate (34.14 per cent compared with 26.62 per cent). Wednesdays therefore generate **113 contract signings** compared with 74 on Saturdays.
* **Thursday’s excellent performance:** Thursday has the highest conversion rate amongst those present (**46.43 per cent**). This figure can be explained by a structural factor: 92.86 per cent of Thursday’s slots (39 out of 42) are ‘Vis-ma-vie’ sessions, where personalised support encourages a high rate of successful outcomes.
* **Data entry bias and lack of representativeness (Tuesday and Monday):**
  * **Tuesday** shows a data collection anomaly, with 15 attendees reported but only four registered participants recorded (technical attendance rate of 375.00 per cent).
  * On **Monday**, only one event was recorded, with zero registered participants and zero attendees (the session was presumably cancelled), which precludes any operational conclusions for that day.

### 4.2.3 Monthly analysis

> **Associated SQL script:** [`sql/02_conversion_by_specifiq_day.sql`](sql/02_conversion_by_specifiq_day.sql)

| Mois | Événements | Inscrits | Présents | Convertis (PI signés) | Taux de présence (%) | Taux de transformation (sur présents) (%) | Taux de conversion global (sur inscrits) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **2025-01** | 22 | 169 | 86 | 26 | 50,89 % | 30,23 % | 15,38 % |
| **2025-03** | 11 | 145 | 55 | 17 | 37,93 % | 30,91 % | 11,72 % |
| **2025-04** | 21 | 282 | 117 | 29 | 41,49 % | 24,79 % | 10,28 % |
| **2025-05** | 20 | 146 | 73 | 27 | 50,00 % | 36,99 % | 18,49 % |
| **2025-07** | 21 | 113 | 34 | 7 | 30,09 % | 20,59 % | 6,19 % |
| **2025-08** | 21 | 17 | 15 | 8 | 88,24 % | 53,33 % | 47,06 % |
| **2025-09** | 34 | 312 | 120 | 61 | 38,46 % | **50,83 %** | **19,55 %** |
| **2025-12** | 12 | 194 | 40 | 8 | 20,62 % | 20,00 % | 4,12 % |
| **2026-01** | 22 | 224 | 73 | 17 | 32,59 % | 23,29 % | 7,59 % |
| **2026-02** | 1 | 0 | 5 | 0 | — | 0,00 % | — |
| **2026-03** | 12 | 116 | 34 | 4 | 29,31 % | 11,76 % | 3,45 % |

**Key observations:**
* **Peak in sign-ups:** September 2025 alone accounts for **61 contract signings** (nearly 30 per cent of the total annual volume), with a conversion rate of **50.83 per cent** amongst those present. The back-to-school effect maximises the intention to commit.
* **The year-end trough in December:** December 2025 sees the sharpest decline: the attendance rate stands at **20.62 per cent** (only 40 attendees out of 194 registered) and the overall conversion rate plummets to **4.12 per cent**, reflecting candidates’ disengagement as the festive season approaches.
* **Structural biases and data collection anomalies:**
  * August 2025: The record conversion rate (47.06 per cent overall and 53.33 per cent of those present) is explained by the nature of the sessions: 100 per cent of the month’s events (21 out of 21) were individual ‘Vis-ma-vie’ immersive sessions. This small-group format (17 registered, 15 attendees and eight sign-ups) facilitates the selection of candidates just before the start of the intake.
  * **February 2026** featured only a single session with no registered participants and five attendees, excluding this month from any statistical analysis.
* **Decline in performance in early 2026:** The January 2026 intake generated an overall conversion rate half that of January 2025 (7.59 per cent compared with 15.38 per cent), a trend confirmed by a decline in March 2026 (3.45 per cent).

#### 4.2.4 Impact of school holidays

> **Related SQL script:** [`sql/02_conversion_by_specifiq_day.sql`](sql/02_conversion_by_specifiq_day.sql)

| Statut | Événements | Inscrits | Présents | Convertis (PI signés) | Taux de présence (%) | Taux de transformation (sur présents) (%) | Taux de conversion global (sur inscrits) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Hors vacances** | 142 | 1 439 | 532 | 175 | 36,97 % | **32,89 %** | **12,16 %** |
| **Vacances scolaires** | 55 | 279 | 120 | 29 | **43,01 %** | 24,17 % | 10,39 % |

**Key observations:**
* **Better attendance during the holidays:** The attendance rate reaches **43.01 per cent** during school holidays (compared with 36.97 per cent outside the holidays). Enrolled participants have more free time and are more likely to keep their appointments.
* **Lower on-the-spot conversion rate:** However, the conversion rate of those present drops to **24.17 per cent** during the holidays (compared with 32.89 per cent during the rest of the year).
* **Performance:**
  * **Outside the holidays:** each event attracts an average of **10.1 registered participants** and generates **1.23 sign-ups**.
  * **During school holidays:** each event attracts only **5.1 registrants** and yields **0.53 contracts**.
  Maintaining a busy schedule during the school holidays (55 sessions organised) places a heavy burden on the teams for a low volume of recruitment (only 29 contracts in total).

  ### 4.3 Performance analysis by campus

> **Related SQL script:** [`sql/03_campus_impact.sql`](sql/03_campus_impact.sql)

| Campus | Événements | Inscrits | Présents | Convertis (PI signés) | Taux de présence (%) | Taux de transformation (sur présents) (%) | Taux de conversion global (sur inscrits) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **MCN** | 2 | 19 | 11 | 6 | 57,89 % | **54,55 %** | **31,58 %** |
| **RDZ** | 7 | 34 | 19 | 9 | 55,88 % | 47,37 % | 26,47 % |
| **CSD** | 7 | 35 | 29 | 9 | **82,86 %** | 31,03 % | 25,71 % |
| **SNS** | 7 | 48 | 33 | 12 | 68,75 % | 36,36 % | 25,00 % |
| **LVA** | 22 | 48 | 32 | 12 | 66,67 % | 37,50 % | 25,00 % |
| **THO** | 22 | 126 | 66 | 18 | 52,38 % | 27,27 % | 14,29 % |
| **TLS** | 17 | 259 | 112 | 32 | 43,24 % | 28,57 % | 12,36 % |
| **RNS** | 23 | 119 | 59 | 14 | 49,58 % | 23,73 % | 11,76 % |
| **FRJ** | 14 | 87 | 31 | 10 | 35,63 % | 32,26 % | 11,49 % |
| **IDF** | 18 | 408 | 101 | 46 | 24,75 % | 45,54 % | 11,27 % |
| **DIJ** | 22 | 134 | 57 | 11 | 42,54 % | 19,30 % | 8,21 % |
| **BDX** | 14 | 149 | 35 | 12 | 23,49 % | 34,29 % | 8,05 % |
| **HDF** | 22 | 252 | 67 | 13 | 26,59 % | 19,40 % | 5,16 % |

**Key observations:**
* **Île-de-France and Toulouse** are the campuses that secured the most signed contracts (between them, 78 out of 204). IDF has the highest number of enrolments (408 enrolled, or 22.7 per session); despite high absenteeism, the conversion rate amongst those present is excellent (45.54 per cent).
* **Île-de-France (24.75 per cent), Bordeaux (23.49 per cent) and HDF (26.59 per cent) have the lowest attendance rates in the network. Fewer than one in four registered participants actually turn up on the day.
*  With 22 events and 252 registrants, **the HDF campus** recorded: a record level of absenteeism (26.59 per cent attendance) and the lowest on-site conversion rate (19.40 per cent), resulting in the lowest overall conversion rate in the network (5.16 per cent, or just 13 contracts).
* **Campuses in smaller towns (CSD, SNS, RDZ, LVA) show good attendance (often above 65 per cent) and solid overall conversion rates of around 25 per cent. Despite lower numbers of registrants per session, candidates’ commitment is significantly stronger there.
* **Volume bias:** The record MCN rate (31.58 per cent) is based on just two events and cannot be considered representative of an annual trend.

#### 4.4 Impact of time slots

> **Related SQL script:** [`sql/04_time_slot_impact.sql`](sql/04_time_slot_impact.sql)

| Time slot | Événements | Inscrits | Présents | Convertis (PI signés) | Taux de présence (%) | Taux de transformation (sur présents) (%) | Taux de conversion global (sur inscrits) (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Journée** | 43 | 30 | 30 | 9 | **100,00 %** | 30,00 % | 30,00 % |
| **Après-midi** | 106 | 1 174 | 439 | 144 | 37,39 % | 32,80 % | 12,27 % |
| **Matin** | 48 | 514 | 183 | 51 | 35,60 % | 27,87 % | 9,92 % |

**Key observations:**
* **The afternoon** accounts for **53.81 per cent of events** (106 out of 197), **68.34 per cent of registrants** (1,174 out of 1,718) and generates **70.59 per cent of the total volume of contracts signed** (144 out of 204). It is also the time slot with the highest on-site conversion rate (**32.80 per cent** of those present sign a contract).
* **The ‘Day’ format has an overall conversion rate of **30.00 per cent** and an attendance rate of 100.00 per cent; this corresponds to the 43 individual immersion sessions (*Vis-ma-vie*). This format attracted only 30 actual participants in total (0.70 registered per session), resulting in nine contracts signed – representing just 4.41 per cent of overall recruitment.
* With 48 sessions and 514 registrants, the **morning slot** converts less effectively on-site (**27.87 per cent**) and has the lowest overall conversion rate (**9.92 per cent**), indicating a less engaged audience than in the afternoon.

### 4.5 Analysis of participant profiles

> **Related SQL script:** [`sql/05_gender_impact.sql`](sql/05_gender_impact.sql)

#### Limitations of the dataset
It is **impossible to precisely identify the profile of participants who convert best** based on the available data, for two reasons:
1. **Lack of socio-demographic variables:** The table contains no information on age, current employment status (student, employee, jobseeker undergoing retraining) or the candidates’ level of education.
2. **No traceability regarding conversion:** Whilst the gender variable is recorded at registration and attendance, the signed contracts (`Nb_presents_avec_PI_signe`) are not linked to a specific profile.

The analysis should focus on the number of men and women at the time of registration and the number of men and women attending the events.

---

| Genre | Inscrits identifiés | Présents identifiés | Taux de présence (%) | Part des inscrits (%) | Part des présents (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Hommes** | 1 230 | 498 | **40,49 %** | 77,85 % | 80,45 % |
| **Femmes** | 350 | 121 | **34,57 %** | 22,15 % | 19,55 % |

**Key findings:**
* Men account for more than three-quarters of those registered (**77.85 per cent**) and those present (**80.45 per cent**).
* The attendance rate for men stands at **40.49 per cent**, compared with **34.57 per cent** for women (a moderate difference of 5.9 percentage points). The drop-off between registration and actual attendance affects both groups in a similar way.
