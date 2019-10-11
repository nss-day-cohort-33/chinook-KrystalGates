-- non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT (c.FirstName || " " || c.LastName) AS "FullName", CustomerId, Country
FROM Customer c
WHERE Country <> "USA";


-- brazil_customers.sql: Provide a query only showing the Customers from Brazil.
SELECT (c.FirstName || " " || c.LastName) AS "FullName", CustomerId, Country
FROM Customer c 
WHERE Country = "Brazil";

-- brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT (c.FirstName || " " || c.LastName) AS "FullName", i.InvoiceDate, i.BillingCountry
FROM Customer c
JOIN Invoice i 
ON c.CustomerId = i.CustomerId;

-- sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT (FirstName || " " || LastName) AS "FullName"
FROM Employee
WHERE Title = "Sales Support Agent";

-- unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM Invoice;

-- sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT (e.FirstName || " " || e.LastName) AS "FullName", i.InvoiceId, i.InvoiceDate
FROM Customer c
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
JOIN Invoice i
ON c. CustomerId = i.CustomerId
ORDER BY e.FirstName;

-- invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total, (c.FirstName || " " || c.LastName) AS "CustomerFullName", i.BillingCountry, (e.FirstName || " " || e.LastName) AS "EmployeeFullName"
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
ORDER BY c.FirstName;

-- total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
SELECT strftime('%Y',i.InvoiceDate) as "Year", COUNT(*) AS "Count"
from Invoice i
WHERE YEAR = "2009" or YEAR = "2011"
GROUP BY YEAR;

-- total_sales_{year}.sql: What are the respective total sales for each of those years?
SELECT strftime('%Y',i.InvoiceDate) as "Year", SUM(i.Total) AS "YearTotal"
FROM Invoice i
WHERE YEAR = "2009" or YEAR = "2011"
GROUP BY YEAR;

-- invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(InvoiceId) AS Tally
FROM InvoiceLine i
WHERE InvoiceId = 37;

-- line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT InvoiceLine.InvoiceId, COUNT(InvoiceLineId) AS COUNT
FROM InvoiceLine
GROUP BY InvoiceId;

-- line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT t.[Name], i.InvoiceLineId
FROM InvoiceLine i
JOIN Track t
ON i.TrackId = t.TrackId;

-- line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT t.[Name], i.InvoiceLineId, aa.[name]
FROM InvoiceLine i
JOIN Track t
ON i.TrackId = t.TrackId
JOIN Album a
ON t.AlbumId = a.AlbumId
JOIN Artist aa
ON a.ArtistId = aa.ArtistId;

-- country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT i.BillingCountry, COUNT(*) AS "Count"
FROM Invoice i
GROUP BY i.BillingCountry;

-- playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
SELECT p.[name], COUNT(*) AS "Count"
FROM PlaylistTrack pt
JOIN Playlist p
ON pt.PlaylistId = p.PlaylistId
GROUP BY p.PlaylistId;

-- tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT t.[name] AS "TrackName", a.Title , m.[name], g.[name]
FROM Track t
JOIN Album a
ON t.AlbumId = a.AlbumId
JOIN MediaType m
ON t.MediaTypeId = m.MediaTypeId
JOIN Genre g 
ON t.GenreId = g.GenreId;

-- invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT i.InvoiceId, COUNT(*)
FROM InvoiceLine il
JOIN Invoice i
ON il.InvoiceId = i.InvoiceId 
GROUP BY il.InvoiceId;

-- sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT (e.FirstName || " " || e.LastName) AS "SalesRep", SUM(i.Total) AS "TotalSales"
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId;

-- top_2009_agent.sql: Which sales agent made the most in sales in 2009?

SELECT
	MAX(TotalSales),
	EmployeeName
FROM (
	SELECT
		"$" || printf ("%.2f",
			SUM(i.total)) TotalSales,
		e.FirstName || " " || e.LastName EmployeeName,
		strftime ("%Y",
			i.InvoiceDate) AS InvoiceYear
	FROM
		Invoice i,
		Employee e,
		Customer c
	WHERE
		i.CustomerId = c.CustomerId
		AND c.SupportRepId = e.EmployeeId
		AND InvoiceYear = "2009"
	GROUP BY
		e.FirstName || " " || e.LastName,
		InvoiceYear) AS Sales;
	-- Hint: Use the MAX function on a subquery.
-- top_agent.sql: Which sales agent made the most in sales over all?

SELECT
	MAX(TotalSales),
	EmployeeName
FROM (
	SELECT
		"$" || printf ("%.2f",
			SUM(i.total)) TotalSales,
		e.FirstName || " " || e.LastName EmployeeName
	FROM
		Invoice i,
		Employee e,
		Customer c
	WHERE
		i.CustomerId = c.CustomerId
		AND c.SupportRepId = e.EmployeeId
	GROUP BY
		e.FirstName || " " || e.LastName) AS Sales;
	-- sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
	SELECT e.FirstName || " " || e.LastName AS FullName, COUNT(c.CustomerId)
	FROM Customer c
	JOIN Employee e
	ON c.SupportRepId = e.EmployeeId
	GROUP BY e.EmployeeId;

	-- sales_per_country.sql: Provide a query that shows the total sales per country.
	SELECT i.BillingCountry, SUM(i.Total) AS TotalSales
	FROM Invoice i
	GROUP BY i.BillingCountry;
	
	-- top_country.sql: Which country's customers spent the most?
	SELECT i.BillingCountry, MAX(i.Total) AS Total
	FROM Invoice i
	GROUP BY i.BillingCountry;

	-- top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
	SELECT
	MAX(Total),
	TrackName, Year
	FROM (
	SELECT
		strftime('%Y',i.InvoiceDate) as "Year", COUNT(il.TrackId) Total,
		t.[Name] TrackName
	FROM
		Invoice i,
		InvoiceLine il,
		Track t
	WHERE
		i.InvoiceId = il.InvoiceId
		AND il.TrackId = t.TrackId and Year = "2013"
	GROUP BY
		TrackName) AS Sales;

	-- top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.
	SELECT
	t.[name] AS TrackName,
	COUNT(il.TrackId) AS Count
FROM
	Invoice i,
	InvoiceLine il,
	track t
WHERE
	i.InvoiceId = il.InvoiceId
	AND il.TrackId = t.TrackId
GROUP BY
	TrackName
ORDER BY
	Count DESC
LIMIT 5;

	-- top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
SELECT
aa.[name] AS ArtistName,
COUNT(il.TrackId) AS Count
FROM
	InvoiceLine il,
	Track t,
	Album a,
	Artist aa
WHERE
	t.TrackId = il.TrackId
	AND t.AlbumId = a.AlbumId
	AND a.ArtistId = aa.ArtistId
GROUP BY
	aa.[name]
ORDER BY
	Count DESC
LIMIT 3;
	-- top_media_type.sql: Provide a query that shows the most purchased Media Type.
	SELECT m.[Name] as MediaName, COUNT(il.TrackId) as COUNT
	FROM
	InvoiceLine il,
	Track t,
	MediaType m
	WHERE il.TrackId = t.TrackId and t.MediaTypeId = m.MediaTypeId
	GROUP BY m.MediaTypeId
	ORDER BY Count DESC
	LIMIT 1;