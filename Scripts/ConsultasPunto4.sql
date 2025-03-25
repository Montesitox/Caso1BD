use mydb;

-- 4.1 consulta de usuarios activos e inversión en suscripciones --

SELECT u.userid, CONCAT(u.firstname, ' ', u.lastname) AS full_name, u.email, c.name AS country,
    ROUND(COALESCE(SUM(
        CASE 
            WHEN p.currencyid = (SELECT currencyid FROM assists_currency WHERE iso_code = 'USD') 
            THEN p.monto * 
                COALESCE((
                    SELECT exchangeRate 
                    FROM assists_currency_exchange 
                    WHERE from_currencyid = p.currencyid AND to_currencyid = (SELECT currencyid FROM assists_currency WHERE iso_code = 'CRC')
                    AND effectiveDate <= p.fecha ORDER BY effectiveDate DESC 
                    LIMIT 1
                ), 530)  -- Tipo de cambio promedio si no hay registro
            WHEN p.currencyid = (SELECT currencyid FROM assists_currency WHERE iso_code = 'CRC') 
            THEN p.monto
            ELSE 0
        END
    ), 0), 2) AS total_paid_in_crc
FROM 
    assists_users u
JOIN assists_countries c ON u.countryid = c.countryid
LEFT JOIN assists_userSubscriptions us ON u.userid = us.userid
LEFT JOIN assists_payments p ON u.userid = p.userid
WHERE 
    u.isActive = 1 AND p.fecha >= '2024-01-01' AND p.fecha <= CURDATE() AND p.result = 'success'
GROUP BY u.userid, u.firstname, u.lastname, u.email, 
    c.name
HAVING total_paid_in_crc > 0
ORDER BY total_paid_in_crc DESC;

-- 4.2 personas a pagar en los proximos 15 días --

SELECT 
    u.firstname AS Nombre,
    u.lastname AS Apellido,
    u.email AS Correo,
    us.next_payment
FROM assists_users u
JOIN assists_userSubscriptions us ON u.userid = us.userid
WHERE us.next_payment BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 15 DAY)
ORDER BY us.next_payment ASC;

-- 4.3 Ranking de los que más uso le dan y los que menos uso le dan --

-- Usuarios con más interacciones --
SELECT u.userid, CONCAT(u.firstname, ' ', u.lastname) AS full_name, u.email, 
       COUNT(l.log_id) AS interacciones
FROM assists_users u
LEFT JOIN assists_dispositive d ON u.userid = d.userid
LEFT JOIN assists_logs l ON d.dispositiveid = l.dispositiveid 
WHERE l.log_type_id IN (1, 2, 3) -- 1: Login, 2: Acción, 3: Error (uso de la app)
GROUP BY u.userid, full_name, u.email
ORDER BY interacciones DESC 
LIMIT 15;

-- Usuarios con menos interacciones (incluye los que nunca usaron la app) --
SELECT u.userid, CONCAT(u.firstname, ' ', u.lastname) AS full_name, u.email, 
       COALESCE(COUNT(l.log_id), 0) AS interacciones
FROM assists_users u
LEFT JOIN assists_dispositive d ON u.userid = d.userid
LEFT JOIN assists_logs l ON d.dispositiveid = l.dispositiveid 
AND l.log_type_id IN (1, 2, 3) -- Mismos tipos de interacciones
GROUP BY u.userid, full_name, u.email
ORDER BY interacciones ASC 
LIMIT 15;

-- 4.4 Errores de la IA --

SELECT 
    aet.name AS error_type, 
    COUNT(af.user_feedbackid) AS occurrence_count,
    MAX(af.feedback_text) AS feedback,
    MAX(vc.originalText) AS original_command,
    MAX(vc.processedText) AS processed_command
FROM assists_user_feedback af
JOIN assists_voicecommand vc ON af.commandid = vc.commandid
JOIN assists_ai_error_types aet ON af.error_typesid = aet.error_typesid
WHERE af.created_at BETWEEN DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND CURDATE()
GROUP BY aet.name
ORDER BY occurrence_count DESC;
