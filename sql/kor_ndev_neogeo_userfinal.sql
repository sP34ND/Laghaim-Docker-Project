-- phpMyAdmin SQL Dump
-- version 4.0.10.18
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 24, 2017 at 11:42 PM
-- Server version: 5.1.73
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `kor_ndev_neogeo_user`
--

-- --------------------------------------------------------

--
-- Table structure for table `bg_user`
--

CREATE TABLE IF NOT EXISTS `bg_user` (
  `user_code` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `jumin` varchar(14) NOT NULL DEFAULT '',
  `passwd` varchar(50) NOT NULL DEFAULT '',
  `old_passwd` varchar(30) NOT NULL DEFAULT '',
  `pw_gubun` tinyint(3) NOT NULL DEFAULT '1',
  `email` varchar(50) NOT NULL DEFAULT '',
  `chk_service` char(1) NOT NULL DEFAULT 'Y',
  `site_id` char(2) NOT NULL DEFAULT 'BG',
  `chk_lag_turn` char(1) NOT NULL DEFAULT 'Y',
  `enc_jumin1` varchar(32) NOT NULL DEFAULT '700101',
  `enc_jumin2` varchar(32) NOT NULL DEFAULT '',
  `enc_jumin3` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `regdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `regmail` varchar(50) NOT NULL DEFAULT '',
  `regip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `pin` varchar(4) NOT NULL DEFAULT '0000',
  `tmp_poll` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_code`),
  UNIQUE KEY `bg_user_id_idx` (`user_id`),
  KEY `bg_user_jumin_idx` (`jumin`),
  KEY `bg_user_name_idx` (`name`),
  KEY `bg_user_chkservice_idx` (`chk_service`),
  KEY `bg_user_site_id_idx` (`site_id`),
  KEY `bg_user_encjumin1_encjumin2` (`enc_jumin1`,`enc_jumin2`),
  KEY `bg_user_login_idx` (`old_passwd`,`chk_service`,`jumin`,`name`,`passwd`,`pw_gubun`),
  KEY `bg_user_passwd_idx` (`old_passwd`,`passwd`,`pw_gubun`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=2 ;

--
-- Dumping data for table `bg_user`
--

INSERT INTO `bg_user` (`user_code`, `user_id`, `name`, `jumin`, `passwd`, `old_passwd`, `pw_gubun`, `email`, `chk_service`, `site_id`, `chk_lag_turn`, `enc_jumin1`, `enc_jumin2`, `enc_jumin3`, `regdate`, `regmail`, `regip`, `pin`, `tmp_poll`) VALUES
(1, 'testreg', 'testreg', '', '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9', '565491d704013245', 1, 'testreg@me.com', 'Y', 'BG', 'Y', '700101', '', 1, '2017-01-24 22:53:41', 'testreg@me.com', '127.0.0.1', '4578', 0);

-- --------------------------------------------------------

--
-- Table structure for table `bg_user_game`
--

CREATE TABLE IF NOT EXISTS `bg_user_game` (
  `ugame_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ugame_game_code` enum('LC','LH','SW','TC') NOT NULL DEFAULT 'LH',
  `ugame_user_code` int(11) unsigned NOT NULL DEFAULT '0',
  `ugame_join_date` date NOT NULL DEFAULT '2006-09-10',
  `ugame_login_date` date NOT NULL DEFAULT '2006-09-10',
  PRIMARY KEY (`ugame_index`),
  UNIQUE KEY `idx_game_code` (`ugame_game_code`,`ugame_user_code`),
  KEY `idx_date` (`ugame_join_date`,`ugame_login_date`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='°ÔÀÓº° À¯Àú ±¸ºÐ Å×ÀÌºí' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `bg_user_game`
--

INSERT INTO `bg_user_game` (`ugame_index`, `ugame_game_code`, `ugame_user_code`, `ugame_join_date`, `ugame_login_date`) VALUES
(1, 'LH', 1, '2017-01-24', '2017-01-24');

-- --------------------------------------------------------

--
-- Table structure for table `bg_user_info_change_log`
--

CREATE TABLE IF NOT EXISTS `bg_user_info_change_log` (
  `icl_idx` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `icl_user_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `icl_change_type` enum('UIC','PWN','PWR','PW3','JIN','GPN','GPR','HTN','REC') NOT NULL DEFAULT 'UIC',
  `icl_connect_path` enum('BG','LH','LC') NOT NULL DEFAULT 'BG',
  `icl_change_desc` text NOT NULL,
  `icl_client_ip` varchar(20) NOT NULL DEFAULT '',
  `icl_change_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`icl_idx`),
  KEY `IDX_UserIdx_ChangeType_ChangeDate` (`icl_user_idx`,`icl_change_type`,`icl_change_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='»ç¿ëÀÚ Á¤º¸ º¯°æ ·Î±×' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `not_use_t_user_ranking_web`
--

CREATE TABLE IF NOT EXISTS `not_use_t_user_ranking_web` (
  `a_index` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `a_lag_user_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '0',
  `a_exp` bigint(3) unsigned NOT NULL DEFAULT '0',
  `a_level` smallint(3) unsigned NOT NULL DEFAULT '0',
  `a_ranking` int(3) unsigned NOT NULL DEFAULT '0',
  `a_race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_gender` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_rank_type` char(3) NOT NULL DEFAULT '0',
  `a_update_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_index_2` (`a_index`,`a_lag_user_index`,`a_char_index`,`a_char_name`,`a_race`,`a_server`,`a_rank_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `not_use_t_user_ranking_web_history`
--

CREATE TABLE IF NOT EXISTS `not_use_t_user_ranking_web_history` (
  `a_index` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `a_lag_user_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '0',
  `a_exp` bigint(3) unsigned NOT NULL DEFAULT '0',
  `a_level` smallint(3) unsigned NOT NULL DEFAULT '0',
  `a_ranking` int(3) unsigned NOT NULL DEFAULT '0',
  `a_race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_gender` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_rank_type` char(3) NOT NULL DEFAULT '0',
  `a_update_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_index_2` (`a_index`,`a_lag_user_index`,`a_char_index`,`a_char_name`,`a_race`,`a_server`,`a_rank_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_admin_order`
--

CREATE TABLE IF NOT EXISTS `t_admin_order` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_unixtime` int(3) unsigned NOT NULL DEFAULT '0',
  `a_send_sms` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_send_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_order` text,
  `a_order_index` int(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_unixtime` (`a_unixtime`,`a_send_sms`,`a_send_order`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_agree_log`
--

CREATE TABLE IF NOT EXISTS `t_agree_log` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '0000',
  `a_passwd` varchar(30) NOT NULL DEFAULT '0000',
  `a_jumin` varchar(14) DEFAULT '000000-0000000',
  `a_name` varchar(12) DEFAULT NULL,
  `a_email` varchar(50) DEFAULT NULL,
  `a_regi_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`),
  KEY `a_idname` (`a_idname`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_auto_program`
--

CREATE TABLE IF NOT EXISTS `t_auto_program` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) DEFAULT '0',
  `a_status` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT '0',
  `a_insert_date` datetime DEFAULT '0000-00-00 00:00:00',
  `a_update_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='¿ÀÅä ÇÁ·Î±×·¥ Ã¼Å©' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_block_ip`
--

CREATE TABLE IF NOT EXISTS `t_block_ip` (
  `a_ip` varchar(20) NOT NULL DEFAULT '0.0.0.0',
  `a_block` tinyint(3) unsigned DEFAULT '0',
  `a_story` varchar(200) DEFAULT NULL,
  `a_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_gm` varchar(50) DEFAULT NULL,
  KEY `a_ip` (`a_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Â÷´Ü ¾ÆÀÌÇÇ ¸ñ·Ï';

-- --------------------------------------------------------

--
-- Table structure for table `t_connect_count`
--

CREATE TABLE IF NOT EXISTS `t_connect_count` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_count` int(11) unsigned NOT NULL DEFAULT '0',
  `a_count_gbp` int(11) unsigned DEFAULT '0',
  `a_count_gu` int(11) unsigned DEFAULT '0',
  `a_date` datetime DEFAULT '0000-00-00 00:00:00',
  `a_server` int(11) unsigned DEFAULT '0',
  `a_world` int(11) unsigned DEFAULT '0',
  `a_sub_num` int(11) unsigned DEFAULT '0',
  `a_area` char(2) DEFAULT 'BJ',
  `a_level_count` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`a_index`),
  KEY `i_datetime` (`a_date`),
  KEY `a_world` (`a_sub_num`,`a_world`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=70 ;

--
-- Dumping data for table `t_connect_count`
--

INSERT INTO `t_connect_count` (`a_index`, `a_count`, `a_count_gbp`, `a_count_gu`, `a_date`, `a_server`, `a_world`, `a_sub_num`, `a_area`, `a_level_count`) VALUES
(1, 0, 0, 0, '2017-01-24 23:02:00', 1, 0, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(2, 0, 0, 0, '2017-01-24 23:02:00', 1, 16, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(3, 0, 0, 0, '2017-01-24 23:02:00', 1, 13, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(4, 0, 0, 0, '2017-01-24 23:02:00', 1, 4, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(5, 0, 0, 0, '2017-01-24 23:02:00', 1, 14, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(6, 0, 0, 0, '2017-01-24 23:02:00', 1, 3, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(7, 0, 0, 0, '2017-01-24 23:02:00', 1, 1, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(8, 0, 0, 0, '2017-01-24 23:02:00', 1, 2, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(9, 0, 0, 0, '2017-01-24 23:02:00', 1, 15, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(10, 0, 0, 0, '2017-01-24 23:02:00', 1, 7, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(11, 0, 0, 0, '2017-01-24 23:02:00', 1, 17, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(12, 0, 0, 0, '2017-01-24 23:02:00', 1, 22, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(13, 0, 0, 0, '2017-01-24 23:02:00', 1, 9, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(14, 0, 0, 0, '2017-01-24 23:02:00', 1, 20, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(15, 0, 0, 0, '2017-01-24 23:02:00', 1, 6, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(16, 0, 0, 0, '2017-01-24 23:02:00', 1, 8, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(17, 0, 0, 0, '2017-01-24 23:02:00', 1, 5, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(18, 0, 0, 0, '2017-01-24 23:02:00', 1, 23, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(19, 0, 0, 0, '2017-01-24 23:02:00', 1, 19, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(20, 0, 0, 0, '2017-01-24 23:02:00', 1, 24, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(21, 0, 0, 0, '2017-01-24 23:02:00', 1, 11, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(22, 0, 0, 0, '2017-01-24 23:02:00', 1, 12, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(23, 0, 0, 0, '2017-01-24 23:02:00', 1, 18, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(24, 0, 0, 0, '2017-01-24 23:26:00', 1, 0, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(25, 0, 0, 0, '2017-01-24 23:26:00', 1, 4, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(26, 0, 0, 0, '2017-01-24 23:26:00', 1, 13, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(27, 0, 0, 0, '2017-01-24 23:26:00', 1, 14, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(28, 0, 0, 0, '2017-01-24 23:26:00', 1, 16, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(29, 0, 0, 0, '2017-01-24 23:26:00', 1, 3, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(30, 0, 0, 0, '2017-01-24 23:26:00', 1, 15, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(31, 0, 0, 0, '2017-01-24 23:26:00', 1, 17, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(32, 0, 0, 0, '2017-01-24 23:26:00', 1, 2, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(33, 0, 0, 0, '2017-01-24 23:26:00', 1, 1, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(34, 0, 0, 0, '2017-01-24 23:26:00', 1, 7, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(35, 0, 0, 0, '2017-01-24 23:26:00', 1, 22, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(36, 0, 0, 0, '2017-01-24 23:26:00', 1, 5, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(37, 0, 0, 0, '2017-01-24 23:26:00', 1, 9, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(38, 0, 0, 0, '2017-01-24 23:26:00', 1, 6, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(39, 0, 0, 0, '2017-01-24 23:26:00', 1, 20, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(40, 0, 0, 0, '2017-01-24 23:26:00', 1, 19, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(41, 0, 0, 0, '2017-01-24 23:26:00', 1, 23, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(42, 0, 0, 0, '2017-01-24 23:26:00', 1, 11, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(43, 0, 0, 0, '2017-01-24 23:26:00', 1, 8, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(44, 0, 0, 0, '2017-01-24 23:26:00', 1, 12, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(45, 0, 0, 0, '2017-01-24 23:26:00', 1, 24, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(46, 0, 0, 0, '2017-01-24 23:26:00', 1, 18, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(47, 0, 0, 0, '2017-01-24 23:36:00', 1, 0, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(48, 0, 0, 0, '2017-01-24 23:36:00', 1, 4, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(49, 0, 0, 0, '2017-01-24 23:36:00', 1, 13, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(50, 0, 0, 0, '2017-01-24 23:36:00', 1, 14, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(51, 0, 0, 0, '2017-01-24 23:36:00', 1, 16, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(52, 0, 0, 0, '2017-01-24 23:36:00', 1, 3, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(53, 0, 0, 0, '2017-01-24 23:36:00', 1, 15, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(54, 0, 0, 0, '2017-01-24 23:36:00', 1, 17, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(55, 0, 0, 0, '2017-01-24 23:36:00', 1, 2, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(56, 0, 0, 0, '2017-01-24 23:36:00', 1, 1, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(57, 0, 0, 0, '2017-01-24 23:36:00', 1, 7, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(58, 0, 0, 0, '2017-01-24 23:36:00', 1, 22, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(59, 0, 0, 0, '2017-01-24 23:36:00', 1, 5, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(60, 0, 0, 0, '2017-01-24 23:36:00', 1, 9, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(61, 0, 0, 0, '2017-01-24 23:36:00', 1, 6, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(62, 0, 0, 0, '2017-01-24 23:36:00', 1, 20, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(63, 0, 0, 0, '2017-01-24 23:36:00', 1, 19, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(64, 0, 0, 0, '2017-01-24 23:36:00', 1, 23, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(65, 0, 0, 0, '2017-01-24 23:36:00', 1, 11, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(66, 0, 0, 0, '2017-01-24 23:36:00', 1, 8, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(67, 0, 0, 0, '2017-01-24 23:36:00', 1, 12, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(68, 0, 0, 0, '2017-01-24 23:36:00', 1, 24, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(69, 0, 0, 0, '2017-01-24 23:36:00', 1, 18, 660, 'BJ', ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0');

-- --------------------------------------------------------

--
-- Table structure for table `t_connect_log`
--

CREATE TABLE IF NOT EXISTS `t_connect_log` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_idname` varchar(25) NOT NULL DEFAULT '',
  `a_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_ip` varchar(20) DEFAULT '0.0.0.0',
  `a_country` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`a_index`),
  KEY `a_idname` (`a_idname`),
  KEY `a_ip_index` (`a_ip`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `t_connect_log`
--

INSERT INTO `t_connect_log` (`a_index`, `a_idname`, `a_date`, `a_ip`, `a_country`) VALUES
(1, 'testreg', '2017-01-24 22:54:23', '192.168.56.100', NULL),
(2, 'testreg', '2017-01-24 23:17:40', '192.168.56.100', NULL),
(3, 'testreg', '2017-01-24 23:21:17', '192.168.56.100', NULL),
(4, 'testreg', '2017-01-24 23:36:35', '192.168.56.100', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_connect_max`
--

CREATE TABLE IF NOT EXISTS `t_connect_max` (
  `a_index` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `a_count` int(1) unsigned DEFAULT '0',
  `a_count_max` int(1) unsigned DEFAULT '0',
  `a_date` date DEFAULT '0000-00-00',
  `a_server` int(1) unsigned DEFAULT '0',
  `a_world` int(1) unsigned DEFAULT '0',
  `a_sub_num` int(1) unsigned DEFAULT '0',
  `a_level_count` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`a_index`),
  KEY `a_date` (`a_date`),
  KEY `a_sub_num` (`a_sub_num`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `t_connect_max`
--

INSERT INTO `t_connect_max` (`a_index`, `a_count`, `a_count_max`, `a_date`, `a_server`, `a_world`, `a_sub_num`, `a_level_count`) VALUES
(1, 0, 0, '2017-01-24', 1, 0, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(2, 0, 0, '2017-01-24', 1, 16, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(3, 0, 0, '2017-01-24', 1, 13, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(4, 0, 0, '2017-01-24', 1, 4, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(5, 0, 0, '2017-01-24', 1, 14, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(6, 0, 0, '2017-01-24', 1, 3, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(7, 0, 0, '2017-01-24', 1, 1, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(8, 0, 0, '2017-01-24', 1, 2, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(9, 0, 0, '2017-01-24', 1, 15, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(10, 0, 0, '2017-01-24', 1, 7, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(11, 0, 0, '2017-01-24', 1, 17, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(12, 0, 0, '2017-01-24', 1, 22, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(13, 0, 0, '2017-01-24', 1, 9, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(14, 0, 0, '2017-01-24', 1, 20, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(15, 0, 0, '2017-01-24', 1, 6, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(16, 0, 0, '2017-01-24', 1, 8, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(17, 0, 0, '2017-01-24', 1, 5, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(18, 0, 0, '2017-01-24', 1, 23, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(19, 0, 0, '2017-01-24', 1, 19, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(20, 0, 0, '2017-01-24', 1, 24, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(21, 0, 0, '2017-01-24', 1, 11, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(22, 0, 0, '2017-01-24', 1, 12, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'),
(23, 0, 0, '2017-01-24', 1, 18, 660, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0');

-- --------------------------------------------------------

--
-- Table structure for table `t_contents_control`
--

CREATE TABLE IF NOT EXISTS `t_contents_control` (
  `a_contents_index` int(3) unsigned DEFAULT '0',
  `a_enable` tinyint(3) unsigned DEFAULT '0',
  UNIQUE KEY `a_contents_index` (`a_contents_index`),
  KEY `a_contents_index_2` (`a_contents_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_contents_control`
--

INSERT INTO `t_contents_control` (`a_contents_index`, `a_enable`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_event2000_user`
--

CREATE TABLE IF NOT EXISTS `t_event2000_user` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_item_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_count` int(11) unsigned NOT NULL DEFAULT '0',
  `a_count_remain` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_user_index`),
  KEY `a_item_index` (`a_item_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_event_admin`
--

CREATE TABLE IF NOT EXISTS `t_event_admin` (
  `a_year` int(3) unsigned DEFAULT '0',
  `a_mon` tinyint(3) unsigned DEFAULT '0',
  `a_day` tinyint(3) unsigned DEFAULT '0',
  `a_hour` tinyint(3) unsigned DEFAULT '0',
  `a_min` tinyint(3) unsigned DEFAULT '0',
  `a_type` tinyint(3) unsigned DEFAULT '0',
  `a_order` char(250) DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_event_vote`
--

CREATE TABLE IF NOT EXISTS `t_event_vote` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_2p4p_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_2p4p_name` char(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_enable` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `a_get_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_2p4p` (`a_2p4p_index`),
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_index_2` (`a_index`),
  KEY `a_user` (`a_2p4p_index`,`a_enable`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='2007-11-21 ÃÖ°­±æµåÅõÇ¥ ¼±Á¤ÀÎ¿ø' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_e_battleleague`
--

CREATE TABLE IF NOT EXISTS `t_e_battleleague` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_coupon` char(64) DEFAULT '0',
  `a_user_index` int(3) unsigned DEFAULT '0',
  `a_enable` tinyint(3) unsigned DEFAULT '0',
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_user_index` (`a_user_index`,`a_enable`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_game_ip`
--

CREATE TABLE IF NOT EXISTS `t_game_ip` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_ip_prefix` varchar(12) NOT NULL DEFAULT '127.0.0',
  `a_ip_start` tinyint(1) unsigned DEFAULT '0',
  `a_ip_end` tinyint(1) unsigned DEFAULT '255',
  `a_flag` tinyint(1) unsigned DEFAULT '1',
  `a_pindex` int(12) DEFAULT NULL,
  PRIMARY KEY (`a_index`),
  KEY `i_ip_prefix` (`a_ip_prefix`),
  KEY `a_pindex` (`a_pindex`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_game_pcinfo`
--

CREATE TABLE IF NOT EXISTS `t_game_pcinfo` (
  `a_pindex` int(12) unsigned NOT NULL AUTO_INCREMENT,
  `a_name` varchar(40) NOT NULL DEFAULT '0000',
  `a_phone` varchar(15) DEFAULT NULL,
  `a_email` varchar(50) DEFAULT NULL,
  `a_regin` varchar(15) DEFAULT NULL,
  `a_kind` varchar(10) DEFAULT '½Å±Ô',
  `a_admincode` varchar(20) DEFAULT NULL,
  `a_desc` varchar(100) DEFAULT NULL,
  `a_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_pindex`),
  KEY `a_name` (`a_name`),
  KEY `a_regin` (`a_regin`),
  KEY `a_kind` (`a_kind`),
  KEY `a_admincode` (`a_admincode`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_game_users`
--

CREATE TABLE IF NOT EXISTS `t_game_users` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_idname` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_character` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `a_server` smallint(1) unsigned NOT NULL DEFAULT '0',
  `a_partner` char(1) NOT NULL DEFAULT 'L',
  `a_partner_id` varchar(20) NOT NULL DEFAULT '',
  `a_point` int(11) unsigned NOT NULL DEFAULT '0',
  `a_regi_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_wingame` int(11) unsigned NOT NULL DEFAULT '0',
  `a_losegame` int(11) unsigned NOT NULL DEFAULT '0',
  `a_totalgame` int(11) unsigned NOT NULL DEFAULT '0',
  `a_level` int(4) NOT NULL DEFAULT '0',
  `a_prize_flag` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`),
  KEY `a_point` (`a_point`),
  KEY `a_user_index` (`a_user_index`),
  KEY `a_partner` (`a_partner`),
  KEY `a_regi_date` (`a_regi_date`),
  KEY `a_wingame` (`a_wingame`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_guild`
--

CREATE TABLE IF NOT EXISTS `t_guild` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '0',
  `a_server` int(11) NOT NULL DEFAULT '0',
  `a_master` varchar(30) NOT NULL DEFAULT '0',
  `a_url` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_enable` int(11) NOT NULL DEFAULT '1',
  `a_points` int(1) unsigned DEFAULT '0',
  `a_grade1` varchar(8) NOT NULL DEFAULT '±æ¸¶',
  `a_grade2` varchar(8) NOT NULL DEFAULT 'ºÎ±æ¸¶',
  `a_grade3` varchar(8) NOT NULL DEFAULT 'ºÎÀå',
  `a_grade4` varchar(8) NOT NULL DEFAULT '±æµå¿ø',
  `a_partner` char(2) NOT NULL DEFAULT 'LH',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_name` (`a_name`,`a_partner`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_guild_member`
--

CREATE TABLE IF NOT EXISTS `t_guild_member` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_char_idx` int(11) NOT NULL DEFAULT '0',
  `a_guild_idx` int(11) NOT NULL DEFAULT '0',
  `a_level` int(11) NOT NULL DEFAULT '0',
  `a_char_name` varchar(20) DEFAULT '0',
  PRIMARY KEY (`a_index`),
  KEY `a_char_idx` (`a_char_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_guild_right`
--

CREATE TABLE IF NOT EXISTS `t_guild_right` (
  `a_server` int(11) NOT NULL DEFAULT '0',
  `a_sub` int(11) NOT NULL DEFAULT '0',
  `a_zone` int(11) NOT NULL DEFAULT '0',
  `a_right` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_guild_right`
--

INSERT INTO `t_guild_right` (`a_server`, `a_sub`, `a_zone`, `a_right`) VALUES
(1, 660, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_item_event`
--

CREATE TABLE IF NOT EXISTS `t_item_event` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_item_index` int(11) NOT NULL DEFAULT '0',
  `a_buy_date` datetime DEFAULT '0000-00-00 00:00:00',
  `a_price` int(11) DEFAULT '0',
  `a_use_flag` tinyint(1) NOT NULL DEFAULT '0',
  `a_use_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`),
  KEY `a_user_index` (`a_user_index`,`a_item_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='À¥ ¾ÆÀÌÅÛ ±¸¸Å ÀÌº¥Æ®' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_item_log`
--

CREATE TABLE IF NOT EXISTS `t_item_log` (
  `a_index` int(3) NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_server_num` int(10) unsigned NOT NULL DEFAULT '0',
  `a_item_vnum` int(11) NOT NULL DEFAULT '0',
  `a_item_name` varchar(30) NOT NULL DEFAULT '',
  `a_plus` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `a_addflag` int(11) unsigned NOT NULL DEFAULT '0',
  `a_count` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `a_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_contents` text,
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_leaflet_count`
--

CREATE TABLE IF NOT EXISTS `t_leaflet_count` (
  `a_server_no` int(11) unsigned NOT NULL DEFAULT '0',
  `a_leaflet_count` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_server_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='¼­¹öº° Àü´ÜÁö ¼ö·®';

-- --------------------------------------------------------

--
-- Table structure for table `t_lotto`
--

CREATE TABLE IF NOT EXISTS `t_lotto` (
  `a_stage` int(3) unsigned DEFAULT '0',
  `a_winner` tinyint(3) unsigned DEFAULT '0',
  `a_winner_number` char(255) DEFAULT NULL,
  UNIQUE KEY `a_stage` (`a_stage`),
  KEY `a_stage_2` (`a_stage`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_lotto`
--

INSERT INTO `t_lotto` (`a_stage`, `a_winner`, `a_winner_number`) VALUES
(0, 1, '1 2 3 4 5 6 7'),
(1, 1, ' 10 19 21 32 38 45 7\n'),
(2, 0, ' 10 19 21 32 38 45 7\n'),
(3, 0, ' 37 7 41 38 6 44 42\n'),
(4, 0, ' 37 7 41 38 6 44 42\n'),
(5, 0, ' 37 7 41 38 6 44 42\n'),
(6, 0, ' 37 7 41 38 6 44 42\n'),
(7, 0, ' 37 7 41 38 6 44 42\n'),
(8, 0, ' 37 7 41 38 6 44 42\n'),
(9, 0, ' 37 7 41 38 6 44 42\n'),
(10, 0, ' 14 11 39 42 9 40 10\n'),
(11, 0, ' 4 5 3 11 44 17 39\n'),
(12, 0, ' 25 11 30 17 43 7 26\n'),
(13, 0, ' 10 5 25 37 30 3 35\n'),
(14, 0, ' 24 13 39 2 7 36 32\n'),
(15, 0, ' 4 1 45 2 20 10 14\n'),
(16, 0, ' 14 36 3 12 39 20 31\n'),
(17, 0, ' 14 36 3 12 39 20 31\n'),
(18, 0, ' 27 15 3 23 41 45 6\n'),
(19, 0, ' 3 38 33 12 37 4 10\n'),
(20, 0, ' 13 19 45 4 41 12 9\n'),
(21, 0, ' 18 11 22 23 14 21 17\n'),
(22, 0, ' 1 30 4 42 5 10 6\n'),
(23, 0, ' 34 28 36 43 4 38 5\n'),
(24, 0, ' 34 28 36 43 4 38 5\n'),
(25, 0, ' 10 43 39 29 23 35 42\n'),
(26, 0, ' 30 34 18 26 8 38 27\n'),
(27, 0, ' 43 25 44 6 22 3 30\n'),
(28, 0, ' 39 41 21 36 22 42 23\n'),
(29, 0, ' 39 41 21 36 22 42 23\n'),
(30, 0, ' 11 32 41 28 17 30 19\n'),
(31, 0, ' 38 4 17 35 45 28 5\n'),
(32, 0, ' 9 37 27 23 43 39 2\n'),
(33, 0, ' 14 45 35 38 42 2 3\n'),
(34, 0, ' 40 19 39 4 20 37 44\n'),
(35, 0, ' 39 38 23 20 11 19 34\n'),
(36, 0, ' 39 38 23 20 11 19 34\n'),
(37, 0, ' 28 23 5 4 18 31 25\n'),
(38, 0, ' 7 6 14 41 39 20 35\n'),
(39, 0, ' 42 27 13 25 17 44 39\n'),
(40, 0, ' 25 17 26 38 1 30 45\n'),
(41, 0, ' 25 17 26 38 1 30 45\n'),
(42, 0, ' 25 9 19 16 38 22 4\n'),
(43, 0, ' 30 24 18 2 29 20 6\n'),
(44, 0, ' 30 24 18 2 29 20 6\n'),
(45, 0, ' 2 11 40 45 32 3 27\n'),
(46, 0, ' 33 13 17 11 3 38 7\n'),
(47, 0, ' 33 13 17 11 3 38 7\n'),
(48, 0, ' 39 41 17 24 13 5 10\n'),
(49, 0, ' 39 41 17 24 13 5 10\n'),
(50, 0, ' 4 20 44 10 32 5 45\n'),
(51, 0, ' 44 32 29 21 30 27 37\n'),
(52, 0, ' 25 12 13 26 16 27 37\n'),
(53, 0, ' 35 44 9 31 43 23 20\n'),
(54, 0, ' 3 20 39 11 22 5 9\n'),
(55, 0, ' 21 41 1 43 34 25 6\n'),
(56, 0, ' 38 29 21 23 33 18 16\n'),
(57, 0, ' 32 43 2 5 44 12 24\n'),
(58, 0, ' 9 27 39 40 12 15 32\n'),
(59, 0, ' 41 27 11 32 31 33 13\n'),
(60, 0, ' 40 7 35 29 33 41 20\n'),
(61, 0, ' 13 12 34 14 33 29 20\n'),
(62, 0, ' 43 29 17 14 1 5 30\n'),
(63, 0, ' 29 12 16 20 31 37 39\n'),
(64, 0, ' 9 34 25 18 42 36 41\n'),
(65, 0, ' 28 45 38 34 25 36 6\n'),
(66, 0, ' 5 31 30 23 11 12 27\n'),
(67, 0, ' 32 7 1 8 34 35 10\n'),
(68, 0, ' 13 42 20 11 4 12 7\n'),
(69, 0, ' 29 44 40 45 24 36 26\n'),
(70, 0, ' 28 44 17 25 6 30 13\n'),
(71, 0, ' 39 40 43 44 3 8 45\n'),
(72, 0, ' 38 26 32 13 3 39 14\n'),
(73, 0, ' 35 36 43 25 29 38 9\n'),
(74, 0, ' 10 30 43 7 6 34 23\n'),
(75, 0, ' 37 7 41 38 6 44 42\n'),
(76, 0, ' 37 7 41 38 6 44 42\n'),
(77, 0, ' 37 7 41 38 6 44 42\n'),
(78, 0, ' 37 7 41 38 6 44 42\n'),
(79, 0, ' 37 7 41 38 6 44 42\n'),
(80, 0, ' 37 7 41 38 6 44 42\n'),
(81, 0, ' 37 7 41 38 6 44 42\n'),
(82, 0, ' 37 7 41 38 6 44 42\n'),
(83, 0, ' 37 7 41 38 6 44 42\n'),
(84, 0, ' 26 9 45 5 21 11 24\n'),
(85, 0, ' 7 40 23 2 36 20 11\n'),
(86, 0, ' 39 4 8 17 23 5 19\n'),
(87, 0, ' 2 5 21 30 8 13 24\n'),
(88, 0, ' 12 18 27 21 30 11 6\n'),
(89, 0, ' 39 37 24 22 20 15 10\n'),
(90, 0, ' 19 3 40 35 15 6 11\n'),
(91, 0, ' 7 33 22 27 30 35 38\n'),
(92, 0, ' 45 13 12 18 30 34 14\n'),
(93, 0, ' 5 31 2 40 9 25 3\n'),
(94, 0, ' 34 36 9 28 32 29 41\n'),
(95, 0, ' 42 36 14 15 45 2 17\n'),
(96, 0, ' 1 36 10 41 12 4 23\n'),
(97, 0, ' 20 41 40 16 17 8 26\n'),
(98, 0, ' 19 41 45 26 4 14 24\n'),
(99, 0, ' 1 35 11 26 18 9 16\n'),
(100, 0, ' 18 40 45 20 31 39 38\n'),
(101, 0, ' 8 22 14 44 33 18 39\n'),
(102, 0, ' 9 2 24 13 34 42 36\n'),
(103, 0, ' 15 30 1 4 11 2 27\n'),
(104, 0, ' 18 17 34 40 19 33 41\n'),
(105, 0, ' 39 29 31 43 2 17 25\n'),
(106, 0, ' 6 2 17 18 13 23 26\n'),
(107, 0, ' 40 17 25 20 8 21 6\n'),
(108, 0, ' 29 28 9 1 11 44 8\n'),
(109, 0, ' 10 27 21 39 38 7 41\n'),
(110, 0, ' 25 12 9 40 20 18 32\n'),
(111, 0, ' 42 14 3 32 19 34 18\n'),
(112, 0, ' 3 43 26 22 35 30 36\n'),
(113, 0, ' 13 42 5 14 3 2 1\n'),
(114, 0, ' 18 13 22 20 30 24 42\n'),
(115, 0, ' 13 10 34 14 22 7 5\n');

-- --------------------------------------------------------

--
-- Table structure for table `t_mad_event`
--

CREATE TABLE IF NOT EXISTS `t_mad_event` (
  `a_user_index` int(11) unsigned DEFAULT '0',
  `a_mad_char_name` char(30) DEFAULT '0',
  UNIQUE KEY `a_user_index` (`a_user_index`),
  KEY `a_user_index_2` (`a_user_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_matrix_end`
--

CREATE TABLE IF NOT EXISTS `t_matrix_end` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_date` datetime DEFAULT NULL,
  `a_text` text,
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_matrix_joint`
--

CREATE TABLE IF NOT EXISTS `t_matrix_joint` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_team_index` int(4) NOT NULL DEFAULT '-1',
  `a_name` char(20) NOT NULL DEFAULT 'none',
  `a_server1` int(4) NOT NULL DEFAULT '-1',
  `a_server2` int(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='into moebius alliance info' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_matrix_result`
--

CREATE TABLE IF NOT EXISTS `t_matrix_result` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_server` tinyint(1) NOT NULL DEFAULT '-1',
  `a_win` int(1) unsigned NOT NULL DEFAULT '0',
  `a_lose` int(1) unsigned NOT NULL DEFAULT '0',
  `a_exp_rate` int(1) unsigned NOT NULL DEFAULT '0',
  `a_item_rate` int(1) unsigned NOT NULL DEFAULT '0',
  `a_money_rate` int(1) unsigned NOT NULL DEFAULT '0',
  `a_set_date` char(10) DEFAULT '0000000000',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='result of moebius battle and adventage rate info' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `t_matrix_result`
--

INSERT INTO `t_matrix_result` (`a_index`, `a_server`, `a_win`, `a_lose`, `a_exp_rate`, `a_item_rate`, `a_money_rate`, `a_set_date`) VALUES
(1, 1, 1, 0, 100, 100, 100, '1453669949');

-- --------------------------------------------------------

--
-- Table structure for table `t_matrix_result_copy`
--

CREATE TABLE IF NOT EXISTS `t_matrix_result_copy` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_server` tinyint(1) NOT NULL DEFAULT '-1',
  `a_win` int(1) unsigned NOT NULL DEFAULT '0',
  `a_lose` int(1) unsigned NOT NULL DEFAULT '0',
  `a_exp_rate` int(1) unsigned NOT NULL DEFAULT '0',
  `a_item_rate` int(1) unsigned NOT NULL DEFAULT '0',
  `a_money_rate` int(1) unsigned NOT NULL DEFAULT '0',
  `a_set_date` char(10) DEFAULT '0000000000',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_matrix_status`
--

CREATE TABLE IF NOT EXISTS `t_matrix_status` (
  `a_battle_start` int(1) NOT NULL DEFAULT '0',
  `a_battle_flag` int(1) NOT NULL DEFAULT '0',
  `a_battle_pulse` int(1) NOT NULL DEFAULT '0',
  `a_hawk` int(1) NOT NULL DEFAULT '0',
  `a_coollane` int(1) NOT NULL DEFAULT '0',
  `a_shiver` int(1) NOT NULL DEFAULT '0',
  `a_gate_idx_1` int(1) NOT NULL DEFAULT '0',
  `a_gate_hp_1` int(1) NOT NULL DEFAULT '0',
  `a_gate_idx_2` int(1) NOT NULL DEFAULT '0',
  `a_gate_hp_2` int(1) NOT NULL DEFAULT '0',
  `a_gate_idx_3` int(1) NOT NULL DEFAULT '0',
  `a_gate_hp_3` int(1) NOT NULL DEFAULT '0',
  `a_gate_idx_4` int(1) NOT NULL DEFAULT '0',
  `a_gate_hp_4` int(1) NOT NULL DEFAULT '0',
  `a_gate_idx_5` int(1) NOT NULL DEFAULT '0',
  `a_gate_hp_5` int(1) NOT NULL DEFAULT '0',
  `a_gate_idx_6` int(1) NOT NULL DEFAULT '0',
  `a_gate_hp_6` int(1) NOT NULL DEFAULT '0',
  `a_gp_reset_1` int(1) NOT NULL DEFAULT '0',
  `a_gp_owner_1` int(1) NOT NULL DEFAULT '0',
  `a_gp_hp_1` int(1) NOT NULL DEFAULT '0',
  `a_gp_pulse_1` int(1) NOT NULL DEFAULT '0',
  `a_gp_reset_2` int(1) NOT NULL DEFAULT '0',
  `a_gp_owner_2` int(1) NOT NULL DEFAULT '0',
  `a_gp_hp_2` int(1) NOT NULL DEFAULT '0',
  `a_gp_pulse_2` int(1) NOT NULL DEFAULT '0',
  `a_gp_reset_3` int(1) NOT NULL DEFAULT '0',
  `a_gp_owner_3` int(1) NOT NULL DEFAULT '0',
  `a_gp_hp_3` int(1) NOT NULL DEFAULT '0',
  `a_gp_pulse_3` int(1) NOT NULL DEFAULT '0',
  `a_gr_state_1` int(1) NOT NULL DEFAULT '0',
  `a_gr_hp_1` int(1) NOT NULL DEFAULT '0',
  `a_gr_state_2` int(1) NOT NULL DEFAULT '0',
  `a_gr_hp_2` int(1) NOT NULL DEFAULT '0',
  `a_gr_state_3` int(1) NOT NULL DEFAULT '0',
  `a_gr_hp_3` int(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='mobius battle status ';

--
-- Dumping data for table `t_matrix_status`
--

INSERT INTO `t_matrix_status` (`a_battle_start`, `a_battle_flag`, `a_battle_pulse`, `a_hawk`, `a_coollane`, `a_shiver`, `a_gate_idx_1`, `a_gate_hp_1`, `a_gate_idx_2`, `a_gate_hp_2`, `a_gate_idx_3`, `a_gate_hp_3`, `a_gate_idx_4`, `a_gate_hp_4`, `a_gate_idx_5`, `a_gate_hp_5`, `a_gate_idx_6`, `a_gate_hp_6`, `a_gp_reset_1`, `a_gp_owner_1`, `a_gp_hp_1`, `a_gp_pulse_1`, `a_gp_reset_2`, `a_gp_owner_2`, `a_gp_hp_2`, `a_gp_pulse_2`, `a_gp_reset_3`, `a_gp_owner_3`, `a_gp_hp_3`, `a_gp_pulse_3`, `a_gr_state_1`, `a_gr_hp_1`, `a_gr_state_2`, `a_gr_hp_2`, `a_gr_state_3`, `a_gr_hp_3`) VALUES
(1, 2, 360000, 10, 10, 10, 1, 1000000, 1, 1000000, 1, 1000000, 1, 1000000, 1, 1000000, 1, 1000000, 0, 0, 1000000, 0, 0, 0, 1000000, 0, 0, 0, 1000000, 0, 1, 1000000, 1, 1000000, 1, 1000000);

-- --------------------------------------------------------

--
-- Table structure for table `t_note_message_history`
--

CREATE TABLE IF NOT EXISTS `t_note_message_history` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_type` int(3) unsigned NOT NULL DEFAULT '0',
  `a_send_server` int(3) unsigned NOT NULL DEFAULT '0',
  `a_sender` char(255) NOT NULL DEFAULT '0',
  `a_receive_num` int(3) unsigned NOT NULL DEFAULT '0',
  `a_title` char(255) DEFAULT '0',
  `a_content` tinytext,
  `a_send_date` int(11) NOT NULL DEFAULT '0',
  KEY `a_index` (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_partner_users`
--

CREATE TABLE IF NOT EXISTS `t_partner_users` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_id` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `a_partner_id` varchar(40) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `a_partner_code` char(2) NOT NULL DEFAULT '',
  `a_partner_uid` varchar(40) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_regi_date` datetime DEFAULT '0000-00-00 00:00:00',
  `a_partner_flag` tinyint(3) unsigned DEFAULT '0',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_user_id` (`a_user_id`),
  KEY `a_partner_code` (`a_partner_code`),
  KEY `a_partner_uid` (`a_partner_uid`),
  KEY `a_regi_date` (`a_regi_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_rank`
--

CREATE TABLE IF NOT EXISTS `t_rank` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_name` char(30) NOT NULL DEFAULT '0',
  `a_char_idx` int(11) unsigned DEFAULT '0',
  `a_server` tinyint(3) NOT NULL DEFAULT '0',
  `a_rank` tinyint(2) unsigned DEFAULT '0',
  `a_race` tinyint(2) unsigned DEFAULT '0',
  `a_bp_point` int(11) unsigned DEFAULT '0',
  `a_cp_point` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_unstuck`
--

CREATE TABLE IF NOT EXISTS `t_unstuck` (
  `a_idname` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`a_idname`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_users`
--

CREATE TABLE IF NOT EXISTS `t_users` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_uidname` varchar(13) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_passwd` varchar(30) DEFAULT NULL,
  `a_2p4p_user_code` int(4) NOT NULL DEFAULT '-1',
  `a_2p4p_user_id` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_turn` char(1) NOT NULL DEFAULT 'N',
  `a_connect` int(11) DEFAULT '-1',
  `a_regi_date` datetime DEFAULT '2001-08-01 10:00:00',
  `a_partner_id` char(2) DEFAULT 'LH',
  `a_enable` int(1) unsigned DEFAULT '1',
  `a_sub_num` int(11) unsigned DEFAULT '0',
  `a_timestamp` int(11) unsigned DEFAULT '0',
  `a_jumin` varchar(15) DEFAULT '000000-0000000',
  `a_birthday` date DEFAULT '0000-00-00',
  `a_birthday_type` char(1) DEFAULT 'P',
  `a_sex` char(1) DEFAULT 'M',
  `a_home_zip` varchar(7) DEFAULT '0',
  `a_home_addr` varchar(150) DEFAULT '0',
  `a_home_phone` varchar(20) DEFAULT '0',
  `a_hp` varchar(20) DEFAULT '0',
  `a_job` varchar(50) DEFAULT '0',
  `a_visit_count` int(11) unsigned DEFAULT '1',
  `a_visit_recent` datetime DEFAULT '0000-00-00 00:00:00',
  `a_mail_flag` char(1) DEFAULT 'Y',
  `a_sms_flag` int(1) unsigned DEFAULT '1',
  `a_accept_parent` char(1) DEFAULT 'Y',
  `a_name` varchar(50) DEFAULT '0',
  `a_email` varchar(50) DEFAULT '0',
  `a_pw_hint` char(2) DEFAULT '0',
  `a_pw_hint_text` varchar(120) DEFAULT '0',
  `a_pw_answer` varchar(150) DEFAULT '0',
  `a_pre_world` int(1) DEFAULT '-1',
  `a_mpass` char(1) DEFAULT 'N',
  `a_special` tinyint(3) unsigned DEFAULT '0',
  `a_mtester` tinyint(1) DEFAULT '0',
  `a_conrecent` bigint(20) unsigned DEFAULT '0',
  `a_grade` int(11) unsigned NOT NULL DEFAULT '2',
  `a_stash_pwd` varchar(8) NOT NULL DEFAULT '0',
  `a_logon_block_time` int(11) unsigned DEFAULT '0',
  `a_bantime` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_potal_id` (`a_2p4p_user_id`),
  UNIQUE KEY `a_idname` (`a_idname`),
  KEY `a_passwd` (`a_passwd`),
  KEY `a_sub_num` (`a_sub_num`),
  KEY `a_name_index` (`a_name`),
  KEY `a_jumin` (`a_jumin`),
  KEY `a_uidname` (`a_uidname`),
  KEY `a_potal_index` (`a_2p4p_user_code`),
  KEY `a_turn` (`a_turn`),
  KEY `a_connect` (`a_connect`),
  KEY `a_regi_date` (`a_regi_date`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `t_users`
--

INSERT INTO `t_users` (`a_index`, `a_idname`, `a_uidname`, `a_passwd`, `a_2p4p_user_code`, `a_2p4p_user_id`, `a_turn`, `a_connect`, `a_regi_date`, `a_partner_id`, `a_enable`, `a_sub_num`, `a_timestamp`, `a_jumin`, `a_birthday`, `a_birthday_type`, `a_sex`, `a_home_zip`, `a_home_addr`, `a_home_phone`, `a_hp`, `a_job`, `a_visit_count`, `a_visit_recent`, `a_mail_flag`, `a_sms_flag`, `a_accept_parent`, `a_name`, `a_email`, `a_pw_hint`, `a_pw_hint_text`, `a_pw_answer`, `a_pre_world`, `a_mpass`, `a_special`, `a_mtester`, `a_conrecent`, `a_grade`, `a_stash_pwd`, `a_logon_block_time`, `a_bantime`) VALUES
(1, NULL, NULL, NULL, 1, 'testreg', 'Y', -1, '2017-01-24 22:54:23', 'LH', 1, 660, 4360, '000000-0000000', '0000-00-00', 'P', 'M', '0', '0', '0', '0', '0', 1, '0000-00-00 00:00:00', 'Y', 1, 'Y', '0', '0', '0', '0', '0', 4, 'N', 0, 0, 0, 2, '0', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `t_users_adultParent`
--

CREATE TABLE IF NOT EXISTS `t_users_adultParent` (
  `a_index` int(12) unsigned NOT NULL AUTO_INCREMENT,
  `a_uidname` varchar(30) NOT NULL DEFAULT '0000',
  `a_parent_name` varchar(50) NOT NULL DEFAULT 'AA',
  `a_parent_jumin` varchar(15) NOT NULL DEFAULT '000000-0000000',
  `a_parent_phone` varchar(30) NOT NULL DEFAULT '000-0000-0000',
  `a_parent_email` varchar(50) DEFAULT '0',
  `a_parent_agree` int(1) NOT NULL DEFAULT '0',
  `a_regi_date` datetime DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_uidname` (`a_uidname`),
  KEY `a_regi_date` (`a_regi_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_users_block`
--

CREATE TABLE IF NOT EXISTS `t_users_block` (
  `a_index` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_idx` int(1) NOT NULL DEFAULT '-1',
  `a_contents` text,
  `a_reason` int(11) NOT NULL DEFAULT '0',
  `a_modify_date` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `a_detail` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_users_delete`
--

CREATE TABLE IF NOT EXISTS `t_users_delete` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `a_delete_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_delete_ip` varchar(15) NOT NULL DEFAULT '127.0.0.1',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `NewIndex` (`a_idname`),
  KEY `NewIndex2` (`a_user_index`,`a_delete_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_users_parent`
--

CREATE TABLE IF NOT EXISTS `t_users_parent` (
  `a_index` int(12) unsigned NOT NULL AUTO_INCREMENT,
  `a_uidname` varchar(30) NOT NULL DEFAULT '',
  `a_parent_name` varchar(50) NOT NULL DEFAULT 'AA',
  `a_parent_jumin` varchar(15) NOT NULL DEFAULT '000000-0000000',
  `a_parent_phone` varchar(30) NOT NULL DEFAULT '000-0000-0000',
  `a_parent_agree` int(1) NOT NULL DEFAULT '0',
  `a_regi_date` datetime DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `a_index` (`a_index`),
  KEY `a_uidname` (`a_uidname`),
  KEY `a_regi_date` (`a_regi_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_users_real`
--

CREATE TABLE IF NOT EXISTS `t_users_real` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT 'abcd',
  `a_real_name` varchar(12) NOT NULL DEFAULT 'BBBB',
  `a_old_name` varchar(12) NOT NULL DEFAULT 'AAAA',
  `a_real_jumin` varchar(15) NOT NULL DEFAULT '000000-0000000',
  `a_old_jumin` varchar(15) NOT NULL DEFAULT '000000-0000000',
  `a_regi_date` datetime NOT NULL DEFAULT '2002-12-19 00:00:00',
  PRIMARY KEY (`a_index`),
  KEY `a_idname` (`a_idname`),
  KEY `a_user_index` (`a_user_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_users_test`
--

CREATE TABLE IF NOT EXISTS `t_users_test` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `a_uidname` varchar(13) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_2p4p_user_code` int(11) unsigned NOT NULL DEFAULT '0',
  `a_2p4p_user_id` varchar(30) DEFAULT NULL,
  `a_turn` char(1) NOT NULL DEFAULT 'N',
  `a_passwd` varchar(30) NOT NULL DEFAULT '',
  `a_connect` int(11) DEFAULT '-1',
  `a_regi_date` datetime DEFAULT '2001-08-01 10:00:00',
  `a_partner_id` char(2) DEFAULT 'LH',
  `a_enable` int(1) unsigned DEFAULT '1',
  `a_sub_num` int(11) unsigned DEFAULT '0',
  `a_timestamp` int(11) unsigned DEFAULT '0',
  `a_jumin` varchar(15) DEFAULT '000000-0000000',
  `a_birthday` date DEFAULT '0000-00-00',
  `a_birthday_type` char(1) DEFAULT 'P',
  `a_sex` char(1) DEFAULT 'M',
  `a_home_zip` varchar(7) DEFAULT '0',
  `a_home_addr` varchar(150) DEFAULT '0',
  `a_home_phone` varchar(20) DEFAULT '0',
  `a_hp` varchar(20) DEFAULT '0',
  `a_job` varchar(50) DEFAULT '0',
  `a_visit_count` int(11) unsigned DEFAULT '1',
  `a_visit_recent` datetime DEFAULT '0000-00-00 00:00:00',
  `a_mail_flag` char(1) DEFAULT 'Y',
  `a_sms_flag` int(1) unsigned DEFAULT '1',
  `a_accept_parent` char(1) DEFAULT 'Y',
  `a_name` varchar(50) DEFAULT '0',
  `a_email` varchar(50) DEFAULT '0',
  `a_pw_hint` char(2) DEFAULT '0',
  `a_pw_hint_text` varchar(120) DEFAULT '0',
  `a_pw_answer` varchar(150) DEFAULT '0',
  `a_pre_world` int(1) DEFAULT '-1',
  `a_mpass` char(1) DEFAULT 'N',
  `a_special` tinyint(3) unsigned DEFAULT '0',
  `a_mtester` tinyint(1) DEFAULT '0',
  `a_conrecent` bigint(20) unsigned DEFAULT '0',
  `a_grade` int(11) unsigned NOT NULL DEFAULT '2',
  PRIMARY KEY (`a_index`),
  UNIQUE KEY `a_idname` (`a_idname`),
  KEY `a_passwd` (`a_passwd`),
  KEY `a_sub_num` (`a_sub_num`),
  KEY `a_name_index` (`a_name`),
  KEY `a_jumin` (`a_jumin`),
  KEY `a_uidname` (`a_uidname`),
  KEY `a_portal_index` (`a_2p4p_user_code`),
  KEY `a_portal_id` (`a_2p4p_user_id`),
  KEY `a_turn` (`a_turn`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
