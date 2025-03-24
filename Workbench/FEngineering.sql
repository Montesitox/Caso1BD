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
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`assists_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_roles` (
  `roleid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` TEXT NOT NULL,
  PRIMARY KEY (`roleid`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_companies` (
  `companyid` INT NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `fiscal_id` VARCHAR(45) NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`companyid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_countries` (
  `countryid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`countryid`))
ENGINE = InnoDB;


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
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL,
  `isActive` TINYINT(1) NOT NULL,
  `voiceprofileid` VARCHAR(100) NULL,
  `companyid` INT NULL,
  `countryid` INT NOT NULL,
  PRIMARY KEY (`userid`),
  INDEX `fk_assists_users_assists_companies1_idx` (`companyid` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_assists_users_assists_countries1_idx` (`countryid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_users_assists_companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `mydb`.`assists_companies` (`companyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_users_assists_countries1`
    FOREIGN KEY (`countryid`)
    REFERENCES `mydb`.`assists_countries` (`countryid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_usersroles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_usersroles` (
  `roleid` INT NOT NULL,
  `userid` INT NOT NULL,
  `lastupdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`roleid`, `userid`),
  INDEX `fk_assist_roles_has_assist_users_assist_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assist_roles_has_assist_users_assist_roles_idx` (`roleid` ASC) VISIBLE,
  CONSTRAINT `fk_assist_roles_has_assist_users_assist_roles`
    FOREIGN KEY (`roleid`)
    REFERENCES `mydb`.`assists_roles` (`roleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assist_roles_has_assist_users_assist_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_modules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_modules` (
  `moduleid` TINYINT(8) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`moduleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_permissions` (
  `permissionid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `moduleid` TINYINT(8) NOT NULL,
  PRIMARY KEY (`permissionid`),
  INDEX `fk_assists_permissions_assists_modules1_idx` (`moduleid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_permissions_assists_modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `mydb`.`assists_modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_rolespermission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_rolespermission` (
  `rolepermissionid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  `roleid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `lastupdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `cheksum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`permissionid`, `roleid`, `rolepermissionid`),
  INDEX `fk_assists_permissions_has_assists_roles_assists_roles1_idx` (`roleid` ASC) VISIBLE,
  INDEX `fk_assists_permissions_has_assists_roles_assists_permission_idx` (`permissionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_permissions_has_assists_roles_assists_permissions1`
    FOREIGN KEY (`permissionid`)
    REFERENCES `mydb`.`assists_permissions` (`permissionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_permissions_has_assists_roles_assists_roles1`
    FOREIGN KEY (`roleid`)
    REFERENCES `mydb`.`assists_roles` (`roleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_userspermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_userspermissions` (
  `rolepermissionid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL,
  `lastupdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`rolepermissionid`, `userid`, `permissionid`),
  INDEX `fk_assists_users_has_assists_permissions_assists_permission_idx` (`permissionid` ASC) VISIBLE,
  INDEX `fk_assists_users_has_assists_permissions_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_users_has_assists_permissions_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_users_has_assists_permissions_assists_permissions1`
    FOREIGN KEY (`permissionid`)
    REFERENCES `mydb`.`assists_permissions` (`permissionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`languages` (
  `language_id` TINYINT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `iso_code` CHAR(3) NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE INDEX `iso_code_UNIQUE` (`iso_code` ASC) VISIBLE)
ENGINE = InnoDB;


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
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_paymentMethods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_paymentMethods` (
  `paymentMethodid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `apiURL` VARCHAR(255) NULL,
  `secretKey` VARCHAR(255) NULL,
  `key` VARCHAR(255) NULL,
  `logoIconURL` VARCHAR(255) NULL,
  `enabled` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`paymentMethodid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_paymentMedia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_paymentMedia` (
  `paymentMediaid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `token` VARCHAR(255) NULL,
  `expTokenDate` DATE NULL,
  `maskAccount` VARCHAR(100) NULL,
  `paymentMethodid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`paymentMediaid`, `paymentMethodid`, `userid`),
  INDEX `fk_assists_paymentMedia_assists_paymentMethods1_idx` (`paymentMethodid` ASC) VISIBLE,
  INDEX `fk_assists_paymentMedia_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_paymentMedia_assists_paymentMethods1`
    FOREIGN KEY (`paymentMethodid`)
    REFERENCES `mydb`.`assists_paymentMethods` (`paymentMethodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_paymentMedia_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_payments` (
  `paymentid` BIGINT NOT NULL AUTO_INCREMENT,
  `monto` DECIMAL(10,2) NOT NULL,
  `actualMonto` DECIMAL(10,2) NULL,
  `result` ENUM('success', 'failed', 'pending') NOT NULL,
  `auth` VARCHAR(255) NULL,
  `reference` VARCHAR(255) NULL,
  `changeToken` VARCHAR(255) NULL,
  `description` VARCHAR(255) NULL,
  `error` TEXT NULL,
  `fecha` DATETIME NOT NULL DEFAULT NOW(),
  `checksum` VARBINARY(250) NULL,
  `userid` INT NOT NULL,
  `moduleid` TINYINT(8) NOT NULL,
  `paymentMediaid` INT NOT NULL,
  `paymentMethodid` INT NOT NULL,
  `currencyid` INT NOT NULL,
  PRIMARY KEY (`paymentid`, `userid`, `moduleid`),
  INDEX `fk_assists_payments_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_payments_assists_modules1_idx` (`moduleid` ASC) VISIBLE,
  INDEX `fk_assists_payments_assists_paymentMedia1_idx` (`paymentMediaid` ASC, `paymentMethodid` ASC) VISIBLE,
  INDEX `fk_assists_payments_assists_currency1_idx` (`currencyid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_payments_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_payments_assists_modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `mydb`.`assists_modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_payments_assists_paymentMedia1`
    FOREIGN KEY (`paymentMediaid` , `paymentMethodid`)
    REFERENCES `mydb`.`assists_paymentMedia` (`paymentMediaid` , `paymentMethodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_payments_assists_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_subscriptions` (
  `subscriptionid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `logo_url` TEXT NULL,
  `is_active` BIT NULL DEFAULT 1,
  PRIMARY KEY (`subscriptionid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_subscriptionprices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_subscriptionprices` (
  `priceid` INT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `recurrency_type` ENUM('monthly', 'yearly') NOT NULL,
  `startdate` DATE NULL,
  `enddate` DATE NULL,
  `is_current` BIT NOT NULL DEFAULT 1,
  `currencyid` INT NOT NULL,
  `subscriptionid` INT NOT NULL,
  PRIMARY KEY (`priceid`),
  INDEX `fk_assists_subscriptionprices_assists_currency1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_assists_subscriptionprices_assists_subscriptions1_idx` (`subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_subscriptionprices_assists_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_subscriptionprices_assists_subscriptions1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `mydb`.`assists_subscriptions` (`subscriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_userSubscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_userSubscriptions` (
  `usersubcriptionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NOT NULL,
  `enddate` DATE NULL,
  `is_active` BIT NULL DEFAULT 1,
  `userid` INT NOT NULL,
  `priceid` INT NOT NULL,
  PRIMARY KEY (`usersubcriptionid`),
  INDEX `fk_assists_userSubscriptions_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_userSubscriptions_assists_subscriptionprices1_idx` (`priceid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_userSubscriptions_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_userSubscriptions_assists_subscriptionprices1`
    FOREIGN KEY (`priceid`)
    REFERENCES `mydb`.`assists_subscriptionprices` (`priceid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`schedules` (
  `scheduleid` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `recurrency_type` ENUM('daily', 'weekly', 'monthly', 'yearly') NOT NULL,
  `recurrencyday` INT NULL,
  `nextexcecution` DATE NOT NULL,
  `is_active` BIT NULL DEFAULT 1,
  `usersubcriptionid` INT NOT NULL,
  PRIMARY KEY (`scheduleid`),
  INDEX `fk_schedules_assists_userSubscriptions1_idx` (`usersubcriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_schedules_assists_userSubscriptions1`
    FOREIGN KEY (`usersubcriptionid`)
    REFERENCES `mydb`.`assists_userSubscriptions` (`usersubcriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assits_subscriptionfeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assits_subscriptionfeatures` (
  `featureid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `datatype` ENUM('int', 'string', 'boolean') NOT NULL,
  `is_active` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`featureid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_company_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_company_subscriptions` (
  `company_subscriptionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NOT NULL,
  `enddate` DATE NOT NULL,
  `is_active` BIT NOT NULL DEFAULT 1,
  `subscriptionid` INT NOT NULL,
  `companyid` INT NOT NULL,
  PRIMARY KEY (`company_subscriptionid`),
  INDEX `fk_assists_company_subscriptions_assists_subscriptions1_idx` (`subscriptionid` ASC) VISIBLE,
  INDEX `fk_assists_company_subscriptions_assists_companies1_idx` (`companyid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_company_subscriptions_assists_subscriptions1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `mydb`.`assists_subscriptions` (`subscriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_company_subscriptions_assists_companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `mydb`.`assists_companies` (`companyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


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
  CONSTRAINT `plan_feature_id`
    FOREIGN KEY (`featureid`)
    REFERENCES `mydb`.`assits_subscriptionfeatures` (`featureid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_subscriptionlimits_assists_company_subscriptions1`
    FOREIGN KEY (`company_subscriptionid`)
    REFERENCES `mydb`.`assists_company_subscriptions` (`company_subscriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_log_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_log_types` (
  `log_type_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`log_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_log_source`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_log_source` (
  `log_source_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `system_component` VARCHAR(100) NULL,
  PRIMARY KEY (`log_source_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_log_severity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_log_severity` (
  `log_severity_id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `severity_level` BIT NULL,
  PRIMARY KEY (`log_severity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_dispositiveType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_dispositiveType` (
  `dispositiveTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dispositiveTypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_dispositive`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_dispositive` (
  `dispositiveid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `activation` DATETIME NOT NULL DEFAULT NOW(),
  `deviceIdentifier` VARCHAR(100) NULL,
  `lastActive` DATETIME NULL,
  `status` ENUM('active', 'inactive', 'maintenance') NULL DEFAULT 'active',
  `firmwareversion` VARCHAR(30) NULL,
  `dispositiveTypeid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`dispositiveid`),
  INDEX `fk_assists_dispositive_assists_dispositiveType1_idx` (`dispositiveTypeid` ASC) VISIBLE,
  INDEX `fk_assists_dispositive_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_dispositive_assists_dispositiveType1`
    FOREIGN KEY (`dispositiveTypeid`)
    REFERENCES `mydb`.`assists_dispositiveType` (`dispositiveTypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_dispositive_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_logs` (
  `log_id` INT NOT NULL,
  `log_type_id` INT NOT NULL,
  `log_source_id` INT NOT NULL,
  `log_severity_id` INT NOT NULL,
  `dispositiveid` INT NOT NULL,
  `description` VARCHAR(255) NULL,
  `post_time` DATETIME NOT NULL,
  `computer` VARCHAR(100) NULL,
  `username` VARCHAR(100) NULL,
  `trace` TEXT NULL,
  `reference_id1` BIGINT NULL,
  `reference_id2` BIGINT NULL,
  `value1` VARCHAR(180) NULL,
  `value2` VARCHAR(180) NULL,
  `checksum` VARCHAR(45) NULL,
  PRIMARY KEY (`log_id`, `dispositiveid`),
  INDEX `fk_logs_log_types1_idx` (`log_type_id` ASC) VISIBLE,
  INDEX `fk_logs_log_source1_idx` (`log_source_id` ASC) VISIBLE,
  INDEX `fk_logs_log_severity1_idx` (`log_severity_id` ASC) VISIBLE,
  INDEX `fk_logs_assists_dispositive1_idx` (`dispositiveid` ASC) VISIBLE,
  CONSTRAINT `fk_logs_log_types1`
    FOREIGN KEY (`log_type_id`)
    REFERENCES `mydb`.`assists_log_types` (`log_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logs_log_source1`
    FOREIGN KEY (`log_source_id`)
    REFERENCES `mydb`.`assists_log_source` (`log_source_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logs_log_severity1`
    FOREIGN KEY (`log_severity_id`)
    REFERENCES `mydb`.`assists_log_severity` (`log_severity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logs_assists_dispositive1`
    FOREIGN KEY (`dispositiveid`)
    REFERENCES `mydb`.`assists_dispositive` (`dispositiveid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


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
    REFERENCES `mydb`.`languages` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_executionState`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_executionState` (
  `executionStateid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`executionStateid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_intentType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_intentType` (
  `intentTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  PRIMARY KEY (`intentTypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_interaction_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_interaction_session` (
  `sessionid` INT NOT NULL AUTO_INCREMENT,
  `session_uuid` VARCHAR(36) NOT NULL,
  `start_time` DATETIME NOT NULL DEFAULT NOW(),
  `end_time` DATETIME NULL,
  `session_status` ENUM('active', 'completed', 'interrupted') NULL DEFAULT 'active',
  `interaction_type` ENUM('audio', 'text', 'video') NOT NULL DEFAULT 'audio',
  `userid` INT NOT NULL,
  `dispositiveid` INT NOT NULL,
  PRIMARY KEY (`sessionid`),
  INDEX `fk_assists_audio_session_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_audio_session_assists_dispositive1_idx` (`dispositiveid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_audio_session_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_audio_session_assists_dispositive1`
    FOREIGN KEY (`dispositiveid`)
    REFERENCES `mydb`.`assists_dispositive` (`dispositiveid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_voicecommand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_voicecommand` (
  `commandid` INT NOT NULL AUTO_INCREMENT,
  `originalText` TEXT NOT NULL,
  `processedText` TEXT NULL,
  `datecommand` DATETIME NOT NULL DEFAULT NOW(),
  `duration_ms` INT NULL,
  `confidenceScore` FLOAT NULL,
  `dispositiveid` INT NOT NULL,
  `executionStateid` INT NOT NULL,
  `intentTypeid` INT NOT NULL,
  `sessionid` INT NOT NULL,
  PRIMARY KEY (`commandid`),
  INDEX `fk_assists_voicecommand_assists_dispositive1_idx` (`dispositiveid` ASC) VISIBLE,
  INDEX `fk_assists_voicecommand_assists_executionState1_idx` (`executionStateid` ASC) VISIBLE,
  INDEX `fk_assists_voicecommand_assists_intentType1_idx` (`intentTypeid` ASC) VISIBLE,
  INDEX `fk_assists_voicecommand_assists_audio_session1_idx` (`sessionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_voicecommand_assists_dispositive1`
    FOREIGN KEY (`dispositiveid`)
    REFERENCES `mydb`.`assists_dispositive` (`dispositiveid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_voicecommand_assists_executionState1`
    FOREIGN KEY (`executionStateid`)
    REFERENCES `mydb`.`assists_executionState` (`executionStateid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_voicecommand_assists_intentType1`
    FOREIGN KEY (`intentTypeid`)
    REFERENCES `mydb`.`assists_intentType` (`intentTypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_voicecommand_assists_audio_session1`
    FOREIGN KEY (`sessionid`)
    REFERENCES `mydb`.`assists_interaction_session` (`sessionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accionType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accionType` (
  `accionTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `handler_class` VARCHAR(100) NULL,
  PRIMARY KEY (`accionTypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accion` (
  `accionid` INT NOT NULL AUTO_INCREMENT,
  `dateAccion` DATETIME NOT NULL DEFAULT NOW(),
  `estado` TINYINT(1) NOT NULL DEFAULT 0,
  `error_message` TEXT NULL,
  `excecution_time_ms` INT NULL,
  `commandid` INT NOT NULL,
  `accionTypeid` INT NOT NULL,
  PRIMARY KEY (`accionid`),
  INDEX `fk_assists_accion_assists_voicecommand1_idx` (`commandid` ASC) VISIBLE,
  INDEX `fk_assists_accion_assists_accionType1_idx` (`accionTypeid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_accion_assists_voicecommand1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_accion_assists_accionType1`
    FOREIGN KEY (`accionTypeid`)
    REFERENCES `mydb`.`assists_accionType` (`accionTypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_providersAI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_providersAI` (
  `providersAIid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`providersAIid`))
ENGINE = InnoDB;


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
  `configuration` JSON NULL,
  `isActive` TINYINT(1) NULL DEFAULT 1,
  `providersAIid` INT NOT NULL,
  `assists_voicecommand_commandid` INT NOT NULL,
  PRIMARY KEY (`modeloAIid`),
  INDEX `fk_assists_modeloAI_assists_providersAI1_idx` (`providersAIid` ASC) VISIBLE,
  INDEX `fk_assists_modeloAI_assists_voicecommand1_idx` (`assists_voicecommand_commandid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_modeloAI_assists_providersAI1`
    FOREIGN KEY (`providersAIid`)
    REFERENCES `mydb`.`assists_providersAI` (`providersAIid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_modeloAI_assists_voicecommand1`
    FOREIGN KEY (`assists_voicecommand_commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_modeloAI_voicecommand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_modeloAI_voicecommand` (
  `modeloAIid` INT NOT NULL,
  `commandid` INT NOT NULL,
  `confidence` FLOAT NOT NULL,
  `processing_time_ms` INT NULL,
  `timestamp` DATETIME NOT NULL,
  `raw_response` JSON NULL,
  PRIMARY KEY (`modeloAIid`, `commandid`),
  INDEX `fk_assists_modeloAI_has_assists_voicecommand_assists_voicec_idx` (`commandid` ASC) VISIBLE,
  INDEX `fk_assists_modeloAI_has_assists_voicecommand_assists_modelo_idx` (`modeloAIid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_modeloAI_has_assists_voicecommand_assists_modeloAI1`
    FOREIGN KEY (`modeloAIid`)
    REFERENCES `mydb`.`assists_modeloAI` (`modeloAIid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_modeloAI_has_assists_voicecommand_assists_voicecom1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_MediaTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_MediaTypes` (
  `mediatypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`mediatypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_MediaFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_MediaFiles` (
  `mediaifileid` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(255) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `size` INT NULL,
  `mime_type` VARCHAR(100) NULL,
  `md5_hash` VARCHAR(32) NULL,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL,
  `userid` INT NOT NULL,
  `mediatypeid` INT NOT NULL,
  `duration_seconds` FLOAT NULL,
  `sample_rate` INT NULL,
  `channels` TINYINT NULL,
  `audio_format` VARCHAR(100) NULL,
  `transcription_status` INT NULL,
  PRIMARY KEY (`mediaifileid`),
  INDEX `fk_assists_MediaFiles_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_MediaFiles_assists_MediaTypes1_idx` (`mediatypeid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_MediaFiles_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_MediaFiles_assists_MediaTypes1`
    FOREIGN KEY (`mediatypeid`)
    REFERENCES `mydb`.`assists_MediaTypes` (`mediatypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_transactions` (
  `transactionid` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(10,2) NOT NULL,
  `description` VARCHAR(255) NULL,
  `transDatetime` DATETIME NOT NULL DEFAULT NOW(),
  `postTime` DATETIME NOT NULL DEFAULT NOW(),
  `refNumber` VARCHAR(255) NULL,
  `exchangeRate` DECIMAL(10,2) NULL,
  `checksum` VARBINARY(250) NULL,
  `userid` INT NOT NULL,
  `paymentid` BIGINT NOT NULL,
  PRIMARY KEY (`transactionid`),
  INDEX `fk_assists_transactions_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_transactions_assists_payments1_idx` (`paymentid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_transactions_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_transactions_assists_payments1`
    FOREIGN KEY (`paymentid`)
    REFERENCES `mydb`.`assists_payments` (`paymentid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


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
  `isactive` BIT NULL DEFAULT 1,
  `last_payment_day` DATE NULL,
  `frecuency_interval` INT NULL,
  `userid` INT NOT NULL,
  `accionid` INT NOT NULL,
  `currencyid` INT NOT NULL,
  `paymentMediaid` INT NOT NULL,
  `transactionid` BIGINT NOT NULL,
  PRIMARY KEY (`recurringpaymentid`),
  INDEX `fk_assists_recurringpayments_assists_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_assists_accion1_idx` (`accionid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_currency1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_assists_paymentMedia1_idx` (`paymentMediaid` ASC) VISIBLE,
  INDEX `fk_assists_recurringpayments_assists_transactions1_idx` (`transactionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_recurringpayments_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_recurringpayments_assists_accion1`
    FOREIGN KEY (`accionid`)
    REFERENCES `mydb`.`assists_accion` (`accionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_recurringpayments_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_recurringpayments_assists_paymentMedia1`
    FOREIGN KEY (`paymentMediaid`)
    REFERENCES `mydb`.`assists_paymentMedia` (`paymentMediaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_recurringpayments_assists_transactions1`
    FOREIGN KEY (`transactionid`)
    REFERENCES `mydb`.`assists_transactions` (`transactionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_paymentconfirmations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_paymentconfirmations` (
  `confirmationid` INT NOT NULL AUTO_INCREMENT,
  `confirmation` DATETIME NOT NULL DEFAULT NOW(),
  `estado` ENUM('pending', 'completed', 'failed') NULL,
  `paymentid` BIGINT NOT NULL,
  PRIMARY KEY (`confirmationid`),
  INDEX `fk_assists_paymentconfirmations_assists_payments1_idx` (`paymentid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_paymentconfirmations_assists_payments1`
    FOREIGN KEY (`paymentid`)
    REFERENCES `mydb`.`assists_payments` (`paymentid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_employees` (
  `employeesid` INT NOT NULL AUTO_INCREMENT,
  `position` VARCHAR(100) NULL,
  `hiring` DATE NOT NULL,
  `updated_at` DATETIME NULL,
  `companyid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`employeesid`),
  INDEX `fk_assists_employees_assists_companies1_idx` (`companyid` ASC) VISIBLE,
  INDEX `fk_assists_employees_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_employees_assists_companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `mydb`.`assists_companies` (`companyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_employees_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_employee_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_employee_subscriptions` (
  `employee_subscriptionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NOT NULL,
  `enddate` DATE NULL,
  `employeesid` INT NOT NULL,
  `subscriptionid` INT NOT NULL,
  PRIMARY KEY (`employee_subscriptionid`),
  INDEX `fk_assists_employee_subscriptions_assists_employees1_idx` (`employeesid` ASC) VISIBLE,
  INDEX `fk_assists_employee_subscriptions_assists_company_subscript_idx` (`subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_employee_subscriptions_assists_employees1`
    FOREIGN KEY (`employeesid`)
    REFERENCES `mydb`.`assists_employees` (`employeesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_employee_subscriptions_assists_company_subscriptio1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `mydb`.`assists_company_subscriptions` (`company_subscriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


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
  CONSTRAINT `fk_assists_user_preferences_languages1`
    FOREIGN KEY (`language_id`)
    REFERENCES `mydb`.`languages` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_user_preferences_assists_currency1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `mydb`.`assists_currency` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_user_preferences_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_conversation_context`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_conversation_context` (
  `conversation_contextid` INT NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL DEFAULT NOW(),
  `last_updated` DATETIME NOT NULL,
  `isActive` TINYINT(1) NULL DEFAULT 1,
  `context_data` JSON NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`conversation_contextid`),
  INDEX `fk_assists_conversation_context_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_conversation_context_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_entities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_entities` (
  `entityid` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(50) NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  `metadata` JSON NULL,
  `confidence_score` FLOAT NULL,
  `commandid` INT NOT NULL,
  PRIMARY KEY (`entityid`),
  INDEX `fk_assists_entities_assists_voicecommand1_idx` (`commandid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_entities_assists_voicecommand1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_user_feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_user_feedback` (
  `user_feedbackid` INT NOT NULL AUTO_INCREMENT,
  `rating` TINYINT NOT NULL,
  `feedback_text` TEXT NULL,
  `is_correct` TINYINT(1) NULL,
  `expected_result` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `additional_info` VARCHAR(255) NULL,
  `commandid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`user_feedbackid`),
  INDEX `fk_assists_user_feedback_assists_voicecommand1_idx` (`commandid` ASC) VISIBLE,
  INDEX `fk_assists_user_feedback_assists_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_assists_user_feedback_assists_voicecommand1`
    FOREIGN KEY (`commandid`)
    REFERENCES `mydb`.`assists_voicecommand` (`commandid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_user_feedback_assists_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`assists_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assists_accionParameters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`assists_accionParameters` (
  `parametersid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `type` ENUM('string', 'number', 'date', 'boolean') NOT NULL,
  `required` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`parametersid`))
ENGINE = InnoDB;


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
    REFERENCES `mydb`.`assists_accion` (`accionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assists_accion_has_assists_accionParameters_assists_accion2`
    FOREIGN KEY (`parametersid`)
    REFERENCES `mydb`.`assists_accionParameters` (`parametersid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
