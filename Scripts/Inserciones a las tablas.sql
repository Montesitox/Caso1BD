use mydb;

DELIMITER $$

CREATE PROCEDURE sp_populate_all()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  DECLARE nextDate DATE;
  DECLARE recType VARCHAR(10);
  DECLARE _isCorrect TINYINT;
  DECLARE _voiceCmdID INT;
  DECLARE _userID INT;
  DECLARE indiceNombre INT;
  DECLARE indiceApellido INT;
  DECLARE nombre VARCHAR(50);
  DECLARE apellido VARCHAR(50);

  -- 0. (assists_countries)
  INSERT INTO assists_countries (name)
    VALUES ('Costa Rica'), ('México'), ('España'), ('Argentina'), ('Colombia');

  -- 1. assists_roles
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_roles (name, description)
    VALUES (
      CASE i 
        WHEN 1 THEN 'Administrador'
        WHEN 2 THEN 'Operador'
        WHEN 3 THEN 'Cliente'
        WHEN 4 THEN 'Soporte'
        ELSE 'Invitado'
      END,
      CONCAT('Descripción del rol ', i)
    );
    SET i = i + 1;
  END WHILE;

  -- 2. assists_companies
	SET i = 1;
	WHILE i <= 5 DO
	  INSERT INTO assists_companies (name, fiscal_id, updated_at)
	  VALUES (
		ELT(i, 'InTech', 'Empresa Presa', 'Soluciones Abiertas', 'Software Hard', 'Empresa S.A.'),
		CONCAT('FISCAL-', LPAD(i,2,'0')),
		NOW()
	  );
	  SET i = i + 1;
	END WHILE;

  -- 3. assists_users
  SET i = 1;
  WHILE i <= 30 DO
    SET indiceNombre = 1 + FLOOR(RAND()*10);
    CASE indiceNombre
      WHEN 1 THEN SET nombre = 'Juan';
      WHEN 2 THEN SET nombre = 'María';
      WHEN 3 THEN SET nombre = 'Pedro';
      WHEN 4 THEN SET nombre = 'Lucía';
      WHEN 5 THEN SET nombre = 'Carlos';
      WHEN 6 THEN SET nombre = 'Ana';
      WHEN 7 THEN SET nombre = 'Luis';
      WHEN 8 THEN SET nombre = 'Sofía';
      WHEN 9 THEN SET nombre = 'Jorge';
      WHEN 10 THEN SET nombre = 'Elena';
    END CASE;
    SET indiceApellido = 1 + FLOOR(RAND()*10);
    CASE indiceApellido
      WHEN 1 THEN SET apellido = 'García';
      WHEN 2 THEN SET apellido = 'Rodríguez';
      WHEN 3 THEN SET apellido = 'Martínez';
      WHEN 4 THEN SET apellido = 'Sánchez';
      WHEN 5 THEN SET apellido = 'López';
      WHEN 6 THEN SET apellido = 'Gómez';
      WHEN 7 THEN SET apellido = 'Fernández';
      WHEN 8 THEN SET apellido = 'Díaz';
      WHEN 9 THEN SET apellido = 'Morales';
      WHEN 10 THEN SET apellido = 'Ruiz';
    END CASE;
    INSERT INTO assists_users (
      username, firstname, lastname, email, password_hash,
      created_at, updated_at, isActive, voiceprofileid, companyid, countryid
    )
    VALUES (
      CONCAT(LOWER(nombre), '.', LOWER(apellido), i),
      nombre,
      apellido,
      CONCAT(LOWER(nombre), '.', LOWER(apellido), i, '@correo.com'),
      'hash-123',
      NOW(),
      NOW(),
      1,
      NULL,
      FLOOR(1 + RAND()*5),
      1 + FLOOR(RAND()*5)
    );
    SET i = i + 1;
  END WHILE;

  -- 4. assists_usersroles
  SET i = 1;
  WHILE i <= 30 DO
    INSERT INTO assists_usersroles (
      roleid, userid, lastupdate, username, checksum, enabled, deleted
    )
    VALUES (
      ((i - 1) MOD 5) + 1,
      i,
      NOW(),
      CONCAT('usuario', i),
      '0xAB',
      1,
      0
    );
    SET i = i + 1;
  END WHILE;

  -- 5. assists_modules
  INSERT INTO assists_modules (name)
    VALUES ('Módulo1'), ('Módulo2'), ('Módulo3');

  -- 6. assists_permissions
  INSERT INTO assists_permissions (description, code, moduleid)
    VALUES 
      ('Gestión de usuarios','GU01', 1),
      ('Editar roles','ER01', 1),
      ('Procesar pago','PP01', 2),
      ('Reembolsar pago','RP01', 2),
      ('Entrenar IA','EIA01', 3),
      ('Usar IA','UIA01', 3);

  -- 7. assists_rolespermission (10 registros)
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO assists_rolespermission (permissionid, roleid, rolepermissionid, enabled, deleted, lastupdate, username, cheksum)
    VALUES (
      1 + FLOOR(RAND()*6),
      1 + FLOOR(RAND()*5),
      i,
      1,
      0,
      NOW(),
      CONCAT('usuario', i),
      '0xCD'
    );
    SET i = i + 1;
  END WHILE;

  -- 8. assists_userspermissions
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO assists_userspermissions (rolepermissionid, userid, permissionid, enabled, deleted, lastupdate, username, checksum)
    VALUES (
      i,
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*6),
      1,
      0,
      NOW(),
      CONCAT('usuario', i),
      '0xEF'
    );
    SET i = i + 1;
  END WHILE;

  -- 9. languages
  INSERT INTO languages (language_id, name, iso_code)
    VALUES (1, 'Inglés', 'ENG'), (2, 'Español', 'ESP');

  -- 10. assists_currency
  INSERT INTO assists_currency (currencyid, iso_code, symbol, name)
    VALUES (1, 'USD', '$', 'Dólar'), (2, 'CRC', '₡', 'Colón');
    
  -- 11. assists_ai_error
  INSERT INTO assists_ai_error_types (name, description) VALUES
	('Falla de reconocimiento', 'La IA no logró reconocer correctamente el audio ingresado.'),
	('Error de interpretación', 'La IA no pudo interpretar la intención del usuario.'),
	('Confusión de contexto', 'La IA confundió el contexto de la conversación, generando respuestas inadecuadas.'),
	('Error de conexión', 'Falló la conexión con el servicio de inteligencia artificial durante el procesamiento.'),
	('Falla de procesamiento', 'Se produjo un error interno durante el procesamiento de la solicitud.'),
	('Error de validación', 'Los datos de entrada no cumplieron con los criterios de validación establecidos.'),
	('Error de respuesta', 'La respuesta generada por la IA fue imprecisa o incompleta.'),
	('Fallo en el entrenamiento', 'Se presentaron problemas durante el entrenamiento del modelo de IA.');

	SET @i = 1;
	WHILE @i <= 100 DO
		SET @category = ELT(1 + FLOOR(RAND()*4), 'Reconocimiento', 'Interpretación', 'Ejecución', 'Contexto');
		SET @subcat = ELT(1 + FLOOR(RAND()*5), 'audio', 'texto', 'intención', 'entidades', 'secuencia');
		SET @severity = ELT(1 + FLOOR(RAND()*3), 'leve', 'moderado', 'grave');
		
		INSERT INTO assists_ai_error_types (name, description)
		VALUES (
			CONCAT(@category, '-', LPAD(@i,3,'0'), ': ', @subcat, ' (', @severity, ')'),
			CONCAT('Error tipo ', @i, ' en ', @subcat, ' durante ', @category, 
				   '. Severidad: ', @severity, '. Código ', 
				   LEFT(UUID(), 8))
		);
		
		SET @i = @i + 1;
	END WHILE;

  -- 12. assists_paymentMethods
	INSERT INTO assists_paymentMethods (name, apiURL, secretKey, `key`, logoIconURL)
	VALUES 
	  ('Tarjeta de Crédito', 'https://api.tarjetacredito.com', 'secreto123', 'clave123', 'https://tarjetacredito.com/logo.png'),
	  ('PayPal', 'https://api.paypal.com', 'secreto456', 'clave456', 'https://paypal.com/logo.png');

  -- 13. assists_paymentMedia
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO assists_paymentMedia (name, token, expTokenDate, maskAccount, paymentMethodid, userid)
    VALUES (
      CONCAT('MedioPago ', i),
      CONCAT('token-', i),
      DATE_ADD(CURDATE(), INTERVAL 30 DAY),
      CONCAT('****', LPAD(FLOOR(RAND()*10000),4,'0')),
      1 + FLOOR(RAND()*2),  -- 1 o 2
      1 + FLOOR(RAND()*30)
    );
    SET i = i + 1;
  END WHILE;

  -- 14. assists_payments
  SET i = 1;
  WHILE i <= 100 DO
    INSERT INTO assists_payments (
      monto, actualMonto, result, auth, reference, changeToken, description,
      error, fecha, checksum, userid, moduleid, paymentMediaid, currencyid
    )
    VALUES (
      ROUND(RAND()*200+50, 2),
      NULL,
      ELT(FLOOR(1+RAND()*3), 'success','failed','pending'),
      CONCAT('AUT-', i),
      CONCAT('REF-', i),
      CONCAT('CHGT-', i),
      CONCAT('Descripción del pago ', i),
      NULL,
      DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND()*365) DAY),
      '0xFF',
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*5),
      CASE FLOOR(RAND()*2)
        WHEN 0 THEN 1  -- USD
        ELSE 2  -- CRC
      END
    );
    SET i = i + 1;
  END WHILE;

  -- 15. assists_subscriptions
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_subscriptions (name, description, logo_url, is_active)
    VALUES (
      CONCAT('Suscripción ', i),
      CONCAT('Descripción de la suscripción ', i),
      CONCAT('http://logo', i, '.com'),
      1
    );
    SET i = i + 1;
  END WHILE;

  -- 16. assists_subscriptionprices
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_subscriptionprices (amount, recurrency_type, startdate, enddate, is_current, currencyid, subscriptionid)
    VALUES (
      ROUND(RAND()*100 + 10, 2),
      ELT(FLOOR(1 + RAND()*4), 'daily', 'weekly', 'monthly', 'yearly'),
      CURDATE(),
      DATE_ADD(CURDATE(), INTERVAL 30 DAY),
      1,
      1 + FLOOR(RAND()*2),
      i
    );
    INSERT INTO assists_subscriptionprices (amount, recurrency_type, startdate, enddate, is_current, currencyid, subscriptionid)
    VALUES (
      ROUND(RAND()*100 + 10, 2),
      ELT(FLOOR(1 + RAND()*2), 'monthly','yearly'),
      CURDATE(),
      DATE_ADD(CURDATE(), INTERVAL 60 DAY),
      1,
      1 + FLOOR(RAND()*2),
      i
    );
    SET i = i + 1;
  END WHILE;

-- 17. assists_userSubscriptions --
  SET i = 1;
  WHILE i <= 100 DO
	  BEGIN
		DECLARE _priceid INT;
		DECLARE _recType VARCHAR(10);
        DECLARE _nextDays INT;
        
		SET _priceid = 1 + FLOOR(RAND() * 5);
        
		SELECT recurrency_type INTO _recType
		  FROM assists_subscriptionprices
		  WHERE subscriptionid = _priceid
		  LIMIT 1;
			SET _nextDays = CASE 
							  WHEN _recType = 'daily' THEN FLOOR(RAND()*10) + 1
							  WHEN _recType = 'weekly' THEN FLOOR(RAND()*4)*7 + 7
							  WHEN _recType = 'monthly' THEN FLOOR(RAND()*2)*30 + 30
							  WHEN _recType = 'yearly' THEN 365
							  ELSE FLOOR(RAND()*60)  -- Rango amplio para otros casos
							END;
		
        SET nextDate = DATE_ADD(CURDATE(), INTERVAL _nextDays DAY);
		INSERT INTO assists_userSubscriptions (startdate, enddate, next_payment, is_active, userid, priceid)
		VALUES (
		  DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND()*365) DAY),
		  DATE_ADD(CURDATE(), INTERVAL _nextDays DAY),
		  nextDate,
		  1,
		  1 + FLOOR(RAND() * 30),
		  _priceid
		);
		SET i = i + 1;
	END;
  END WHILE;

  -- 18. schedules
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO schedules (name, recurrency_type, recurrencyday, nextexcecution, is_active, usersubcriptionid)
    VALUES (
      CONCAT('Horario ', i),
      ELT(FLOOR(1 + RAND()*4), 'daily','weekly','monthly','yearly'),
      1 + FLOOR(RAND()*28),
      DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*30) DAY),
      1,
      1 + FLOOR(RAND()*10)
    );
    SET i = i + 1;
  END WHILE;

  -- 19. assits_subscriptionfeatures
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assits_subscriptionfeatures (name, description, datatype, is_active)
    VALUES (
      CONCAT('Característica ', i),
      CONCAT('Descripción de la característica ', i),
      ELT(FLOOR(1 + RAND()*3), 'int','string','boolean'),
      1
    );
    SET i = i + 1;
  END WHILE;

  -- 20. assists_company_subscriptions
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_company_subscriptions (startdate, enddate, is_active, subscriptionid, companyid)
    VALUES (
      CURDATE(),
      DATE_ADD(CURDATE(), INTERVAL 365 DAY),
      1,
      1 + FLOOR(RAND()*5),
      1 + FLOOR(RAND()*5)
    );
    SET i = i + 1;
  END WHILE;

  -- 21. assists_subscriptionlimits
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_subscriptionlimits (limitvalue, time_period, featureid, company_subscriptionid)
    VALUES (
      CONCAT('Límite ', i),
      ELT(FLOOR(1 + RAND()*4), 'day','week','month','year'),
      1 + FLOOR(RAND()*5),
      i
    );
    INSERT INTO assists_subscriptionlimits (limitvalue, time_period, featureid, company_subscriptionid)
    VALUES (
      CONCAT('Límite extra ', i),
      ELT(FLOOR(1 + RAND()*4), 'day','week','month','year'),
      1 + FLOOR(RAND()*5),
      i
    );
    SET i = i + 1;
  END WHILE;

  -- 22. assists_log_types
  INSERT INTO assists_log_types (log_type_id, name, description)
    VALUES (1, 'Inicio de sesión', 'Evento de inicio de sesión'),
           (2, 'Acción', 'Acciones generales'),
           (3, 'Error', 'Registro de errores');

  -- 23. assists_log_source
  INSERT INTO assists_log_source (log_source_id, name, system_component)
    VALUES (1, 'Fuente1', 'Componente1'),
           (2, 'Fuente2', 'Componente2'),
           (3, 'Fuente3', 'Componente3');

  -- 24. assists_log_severity
  INSERT INTO assists_log_severity (log_severity_id, name, severity_level)
    VALUES (1, 'Bajo', 0),
           (2, 'Medio', 0),
           (3, 'Alto', 1);

  -- 25. assists_dispositiveType
  INSERT INTO assists_dispositiveType (name)
    VALUES ('Altavoz'), ('Móvil'), ('Portátil');

 
  -- 26. assists_dispositive
  SET i = 1;
  WHILE i <= 50 DO
    INSERT INTO assists_dispositive (
      name, activation, deviceIdentifier, lastActive, status, firmwareversion,
      dispositiveTypeid, userid
    )
    VALUES (
      CONCAT('Dispositivo ', i),
      NOW(),
      CONCAT('DISP-', i),
      NOW(),
      'active',
      CONCAT('fw', i, '.0'),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*30)
    );
    SET i = i + 1;
  END WHILE;

  -- 27. assists_logs
  SET i = 1;
  WHILE i <= 100 DO
    INSERT INTO assists_logs (
      log_id, log_type_id, log_source_id, log_severity_id, dispositiveid,
      description, post_time, computer, username, trace, value1, value2, checksum
    )
    VALUES (
      i,
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*50),
      CONCAT('Descripción del log ', i),
      NOW(),
      CONCAT('PC', i),
      CONCAT('usuario', 1 + FLOOR(RAND()*30)),
      CONCAT('Traza ', i),
      CONCAT('Valor1_', i),
      CONCAT('Valor2_', i),
      CONCAT('Checksum_', i)
    );
    SET i = i + 1;
  END WHILE;

  -- 27b. Logs de inicio de sesión con log_type_id = 1
  SET i = 1;
  WHILE i <= 20 DO
    INSERT INTO assists_logs (
      log_id, log_type_id, log_source_id, log_severity_id, dispositiveid,
      description, post_time, computer, username, trace, value1, value2, checksum
    )
    VALUES (
      1000 + i,
      1,
      1,
      1,
      1 + FLOOR(RAND()*10),
      'Inicio de sesión',
      NOW(),
      CONCAT('PC_Login', i),
      CONCAT('usuario', 1 + FLOOR(RAND()*30)),
      'Evento de inicio de sesión',
      'Valor1_Login',
      'Valor2_Login',
      'Chk_Login'
    );
    SET i = i + 1;
  END WHILE;

  -- 28. translations
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO translations (translation_id, `key`, `value`, language_id)
    VALUES (
      i,
      CONCAT('Clave', i),
      CONCAT('Traducción para la clave ', i),
      1 + FLOOR(RAND()*2)
    );
    SET i = i + 1;
  END WHILE;

  -- 29. assists_executionState
  INSERT INTO assists_executionState (name)
    VALUES ('pendiente'), ('realizado'), ('error');

  -- 30. assists_intentType
  INSERT INTO assists_intentType (name, descripcion)
    VALUES ('ReproducirMúsica','Intención de reproducir música'),
           ('ObtenerClima','Intención de obtener el clima'),
           ('EnviarCorreo','Intención de enviar un correo');

  -- 31. assists_interaction_session
  SET i = 1;
  WHILE i <= 15 DO
    INSERT INTO assists_interaction_session (
      session_uuid, start_time, end_time, session_status, interaction_type,
      userid, dispositiveid
    )
    VALUES (
      UUID(),
      NOW(),
      NULL,
      'active',
      'audio',
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*10)
    );
    SET i = i + 1;
  END WHILE;

  -- 32. assists_voicecommand 
  -- 32a. Uso intensivo
  SET i = 1;
  WHILE i <= 100 DO
    SET j = 1;
    WHILE j <= 4 DO
      SET _isCorrect = IF(RAND() < 0.8, 1, 0);
      INSERT INTO assists_voicecommand 
        (originalText, processedText, datecommand, duration_ms, confidenceScore,
         dispositiveid, executionStateid, intentTypeid, sessionid, is_correct)
      VALUES (
        CONCAT('Texto original pesado para usuario ', i, ' comando ', j),
        CONCAT('Texto procesado pesado para usuario ', i, ' comando ', j),
        DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND()*365) DAY),
        FLOOR(RAND()*5000),
        RAND(),
        1 + FLOOR(RAND()*10),
        1 + FLOOR(RAND()*3),
        1 + FLOOR(RAND()*3),
        1 + FLOOR(RAND()*15),
        _isCorrect
      );
      SET _voiceCmdID = LAST_INSERT_ID();
      IF _isCorrect = 0 THEN
        INSERT INTO assists_user_feedback 
          (created_At, feedback_text, commandid, userid, error_typesid)
        VALUES (
		  DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND()*365) DAY),
		  CONCAT('Error en el comando ', _voiceCmdID, ': no se entendió correctamente'),
		  _voiceCmdID,
		  1 + FLOOR(RAND() * 30),
		  1 + FLOOR(RAND()*30)
		);
      END IF;
      SET j = j + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;

  -- 32b. Uso ligero
  SET i = 16;
  WHILE i <= 200 DO
    SET _isCorrect = IF(RAND() < 0.8, 1, 0);
    INSERT INTO assists_voicecommand 
      (originalText, processedText, datecommand, duration_ms, confidenceScore,
       dispositiveid, executionStateid, intentTypeid, sessionid, is_correct)
    VALUES (
      CONCAT('Texto original ligero para usuario ', i),
      CONCAT('Texto procesado ligero para usuario ', i),
      DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND()*365) DAY),
      FLOOR(RAND()*5000),
      RAND(),
      1 + FLOOR(RAND()*10),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*15),
      _isCorrect
    );
    SET _voiceCmdID = LAST_INSERT_ID();
    IF _isCorrect = 0 THEN
        INSERT INTO assists_user_feedback 
          (created_At, feedback_text, commandid, userid, error_typesid)
        VALUES (
		  DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND()*365) DAY),
		  CONCAT('Error en el comando ', _voiceCmdID ,': no se entendió correctamente'),
		  _voiceCmdID,
		  1 + FLOOR(RAND() * 30),
		  1 + FLOOR(RAND()*8)
		);
    END IF;
    SET i = i + 1;
  END WHILE;

  -- 33. assists_accionType
  INSERT INTO assists_accionType (name, descripcion)
    VALUES ('EnviarCorreo','Enviar un correo'),
           ('ReproducirMúsica','Reproducir música'),
           ('Alarma','Configurar una alarma');

  -- 34. assists_accion
  SET i = 1;
  WHILE i <= 20 DO
    INSERT INTO assists_accion 
      (dateAccion, estado, error_message, excecution_time_ms, commandid, accionTypeid)
    VALUES (
      NOW(),
      IF(RAND() < 0.5, 0, 1),
      IF(RAND() < 0.2, CONCAT('Detalle del error ', i), NULL),
      FLOOR(RAND()*1000),
      1 + FLOOR(RAND()* (CASE WHEN (SELECT COUNT(*) FROM assists_voicecommand) > 0 
                              THEN (SELECT COUNT(*) FROM assists_voicecommand)
                              ELSE 30 END)),
      1 + FLOOR(RAND()*3)
    );
    SET i = i + 1;
  END WHILE;

  -- 35. assists_providersAI
  SET i = 1;
  WHILE i <= 3 DO
    INSERT INTO assists_providersAI (name, description)
    VALUES (
      ELT(i, 'OpenAI','Google','Microsoft'),
      CONCAT('Descripción del proveedor de IA ', i)
    );
    SET i = i + 1;
  END WHILE;

  -- 36. assists_modeloAI
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_modeloAI (
      name, version, date_training, date_deployed, text_precision, model_type,
      configuration, isActive, providersAIid, assists_voicecommand_commandid
    )
    VALUES (
      CONCAT('Modelo ', i),
      CONCAT('v', i),
      NOW(),
      NOW(),
      RAND(),
      ELT(FLOOR(1 + RAND()*4), 'stt','nlu','intent','multi'),
      JSON_OBJECT('parametro', CONCAT('Valor ', i)),
      1,
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*30)
    );
    SET i = i + 1;
  END WHILE;

  -- 37. assists_modeloAI_voicecommand
	SET i = 0;
	WHILE i < 20 DO
	  SET @modeloAIid = 1 + FLOOR(RAND()*5);
	  SET @commandid = 1 + FLOOR(RAND()*30);
	  SELECT COUNT(*) INTO @cnt 
		FROM assists_modeloAI_voicecommand 
		WHERE modeloAIid = @modeloAIid AND commandid = @commandid;
	  IF @cnt = 0 THEN
		INSERT INTO assists_modeloAI_voicecommand (
		  modeloAIid, commandid, confidence, processing_time_ms, timestamp, raw_response
		)
		VALUES (
		  @modeloAIid,
		  @commandid,
		  RAND(),
		  FLOOR(RAND()*1000),
		  NOW(),
		  JSON_OBJECT('respuesta', CONCAT('Respuesta ', i+1))
		);
		SET i = i + 1;
	  END IF;
	END WHILE;

  -- 38. assists_MediaTypes
  INSERT INTO assists_MediaTypes (name)
    VALUES ('Imagen'), ('Video'), ('Audio');

  -- 39. assists_MediaFiles
  SET i = 1;
  WHILE i <= 20 DO
    INSERT INTO assists_MediaFiles (
      path, name, size, mime_type, md5_hash, is_deleted, created_at, updated_at, userid, mediatypeid,
      duration_seconds, sample_rate, channels, audio_format, transcription_status
    )
    VALUES (
      CONCAT('/ruta/archivo', i),
      CONCAT('Archivo ', i),
      FLOOR(RAND()*10000),
      'application/octet-stream',
      LPAD(FLOOR(RAND()*100000), 6, '0'),
      0,
      NOW(),
      NOW(),
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*3),
      FLOOR(RAND()*300),
      FLOOR(8000 + RAND()*4000),
      1 + FLOOR(RAND()*2),
      'mp3',
      FLOOR(RAND()*2)
    );
    SET i = i + 1;
  END WHILE;

  -- 40. assists_transactions
  SET i = 1;
  WHILE i <= 30 DO
    INSERT INTO assists_transactions (
      amount, description, transDatetime, postTime, refNumber, exchangeRate, checksum, userid, paymentid
    )
    VALUES (
      ROUND(RAND()*100+10,2),
      CONCAT('Descripción de transacción ', i),
      NOW(),
      NOW(),
      CONCAT('REFT-', i),
      ROUND(RAND()*5,2),
      '0xAA',
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*10)
    );
    SET i = i + 1;
  END WHILE;

  -- 41. assists_recurringpayments
  SET i = 1;
  WHILE i <= 5 DO
    SET recType = ELT(FLOOR(1 + RAND()*4), 'daily','weekly','monthly','yearly');
    SET nextDate = CASE 
                     WHEN recType = 'daily' THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*5)+1 DAY)
                     WHEN recType = 'weekly' THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*7)+7 DAY)
                     WHEN recType = 'monthly' THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*30)+30 DAY)
                     WHEN recType = 'yearly' THEN DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365)+365 DAY)
                     ELSE CURDATE()
                   END;
    INSERT INTO assists_recurringpayments (
      service, amount, recurrence, recurrenceday, nextPayment, isactive,
      last_payment_day, frecuency_interval, userid, accionid, currencyid,
      paymentMediaid, transactionid
    )
    VALUES (
      CONCAT('Servicio recurrente ', i),
      ROUND(RAND()*100 + 10,2),
      recType,
      FLOOR(1 + RAND()*28),
      nextDate,
      1,
      NULL,
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*20),
      1 + FLOOR(RAND()*2),
      1 + FLOOR(RAND()*5),
      1 + FLOOR(RAND()*5)
    );
    SET i = i + 1;
  END WHILE;

  -- 42. assists_paymentconfirmations
  INSERT INTO assists_paymentconfirmations (estado, paymentid)
    VALUES ('pending', 1), ('completed', 2), ('failed', 3);

  -- 43. assists_employees
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO assists_employees (
      position, hiring, updated_at, companyid, userid
    )
    VALUES (
      CONCAT('Puesto ', i),
      DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
      NOW(),
      1 + FLOOR(RAND()*5),
      1 + FLOOR(RAND()*30)
    );
    SET i = i + 1;
  END WHILE;

  -- 44. assists_employee_subscriptions
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO assists_employee_subscriptions (
      startdate, enddate, employeesid, subscriptionid
    )
    VALUES (
      CURDATE(),
      DATE_ADD(CURDATE(), INTERVAL 365 DAY),
      1 + FLOOR(RAND()*10),
      1 + FLOOR(RAND()*5)
    );
    SET i = i + 1;
  END WHILE;

  -- 45. assists_user_preferences
  SET i = 1;
  WHILE i <= 30 DO
    INSERT INTO assists_user_preferences (
      language_id, currencyid, userid
    )
    VALUES (
      1 + FLOOR(RAND()*2),
      1 + FLOOR(RAND()*2),
      i
    );
    SET i = i + 1;
  END WHILE;

  -- 46. assists_conversation_context
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO assists_conversation_context (
      start_time, last_updated, isActive, context_data, userid
    )
    VALUES (
      NOW(),
      NOW(),
      1,
      JSON_OBJECT('contexto', CONCAT('Contexto ', i)),
      1 + FLOOR(RAND()*30)
    );
    SET i = i + 1;
  END WHILE;

  -- 47. assists_entities
  SET i = 1;
  WHILE i <= 30 DO
    INSERT INTO assists_entities (
      type, value, metadata, confidence_score, commandid
    )
    VALUES (
      CONCAT('Tipo', 1 + FLOOR(RAND()*3)),
      CONCAT('Valor', i),
      JSON_OBJECT('info', CONCAT('Metadato ', i)),
      RAND(),
      1 + FLOOR(RAND()*30)
    );
    SET i = i + 1;
  END WHILE;

  -- 48. assists_user_feedback
  SET i = 1;
  WHILE i <= 40 DO
    INSERT INTO assists_user_feedback (
      created_At, feedback_text, commandid, userid, error_typesid
    )
    VALUES (
	  NOW(),
      CONCAT('Texto de retroalimentación ', i),
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*5)
    );
    
    SET i = i + 1;
  END WHILE;

  -- 49. assists_accionParameters
  INSERT IGNORE INTO assists_accionParameters (name, type, required)
    VALUES
      ('destinatarioCorreo','string',1),
      ('asuntoCorreo','string',1),
      ('volumen','number',0),
      ('horaAlarma','date',1),
      ('confirmacion','boolean',0);

  -- 50. assists_accionParametersValues
  SET i = 1;
  WHILE i <= 20 DO
	BEGIN
		DECLARE pIndex INT;
		DECLARE aIndex INT;
		SET pIndex = (i MOD 5) + 1;
		SET aIndex = (i MOD 20) + 1;
		INSERT IGNORE INTO assists_accionParametersValues (accionid, parametersid, value)
		VALUES (
		  aIndex,
		  pIndex,
		  CONCAT('Valor para la acción ', aIndex, ' parámetro ', pIndex)
		);
		SET i = i + 1;
    END;
  END WHILE;
  
  -- 51. Currency exchange
  INSERT INTO assists_currency_exchange (from_currencyid, to_currencyid, exchangeRate, effectiveDate)
VALUES 
    (1, 2, 530.50, '2024-01-01'),  -- Dólar a Colón
    (1, 2, 532.75, '2024-02-15'),
    (1, 2, 528.25, '2024-03-10');

END $$

DELIMITER ;