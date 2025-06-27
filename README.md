# 🍱 Food Delivery App - AIMST University

## 📌 Project Overview
The Food Delivery App is a centralized food ordering platform designed exclusively for **AIMST University** students, staff, management, and on-campus vendors (Jaya Catering, Anico, and Kopitiam). The application offers convenient food ordering, delivery or pickup options, and robust backend tools for vendors to manage their menus efficiently.

---

## ✨ Key Features

### 🧠 Smart Chatbot Integration
- In-app chatbot for **FAQs** and real-time **user support**.

### 🔐 Security & Authentication
- **Firebase** integration for secure data handling.
- **Firewall protection** for intrusion prevention.
- **Three-layer authentication**:  
  1. **Student/Staff ID** login  
  2. **Custom image (e.g., apple, watermelon)** selection  
  3. **Face scan login** *(if device supports)*

### 🔌 API Development
- RESTful APIs for:
  - Food order management
  - Vendor item updates
  - Payment processing
  - Notification triggers
  - User management

### 📚 User Manual
- In-app and downloadable manual covering:
  - How to use the app
  - Vendor dashboard usage
  - Payment & ordering process
  - Scheduling and feedback

### 💳 Payment Gateway (Dummy)
- Dummy payment for test mode
- Support for:
  - **QR Code Payment**
  - **Apple Pay**
  - **Touch ’n Go**

### 🍜 Menu & Food Ordering System
- Local food and beverages from Jaya Catering, Anico, and Kopitiam.
- Add food with:
  - Description, price, and dietary labels (veg, non-veg, low-calorie).
- Add to cart, with **undo** option.
- **Order summary** and **re-selection** supported.
- Vendor tools to **add/edit/update** food items and stock availability in real-time.

### 🚧 Development Challenges & Solutions
| Challenge                            | Solution                                      |
|-------------------------------------|-----------------------------------------------|
| Secure login only for AIMST users   | Custom login + Firebase Authentication        |
| Real-time stock/menu updates        | Vendor dashboard + push notifications         |
| Scheduled order complications       | Implemented time-picker with date selector    |
| Device compatibility                | Built as **PWA** for cross-platform support   |

### 🧪 Testing Phase
- Post-development:
  - **Unit testing**
  - **Integration testing**
  - **User acceptance testing (UAT)**
  - **Cross-platform compatibility checks (Android & iOS)**

### 🔔 Notifications (WebSocket or Push)
- **Real-time order status** (confirmed, delayed, delivered)
- **Estimated wait time**
- **Order history**
- **Multi-language support** (English & Malay)

### 📆 Scheduled Orders
- Schedule orders for **future pickup/delivery** (e.g., order at 9am for 1pm delivery).

### 📊 Feedback & Rating
- **Feedback form** after order completion.
- **Star ratings** system.
- Vendor response option for feedback.

### 🛍️ Personalized Experience
- Favorite/repeat meals
- Promotions and discounts
- Striking UI elements
- Order filters (price range, dietary tags, vendor)

### 🔎 Accessibility Features
- **Alt text**, **screen reader descriptions**
- Visual accessibility (contrast, dropdowns, filters)
- Speech descriptions
- Searchable menu with filter options

### 📱 Platform Support
- Fully responsive **Progressive Web Application (PWA)**
- Available on **Android** and **iOS** via remote installation

---

## 👥 User Types & Access

| User Type     | Access Privileges                                         |
|---------------|-----------------------------------------------------------|
| Students      | Order, feedback, schedule, customize profile              |
| Staff         | Same as students                                          |
| Management    | View reports, monitor vendor performance                  |
| Vendors       | Update menus, manage stock, track orders                  |

- Login via:
  - **Student/Staff ID**
  - **Apple, Facebook, Google, Email login options**
  - **Third authentication image or face scan**

---

## 🧾 App Components

- **Login & Authentication**
- **Main Dashboard**
- **Menu & Food Details**
- **Cart & Payment Page**
- **Order Status Tracking**
- **Notifications**
- **Vendor Panel**
- **Feedback & Ratings**
- **Profile Management**

---

## 🛡️ Copyright

All pages include:  
`© AIMST UNIVERSITY`

---

## 📥 Installation Guide

### 📲 Android/iOS Installation
- Remote installation available via:
  - Firebase App Distribution or TestFlight
  - QR Code installation link

---

## 📧 Contact

For internal use only:  
📧 Email: support@aimst.edu.my  
📞 Helpline: 1800-FOOD-HELP

---

