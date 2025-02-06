-- Authentication Table (Stores login credentials)
CREATE TABLE auth_users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL 
);

-- User Info Table (Stores user-specific info like name, preferences, etc.)
CREATE TABLE users (
    auth_id INT PRIMARY KEY NOT NULL REFERENCES auth_users(id) ON DELETE CASCADE,  
    name NVARCHAR(255) NOT NULL,
    dietary_preferences NVARCHAR(MAX),  -- E.g., Vegetarian, Vegan, etc.
    health_goal NVARCHAR(MAX),          -- E.g., Weight Loss, Muscle Gain, etc.
    age INT,
    height INT,
    weight INT          
);

-- Recipe Table (Stores recipe details including ingredients as JSON)
CREATE TABLE recipes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    image_url NVARCHAR(255),   -- URL of the recipe image
    calories INT,
    protein INT,
    prep_time INT,            -- Store preparation time in minutes
    ingredients NVARCHAR(MAX), -- Store ingredients as JSON string
    steps NVARCHAR(MAX)        -- Store cooking steps as JSON string
);

-- User Recipe Interaction Table (Tracks user interactions like favorites, history, ratings)
CREATE TABLE user_recipes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(auth_id) ON DELETE CASCADE,  
    recipe_id INT NOT NULL REFERENCES recipes(id) ON DELETE CASCADE  
);

INSERT INTO recipes (title, description, image_url, ingredients, steps, calories, protein, prep_time) VALUES
('Spaghetti Bolognese', 'A classic Italian meat sauce served over pasta', 'assets/Images/spaghetti.png',
 '["spaghetti", "ground beef", "onions", "tomato sauce", "red wine"]',
 '["Cook the spaghetti according to package directions.", "Brown the ground beef and onions.", "Add the tomato sauce and red wine and simmer for 1 hour.", "Toss with cooked spaghetti and serve."]',
 650, 35, 60),

('Chicken Parmesan', 'Breaded chicken breast topped with tomato sauce and mozzarella', 'assets/Images/chicken.png',
 '["chicken breasts", "breadcrumbs", "parmesan", "tomato sauce", "mozzarella"]',
 '["Bread chicken breasts with breadcrumbs.", "Pan fry until golden brown.", "Top with tomato sauce and mozzarella.", "Bake until cheese is melted."]',
 550, 45, 30),

('Caesar Salad', 'Romaine lettuce with creamy Caesar dressing, croutons and parmesan', 'assets/Images/salad.png',
 '["romaine lettuce", "caesar dressing", "croutons", "parmesan"]',
 '["Chop romaine lettuce.", "Toss with caesar dressing.", "Top with croutons and parmesan."]',
 250, 10, 10),

('Tacos', 'Soft tortilla shells filled with seasoned ground beef, lettuce, cheese and salsa', 'assets/Images/tacos.png',
 '["tortillas", "ground beef", "lettuce", "cheese", "salsa"]',
 '["Cook ground beef with taco seasoning.", "Warm tortillas.", "Fill with beef, lettuce, cheese and salsa."]',
 500, 20, 20),

('Pasta Alfredo', 'Fettuccine pasta tossed in a rich, creamy parmesan cheese sauce', 'assets/Images/alfredo.png',
 '["fettuccine", "butter", "cream", "parmesan"]',
 '["Cook pasta according to package directions.", "Melt butter in a pan.", "Add cream and parmesan and cook until thick and creamy.", "Toss pasta with sauce."]',
 800, 15, 15),

('Cheese Pizza', 'Crispy crust with tomato sauce and mozzarella cheese', 'assets/Images/pizza.png',
 '["pizza dough", "tomato sauce", "mozzarella"]',
 '["Stretch dough into rounds.", "Top with sauce and cheese.", "Bake until crust is crispy and cheese melted."]',
 700, 20, 40),

('Hamburger', 'Juicy beef patty with lettuce, tomato, onion and cheese on a bun', 'assets/Images/burger.png',
 '["ground beef", "hamburger buns", "lettuce", "tomato", "onion", "cheese"]',
 '["Form ground beef into patties and grill.", "Toast buns.", "Place patty on bun and top with lettuce, tomato, onion and cheese."]',
 650, 25, 15),

('Chocolate Chip Cookies', 'Chewy cookies filled with chocolate chips', 'assets/Images/cookies.png',
 '["flour", "butter", "sugar", "eggs", "chocolate chips"]',
 '["Cream butter and sugar.", "Beat in eggs.", "Stir in flour and chocolate chips.", "Scoop dough and bake."]',
 200, 3, 30),

('Chicken Fried Rice', 'Rice stir-fried with chicken, vegetables and egg', 'assets/Images/chicken_fried_rice.png',
 '["rice", "chicken", "vegetables", "egg", "soy sauce"]',
 '["Cook rice.", "Stir fry chicken and vegetables.", "Add rice and stir fry.", "Scramble egg and mix in.", "Season with soy sauce."]',
 450, 25, 30),

('Pasta Bolognese', 'True Italian classic with a meaty, chili sauce', 'assets/images/pasta_bolognese.png',
 '["pasta", "ground beef", "tomato sauce", "onions", "garlic", "chili flakes"]',
 '["Cook pasta according to package instructions.", "Brown ground beef in a pan.", "Add chopped onions, garlic, and chili flakes.", "Pour in tomato sauce and simmer.", "Mix cooked pasta with the sauce and serve."]',
 200, 45, 10),

('Garlic Potatoes', 'Crispy Garlic Roasted Potatoes', 'assets/Images/filete_con_papas_cambray.png',
 '["potatoes", "garlic", "olive oil", "salt", "pepper"]',
 '["Preheat oven to 400°F (200°C).", "Cut potatoes into wedges.", "Toss potatoes with olive oil, minced garlic, salt, and pepper.", "Spread on a baking sheet and roast until crispy.", "Serve hot."]',
 150, 30, 8),

('Asparagus', 'White Onion, Fennel, and Watercress Salad', 'assets/Images/asparagus.png',
 '["asparagus", "white onion", "fennel", "watercress", "olive oil", "lemon juice"]',
 '["Trim and blanch asparagus.", "Thinly slice white onion and fennel.", "Toss asparagus, onion, fennel, and watercress with olive oil and lemon juice.", "Season with salt and pepper.", "Serve as a fresh salad."]',
 190, 35, 12),

('Filet Mignon', 'Bacon-Wrapped Filet Mignon', 'assets/Images/steak_bacon.png',
 '["filet mignon steaks", "bacon", "salt", "pepper", "garlic", "thyme"]',
 '["Preheat oven to 375°F (190°C).", "Season steaks with salt, pepper, and minced garlic.", "Wrap each steak with a slice of bacon.", "Sear steaks in a hot pan.", "Transfer to oven and cook to desired doneness.", "Let rest before serving."]',
 250, 55, 20);

INSERT INTO recipes (title, description, image_url, calories, protein, prep_time, ingredients, steps)
VALUES
('Classic Margherita Pizza', 'A classic Italian pizza with fresh mozzarella and basil.', 'https://cdn.dummyjson.com/recipe-images/1.webp', 300, 12, 20, '["Pizza dough", "Tomato sauce", "Fresh mozzarella cheese", "Fresh basil leaves", "Olive oil", "Salt and pepper to taste"]', '["Preheat the oven to 475°F (245°C).", "Roll out the pizza dough and spread tomato sauce evenly.", "Top with slices of fresh mozzarella and fresh basil leaves.", "Drizzle with olive oil and season with salt and pepper.", "Bake in the preheated oven for 12-15 minutes or until the crust is golden brown.", "Slice and serve hot."]'),
('Vegetarian Stir-Fry', 'A healthy and flavorful stir-fry with tofu and vegetables.', 'https://cdn.dummyjson.com/recipe-images/2.webp', 250, 18, 15, '["Tofu, cubed", "Broccoli florets", "Carrots, sliced", "Bell peppers, sliced", "Soy sauce", "Ginger, minced", "Garlic, minced", "Sesame oil", "Cooked rice for serving"]', '["In a wok, heat sesame oil over medium-high heat.", "Add minced ginger and garlic, sauté until fragrant.", "Add cubed tofu and stir-fry until golden brown.", "Add broccoli, carrots, and bell peppers. Cook until vegetables are tender-crisp.", "Pour soy sauce over the stir-fry and toss to combine.", "Serve over cooked rice."]'),

('Quinoa Salad with Avocado', 'A refreshing quinoa salad with avocado and vegetables.', 'https://cdn.dummyjson.com/recipe-images/6.webp', 280, 10, 20, '["Quinoa, cooked", "Avocado, diced", "Cherry tomatoes, halved", "Cucumber, diced", "Red bell pepper, diced", "Feta cheese, crumbled", "Lemon vinaigrette dressing", "Salt and pepper to taste"]', '["In a large bowl, combine cooked quinoa, diced avocado, halved cherry tomatoes, diced cucumber, diced red bell pepper, and crumbled feta cheese.", "Drizzle with lemon vinaigrette dressing and toss to combine.", "Season with salt and pepper to taste.", "Chill in the refrigerator before serving."]'),
('Tomato Basil Bruschetta', 'A simple and delicious Italian appetizer.', 'https://cdn.dummyjson.com/recipe-images/7.webp', 120, 4, 15, '["Baguette, sliced", "Tomatoes, diced", "Fresh basil, chopped", "Garlic cloves, minced", "Balsamic glaze", "Olive oil", "Salt and pepper to taste"]', '["Preheat the oven to 375°F (190°C).", "Place baguette slices on a baking sheet and toast in the oven until golden brown.", "In a bowl, combine diced tomatoes, chopped fresh basil, minced garlic, and a drizzle of olive oil.", "Season with salt and pepper to taste.", "Top each toasted baguette slice with the tomato-basil mixture.", "Drizzle with balsamic glaze before serving."]'),
('Beef and Broccoli Stir-Fry', 'A savory stir-fry with beef and broccoli.', 'https://cdn.dummyjson.com/recipe-images/8.webp', 380, 30, 20, '["Beef sirloin, thinly sliced", "Broccoli florets", "Soy sauce", "Oyster sauce", "Sesame oil", "Garlic, minced", "Ginger, minced", "Cornstarch", "Cooked white rice for serving"]', '["In a bowl, mix soy sauce, oyster sauce, sesame oil, and cornstarch to create the sauce.", "In a wok, stir-fry thinly sliced beef until browned. Remove from the wok.", "Stir-fry broccoli florets, minced garlic, and minced ginger in the same wok.", "Add the cooked beef back to the wok and pour the sauce over the mixture.", "Stir until everything is coated and heated through.", "Serve over cooked white rice."]'),
('Caprese Salad', 'A fresh and light Italian salad.', 'https://cdn.dummyjson.com/recipe-images/9.webp', 200, 10, 10, '["Tomatoes, sliced", "Fresh mozzarella cheese, sliced", "Fresh basil leaves", "Balsamic glaze", "Extra virgin olive oil", "Salt and pepper to taste"]', '["Arrange alternating slices of tomatoes and fresh mozzarella on a serving platter.", "Tuck fresh basil leaves between the slices.", "Drizzle with balsamic glaze and extra virgin olive oil.", "Season with salt and pepper to taste.", "Serve immediately as a refreshing salad."]'),
('Shrimp Scampi Pasta', 'A flavorful shrimp scampi pasta with garlic and white wine.', 'https://cdn.dummyjson.com/recipe-images/10.webp', 400, 25, 15, '["Linguine pasta", "Shrimp, peeled and deveined", "Garlic, minced", "White wine", "Lemon juice", "Red pepper flakes", "Fresh parsley, chopped", "Salt and pepper to taste"]', '["Cook linguine pasta according to package instructions.", "In a skillet, sauté minced garlic in olive oil until fragrant.", "Add shrimp and cook until pink and opaque.", "Pour in white wine and lemon juice. Simmer until the sauce slightly thickens.", "Season with red pepper flakes, salt, and pepper.", "Toss cooked linguine in the shrimp scampi sauce.", "Garnish with chopped fresh parsley before serving."]'),
('Chicken Biryani', 'Aromatic and flavorful chicken biryani.', 'https://cdn.dummyjson.com/recipe-images/11.webp', 550, 35, 30, '["Basmati rice", "Chicken, cut into pieces", "Onions, thinly sliced", "Tomatoes, chopped", "Yogurt", "Ginger-garlic paste", "Biryani masala", "Green chilies, sliced", "Fresh coriander leaves", "Mint leaves", "Ghee", "Salt to taste"]', '["Marinate chicken with yogurt, ginger-garlic paste, biryani masala, and salt.", "In a pot, sauté sliced onions until golden brown. Remove half for later use.", "Layer marinated chicken, chopped tomatoes, half of the fried onions, and rice in the pot.", "Top with ghee, green chilies, fresh coriander leaves, mint leaves, and the remaining fried onions.", "Cover and cook on low heat until the rice is fully cooked and aromatic.", "Serve hot, garnished with additional coriander and mint leaves."]'),
('Chicken Karahi', 'Spicy and tangy chicken karahi.', 'https://cdn.dummyjson.com/recipe-images/12.webp', 420, 40, 20, '["Chicken, cut into pieces", "Tomatoes, chopped", "Green chilies, sliced", "Ginger, julienned", "Garlic, minced", "Coriander powder", "Cumin powder", "Red chili powder", "Garam masala", "Cooking oil", "Fresh coriander leaves", "Salt to taste"]', '["In a wok (karahi), heat cooking oil and sauté minced garlic until golden brown.", "Add chicken pieces and cook until browned on all sides.", "Add chopped tomatoes, green chilies, ginger, and spices. Cook until tomatoes are soft.", "Cover and simmer until the chicken is tender and the oil separates from the masala.", "Garnish with fresh coriander leaves and serve hot with naan or rice."]'),
('Aloo Keema', 'A hearty dish of ground beef and potatoes.', 'https://cdn.dummyjson.com/recipe-images/13.webp', 380, 25, 25, '["Ground beef", "Potatoes, peeled and diced", "Onions, finely chopped", "Tomatoes, chopped", "Ginger-garlic paste", "Cumin powder", "Coriander powder", "Turmeric powder", "Red chili powder", "Cooking oil", "Fresh coriander leaves", "Salt to taste"]', '["In a pan, heat cooking oil and sauté chopped onions until golden brown.", "Add ginger-garlic paste and sauté until fragrant.", "Add ground beef and cook until browned. Drain excess oil if needed.", "Add diced potatoes, chopped tomatoes, and spices. Mix well.", "Cover and simmer until the potatoes are tender and the masala is well-cooked.", "Garnish with fresh coriander leaves and serve hot with naan or rice."]'),
('Chapli Kebabs', 'Spicy and flavorful beef kebabs.', 'https://cdn.dummyjson.com/recipe-images/14.webp', 320, 25, 30, '["Ground beef", "Onions, finely chopped", "Tomatoes, finely chopped", "Green chilies, chopped", "Coriander leaves, chopped", "Pomegranate seeds", "Ginger-garlic paste", "Cumin powder", "Coriander powder", "Red chili powder", "Egg", "Cooking oil", "Salt to taste"]', '["In a large bowl, mix ground beef, chopped onions, tomatoes, green chilies, coriander leaves, and pomegranate seeds.", "Add ginger-garlic paste, cumin powder, coriander powder, red chili powder, and salt. Mix well.", "Add an egg to bind the mixture and form into round flat kebabs.", "Heat cooking oil in a pan and shallow fry the kebabs until browned on both sides.", "Serve hot with naan or mint chutney."]'),
('Saag (Spinach) with Makki di Roti', 'A traditional Punjabi dish with spinach and cornmeal flatbread.', 'https://cdn.dummyjson.com/recipe-images/15.webp', 280, 12, 40, '["Mustard greens, washed and chopped", "Spinach, washed and chopped", "Cornmeal (makki ka atta)", "Onions, finely chopped", "Green chilies, chopped", "Ginger, grated", "Ghee", "Salt to taste"]', '["Boil mustard greens and spinach until tender. Drain and blend into a coarse paste.", "In a pan, sauté chopped onions, green chilies, and grated ginger in ghee until golden brown.", "Add the greens paste and cook until it thickens.", "Meanwhile, knead cornmeal with water to make a dough. Roll into rotis (flatbreads).", "Cook the rotis on a griddle until golden brown.", "Serve hot saag with makki di roti and a dollop of ghee."]'),
('Japanese Ramen Soup', 'A comforting bowl of Japanese ramen.', 'https://cdn.dummyjson.com/recipe-images/16.webp', 480, 25, 20, '["Ramen noodles", "Chicken broth", "Soy sauce", "Mirin", "Sesame oil", "Shiitake mushrooms, sliced", "Bok choy, chopped", "Green onions, sliced", "Soft-boiled eggs", "Grilled chicken slices", "Norwegian seaweed (nori)"]', '["Cook ramen noodles according to package instructions and set aside.", "In a pot, combine chicken broth, soy sauce, mirin, and sesame oil. Bring to a simmer.", "Add sliced shiitake mushrooms and chopped bok choy. Cook until vegetables are tender.", "Divide the cooked noodles into serving bowls and ladle the hot broth over them.", "Top with green onions, soft-boiled eggs, grilled chicken slices, and nori.", "Serve hot and enjoy the authentic Japanese ramen!"]'),
('Moroccan Chickpea Tagine', 'A flavorful Moroccan chickpea stew.', 'https://cdn.dummyjson.com/recipe-images/17.webp', 320, 12, 15, '["Chickpeas, cooked", "Tomatoes, chopped", "Carrots, diced", "Onions, finely chopped", "Garlic, minced", "Cumin", "Coriander", "Cinnamon", "Paprika", "Vegetable broth", "Olives", "Fresh cilantro, chopped"]', '["In a tagine or large pot, sauté chopped onions and minced garlic until softened.", "Add diced carrots, chopped tomatoes, and cooked chickpeas.", "Season with cumin, coriander, cinnamon, and paprika. Stir to coat.", "Pour in vegetable broth and bring to a simmer. Cook until carrots are tender.", "Stir in olives and garnish with fresh cilantro before serving.", "Serve this flavorful Moroccan dish with couscous or crusty bread."]'),
('Korean Bibimbap', 'A colorful and nutritious Korean rice bowl.', 'https://cdn.dummyjson.com/recipe-images/18.webp', 550, 20, 30, '["Cooked white rice", "Beef bulgogi (marinated and grilled beef slices)", "Carrots, julienned and sautéed", "Spinach, blanched and seasoned", "Zucchini, sliced and grilled", "Bean sprouts, blanched", "Fried egg", "Gochujang (Korean red pepper paste)", "Sesame oil", "Toasted sesame seeds"]', '["Arrange cooked white rice in a bowl.", "Top with beef bulgogi, sautéed carrots, seasoned spinach, grilled zucchini, and blanched bean sprouts.", "Place a fried egg on top and drizzle with gochujang and sesame oil.", "Sprinkle with toasted sesame seeds before serving.", "Mix everything together before enjoying this delicious Korean bibimbap!", "Feel free to customize with additional vegetables or protein."]'),
('Greek Moussaka', 'A rich and hearty Greek casserole.', 'https://cdn.dummyjson.com/recipe-images/19.webp', 420, 25, 45, '["Eggplants, sliced", "Ground lamb or beef", "Onions, finely chopped", "Garlic, minced", "Tomatoes, crushed", "Red wine", "Cinnamon", "Allspice", "Nutmeg", "Olive oil", "Milk", "Flour", "Parmesan cheese", "Egg yolks"]', '["Preheat oven to 375°F (190°C).", "Sauté sliced eggplants in olive oil until browned. Set aside.", "In the same pan, cook chopped onions and minced garlic until softened.", "Add ground lamb or beef and brown. Stir in crushed tomatoes, red wine, and spices.", "In a separate saucepan, make béchamel sauce: melt butter, whisk in flour, add milk, and cook until thickened.", "Remove from heat and stir in Parmesan cheese and egg yolks.", "In a baking dish, layer eggplants and meat mixture. Top with béchamel sauce.", "Bake for 40-45 minutes until golden brown. Let it cool before slicing.", "Serve slices of moussaka warm and enjoy this Greek classic!"]');