CREATE DATABASE ExcelR_Pro;
USE excelr_pro;
SELECT * FROM fact_bookings_mfd
LIMIT 15;

-- 1. Total Revenue
SELECT CONCAT("$",SUM(revenue_realized)) AS `Total Revenue` FROM fact_bookings_mfd;

-- 2. Total Booking
SELECT COUNT(booking_status) AS `Total Bookings` FROM fact_bookings_mfd;

-- 3. Total Capacity
SELECT SUM(capacity) AS `Total Capacity` FROM fact_aggregated_bookings;

-- 4. Sucessful Booking
SELECT COUNT(booking_status) AS `Sucessful Booking` FROM fact_bookings_mfd
WHERE booking_status = "Checked Out" OR booking_status = "No Show";

-- 5. Occupancy %
SELECT 
	CONCAT(ROUND((SUM(successful_bookings)/SUM(capacity))*100,2),"%") AS `Occupancy%` 
FROM fact_aggregated_bookings;

-- 6.  Average Rating
SELECT ROUND(AVG(ratings_given),2) AS `Average Rating` FROM fact_bookings_mfd; 

-- 7. NUMBER OF DAYS 
SELECT COUNT(ï»¿date) AS `Count of Days` FROM dim_date_mfd;

-- 8. Total Cancelled Booking
SELECT COUNT(booking_status) FROM fact_bookings_mfd
WHERE booking_status = "Cancelled";

-- 9. Cancellation %
SELECT 
	CONCAT(ROUND((COUNT(booking_status)/(SELECT COUNT(booking_status) FROM fact_bookings_mfd))*100 ,2),"%") 
	AS `Cancellation %`
FROM fact_bookings_mfd
WHERE booking_status = "Cancelled";
    
-- 10. Total Checked Out
SELECT 
	COUNT(booking_status) AS `Total Checked Out`
FROM fact_bookings_mfd
WHERE booking_status = "Checked Out";
    
-- 11. Total No Show Bookings
SELECT 
	COUNT(booking_status) AS `Total No Show Bookings`
FROM fact_bookings_mfd
WHERE booking_status = "No Show"; 

-- 12. No Show %
SELECT 
	CONCAT(ROUND((COUNT(booking_status)/(SELECT COUNT(booking_status) FROM fact_bookings_mfd))*100 ,2),"%") 
	AS `No Show %`
FROM fact_bookings_mfd
WHERE booking_status = "No Show";

-- 13. Booking % by Platforms
SELECT 
	booking_platform AS `Booking Platform`,
    CONCAT(ROUND((COUNT(booking_status)/(SELECT COUNT(booking_status) FROM fact_bookings_mfd))*100,2),"%") 
    AS `Booking %`
FROM fact_bookings_mfd
GROUP BY booking_platform
ORDER BY `Booking %` DESC;

-- 14. Booking % by Room Class
SELECT 
	dr.room_class AS `Room Class`,
    CONCAT(ROUND((COUNT(fb.room_category)/(SELECT COUNT(room_category) FROM fact_bookings_mfd))*100,2),"%")
    AS `Booking %`
FROM dim_rooms dr JOIN fact_bookings_mfd fb ON dr.room_id = fb.room_category
GROUP BY `Room Class`
ORDER BY `Booking %` DESC;

-- 15. Average Daily Rate ADR
SELECT 
	CONCAT("$",ROUND(SUM(revenue_realized)
    /
    (SELECT SUM(successful_bookings) FROM fact_aggregated_bookings),2)) 
    AS ADR
FROM fact_bookings_mfd;
    
-- 16. Realisation % 
SELECT 
	CONCAT(ROUND((COUNT(booking_status)/(SELECT COUNT(booking_status) FROM fact_bookings_mfd))*100 ,2),"%") 
	AS `Realisation %`
FROM fact_bookings_mfd
WHERE booking_status = "Checked out";
    
-- 17. RevPAR(Revenue Per Available Room)
SELECT 
	CONCAT("$",ROUND(SUM(revenue_realized)
    /
    (SELECT SUM(capacity) FROM fact_aggregated_bookings),2)) 
    AS RevPAR
FROM fact_bookings_mfd;

-- 18. DBRN(Daily Booked Room Nights)
SELECT 
	ROUND(COUNT(ï»¿booking_id)
    /
    (SELECT COUNT(DISTINCT check_in_date) FROM fact_bookings_mfd),2)
    AS DBRN
FROM fact_bookings_mfd;

-- 19. DSRN(Daily Sellable Room Nights)
SELECT 
	ROUND(SUM(capacity)
    /
    (SELECT COUNT(DISTINCT check_in_date) FROM fact_bookings_mfd),0)
    AS DSRN
FROM fact_aggregated_bookings;

-- 20. 