-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`assists_MediaTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_MediaTypes` (
  `mediatypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`mediatypeid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_companies` (
  `companyid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `fiscal_id` VARCHAR(45) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`companyid`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_countries` (
  `countryid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`countryid`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_users` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL,
  `isActive` TINYINT(1) NOT NULL,
  `voiceprofileid` VARCHAR(100) NULL DEFAULT NULL,
  `companyid` INT NULL DEFAULT NULL,
  `countryid` INT NOT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_assists_users_assists_companies1_idx` (`companyid` ASC) VISIBLE,
  INDEX `fk_assists_users_assists_countries1_idx` (`countryid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_users_assists_companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `mydb`.`assists_companies` (`companyid`),
  CONSTRAINT `fk_assists_users_assists_countries1`
    FOREIGN KEY (`countryid`)
    REFERENCES `mydb`.`assists_countries` (`countryid`))
ENGINE = InnoDB
AUTO_INCREMENT = 31
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_MediaFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_MediaFiles` (
  `mediaifileid` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(255) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `size` INT NULL DEFAULT NULL,
  `mime_type` VARCHAR(100) NULL DEFAULT NULL,
  `md5_hash` VARCHAR(32) NULL DEFAULT NULL,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `userid` INT NOT NULL,
  `mediatypeid` INT NOT NULL,
  `duration_seconds` FLOAT NULL DEFAULT NULL,
  `sample_rate` INT NULL DEFAULT NULL,
  `channels` TINYINT NULL DEFAULT NULL,
  `audio_format` VARCHAR(100) NULL DEFAULT NULL,
  `transcription_status` INT NULL DEFAULT NULL,
  PRIMARY KEY (`mediaifileid`),
  INDEX `fk_assists_MediaFiles_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_MediaFiles_assists_MediaTypes1_idx` (`mediatypeid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_MediaFiles_assists_MediaTypes1`
    FOREIGN KEY (`mediatypeid`)
    REFERENCES `mydb`.`assists_MediaTypes` (`mediatypeid`),
  CONSTRAINT `fk_assists_MediaFiles_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accionType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accionType` (
  `accionTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `handler_class` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`accionTypeid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_dispositiveType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_dispositiveType` (
  `dispositiveTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dispositiveTypeid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_dispositive`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_dispositive` (
  `dispositiveid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `activation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deviceIdentifier` VARCHAR(100) NULL DEFAULT NULL,
  `lastActive` DATETIME NULL DEFAULT NULL,
  `status` ENUM('active', 'inactive', 'maintenance') NULL DEFAULT 'active',
  `firmwareversion` VARCHAR(30) NULL DEFAULT NULL,
  `dispositiveTypeid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`dispositiveid`),
  INDEX `fk_assists_dispositive_assists_dispositiveType1_idx` (`dispositiveTypeid` ASC) VISIBLE,
  INDEX `fk_assists_dispositive_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_dispositive_assists_dispositiveType1`
    FOREIGN KEY (`dispositiveTypeid`)
    REFERENCES `mydb`.`assists_dispositiveType` (`dispositiveTypeid`),
  CONSTRAINT `fk_assists_dispositive_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_interaction_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_interaction_session` (
  `sessionid` INT NOT NULL AUTO_INCREMENT,
  `session_uuid` VARCHAR(36) NOT NULL,
  `start_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` DATETIME NULL DEFAULT NULL,
  `session_status` ENUM('active', 'completed', 'interrupted') NULL DEFAULT 'active',
  `interaction_type` ENUM('audio', 'text', 'video') NOT NULL DEFAULT 'audio',
  `userid` INT NOT NULL,
  `dispositiveid` INT NOT NULL,
  PRIMARY KEY (`sessionid`),
  INDEX `fk_assists_audio_session_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_audio_session_assists_dispositive1_idx` (`dispositiveid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_audio_session_assists_dispositive1`
    FOREIGN KEY (`dispositiveid`)
    REFERENCES `mydb`.`assists_dispositive` (`dispositiveid`),
  CONSTRAINT `fk_assists_audio_session_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_executionState`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_executionState` (
  `executionStateid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`executionStateid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_intentType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_intentType` (
  `intentTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`intentTypeid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_voicecommand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_voicecommand` (
  `commandid` INT NOT NULL AUTO_INCREMENT,
  `originalText` TEXT NOT NULL,
  `processedText` TEXT NULL DEFAULT NULL,
  `datecommand` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `duration_ms` INT NULL DEFAULT NULL,
  `confidenceScore` FLOAT NULL DEFAULT NULL,
  `is_correct` TINYINT(1) NOT NULL,
  `dispositiveid` INT NOT NULL,
  `executionStateid` INT NOT NULL,
  `intentTypeid` INT NOT NULL,
  `sessionid` INT NOT NULL,
  PRIMARY KEY (`commandid`),
  INDEX `fk_assists_voicecommand_assists_dispositive1_idx` (`dispositiveid` ASC) VISIBLE,
  INDEX `fk_assists_voicecommand_assists_executionState1_idx` (`executionStateid` ASC) VISIBLE,
  INDEX `fk_assists_voicecommand_assists_intentType1_idx` (`intentTypeid` ASC) VISIBLE,
  INDEX `fk_assists_voicecommand_assists_audio_session1_idx` (`sessionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_voicecommand_assists_audio_session1`
    FOREIGN KEY (`sessionid`)
    REFERENCES `mydb`.`assists_interaction_session` (`sessionid`),
  CONSTRAINT `fk_assists_voicecommand_assists_dispositive1`
    FOREIGN KEY (`dispositiveid`)
    REFERENCES `mydb`.`assists_dispositive` (`dispositiveid`),
  CONSTRAINT `fk_assists_voicecommand_assists_executionState1`
    FOREIGN KEY (`executionStateid`)
    REFERENCES `mydb`.`assists_executionState` (`executionStateid`),
  CONSTRAINT `fk_assists_voicecommand_assists_intentType1`
    FOREIGN KEY (`intentTypeid`)
    REFERENCES `mydb`.`assists_intentType` (`intentTypeid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accion` (
  `accionid` INT NOT NULL AUTO_INCREMENT,
  `dateAccion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` TINYINT(1) NOT NULL DEFAULT '0',
  `error_message` TEXT NULL DEFAULT NULL,
  `excecution_time_ms` INT NULL DEFAULT NULL,
  `commandid` INT NOT NULL,
  `accionTypeid` INT NOT NULL,
  PRIMARY KEY (`accionid`),
  INDEX `fk_assists_accion_assists_voicecommand1_idx` (`commandid` ASC) VISIBLE,
  INDEX `fk_assists_accion_assists_accionType1_idx` (`accionTypeid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_accion_assists_accionType1`
    FOREIGN KEY (`accionTypeid`)
    REFERENCES `mydb`.`assists_accionType` (`accionTypeid`),
  CONSTRAINT `fk_assists_accion_assists_voicecommand1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accionParameters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accionParameters` (
  `parametersid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `type` ENUM('string', 'number', 'date', 'boolean') NOT NULL,
  `required` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`parametersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accionParametersValues`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accionParametersValues` (
  `accionid` INT NOT NULL,
  `parametersid` INT NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`accionid`, `parametersid`),
  INDEX `fk_assists_accion_has_assists_accionParameters_assists_acci_idx` (`parametersid` ASC) VISIBLE,
  INDEX `fk_assists_accion_has_assists_accionParameters_assists_acci_idx1` (`accionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_accion_has_assists_accionParameters_assists_accion1`
    FOREIGN KEY (`accionid`)
    REFERENCES `mydb`.`assists_accion` (`accionid`),
  CONSTRAINT `fk_assists_accion_has_assists_accionParameters_assists_accion2`
    FOREIGN KEY (`parametersid`)
    REFERENCES `mydb`.`assists_accionParameters` (`parametersid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_ai_error_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_ai_error_types` (
  `error_typesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`error_typesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_subscriptions` (
  `subscriptionid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `logo_url` TEXT NULL DEFAULT NULL,
  `is_active` BIT(1) NULL DEFAULT b'1',
  PRIMARY KEY (`subscriptionid`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_company_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_company_subscriptions` (
  `company_subscriptionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NOT NULL,
  `enddate` DATE NOT NULL,
  `is_active` BIT(1) NOT NULL DEFAULT b'1',
  `subscriptionid` INT NOT NULL,
  `companyid` INT NOT NULL,
  PRIMARY KEY (`company_subscriptionid`),
  INDEX `fk_assists_company_subscriptions_assists_subscriptions1_idx` (`subscriptionid` ASC) VISIBLE,
  INDEX `fk_assists_company_subscriptions_assists_companies1_idx` (`companyid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_company_subscriptions_assists_companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `mydb`.`assists_companies` (`companyid`),
  CONSTRAINT `fk_assists_company_subscriptions_assists_subscriptions1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `mydb`.`assists_subscriptions` (`subscriptionid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_conversation_context`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_conversation_context` (
  `conversation_contextid` INT NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated` DATETIME NOT NULL,
  `isActive` TINYINT(1) NULL DEFAULT '1',
  `context_data` JSON NULL DEFAULT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`conversation_contextid`),
  INDEX `fk_assists_conversation_context_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_conversation_context_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_currency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_currency` (
  `currencyid` INT NOT NULL,
  `iso_code` CHAR(3) NOT NULL,
  `symbol` VARCHAR(5) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`currencyid`),
  UNIQUE INDEX `iso_code_UNIQUE` (`iso_code` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_currency_exchange`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_currency_exchange` (
  `exchangeid` INT NOT NULL AUTO_INCREMENT,
  `exchangeRate` DECIMAL(10,4) NOT NULL,
  `effectiveDate` DATE NOT NULL,
  `from_currencyid` INT NOT NULL,
  `to_currencyid` INT NOT NULL,
  PRIMARY KEY (`exchangeid`),
  INDEX `fk_assists_currency_exchange_assists_currency1_idx` (`from_currencyid` ASC) VISIBLE,
  INDEX `fk_assists_currency_exchange_assists_currency2_idx` (`to_currencyid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_currency_exchange_assists_currency1`
    FOREIGN KEY (`from_currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`),
  CONSTRAINT `fk_assists_currency_exchange_assists_currency2`
    FOREIGN KEY (`to_currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_employees` (
  `employeesid` INT NOT NULL AUTO_INCREMENT,
  `position` VARCHAR(100) NULL DEFAULT NULL,
  `hiring` DATE NOT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `companyid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`employeesid`),
  INDEX `fk_assists_employees_assists_companies1_idx` (`companyid` ASC) VISIBLE,
  INDEX `fk_assists_employees_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_employees_assists_companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `mydb`.`assists_companies` (`companyid`),
  CONSTRAINT `fk_assists_employees_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_employee_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_employee_subscriptions` (
  `employee_subscriptionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NOT NULL,
  `enddate` DATE NULL DEFAULT NULL,
  `employeesid` INT NOT NULL,
  `subscriptionid` INT NOT NULL,
  PRIMARY KEY (`employee_subscriptionid`),
  INDEX `fk_assists_employee_subscriptions_assists_employees1_idx` (`employeesid` ASC) VISIBLE,
  INDEX `fk_assists_employee_subscriptions_assists_company_subscript_idx` (`subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_employee_subscriptions_assists_company_subscriptio1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `mydb`.`assists_company_subscriptions` (`company_subscriptionid`),
  CONSTRAINT `fk_assists_employee_subscriptions_assists_employees1`
    FOREIGN KEY (`employeesid`)
    REFERENCES `mydb`.`assists_employees` (`employeesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_entities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_entities` (
  `entityid` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(50) NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `confidence_score` FLOAT NULL DEFAULT NULL,
  `commandid` INT NOT NULL,
  PRIMARY KEY (`entityid`),
  INDEX `fk_assists_entities_assists_voicecommand1_idx` (`commandid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_entities_assists_voicecommand1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_log_severity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_log_severity` (
  `log_severity_id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `severity_level` BIT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`log_severity_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_log_source`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_log_source` (
  `log_source_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `system_component` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`log_source_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_log_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_log_types` (
  `log_type_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`log_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_logs` (
  `log_id` INT NOT NULL,
  `log_type_id` INT NOT NULL,
  `log_source_id` INT NOT NULL,
  `log_severity_id` INT NOT NULL,
  `dispositiveid` INT NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `post_time` DATETIME NOT NULL,
  `computer` VARCHAR(100) NULL DEFAULT NULL,
  `username` VARCHAR(100) NULL DEFAULT NULL,
  `trace` TEXT NULL DEFAULT NULL,
  `reference_id1` BIGINT NULL DEFAULT NULL,
  `reference_id2` BIGINT NULL DEFAULT NULL,
  `value1` VARCHAR(180) NULL DEFAULT NULL,
  `value2` VARCHAR(180) NULL DEFAULT NULL,
  `checksum` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`log_id`, `dispositiveid`),
  INDEX `fk_logs_log_types1_idx` (`log_type_id` ASC) VISIBLE,
  INDEX `fk_logs_log_source1_idx` (`log_source_id` ASC) VISIBLE,
  INDEX `fk_logs_log_severity1_idx` (`log_severity_id` ASC) VISIBLE,
  INDEX `fk_logs_assists_dispositive1_idx` (`dispositiveid` ASC) VISIBLE,
  CONSTRAINT `fk_logs_assists_dispositive1`
    FOREIGN KEY (`dispositiveid`)
    REFERENCES `mydb`.`assists_dispositive` (`dispositiveid`),
  CONSTRAINT `fk_logs_log_severity1`
    FOREIGN KEY (`log_severity_id`)
    REFERENCES `mydb`.`assists_log_severity` (`log_severity_id`),
  CONSTRAINT `fk_logs_log_source1`
    FOREIGN KEY (`log_source_id`)
    REFERENCES `mydb`.`assists_log_source` (`log_source_id`),
  CONSTRAINT `fk_logs_log_types1`
    FOREIGN KEY (`log_type_id`)
    REFERENCES `mydb`.`assists_log_types` (`log_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_providersAI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_providersAI` (
  `providersAIid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`providersAIid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_modeloAI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_modeloAI` (
  `modeloAIid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `version` VARCHAR(10) NOT NULL,
  `date_training` DATETIME NOT NULL,
  `date_deployed` DATETIME NOT NULL,
  `text_precision` FLOAT NOT NULL,
  `model_type` ENUM('stt', 'nlu', 'intent', 'multi') NOT NULL,
  `configuration` JSON NULL DEFAULT NULL,
  `isActive` TINYINT(1) NULL DEFAULT '1',
  `providersAIid` INT NOT NULL,
  `assists_voicecommand_commandid` INT NOT NULL,
  PRIMARY KEY (`modeloAIid`),
  INDEX `fk_assists_modeloAI_assists_providersAI1_idx` (`providersAIid` ASC) VISIBLE,
  INDEX `fk_assists_modeloAI_assists_voicecommand1_idx` (`assists_voicecommand_commandid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_modeloAI_assists_providersAI1`
    FOREIGN KEY (`providersAIid`)
    REFERENCES `mydb`.`assists_providersAI` (`providersAIid`),
  CONSTRAINT `fk_assists_modeloAI_assists_voicecommand1`
    FOREIGN KEY (`assists_voicecommand_commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_modeloAI_voicecommand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_modeloAI_voicecommand` (
  `modeloAIid` INT NOT NULL,
  `commandid` INT NOT NULL,
  `confidence` FLOAT NOT NULL,
  `processing_time_ms` INT NULL DEFAULT NULL,
  `timestamp` DATETIME NOT NULL,
  `raw_response` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`modeloAIid`, `commandid`),
  INDEX `fk_assists_modeloAI_has_assists_voicecommand_assists_voicec_idx` (`commandid` ASC) VISIBLE,
  INDEX `fk_assists_modeloAI_has_assists_voicecommand_assists_modelo_idx` (`modeloAIid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_modeloAI_has_assists_voicecommand_assists_modeloAI1`
    FOREIGN KEY (`modeloAIid`)
    REFERENCES `mydb`.`assists_modeloAI` (`modeloAIid`),
  CONSTRAINT `fk_assists_modeloAI_has_assists_voicecommand_assists_voicecom1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_modules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_modules` (
  `moduleid` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`moduleid`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_paymentMethods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_paymentMethods` (
  `paymentMethodid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `apiURL` VARCHAR(255) NULL DEFAULT NULL,
  `secretKey` VARCHAR(255) NULL DEFAULT NULL,
  `key` VARCHAR(255) NULL DEFAULT NULL,
  `logoIconURL` VARCHAR(255) NULL DEFAULT NULL,
  `enabled` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`paymentMethodid`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_paymentMedia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_paymentMedia` (
  `paymentMediaid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `token` VARCHAR(255) NULL DEFAULT NULL,
  `expTokenDate` DATE NULL DEFAULT NULL,
  `maskAccount` VARCHAR(100) NULL DEFAULT NULL,
  `userid` INT NOT NULL,
  `paymentMethodid` INT NOT NULL,
  PRIMARY KEY (`paymentMediaid`),
  INDEX `fk_assists_paymentMedia_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_paymentMedia_assists_paymentMethods1_idx` (`paymentMethodid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_paymentMedia_assists_paymentMethods1`
    FOREIGN KEY (`paymentMethodid`)
    REFERENCES `mydb`.`assists_paymentMethods` (`paymentMethodid`),
  CONSTRAINT `fk_assists_paymentMedia_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_payments` (
  `paymentid` BIGINT NOT NULL AUTO_INCREMENT,
  `monto` DECIMAL(10,2) NOT NULL,
  `actualMonto` DECIMAL(10,2) NULL DEFAULT NULL,
  `result` ENUM('success', 'failed', 'pending') NOT NULL,
  `auth` VARCHAR(255) NULL DEFAULT NULL,
  `reference` VARCHAR(255) NULL DEFAULT NULL,
  `changeToken` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `error` TEXT NULL DEFAULT NULL,
  `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `checksum` VARBINARY(250) NULL DEFAULT NULL,
  `currencyid` INT NOT NULL,
  `userid` INT NOT NULL,
  `moduleid` TINYINT NOT NULL,
  `paymentMediaid` INT NOT NULL,
  PRIMARY KEY (`paymentid`),
  INDEX `fk_assists_payments_assists_currency1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_assists_payments_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_payments_assists_modules1_idx` (`moduleid` ASC) VISIBLE,
  INDEX `fk_assists_payments_assists_paymentMedia1_idx` (`paymentMediaid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_payments_assists_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`),
  CONSTRAINT `fk_assists_payments_assists_modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `mydb`.`assists_modules` (`moduleid`),
  CONSTRAINT `fk_assists_payments_assists_paymentMedia1`
    FOREIGN KEY (`paymentMediaid`)
    REFERENCES `mydb`.`assists_paymentMedia` (`paymentMediaid`),
  CONSTRAINT `fk_assists_payments_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_paymentconfirmations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_paymentconfirmations` (
  `confirmationid` INT NOT NULL AUTO_INCREMENT,
  `confirmation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('pending', 'completed', 'failed') NULL DEFAULT NULL,
  `paymentid` BIGINT NOT NULL,
  PRIMARY KEY (`confirmationid`),
  INDEX `fk_assists_paymentconfirmations_assists_payments1_idx` (`paymentid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_paymentconfirmations_assists_payments1`
    FOREIGN KEY (`paymentid`)
    REFERENCES `mydb`.`assists_payments` (`paymentid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_permissions` (
  `permissionid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `moduleid` TINYINT NOT NULL,
  PRIMARY KEY (`permissionid`),
  INDEX `fk_assists_permissions_assists_modules1_idx` (`moduleid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_permissions_assists_modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `mydb`.`assists_modules` (`moduleid`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_transactions` (
  `transactionid` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(10,2) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `transDatetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `postTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `refNumber` VARCHAR(255) NULL DEFAULT NULL,
  `exchangeRate` DECIMAL(10,2) NULL DEFAULT NULL,
  `checksum` VARBINARY(250) NULL DEFAULT NULL,
  `userid` INT NOT NULL,
  `paymentid` BIGINT NOT NULL,
  PRIMARY KEY (`transactionid`),
  INDEX `fk_assists_transactions_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_transactions_assists_payments1_idx` (`paymentid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_transactions_assists_payments1`
    FOREIGN KEY (`paymentid`)
    REFERENCES `mydb`.`assists_payments` (`paymentid`),
  CONSTRAINT `fk_assists_transactions_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_recurringpayments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_recurringpayments` (
  `recurringpaymentid` INT NOT NULL AUTO_INCREMENT,
  `service` VARCHAR(100) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `recurrence` ENUM('daily', 'weekly', 'monthly', 'yearly') NOT NULL,
  `recurrenceday` INT NOT NULL,
  `nextPayment` DATETIME NOT NULL,
  `isactive` BIT(1) NULL DEFAULT b'1',
  `last_payment_day` DATE NULL DEFAULT NULL,
  `frecuency_interval` INT NULL DEFAULT NULL,
  `userid` INT NOT NULL,
  `accionid` INT NOT NULL,
  `currencyid` INT NOT NULL,
  `transactionid` BIGINT NOT NULL,
  `paymentMediaid` INT NOT NULL,
  PRIMARY KEY (`recurringpaymentid`),
  INDEX `fk_assists_recurringpayments_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_assists_accion1_idx` (`accionid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_currency1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_assists_transactions1_idx` (`transactionid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_assists_paymentMedia1_idx` (`paymentMediaid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_recurringpayments_assists_accion1`
    FOREIGN KEY (`accionid`)
    REFERENCES `mydb`.`assists_accion` (`accionid`),
  CONSTRAINT `fk_assists_recurringpayments_assists_paymentMedia1`
    FOREIGN KEY (`paymentMediaid`)
    REFERENCES `mydb`.`assists_paymentMedia` (`paymentMediaid`),
  CONSTRAINT `fk_assists_recurringpayments_assists_transactions1`
    FOREIGN KEY (`transactionid`)
    REFERENCES `mydb`.`assists_transactions` (`transactionid`),
  CONSTRAINT `fk_assists_recurringpayments_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`),
  CONSTRAINT `fk_assists_recurringpayments_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_roles` (
  `roleid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` TEXT NOT NULL,
  PRIMARY KEY (`roleid`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_rolespermission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_rolespermission` (
  `rolepermissionid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  `roleid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `lastupdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `cheksum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`permissionid`, `roleid`, `rolepermissionid`),
  INDEX `fk_assists_permissions_has_assists_roles_assists_roles1_idx` (`roleid` ASC) VISIBLE,
  INDEX `fk_assists_permissions_has_assists_roles_assists_permission_idx` (`permissionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_permissions_has_assists_roles_assists_permissions1`
    FOREIGN KEY (`permissionid`)
    REFERENCES `mydb`.`assists_permissions` (`permissionid`),
  CONSTRAINT `fk_assists_permissions_has_assists_roles_assists_roles1`
    FOREIGN KEY (`roleid`)
    REFERENCES `mydb`.`assists_roles` (`roleid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assits_subscriptionfeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assits_subscriptionfeatures` (
  `featureid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `datatype` ENUM('int', 'string', 'boolean') NOT NULL,
  `is_active` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`featureid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_subscriptionlimits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_subscriptionlimits` (
  `company_limitid` INT NOT NULL AUTO_INCREMENT,
  `limitvalue` VARCHAR(100) NOT NULL,
  `time_period` ENUM('day', 'week', 'month', 'year') NOT NULL,
  `featureid` INT NOT NULL,
  `company_subscriptionid` INT NOT NULL,
  PRIMARY KEY (`company_limitid`),
  INDEX `plan_feature_id_idx` (`featureid` ASC) VISIBLE,
  INDEX `fk_assists_subscriptionlimits_assists_company_subscriptions_idx` (`company_subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_subscriptionlimits_assists_company_subscriptions1`
    FOREIGN KEY (`company_subscriptionid`)
    REFERENCES `mydb`.`assists_company_subscriptions` (`company_subscriptionid`),
  CONSTRAINT `plan_feature_id`
    FOREIGN KEY (`featureid`)
    REFERENCES `mydb`.`assits_subscriptionfeatures` (`featureid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_subscriptionprices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_subscriptionprices` (
  `priceid` INT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(10,2) NOT NULL,
  `recurrency_type` ENUM('monthly', 'yearly') NOT NULL,
  `startdate` DATE NULL DEFAULT NULL,
  `enddate` DATE NULL DEFAULT NULL,
  `is_current` BIT(1) NOT NULL DEFAULT b'1',
  `currencyid` INT NOT NULL,
  `subscriptionid` INT NOT NULL,
  PRIMARY KEY (`priceid`),
  INDEX `fk_assists_subscriptionprices_assists_currency1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_assists_subscriptionprices_assists_subscriptions1_idx` (`subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_subscriptionprices_assists_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`),
  CONSTRAINT `fk_assists_subscriptionprices_assists_subscriptions1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `mydb`.`assists_subscriptions` (`subscriptionid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_userSubscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_userSubscriptions` (
  `usersubcriptionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NOT NULL,
  `enddate` DATE NULL DEFAULT NULL,
  `next_payment` DATE NULL DEFAULT NULL,
  `is_active` BIT(1) NULL DEFAULT b'1',
  `userid` INT NOT NULL,
  `priceid` INT NOT NULL,
  PRIMARY KEY (`usersubcriptionid`),
  INDEX `fk_assists_userSubscriptions_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_userSubscriptions_assists_subscriptionprices1_idx` (`priceid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_userSubscriptions_assists_subscriptionprices1`
    FOREIGN KEY (`priceid`)
    REFERENCES `mydb`.`assists_subscriptionprices` (`priceid`),
  CONSTRAINT `fk_assists_userSubscriptions_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_user_feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_user_feedback` (
  `user_feedbackid` INT NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `feedback_text` TEXT NULL DEFAULT NULL,
  `commandid` INT NOT NULL,
  `userid` INT NOT NULL,
  `error_typesid` INT NOT NULL,
  PRIMARY KEY (`user_feedbackid`),
  INDEX `fk_assists_user_feedback_assists_voicecommand1_idx` (`commandid` ASC) VISIBLE,
  INDEX `fk_assists_user_feedback_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_user_feedback_assists_ai_error_types1_idx` (`error_typesid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_user_feedback_assists_ai_error_types1`
    FOREIGN KEY (`error_typesid`)
    REFERENCES `mydb`.`assists_ai_error_types` (`error_typesid`),
  CONSTRAINT `fk_assists_user_feedback_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`),
  CONSTRAINT `fk_assists_user_feedback_assists_voicecommand1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`languages` (
  `language_id` TINYINT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `iso_code` CHAR(3) NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE INDEX `iso_code_UNIQUE` (`iso_code` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_user_preferences`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_user_preferences` (
  `user_preferencesid` INT NOT NULL AUTO_INCREMENT,
  `language_id` TINYINT NOT NULL,
  `currencyid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`user_preferencesid`),
  INDEX `fk_assists_user_preferences_languages1_idx` (`language_id` ASC) VISIBLE,
  INDEX `fk_assists_user_preferences_assists_currency1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_assists_user_preferences_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_user_preferences_assists_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`),
  CONSTRAINT `fk_assists_user_preferences_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`),
  CONSTRAINT `fk_assists_user_preferences_languages1`
    FOREIGN KEY (`language_id`)
    REFERENCES `mydb`.`languages` (`language_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_userspermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_userspermissions` (
  `rolepermissionid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL,
  `lastupdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`rolepermissionid`, `userid`, `permissionid`),
  INDEX `fk_assists_users_has_assists_permissions_assists_permission_idx` (`permissionid` ASC) VISIBLE,
  INDEX `fk_assists_users_has_assists_permissions_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_users_has_assists_permissions_assists_permissions1`
    FOREIGN KEY (`permissionid`)
    REFERENCES `mydb`.`assists_permissions` (`permissionid`),
  CONSTRAINT `fk_assists_users_has_assists_permissions_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`assists_usersroles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_usersroles` (
  `roleid` INT NOT NULL,
  `userid` INT NOT NULL,
  `lastupdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT b'1',
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`roleid`, `userid`),
  INDEX `fk_assist_roles_has_assist_users_assist_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assist_roles_has_assist_users_assist_roles_idx` (`roleid` ASC) VISIBLE,
  CONSTRAINT `fk_assist_roles_has_assist_users_assist_roles`
    FOREIGN KEY (`roleid`)
    REFERENCES `mydb`.`assists_roles` (`roleid`),
  CONSTRAINT `fk_assist_roles_has_assist_users_assist_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`schedules` (
  `scheduleid` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `recurrency_type` ENUM('daily', 'weekly', 'monthly', 'yearly') NOT NULL,
  `recurrencyday` INT NULL DEFAULT NULL,
  `nextexcecution` DATE NOT NULL,
  `is_active` BIT(1) NULL DEFAULT b'1',
  `usersubcriptionid` INT NOT NULL,
  PRIMARY KEY (`scheduleid`),
  INDEX `fk_schedules_assists_userSubscriptions1_idx` (`usersubcriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_schedules_assists_userSubscriptions1`
    FOREIGN KEY (`usersubcriptionid`)
    REFERENCES `mydb`.`assists_userSubscriptions` (`usersubcriptionid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`translations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`translations` (
  `translation_id` INT NOT NULL,
  `key` VARCHAR(100) NOT NULL,
  `value` TEXT NOT NULL,
  `language_id` TINYINT NOT NULL,
  PRIMARY KEY (`translation_id`),
  INDEX `fk_translations_languages1_idx` (`language_id` ASC) VISIBLE,
  CONSTRAINT `fk_translations_languages1`
    FOREIGN KEY (`language_id`)
    REFERENCES `mydb`.`languages` (`language_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure sp_populate_all
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_populate_all`()
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
  WHILE i <= 10 DO
    INSERT INTO assists_payments (
      monto, actualMonto, result, auth, reference, changeToken, description,
      error, fecha, checksum, userid, moduleid, paymentMediaid, currencyid
    )
    VALUES (
      ROUND(RAND()*100+10, 2),
      NULL,
      ELT(FLOOR(1+RAND()*3), 'success','failed','pending'),
      CONCAT('AUT-', i),
      CONCAT('REF-', i),
      CONCAT('CHGT-', i),
      CONCAT('Descripción del pago ', i),
      IF(RAND()<0.2, CONCAT('Detalle del error #', i), NULL),
      NOW(),
      '0xFF',
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*5),
      1 + FLOOR(RAND()*2)
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
      ELT(FLOOR(1 + RAND()*2), 'monthly','yearly'),
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

  -- 17. assists_userSubscriptions
  SET i = 1;
  WHILE i <= 10 DO
    -- Calculamos next_payment basándonos en la fecha de inicio (startdate) y el tipo de recurrency del precio (tomamos el enddate del precio como ejemplo)
    INSERT INTO assists_userSubscriptions (startdate, enddate, is_active, userid, priceid)
    VALUES (
      CURDATE(),
      DATE_ADD(CURDATE(), INTERVAL 30 DAY),
      1,
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*5)
    );
    SET i = i + 1;
  END WHILE;

  -- 18. schedules
  SET i = 1;
  WHILE i <= 10 DO
    INSERT INTO schedules (name, recurrency_type, recurrenceday, nextexcecution, is_active, usersubcriptionid)
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
  WHILE i <= 10 DO
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
  WHILE i <= 30 DO
    INSERT INTO assists_logs (
      log_id, log_type_id, log_source_id, log_severity_id, dispositiveid,
      description, post_time, computer, username, trace, value1, value2, checksum
    )
    VALUES (
      i,
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*10),
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
  WHILE i <= 10 DO
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
  WHILE i <= 15 DO
    SET j = 1;
    WHILE j <= 4 DO
      SET _isCorrect = IF(RAND() < 0.8, 1, 0);
      INSERT INTO assists_voicecommand 
        (originalText, processedText, datecommand, duration_ms, confidenceScore,
         dispositiveid, executionStateid, intentTypeid, sessionid, is_correct)
      VALUES (
        CONCAT('Texto original pesado para usuario ', i, ' comando ', j),
        CONCAT('Texto procesado pesado para usuario ', i, ' comando ', j),
        NOW(),
        FLOOR(RAND()*5000),
        RAND(),
        1 + FLOOR(RAND()*10),
        1 + FLOOR(RAND()*3),
        1 + FLOOR(RAND()*3),
        i,  -- se usa i como sessionid (simplificación)
        _isCorrect
      );
      SET _voiceCmdID = LAST_INSERT_ID();
      IF _isCorrect = 0 THEN
        INSERT INTO assists_user_feedback 
          (rating, feedback_text, is_correct, expected_result, created_at, additional_info, commandid, userid)
        VALUES (
          1 + FLOOR(RAND()*5),
          CONCAT('Error en el comando ', _voiceCmdID, ': no se entendió correctamente'),
          0,
          'El sistema no procesó el comando como se esperaba',
          NOW(),
          'Feedback autogenerado',
          _voiceCmdID,
          i
        );
      END IF;
      SET j = j + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;

  -- 32b. Uso ligero
  SET i = 16;
  WHILE i <= 30 DO
    SET _isCorrect = IF(RAND() < 0.8, 1, 0);
    INSERT INTO assists_voicecommand 
      (originalText, processedText, datecommand, duration_ms, confidenceScore,
       dispositiveid, executionStateid, intentTypeid, sessionid, is_correct)
    VALUES (
      CONCAT('Texto original ligero para usuario ', i),
      CONCAT('Texto procesado ligero para usuario ', i),
      NOW(),
      FLOOR(RAND()*5000),
      RAND(),
      1 + FLOOR(RAND()*10),
      1 + FLOOR(RAND()*3),
      1 + FLOOR(RAND()*3),
      i,
      _isCorrect
    );
    SET _voiceCmdID = LAST_INSERT_ID();
    IF _isCorrect = 0 THEN
      INSERT INTO assists_user_feedback 
        (rating, feedback_text, is_correct, expected_result, created_at, additional_info, commandid, userid)
      VALUES (
        1 + FLOOR(RAND()*5),
        CONCAT('Error en el comando ', _voiceCmdID, ': no se entendió correctamente'),
        0,
        'El sistema no procesó el comando como se esperaba',
        NOW(),
        'Feedback autogenerado',
        _voiceCmdID,
        i
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
  SET i = 1;
  WHILE i <= 20 DO
    INSERT INTO assists_modeloAI_voicecommand (
      modeloAIid, commandid, confidence, processing_time_ms, timestamp, raw_response
    )
    VALUES (
      1 + FLOOR(RAND()*5),
      1 + FLOOR(RAND()*30),
      RAND(),
      FLOOR(RAND()*1000),
      NOW(),
      JSON_OBJECT('respuesta', CONCAT('Respuesta ', i))
    );
    SET i = i + 1;
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
    VALUES ('pendiente', 1), ('completado', 2), ('fallido', 3);

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
      rating, feedback_text, is_correct, expected_result, created_at, additional_info, commandid, userid
    )
    VALUES (
      1 + FLOOR(RAND()*5),
      CONCAT('Texto de retroalimentación ', i),
      IF(RAND() < 0.8, 0, 1),
      CONCAT('Resultado esperado ', i),
      NOW(),
      CONCAT('Información adicional ', i),
      1 + FLOOR(RAND()*30),
      1 + FLOOR(RAND()*30)
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

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
