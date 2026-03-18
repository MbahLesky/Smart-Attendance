# Application Structure & Interface Specification

## Table of Contents
1. [Purpose of the Document](#1-purpose-of-the-document)
2. [System Component Overview](#2-system-component-overview)
3. [Backend Project Structure](#3-backend-project-structure)
4. [Admin Web Application Structure (React)](#4-admin-web-application-structure-react)
5. [Admin Web Application Pages](#5-admin-web-application-pages)
6. [Mobile Application Structure (Flutter)](#6-mobile-application-structure-flutter)
7. [Mobile App Screens](#7-mobile-app-screens)
8. [Navigation Structure](#8-navigation-structure)
9. [Feature-to-Module Mapping](#9-feature-to-module-mapping)

---

## 1. Purpose of the Document
This document defines the structural organization of the Smart Attendance Tracking System. It outlines how the applications will be divided into modules, the folder structures for development, and the pages or screens that will compose the user interfaces.

## 2. System Component Overview
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Admin Web App** | React | Administration and system management |
| **Mobile App** | Flutter | Attendance scanning and user access |
| **Backend API** | Node.js / Express | Business logic and data processing |

## 3. Backend Project Structure
The backend follows a modular feature-based architecture:
```text
server/
├── src/
│   ├── config/
│   │   ├── database.js
│   │   ├── environment.js
│   ├── modules/
│   │   ├── auth/
│   │   ├── organizations/
│   │   ├── departments/
│   │   ├── users/
│   │   ├── sessions/
│   │   ├── attendance/
│   │   ├── reports/
│   ├── middlewares/
│   ├── utils/
│   ├── app.js
│   └── server.js
```

## 4. Admin Web Application Structure (React)
Built using React with a feature-based architecture:
```text
src/
├── app/
├── components/
├── features/
│   ├── auth/
│   ├── organizations/
│   ├── departments/
│   ├── users/
│   ├── sessions/
│   ├── attendance/
│   └── reports/
├── layouts/
├── pages/
├── services/
```

## 5. Admin Web Application Pages
* **Authentication:** Login, Registration, Forgot Password.
* **Dashboard:** Summary stats.
* **Organization Management:** List, Create, Edit.
* **Department Management:** List, Create, Edit, User Assignment.
* **User Management:** List, Create, Profile, Deactivate.
* **Session Management:** List, Create, Details, QR Code View.
* **Attendance Monitoring:** Records, Session Attendance, Manual Edit.
* **Reports:** Daily, Session, Department, Analytics Export.

## 6. Mobile Application Structure (Flutter)
The mobile app uses **Riverpod** for state management and follows a feature-first folder structure.
```text
lib/
├── core/
│   ├── routing/
│   ├── theme/
│   ├── constants/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── attendance/ (Scanner, Result, Verification)
│   ├── organizations/ (Join Organization, Join Department)
│   ├── history/
│   └── profile/
├── models/
├── providers/
├── main.dart
```

## 7. Mobile App Screens
* **Auth:** Login, Registration.
* **Dashboard:** Active and upcoming sessions.
* **Join Organization:** Search and join an organization using a code or list.
* **Join Department:** Select a department within an organization.
* **QR Scanner:** Uses `mobile_scanner` to scan session QR codes.
* **Attendance Verification (Upcoming):**
    * **Geolocation:** Verifies user is within a specific radius of the session location.
    * **Wi-Fi Base:** Verifies user is connected to a specific Wi-Fi network.
* **Attendance Result:** Success message, status, and session info.
* **Attendance History:** Chronological list of records.
* **Profile:** User info and account settings.

## 8. Navigation Structure

### 8.1. Web Application Navigation
`Login -> Dashboard -> [Organizations, Departments, Users, Sessions, Attendance, Reports, Settings]`

### 8.2. Mobile Application Navigation
`Login -> Dashboard -> [Join Organization/Dept, Scan QR, Attendance Result, History, Profile]`

## 9. Feature-to-Module Mapping
| Feature | Backend Module | Web Module | Mobile Module |
| :--- | :--- | :--- | :--- |
| Authentication | Auth | Auth | Auth |
| Organization | Organizations | Organizations | Organizations |
| User Management | Users | Users | — |
| Sessions | Sessions | Sessions | — |
| QR Attendance | Attendance | Attendance | Attendance |
| Geolocation/Wi-Fi | Attendance | — | Attendance |
| Reports | Reports | Reports | — |
