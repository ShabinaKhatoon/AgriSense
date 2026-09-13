# 🌱 AgriSense — IoT Smart Agriculture Monitoring System

<p align="center">

### 🌾 Smart Farming Through Real-Time Data & Intelligent Insights

**Monitor • Analyze • Predict • Act**

</p>

---

## 🚀 Overview

**AgriSense** is an IoT-based Smart Agriculture Monitoring System designed to help farmers monitor important environmental and soil conditions and make data-driven farming decisions.

The system collects real-time agricultural data such as:

- 🌡️ Temperature
- 💧 Humidity
- 🌱 Soil Moisture

The collected data is processed through a **Django backend** and presented through a **Flutter mobile application** in a simple and farmer-friendly format.

AgriSense goes beyond displaying raw sensor values by providing **data analysis, trends, alerts, farm insights, and automated irrigation decision support**.

> **AgriSense transforms raw agricultural sensor data into meaningful insights for smarter and more efficient farming.**

---

# 🎯 Problem Statement

Traditional farming often depends on manual observation and experience to determine whether crops require water or whether environmental conditions are suitable.

This can lead to:

- Excessive water usage
- Delayed irrigation
- Difficulty monitoring changing field conditions
- Lack of historical data
- Manual decision-making
- Inefficient resource utilization

### 💡 AgriSense Solution

AgriSense provides a technology-driven approach where sensor data is collected, stored, analyzed, and converted into understandable information.

```text
Real-World Farm Conditions
          ↓
      IoT Sensors
          ↓
         ESP32
          ↓
    Django Backend
          ↓
    Data Processing
          ↓
      Analytics
          ↓
 Flutter Mobile Application
          ↓
 Farmer-Friendly Insights
          ↓
   Smarter Decisions

```

# ✨ Key Features

## 🌡️ Real-Time Environmental Monitoring

Monitor important field parameters:

- 🌡️ Temperature
- 💧 Humidity
- 🌱 Soil Moisture

---

## 📱 Farmer-Friendly Mobile Application

The Flutter application provides a simple and intuitive interface for farmers to view agricultural information without dealing with complex raw data.

Farmers can easily access:

- Current field conditions
- Sensor readings
- Alerts
- Analytics
- Recommendations
- Irrigation-related information

---

## 📊 Data Analytics

AgriSense analyzes collected sensor data to identify useful patterns and provide meaningful information for decision-making.

The analytics system provides:

- Average sensor values
- Minimum and maximum readings
- Historical trends
- Number of records
- Data range
- Farm health insights
- Recommendations

---

## 💧 Automated Irrigation Decision Support

The system uses soil and environmental conditions to support irrigation decisions.

This helps with:

- 💧 Better water utilization
- ⏱️ Timely irrigation
- 📊 Data-driven decisions
- 🌱 Improved crop monitoring
- ♻️ Reduced unnecessary watering

---

## 🚨 Smart Alerts

AgriSense provides alerts based on agricultural conditions so that important changes can be identified quickly.

Alerts can be categorized according to priority:

- 🟢 Low
- 🟡 Medium
- 🟠 High
- 🔴 Critical

This helps farmers focus on conditions that may require immediate attention.

---

## ❤️ Farm Health Score

AgriSense provides an overall **Farm Health Score** based on the available agricultural data and analysis.

The score gives farmers a simple way to understand the general condition of their farm without manually interpreting every individual sensor reading.

---

## 📈 Data Visualization

Agricultural data is presented using charts and visual representations.

The application helps visualize:

- 🌡️ Temperature trends
- 💧 Humidity trends
- 🌱 Soil moisture trends

Visual analytics make it easier to identify changes and patterns over time.

---

# 🏗️ System Architecture

```text
                         🌱 AGRISENSE
                              │
                              ▼
                    ┌──────────────────┐
                    │  AGRICULTURAL    │
                    │      FIELD       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   IoT SENSORS    │
                    │                  │
                    │ 🌡 Temperature   │
                    │ 💧 Humidity      │
                    │ 🌱 Soil Moisture │
                    └────────┬─────────┘
                             │
                             │ Sensor Data
                             ▼
                    ┌──────────────────┐
                    │      ESP32       │
                    │  Microcontroller │
                    └────────┬─────────┘
                             │
                             │ Data Transmission
                             ▼
                    ┌──────────────────┐
                    │  DJANGO BACKEND  │
                    │                  │
                    │ REST APIs        │
                    │ Data Processing  │
                    │ Data Storage     │
                    │ Analytics        │
                    │ Alerts           │
                    │ Irrigation Logic │
                    └────────┬─────────┘
                             │
                             │ Processed Data
                             ▼
                    ┌──────────────────┐
                    │   FLUTTER APP    │
                    │                  │
                    │ Dashboard        │
                    │ Monitoring       │
                    │ Analytics        │
                    │ Charts           │
                    │ Recommendations │
                    └────────┬─────────┘
                             │
                             ▼
                       👨‍🌾 FARMER
                             │
                             ▼
                    SMART FARM DECISIONS
```
# 📊 Data Flow Diagram
### Level 0 Context Diagram
```text

                         ┌───────────────┐
                         │    FARMER     │
                         └───────┬───────┘
                                 │
                         Login / Requests
                                 │
                                 ▼
                  ┌──────────────────────────┐
                  │                          │
                  │       AGRISENSE          │
                  │                          │
                  │ Smart Agriculture        │
                  │ Monitoring & Analytics   │
                  │                          │
                  └────────────┬─────────────┘
                               │
                    Insights / Alerts /
                 Recommendations / Status
                               │
                               ▼
                         ┌───────────────┐
                         │    FARMER     │
                         └───────────────┘


       Sensor Readings
             │
             ▼
      ┌───────────────┐
      │ ESP32 + IoT   │
      │    Sensors    │
      └───────┬───────┘
              │
              │ Temperature
              │ Humidity
              │ Soil Moisture
              ▼
       ┌───────────────┐
       │   AGRISENSE   │
       └───────────────┘
```

# 📊 DFD — Level 1
```text
                         👨‍🌾 FARMER
                              │
                              │ Login / Requests
                              ▼
                    ┌───────────────────┐
                    │ 1.0 AUTHENTICATION│
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  2.0 MONITORING   │
                    └─────────┬─────────┘
                              │
                              │ Request Sensor Data
                              ▼
                    ┌───────────────────┐
                    │ ESP32 + SENSORS   │
                    └─────────┬─────────┘
                              │
                              │ Sensor Readings
                              ▼
                    ┌───────────────────┐
                    │ 3.0 DATA PROCESS  │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │   4.0 ANALYTICS   │
                    └─────────┬─────────┘
                              │
               ┌──────────────┼──────────────┐
               │              │              │
               ▼              ▼              ▼
          📈 Trends        🚨 Alerts      💧 Irrigation
                                             Decision
               │              │              │
               └──────────────┼──────────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │ 5.0 MOBILE DISPLAY│
                    │     FLUTTER       │
                    └─────────┬─────────┘
                              │
                              ▼
                         👨‍🌾 FARMER
```
# 🔄 Complete System Workflow
```text
                         START
                           │
                           ▼
                 🌱 FIELD CONDITIONS
                           │
                           ▼
                   📡 IoT SENSORS
                           │
                           ▼
                        ESP32
                           │
                           ▼
                 📤 DATA TRANSMISSION
                           │
                           ▼
                  🌐 DJANGO BACKEND
                           │
                           ▼
                  💾 DATA PROCESSING
                           │
                           ▼
                    📊 ANALYTICS
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
          📈 Trends      🚨 Alerts    💧 Irrigation
                                      Decision
              │            │            │
              └────────────┼────────────┘
                           │
                           ▼
                    📱 FLUTTER APP
                           │
                           ▼
                  👨‍🌾 FARMER
                           │
                           ▼
                  SMART DECISION
                           │
                           ▼
                          END
```
# 🧠 Irrigation Decision Flow
```text
                    🌱 SOIL MOISTURE
                           │
                           ▼
                ┌────────────────────┐
                │ Is moisture level  │
                │       low?         │
                └─────────┬──────────┘
                          │
                    ┌─────┴─────┐
                   YES          NO
                    │            │
                    ▼            ▼
          Check environmental   Continue
              conditions       monitoring
                    │            │
                    ▼            │
           💧 Irrigation         │
             Required?           │
                    │            │
              ┌─────┴─────┐      │
             YES          NO     │
              │            │     │
              ▼            ▼     │
       💧 Recommend      Monitor │
         Irrigation              │
              │                  │
              └────────┬─────────┘
                       ▼
                Continue Monitoring
```

| Category                | Technology                           |
| ----------------------- | ------------------------------------ |
| 📱 Mobile Application   | Flutter                              |
| 💻 Programming Language | Dart                                 |
| ⚙️ Backend              | Django                               |
| 🔌 IoT Microcontroller  | ESP32                                |
| 🌡️ Sensors             | Temperature, Humidity, Soil Moisture |
| 🌐 Communication        | REST API / HTTP                      |
| 📊 Data Processing      | Python / Django Backend              |
| 📈 Visualization        | Flutter Charts                       |
| 🗄️ Database            | Backend Database                     |
| 🔧 Development Tools    | VS Code, Android Studio              |
| 🌐 Version Control      | Git & GitHub                         |
