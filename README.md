# **Personalized Recipe Recommender App**  

## **Mobile Programming Course - Group 5**  
**Team Members:**  
- John Sawaya  
- Charbel Kiwan  
- Elie Bou Naoum  
- Karen Kdeissy  
- Elissa Merhi  

## **Overview**  
The **Personalized Recipe Recommender App** is a user-centric meal planning application that helps users discover and track recipes based on their dietary goals. The app calculates daily calorie needs based on user input (age, height, weight, and goal) and recommends suitable recipes. Users can browse, save favorites, and explore a variety of dishes with detailed nutritional insights.  

## **Key Features**  
**Recipe Recommendations** – The app suggests recipes tailored to the user's calorie needs based on their fitness goals. *(Note: Recommendations are based on predefined calculations, not AI-generated.)*   **Navigation System** – The app features a **bottom navigation bar** with four main pages:  
   - **Home** 🏠 – Displays personalized recipe recommendations and calculates user-specific daily calorie needs.  
   - **Explore** 🔍 – Allows users to browse all available recipes and discover new dishes.  
   - **Favorites** ❤️ – Users can save and remove recipes they like for quick access.  
   - **Profile** 👤 – Displays user information and settings.
   -  **Recipe Details** – Clicking on a recipe shows:  
   - Preparation time  
   - Calories and macronutrients  
   - Description and step-by-step instructions  
   - List of ingredients  
 **User Authentication** – The app includes a **Login and Register** system for secure access.  

## **Project Structure**  

### **Backend (Server & Database)**  
- Located in the **backend** folder.  
- Contains:  
  - `server.js` – The backend server file, handling **CRUD operations** with the database.  
  - `recipe_recommender.bak` – Backup file of the PostgreSQL database.
  - 'recipeapp_f.sql' -queries commands.
   

### **Frontend (Flutter App)**  
- Located in the **lib** folder.  
- Contains:  
  - **Flutter UI files** – All Dart files for the frontend.  
  - **API Services (`/lib/services`)** – `service_api.dart` handles the connection between the frontend and backend.  

## **Technology Stack**  
- **Frontend:** Flutter (for mobile UI)  
- **Backend:** Node.js with Express.js (hosted on **Render**)  
- **Database:** PostgreSQL (also hosted on **Render**, available until **March 2** due to platform restrictions)  

## **Database Design**  
The PostgreSQL database consists of:  
- **Authentication Table (`auth_users`)** – Manages user login and registration.  
- **User Info Table (`users`)** – Stores user details, dietary preferences, and health goals.  
- **Recipes Table (`recipes`)** – Contains recipe information, including title, description, ingredients, and nutrition facts.  
- **User Recipe Interaction Table (`user_recipes`)** – Tracks user interactions, such as favorites and browsing history.  

## **Demo Video**  
🎥 **Watch a recording of our app in action:**  

<video width="600" controls>
  <source src="RecipeRecVideo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
 

## **Future Enhancements**  
**AI Meal Planning** – Implement smart meal generation based on dietary needs.  
**Gamification** – Add rewards, challenges, and interactive cooking tools.  
 **Voice Commands** – Enable hands-free recipe navigation.  

