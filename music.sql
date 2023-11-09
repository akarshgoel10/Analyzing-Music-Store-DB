/* Q1 : Who is senior most employee?*/

select * from employee order by levels desc limit 1

/*Q2: Which Country has Most Invoices?*/

select count(*) as invoices,billing_country from invoice group by billing_country order by invoices desc limit 1;

/*Q3 : What are top 3 values of total invoices ?*/

select max(total) as total_invoices,billing_country from invoice group by billing_country order by total_invoices desc limit 3;

/*Q4: Which city has the best customers?*/

select billing_city,sum(total) from invoice group by billing_city order by sum(total) desc limit 1;

/*Q5 : Who is the best customer?*/

select c.customer_id,c.first_name,sum(i.total) as total from 
customer c
join
invoice i
on c.customer_id = i.customer_id
group by c.customer_id
order by total desc limit 1;

/*Q6 : Query to return email,fname,lname,genre of all rock music listeners. Return list ordered alphabatically by email starting with A.*/

SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoiceline ON invoiceline.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoiceline.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

/*Q7 : Lets invite artists who written most rock music. Return Artist name,total track count of top 10 rock bands.*/

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/*Q8 :  Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds from track where milliseconds > (select avg(milliseconds) as ag from track) order by milliseconds desc

/*Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent*/

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

/* Q:10 we want to find out the most popular music Genre for each country. We determine the most popular genre as the genre
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

