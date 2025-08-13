SELECT * FROM restaurants;

#Q1 - Return List of all restaurant with Rating above 4.5
SELECT count(distinct restaurant_name) as high_rated_restaurants FROM restaurants WHERE rating>4.5;

#Q2 - Return list of city with highest no of restaurant
SELECT city, count(distinct restaurant_name) as restaurant_count FROM restaurants group by city order by restaurant_count desc limit 1;

#Q3 - Return list of restaurant with having "pizza" in there name
SELECT distinct restaurant_name as num_of_restaurant FROM restaurants WHERE restaurant_name like '%Pizza%';

#Q4 - Returns the most frequent cuisine in restaurants along with how many restaurants serve that cuisine.
SELECT cuisine, count(*) as cuisine_count FROM restaurants group by cuisine order by cuisine_count desc limit 1;

#Q5 - Return list of city with average ratings from ascending order
SELECT city,avg(rating) as avg_rating FROM restaurants group by city;

#Q6  -  Return the most expensive 'Recommended' item per restaurant.
SELECT  restaurant_name,menu_category, max(price) as highest_price FROM restaurants WHERE menu_category = 'Recommended' group by restaurant_name,menu_category;

#Q7 - Return Top 5 most expensive restaurants (non-Indian cuisine)
SELECT distinct restaurant_name, cost_per_person FROM restaurants WHERE cuisine != 'Indian' order by cost_per_person desc limit 5;

#Q8 - Return restaurants where cost_per_person is above the average cost across all restaurants.
    -  useful for identifying above-average priced restaurants.
SELECT distinct restaurant_name, cost_per_person FROM restaurants WHERE cost_per_person>( SELECT avg(cost_per_person) FROM restaurants);

#Q9 - Self-join to find restaurants that have the same name in different cities.
    - Possible redundancy:
       This can return both (City A, City B) and (City B, City A). You can fix this by adding: AND t1.city < t2.city   to get only unique city pairs.

SELECT distinct t1.restaurant_name, t1.city,t2.city FROM restaurants t1 join restaurants t2 on t1.restaurant_name = t2.restaurant_name and t1.city != t2.city;

#Q10 Returns the restaurant with the most Main Course items.
SELECT restaurant_name, menu_category, count(item) as no_of_items FROM restaurants WHERE menu_category = 'Main Course' group by restaurant_name,menu_category order by no_of_items desc limit 1;

#Q11 - Return all restaurants where 100% of the menu items are vegetarian.
SELECT 
    restaurant_name, 
    COUNT(CASE WHEN veg_or_non_veg = 'Veg' THEN 1 END) * 100.0 / COUNT(*) AS vegetarian_percentage
FROM 
    restaurants
GROUP BY 
    restaurant_name
HAVING 
    COUNT(CASE WHEN veg_or_non_veg = 'Veg' THEN 1 END) * 100.0 / COUNT(*) = 100.0
ORDER BY 
    restaurant_name;


#Q12 - Find the restaurant with the lowest average item price.
SELECT restaurant_name, AVG(price) AS avg_price
FROM restaurants
GROUP BY restaurant_name
ORDER BY avg_price
LIMIT 1;


#Q13 - Find the top 5 restaurants with the most diverse menus, based on the number of unique menu_category entries
SELECT restaurant_name, COUNT(DISTINCT menu_category) AS no_of_categories
FROM restaurants
GROUP BY restaurant_name
ORDER BY no_of_categories DESC
LIMIT 5;


#Q14 - Find the restaurant with the highest % of non-veg items
SELECT 
    restaurant_name,
    (COUNT(CASE WHEN veg_or_non_veg = 'Non-veg' THEN 1 END) * 100.0 / COUNT(*)) AS nonveg_percent
FROM 
    restaurants
GROUP BY 
    restaurant_name
ORDER BY 
    nonveg_percent DESC
LIMIT 1;

#Q15 -  Find all restaurants that serve ONLY non-veg items
SELECT 
    restaurant_name, 
    (COUNT(CASE WHEN veg_or_non_veg LIKE 'non%' THEN 1 END) * 100.0 / COUNT(*)) AS non_veg_percent
FROM 
    restaurants
GROUP BY 
    restaurant_name
HAVING 
    (COUNT(CASE WHEN veg_or_non_veg LIKE 'non%' THEN 1 END) * 100.0 / COUNT(*)) = 100.0;
 
// OR - usually cannot use the alias non_veg_percent inside the HAVING clause (depends on the SQL dialect)
//  you should repeat the full expression in the HAVING clause instead of using the alias.
SELECT 
    restaurant_name, (COUNT(CASE WHEN veg_or_non_veg LIKE "non%" THEN 1 END) * 100 / COUNT(*))  as non_veg_percent 
FROM 
    restaurants  
group by 
    restaurant_name 
HAVING non_veg_percent = 100.00 ;