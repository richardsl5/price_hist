use crypto;

SELECT DATE(p_date) AS 'Date', ROUND(sum(p.price * h.qty),0) AS 'Value' 
	FROM price_history p, buy_history h
	WHERE p.ticker = h.ticker
GROUP BY DATE(p_date)
ORDER BY DATE(p_date)
