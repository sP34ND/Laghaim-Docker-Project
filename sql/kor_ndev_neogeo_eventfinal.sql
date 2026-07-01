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
-- Database: `kor_ndev_neogeo_event`
--

-- --------------------------------------------------------

--
-- Table structure for table `11year_event`
--

CREATE TABLE IF NOT EXISTS `11year_event` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_count` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest5` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_2p4p_user_code`,`a_char_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `12year_event`
--

CREATE TABLE IF NOT EXISTS `12year_event` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_count` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest5` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_2p4p_user_code`,`a_char_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event`
--

CREATE TABLE IF NOT EXISTS `bg_game_event` (
  `idx` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `game_money` bigint(8) unsigned DEFAULT '0',
  `chk_use` char(1) NOT NULL DEFAULT 'N',
  `get_date` datetime DEFAULT NULL,
  `join_game_type` char(2) NOT NULL DEFAULT '24',
  `bg_game_type` smallint(2) unsigned NOT NULL DEFAULT '0',
  `update_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`idx`),
  KEY `bg_game_event_user_code_idx` (`user_code`),
  KEY `bg_game_event_chk_use_idx` (`chk_use`),
  KEY `bg_game_event_bg_game_type` (`bg_game_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='11¿ù ÀÌÈÄ bg_game_event_goods »ç¿ë- ÀÌÆÇ»çÆÇ °ÔÀÓ¸Ó´Ï Áö±Þ' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_card`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_card` (
  `ecard_idx` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `ecard_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `ecard_card_number` smallint(2) unsigned NOT NULL DEFAULT '0',
  `ecard_site_code` char(2) NOT NULL DEFAULT '24',
  `ecard_chk_use` char(1) NOT NULL DEFAULT 'N',
  `ecard_use_kind` varchar(10) DEFAULT NULL,
  `ecard_update_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ecard_idx`),
  KEY `bg_game_event_card_user_code` (`ecard_user_code`),
  KEY `bg_game_event_card_chk_use` (`ecard_chk_use`),
  KEY `bg_game_event_card_card_number` (`ecard_card_number`),
  KEY `bg_game_event_card_ecard_site_code` (`ecard_site_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='2ÆÇ»çÆÇ °ÔÀÓ - Ä«µå ¸ðÀ¸±â' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_goods`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_goods` (
  `egoods_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `egoods_user_code` int(11) unsigned NOT NULL DEFAULT '0',
  `egoods_site_code` varchar(6) NOT NULL DEFAULT '24',
  `egoods_item_no` int(11) DEFAULT NULL,
  `egoods_cnt` bigint(10) unsigned NOT NULL DEFAULT '0',
  `egoods_org_cnt` bigint(10) unsigned NOT NULL DEFAULT '0',
  `egoods_enable` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `egoods_create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `egoods_use_date` datetime DEFAULT '0000-00-00 00:00:00',
  `egoods_give_place` varchar(10) NOT NULL DEFAULT 'web',
  `egoods_event_name` varchar(15) NOT NULL DEFAULT 'CARD',
  PRIMARY KEY (`egoods_index`),
  KEY `idx_user_code` (`egoods_user_code`,`egoods_site_code`,`egoods_enable`),
  KEY `idx_date` (`egoods_create_date`),
  KEY `egoods_event_name` (`egoods_event_name`),
  KEY `IDX_CreateDate_EventName` (`egoods_create_date`,`egoods_event_name`),
  KEY `idx_enable` (`egoods_site_code`,`egoods_enable`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='°¢ °ÔÀÓº° Áö±Þ »óÇ°' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_item`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_item` (
  `eitem_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `eitem_site_code` varchar(6) NOT NULL DEFAULT '',
  `eitem_item_no` int(10) unsigned NOT NULL DEFAULT '0',
  `eitem_item_name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`eitem_index`),
  KEY `idx_event_item` (`eitem_item_no`,`eitem_site_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='°¢ °ÔÀÓº° »óÇ°  ÄÚµå' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_lhp_day`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_lhp_day` (
  `event_idx` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `event_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `event_day_count` int(4) unsigned NOT NULL DEFAULT '0',
  `event_day_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`event_idx`),
  KEY `bg_game_event_lhp_day_event_user_code` (`event_user_code`),
  KEY `bg_game_event_lhp_day_event_lhp_day_count` (`event_day_count`),
  KEY `bg_game_event_lhp_day_bg_game_event_lhp_date` (`event_day_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='¶ó±×ÇÏÀÓ¹è ¸Â°í ÀÌº¥Æ® - ÇÏ·ç LHP' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_lhp_total`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_lhp_total` (
  `event_idx` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `event_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `event_total_count` int(4) unsigned NOT NULL DEFAULT '0',
  `event_update_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`event_idx`),
  KEY `bg_game_event_lhp_total_event_user_code` (`event_user_code`),
  KEY `event_total_count` (`event_total_count`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='¶ó±×ÇÏÀÓ¹è ¸Â°í ÀÌº¥Æ® - ÅäÅ» LHP' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_log`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_log` (
  `idx` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `category` smallint(1) unsigned NOT NULL DEFAULT '1',
  `money` bigint(8) unsigned NOT NULL DEFAULT '0',
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`idx`),
  UNIQUE KEY `idx` (`idx`),
  KEY `user_code_idx` (`user_code`),
  KEY `category_idx` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_event_rank`
--

CREATE TABLE IF NOT EXISTS `bg_game_event_rank` (
  `erank_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `erank_event_kind` int(4) unsigned NOT NULL DEFAULT '1',
  `erank_rank` int(4) unsigned NOT NULL DEFAULT '0',
  `erank_user_code` int(11) unsigned NOT NULL DEFAULT '0',
  `erank_user_id` varchar(20) DEFAULT '1',
  `erank_nickname` varchar(30) DEFAULT '1',
  `erank_sex` char(1) DEFAULT 'M',
  `erank_game_level` int(4) unsigned DEFAULT '0',
  `erank_money` bigint(8) unsigned DEFAULT '0',
  `erank_event_point` int(11) unsigned DEFAULT '0',
  `erank_regi_date` datetime NOT NULL DEFAULT '2005-10-19 00:00:00',
  PRIMARY KEY (`erank_index`),
  KEY `idx_event_rank` (`erank_event_kind`,`erank_user_code`),
  KEY `idx_event_rank_level` (`erank_rank`,`erank_event_point`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='ÀÌº¥Æ® - ·©Å·' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_itemupgrade_rank`
--

CREATE TABLE IF NOT EXISTS `bg_game_itemupgrade_rank` (
  `idx` int(11) NOT NULL AUTO_INCREMENT,
  `server_name` varchar(30) NOT NULL DEFAULT '',
  `char_idx` int(11) NOT NULL DEFAULT '0',
  `char_name` varchar(30) NOT NULL DEFAULT '',
  `item_position` int(11) NOT NULL DEFAULT '0',
  `item_idx` int(11) NOT NULL DEFAULT '0',
  `upgrade_count` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`idx`),
  KEY `idx_item_upgrade` (`char_idx`,`item_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_game_mileage_item`
--

CREATE TABLE IF NOT EXISTS `bg_game_mileage_item` (
  `mitem_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mitem_site_code` varchar(6) NOT NULL DEFAULT '',
  `mitem_item_no` int(10) unsigned NOT NULL DEFAULT '0',
  `mitem_item_name` varchar(30) NOT NULL DEFAULT '',
  `mitem_mileage` int(10) unsigned NOT NULL DEFAULT '0',
  `mitem_enable` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`mitem_index`),
  KEY `idx_event_item` (`mitem_item_no`,`mitem_site_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_laghaim_event_recommend`
--

CREATE TABLE IF NOT EXISTS `bg_laghaim_event_recommend` (
  `recom_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `recom_regist_2p4p_ucode` int(4) unsigned DEFAULT NULL,
  `recom_regist_lag_ucode` int(4) unsigned DEFAULT NULL,
  `recom_regist_idname` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `recom_recom_2p4p_ucode` int(4) unsigned DEFAULT NULL,
  `recom_recom_lag_ucode` int(4) unsigned DEFAULT NULL,
  `recom_recom_idname` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `recom_event_type` varchar(5) DEFAULT NULL,
  `recom_regist_date` datetime DEFAULT NULL,
  `recom_generate_lp` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`recom_index`),
  KEY `date_2p4pucode` (`recom_regist_date`,`recom_recom_2p4p_ucode`,`recom_event_type`),
  KEY `date_2p4pucode2` (`recom_regist_date`,`recom_regist_2p4p_ucode`,`recom_event_type`),
  KEY `IDX_RegistDate_RecomIdname` (`recom_recom_idname`,`recom_regist_date`,`recom_event_type`),
  KEY `IDX_RegistDate_RegistIdName` (`recom_regist_idname`,`recom_regist_date`,`recom_event_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_laghaim_event_skt`
--

CREATE TABLE IF NOT EXISTS `bg_laghaim_event_skt` (
  `eskt_index` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `eskt_memb_index` int(11) unsigned NOT NULL DEFAULT '0',
  `eskt_game_index` int(11) unsigned NOT NULL DEFAULT '0',
  `eskt_partner_id` varchar(15) NOT NULL DEFAULT '0',
  `eskt_site_id` varchar(15) NOT NULL DEFAULT '',
  `eskt_ok_count` tinyint(1) unsigned NOT NULL DEFAULT '2',
  `eskt_ok_tcount` int(4) unsigned NOT NULL DEFAULT '0',
  `eskt_phone` varchar(15) NOT NULL DEFAULT '000-0000-0000',
  `eskt_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`eskt_index`),
  KEY `eskt_memb_index` (`eskt_memb_index`,`eskt_game_index`,`eskt_partner_id`,`eskt_site_id`,`eskt_phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='SKT ÀÌº¥Æ®' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bg_school_live`
--

CREATE TABLE IF NOT EXISTS `bg_school_live` (
  `slive_index` int(11) unsigned NOT NULL DEFAULT '0',
  `slive_sinfo_index` int(10) unsigned NOT NULL DEFAULT '0',
  `slive_name` varchar(40) NOT NULL DEFAULT '',
  `slive_grade` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `slive_class` varchar(20) NOT NULL DEFAULT '0',
  `slive_count_event` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`slive_index`),
  KEY `idx_slive` (`slive_sinfo_index`,`slive_class`,`slive_grade`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bg_ssawar_count`
--

CREATE TABLE IF NOT EXISTS `bg_ssawar_count` (
  `scount_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `scount_event_name` varchar(30) NOT NULL DEFAULT 'star',
  `scount_userCode` int(11) NOT NULL DEFAULT '0',
  `scount_items` varchar(15) NOT NULL DEFAULT 'star',
  `scount_count` int(11) unsigned NOT NULL DEFAULT '0',
  `scount_count_use` int(11) unsigned NOT NULL DEFAULT '0',
  `scount_date` date NOT NULL DEFAULT '2006-04-20',
  PRIMARY KEY (`scount_index`),
  KEY `scount_group` (`scount_event_name`,`scount_userCode`,`scount_items`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Chuseok201309`
--

CREATE TABLE IF NOT EXISTS `Chuseok201309` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_quest_index0` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count0` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count4` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_2p4p_user_code`,`a_char_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Chuseok201309_Rank`
--

CREATE TABLE IF NOT EXISTS `Chuseok201309_Rank` (
  `no` int(4) unsigned NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `quest` int(11) unsigned NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Event_13year_hunt`
--

CREATE TABLE IF NOT EXISTS `Event_13year_hunt` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_quest_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`),
  KEY `index` (`a_user_index`,`a_server`,`a_char_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Event_20131008_hunt`
--

CREATE TABLE IF NOT EXISTS `Event_20131008_hunt` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_quest_index0` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count0` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_min_quest_count` int(11) unsigned NOT NULL DEFAULT '0',
  `a_hunt1_totalpoint` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_2p4p_user_code`,`a_char_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Event_20131008_hunt_item`
--

CREATE TABLE IF NOT EXISTS `Event_20131008_hunt_item` (
  `idx` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `itemtype` char(1) DEFAULT NULL,
  `point` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Event_20131211_hunt`
--

CREATE TABLE IF NOT EXISTS `Event_20131211_hunt` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_quest_index0` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count0` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_index4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest_count4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_min_quest_count` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_2p4p_user_code`,`a_char_index`),
  KEY `a_char_index` (`a_char_index`),
  KEY `a_2p4p_user_code` (`a_2p4p_user_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Event_20140108_Yut`
--

CREATE TABLE IF NOT EXISTS `Event_20140108_Yut` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_postion_now` int(11) unsigned DEFAULT '0',
  `a_success_count` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_char_index`),
  KEY `a_user_index` (`a_user_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Event_20140709_Mad`
--

CREATE TABLE IF NOT EXISTS `Event_20140709_Mad` (
  `a_user_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_complet` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `a_one_day_view` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `a_name` char(20) DEFAULT '0',
  UNIQUE KEY `a_user_index` (`a_user_index`),
  KEY `a_user_index_2` (`a_user_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `hunt201306`
--

CREATE TABLE IF NOT EXISTS `hunt201306` (
  `a_index` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) unsigned NOT NULL DEFAULT '0',
  `a_server` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(11) unsigned NOT NULL DEFAULT '0',
  `a_char_name` char(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `a_lastdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `a_count` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest1` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest2` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest3` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest4` int(11) unsigned NOT NULL DEFAULT '0',
  `a_quest5` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`,`a_2p4p_user_code`,`a_char_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPaymentLGAConfirmLog`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPaymentLGAConfirmLog` (
  `lcl_idx` mediumint(3) unsigned NOT NULL AUTO_INCREMENT,
  `lcl_user_idx` int(11) NOT NULL DEFAULT '0',
  `lcl_lag_user_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `lcl_user_id` varchar(30) NOT NULL DEFAULT '',
  `lcl_user_name` varchar(30) NOT NULL DEFAULT '0',
  `lcl_payment_code` varchar(5) NOT NULL DEFAULT '',
  `lcl_payment_method` varchar(5) NOT NULL DEFAULT '',
  `lcl_lga_payment_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `lcl_lga_confirm_result` varchar(5) NOT NULL DEFAULT '',
  `lcl_regdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`lcl_idx`),
  KEY `IDX_RegDate_UserIdx_UserId_PaymentCode` (`lcl_regdate`,`lcl_user_idx`,`lcl_user_id`,`lcl_payment_code`),
  KEY `IDX_LgaPaymentIdx` (`lcl_lga_payment_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPaymentLog`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPaymentLog` (
  `lpl_idx` mediumint(3) unsigned NOT NULL AUTO_INCREMENT,
  `lpl_user_idx` int(11) NOT NULL DEFAULT '0',
  `lpl_lag_user_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `lpl_user_id` varchar(30) NOT NULL DEFAULT '',
  `lpl_user_name` varchar(30) NOT NULL DEFAULT '0',
  `lpl_payment_code` varchar(5) NOT NULL DEFAULT '',
  `lpl_payment_method` varchar(5) NOT NULL DEFAULT '',
  `lpl_lga_payment_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `lpl_regdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`lpl_idx`),
  UNIQUE KEY `UNQ_LGAPaymentIdx` (`lpl_lga_payment_idx`),
  KEY `IDX_RegDate_UserIdx_UserId_PaymentCode` (`lpl_regdate`,`lpl_user_idx`,`lpl_user_id`,`lpl_payment_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='¶ó±×ÇÏÀÓ °áÁ¦ ·Î±× (2013-03-07 ½ÃÀÛ)' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointGoods`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointGoods` (
  `lpi_idx` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `lpi_item_code` varchar(4) NOT NULL DEFAULT '',
  `lpi_dorm_code` varchar(6) NOT NULL DEFAULT '',
  `lpi_goods_type` varchar(10) NOT NULL DEFAULT '',
  `lpi_item_name` varchar(30) NOT NULL DEFAULT '',
  `lpi_item_laghaim_point` smallint(3) NOT NULL DEFAULT '0',
  `lpi_item_laghaim_point_max` smallint(5) unsigned NOT NULL DEFAULT '0',
  `lpi_made_up_name_1` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_1` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_1` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_2` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_2` smallint(3) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_2` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_3` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_3` smallint(3) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_3` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_4` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_4` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_4` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_5` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_5` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_5` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_6` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_6` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_6` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_7` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_7` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_7` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_8` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_8` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_8` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_9` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_9` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_9` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_10` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_10` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_10` tinyint(3) unsigned DEFAULT NULL,
  `lpi_desc` varchar(255) DEFAULT NULL,
  `lpi_fluctuation_type` enum('PLUS','MINUS','ZERO') NOT NULL DEFAULT 'ZERO',
  PRIMARY KEY (`lpi_idx`),
  UNIQUE KEY `UNQ_ItemCode` (`lpi_item_code`),
  KEY `IDX_ItemCode` (`lpi_item_code`,`lpi_item_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='¶ó±×ÇÏÀÓ °áÁ¦ »óÇ° ±¸ºÐ ÄÚµå' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointGoods_copy`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointGoods_copy` (
  `lpi_idx` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `lpi_item_code` varchar(4) NOT NULL DEFAULT '',
  `lpi_dorm_code` varchar(6) NOT NULL DEFAULT '',
  `lpi_goods_type` varchar(10) NOT NULL DEFAULT '',
  `lpi_item_name` varchar(30) NOT NULL DEFAULT '',
  `lpi_item_laghaim_point` smallint(3) NOT NULL DEFAULT '0',
  `lpi_item_laghaim_point_max` smallint(5) unsigned NOT NULL DEFAULT '0',
  `lpi_made_up_name_1` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_1` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_1` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_2` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_2` smallint(3) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_2` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_3` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_3` smallint(3) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_3` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_4` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_4` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_4` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_5` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_5` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_5` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_6` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_6` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_6` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_7` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_7` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_7` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_8` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_8` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_8` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_9` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_9` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_9` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_10` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_10` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_10` tinyint(3) unsigned DEFAULT NULL,
  `lpi_desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`lpi_idx`),
  UNIQUE KEY `UNQ_ItemCode` (`lpi_item_code`),
  KEY `IDX_ItemCode` (`lpi_item_code`,`lpi_item_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointGoods_datetime`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointGoods_datetime` (
  `idx` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `lpi_idx` int(4) unsigned NOT NULL DEFAULT '0',
  `in_userid` varchar(30) NOT NULL DEFAULT '',
  `in_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `up_userid` varchar(30) NOT NULL DEFAULT '',
  `up_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointGoods_Dev`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointGoods_Dev` (
  `lpi_idx` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `lpi_item_code` varchar(4) NOT NULL DEFAULT '',
  `lpi_dorm_code` varchar(6) NOT NULL DEFAULT '',
  `lpi_goods_type` varchar(10) NOT NULL DEFAULT '',
  `lpi_item_name` varchar(30) NOT NULL DEFAULT '',
  `lpi_item_laghaim_point` smallint(3) NOT NULL DEFAULT '0',
  `lpi_item_laghaim_point_max` smallint(5) unsigned NOT NULL DEFAULT '0',
  `lpi_made_up_name_1` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_1` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_1` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_2` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_2` smallint(3) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_2` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_3` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_3` smallint(3) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_3` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_4` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_4` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_4` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_5` varchar(50) DEFAULT NULL,
  `lpi_made_up_code_5` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_5` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_6` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_6` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_6` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_7` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_7` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_7` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_8` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_8` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_8` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_9` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_9` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_9` tinyint(3) unsigned DEFAULT NULL,
  `lpi_made_up_name_10` varchar(30) DEFAULT NULL,
  `lpi_made_up_code_10` smallint(5) unsigned DEFAULT NULL,
  `lpi_made_up_quantity_10` tinyint(3) unsigned DEFAULT NULL,
  `lpi_desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`lpi_idx`),
  UNIQUE KEY `UNQ_ItemCode` (`lpi_item_code`),
  KEY `IDX_ItemCode` (`lpi_item_code`,`lpi_item_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointGoods_WriteLog`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointGoods_WriteLog` (
  `idx` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lpi_idx` int(11) NOT NULL DEFAULT '0',
  `fuser_id` varchar(30) NOT NULL DEFAULT '',
  `fdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `muser_id` varchar(30) NOT NULL DEFAULT '',
  `mdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`idx`),
  KEY `IDX_LaghaimPointGoods_WriteLog` (`lpi_idx`,`fuser_id`,`muser_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='.... ...... .. (2013-10-21 ..)' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointHistory`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointHistory` (
  `lph_idx` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lph_user_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `lph_user_lag_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `lph_user_idname` varchar(30) NOT NULL DEFAULT '',
  `lph_old_point` mediumint(8) NOT NULL DEFAULT '0',
  `lph_generate_point` mediumint(6) NOT NULL DEFAULT '0',
  `lph_new_point` mediumint(8) NOT NULL DEFAULT '0',
  `lph_point_goods_code` varchar(4) NOT NULL DEFAULT '',
  `lph_recall_admin_info` varchar(150) DEFAULT NULL,
  `lph_generate_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`lph_idx`),
  KEY `IDX_UserIdx_PointGoodsCode_GenerateDate` (`lph_user_idx`,`lph_point_goods_code`,`lph_generate_date`),
  KEY `IDX_PointGoodsCode_GenerateDate` (`lph_point_goods_code`,`lph_generate_date`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='ÇÁ¸®¹Ì¾ö ¼­ºñ½º(Laghaim Point) È÷½ºÅä¸®' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `TBL_LaghaimPointHistory`
--

INSERT INTO `TBL_LaghaimPointHistory` (`lph_idx`, `lph_user_idx`, `lph_user_lag_idx`, `lph_user_idname`, `lph_old_point`, `lph_generate_point`, `lph_new_point`, `lph_point_goods_code`, `lph_recall_admin_info`, `lph_generate_date`) VALUES
(1, 1, 1, 'testreg', 50000, -25000, 25000, 'LH01', NULL, '2017-01-24 23:37:12');

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointRepayJoin`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointRepayJoin` (
  `lpr_user_idx` int(3) unsigned NOT NULL DEFAULT '0',
  `lpr_lag_user_idx` mediumint(9) DEFAULT NULL,
  `lpr_repay_point` mediumint(5) unsigned NOT NULL DEFAULT '0',
  `lpr_goods_code` varchar(15) DEFAULT NULL,
  `lpr_reg_date` datetime DEFAULT NULL,
  KEY `IDX_UserIdx` (`lpr_user_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Laghaim Point È¯ºÒ µ¥ÀÌÅÍ ÀÓ½Ã ÀúÀå¿ë (for L.P °æ¸Å)';

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPointUser`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPointUser` (
  `lpu_idx` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lpu_user_idx` int(11) unsigned NOT NULL DEFAULT '0',
  `lpu_user_lag_idx` int(11) unsigned NOT NULL DEFAULT '0',
  `lpu_user_idname` varchar(30) NOT NULL DEFAULT '',
  `lpu_user_lag_point` int(11) NOT NULL DEFAULT '0',
  `lpu_update_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`lpu_idx`),
  UNIQUE KEY `IDX_UserIdx` (`lpu_user_idx`),
  KEY `IDX_UserIdname` (`lpu_user_idname`),
  KEY `IDX_UserLagIdx` (`lpu_user_lag_idx`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='ÇÁ¸®¹Ì¾ö ¼­ºñ½º(Laghaim Point)' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `TBL_LaghaimPointUser`
--

INSERT INTO `TBL_LaghaimPointUser` (`lpu_idx`, `lpu_user_idx`, `lpu_user_lag_idx`, `lpu_user_idname`, `lpu_user_lag_point`, `lpu_update_date`) VALUES
(1, 1, 0, 'testreg', 25000, '2017-01-24 23:37:12');

-- --------------------------------------------------------

--
-- Table structure for table `TBL_LaghaimPremiumHistory`
--

CREATE TABLE IF NOT EXISTS `TBL_LaghaimPremiumHistory` (
  `lph_idx` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lph_user_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `lph_user_lag_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `lph_user_id` varchar(30) NOT NULL DEFAULT '',
  `lph_user_name` varchar(30) NOT NULL DEFAULT '',
  `lph_goods_code` varchar(4) NOT NULL DEFAULT '',
  `lph_payment_code` char(3) NOT NULL DEFAULT '',
  `lph_lag_payment_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `lph_generate_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`lph_idx`),
  KEY `IDX_UserIdx_PointGoodsCode_GenerateDate` (`lph_user_idx`,`lph_goods_code`,`lph_generate_date`),
  KEY `IDX_LagPaymentIdx` (`lph_lag_payment_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='ÇÁ¸®¹Ì¾ö¼­ºñ½º È÷½ºÅä¸® - Ä³¸¯ÅÍ °èÁ¤ ÀÌµ¿ ¼­ºñ½º' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_PremiumResultHistory`
--

CREATE TABLE IF NOT EXISTS `TBL_PremiumResultHistory` (
  `prh_idx` int(10) NOT NULL AUTO_INCREMENT,
  `prh_th_user_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `prh_th_user_lag_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `prh_th_user_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `prh_tar_user_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `prh_tar_user_lag_idx` int(8) unsigned NOT NULL DEFAULT '0',
  `prh_tar_user_idname` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `prh_modify_before_desc` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `prh_modify_after_desc` varchar(30) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `prh_site_code` enum('LH','LC') NOT NULL DEFAULT 'LH',
  `prh_server` enum('0','1','2','3','4','5','6','7','8') NOT NULL DEFAULT '0',
  `prh_modify_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `prh_give_place` enum('LH','LC','web') NOT NULL DEFAULT 'LH',
  `prh_event_name` enum('none','guild','char','charmove') NOT NULL DEFAULT 'none',
  PRIMARY KEY (`prh_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_TEVE_10YEAR_UserUse`
--

CREATE TABLE IF NOT EXISTS `TBL_TEVE_10YEAR_UserUse` (
  `uul_idx` mediumint(3) unsigned NOT NULL AUTO_INCREMENT,
  `uul_user_code` int(10) unsigned NOT NULL DEFAULT '0',
  `uul_use_cnt` smallint(5) unsigned NOT NULL DEFAULT '0',
  `uul_last_use_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`uul_user_code`),
  KEY `IDX_TblIdx` (`uul_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='10 years' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_TEVE_UserUse`
--

CREATE TABLE IF NOT EXISTS `TBL_TEVE_UserUse` (
  `uul_idx` mediumint(3) unsigned NOT NULL AUTO_INCREMENT,
  `uul_user_code` int(10) unsigned NOT NULL DEFAULT '0',
  `uul_use_cnt` smallint(5) unsigned NOT NULL DEFAULT '0',
  `uul_last_use_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`uul_user_code`),
  KEY `IDX_TblIdx` (`uul_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='5? ??? ? ???? ????' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TBL_Ticket`
--

CREATE TABLE IF NOT EXISTS `TBL_Ticket` (
  `tkt_idx` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `tkt_coupon_no` varchar(20) NOT NULL DEFAULT '',
  `tkt_user_idx` int(10) unsigned DEFAULT NULL,
  `tkt_game_type` char(2) DEFAULT NULL,
  `tkt_used` char(1) NOT NULL DEFAULT 'N',
  `tkt_issue_date` datetime DEFAULT NULL,
  PRIMARY KEY (`tkt_idx`),
  KEY `IDX_UserIdx_GameType` (`tkt_user_idx`,`tkt_game_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='³ð³ð³ð ÀÌº¥Æ®¿ë ¿µÈ­Æ¼ÄÏ ½Ã¸®¾ó' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TEVE_10YEAR`
--

CREATE TABLE IF NOT EXISTS `TEVE_10YEAR` (
  `eve_idx` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eve_get_c` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eve_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='EVE 10YEARS' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TEVE_10YEAR_User`
--

CREATE TABLE IF NOT EXISTS `TEVE_10YEAR_User` (
  `eve_idx` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eve_user_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `eve_user_idname` varchar(30) NOT NULL DEFAULT '',
  `eve_get_c` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eve_idx`),
  UNIQUE KEY `eve_user_idname_idx` (`eve_user_idname`),
  KEY `IDX_UserIdx` (`eve_user_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='10 years' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TEVE_10YEAR_WebUser`
--

CREATE TABLE IF NOT EXISTS `TEVE_10YEAR_WebUser` (
  `eve_idx` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eve_user_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `eve_user_idname` varchar(30) NOT NULL DEFAULT '',
  `eve_get_c` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eve_idx`),
  UNIQUE KEY `eve_user_idname_idx` (`eve_user_idname`),
  KEY `IDX_UserIdx` (`eve_user_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='10 Web years' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `TEVE_User`
--

CREATE TABLE IF NOT EXISTS `TEVE_User` (
  `eve_idx` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eve_user_idx` int(10) unsigned NOT NULL DEFAULT '0',
  `eve_user_idname` varchar(30) NOT NULL DEFAULT '',
  `eve_get_c` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eve_idx`),
  UNIQUE KEY `eve_user_idname_idx` (`eve_user_idname`),
  KEY `IDX_UserIdx` (`eve_user_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='5? ???? ?????DB' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_present85`
--

CREATE TABLE IF NOT EXISTS `t_present85` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_enable` int(11) NOT NULL DEFAULT '1',
  `a_date` date NOT NULL DEFAULT '0000-00-00',
  `a_user_index` int(10) unsigned NOT NULL DEFAULT '0',
  `a_char_index` int(10) unsigned NOT NULL DEFAULT '0',
  `a_vnum` int(10) unsigned NOT NULL DEFAULT '0',
  `a_org_count` int(10) unsigned NOT NULL DEFAULT '1',
  `a_count` int(10) unsigned NOT NULL DEFAULT '1',
  `a_plus` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `a_flag1` int(10) unsigned NOT NULL DEFAULT '0',
  `a_flag2` int(10) unsigned NOT NULL DEFAULT '0',
  `a_flag_ext` varchar(50) NOT NULL DEFAULT '0',
  `a_userdate` date NOT NULL DEFAULT '0000-00-00',
  `a_serv_no` char(1) NOT NULL DEFAULT '0',
  `a_2p4p_user_code` int(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`a_index`),
  KEY `a_index_2` (`a_index`),
  KEY `IDX_UCode_VNum` (`a_2p4p_user_code`,`a_vnum`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Web¿¡¼­ ¾ÆÀÌÅÛ Áö±Þ¿ë-°¢¼­¹ö¿¡ ¼öµ¿À¸·Î Ã³¸®' AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
