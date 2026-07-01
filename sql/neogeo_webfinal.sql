-- phpMyAdmin SQL Dump
-- version 4.0.10.18
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 24, 2017 at 11:44 PM
-- Server version: 5.1.73
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `neogeo_web`
--

-- --------------------------------------------------------

--
-- Table structure for table `t_adminactionlog`
--

CREATE TABLE IF NOT EXISTS `t_adminactionlog` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_gm` varchar(50) NOT NULL DEFAULT '',
  `a_ip` varchar(15) NOT NULL DEFAULT '',
  `a_hostname` varchar(100) NOT NULL DEFAULT '',
  `a_time` int(10) NOT NULL DEFAULT '0',
  `a_action` text NOT NULL,
  PRIMARY KEY (`a_index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_admininfo`
--

CREATE TABLE IF NOT EXISTS `t_admininfo` (
  `a_index` int(10) NOT NULL AUTO_INCREMENT,
  `a_username` varchar(50) NOT NULL DEFAULT '',
  `a_password` varchar(50) NOT NULL DEFAULT '',
  `a_displayname` varchar(50) NOT NULL DEFAULT '',
  `a_rights` int(11) NOT NULL DEFAULT '0',
  `a_role` int(11) NOT NULL DEFAULT '0',
  `a_enable` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=67 ;

--
-- Dumping data for table `t_admininfo`
--

INSERT INTO `t_admininfo` (`a_index`, `a_username`, `a_password`, `a_displayname`, `a_rights`, `a_role`, `a_enable`) VALUES
(1, 'admin', '07fbe9538396b773c91ae0fb38eecc72', 'Administrator', 2147483647, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_adminlog`
--

CREATE TABLE IF NOT EXISTS `t_adminlog` (
  `a_index` int(10) NOT NULL AUTO_INCREMENT,
  `a_admin` varchar(50) NOT NULL DEFAULT '0',
  `a_time` int(11) NOT NULL DEFAULT '0',
  `a_ip` varchar(50) NOT NULL DEFAULT '0',
  `a_hostname` varchar(50) DEFAULT '',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_banlist`
--

CREATE TABLE IF NOT EXISTS `t_banlist` (
  `a_index` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) unsigned NOT NULL,
  `a_timestamp` int(11) unsigned NOT NULL,
  `a_reason` varchar(255) NOT NULL,
  `a_admin_name` varchar(255) NOT NULL,
  `a_action` varchar(50) NOT NULL,
  `a_bantime` varchar(50) DEFAULT '',
  `a_gmreason` varchar(255) DEFAULT '',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_donate_log`
--

CREATE TABLE IF NOT EXISTS `t_donate_log` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(10) unsigned DEFAULT '0',
  `a_timestamp` int(10) unsigned DEFAULT '0',
  `a_euro` varchar(50) DEFAULT '0',
  `a_points` int(10) DEFAULT '0',
  `a_gm` varchar(50) DEFAULT NULL,
  `a_ref` varchar(100) DEFAULT '',
  `a_reason` varchar(100) DEFAULT '',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_emails`
--

CREATE TABLE IF NOT EXISTS `t_emails` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_email` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_failedadminlogin`
--

CREATE TABLE IF NOT EXISTS `t_failedadminlogin` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `a_username` varchar(50) NOT NULL DEFAULT '0',
  `a_password` varchar(50) NOT NULL DEFAULT '0',
  `a_ip` varchar(50) NOT NULL DEFAULT '0',
  `a_hostname` varchar(100) NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_giveitemlog`
--

CREATE TABLE IF NOT EXISTS `t_giveitemlog` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_user_idx` int(11) NOT NULL DEFAULT '-1',
  `a_item_idx` int(11) NOT NULL DEFAULT '0',
  `a_plus` int(11) NOT NULL DEFAULT '0',
  `a_count` int(11) NOT NULL DEFAULT '1',
  `a_time` int(11) NOT NULL DEFAULT '0',
  `a_ip` varchar(15) NOT NULL DEFAULT '',
  `a_reason` varchar(255) NOT NULL DEFAULT '',
  `a_gm` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_levelevent_valiant`
--

CREATE TABLE IF NOT EXISTS `t_levelevent_valiant` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_user_idx` int(11) NOT NULL DEFAULT '-1',
  `a_char_idx` int(11) NOT NULL DEFAULT '-1',
  `a_char_name` varchar(50) NOT NULL DEFAULT '',
  `a_char_level` int(11) NOT NULL DEFAULT '0',
  `a_char_race` int(11) NOT NULL DEFAULT '-1',
  `a_taken` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_log`
--

CREATE TABLE IF NOT EXISTS `t_log` (
  `a_index` int(10) NOT NULL AUTO_INCREMENT,
  `a_admin` int(10) NOT NULL DEFAULT '0',
  `a_ip` varchar(16) NOT NULL DEFAULT '',
  `a_host` varchar(255) NOT NULL DEFAULT '',
  `a_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `a_user_idx` int(10) NOT NULL DEFAULT '-1',
  `a_char_idx` int(10) NOT NULL DEFAULT '-1',
  `a_type` varchar(255) NOT NULL,
  `a_action` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_logfind`
--

CREATE TABLE IF NOT EXISTS `t_logfind` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_status` int(11) NOT NULL DEFAULT '0',
  `a_gm` varchar(50) NOT NULL DEFAULT '',
  `a_search` varchar(100) NOT NULL DEFAULT '',
  `a_url` varchar(255) NOT NULL DEFAULT '',
  `a_filesize` int(11) NOT NULL DEFAULT '0',
  `a_password` varchar(12) NOT NULL DEFAULT '',
  `a_date_add` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `a_date_finish` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_loginfail`
--

CREATE TABLE IF NOT EXISTS `t_loginfail` (
  `a_ip` varchar(15) NOT NULL DEFAULT '',
  `a_time` int(11) NOT NULL DEFAULT '0',
  `a_step` int(1) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_mailchange`
--

CREATE TABLE IF NOT EXISTS `t_mailchange` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '-1',
  `a_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `a_newmail` varchar(50) NOT NULL DEFAULT '',
  `a_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_onlinecount`
--

CREATE TABLE IF NOT EXISTS `t_onlinecount` (
  `a_index` int(11) NOT NULL AUTO_INCREMENT,
  `a_timestamp` int(11) NOT NULL DEFAULT '0',
  `a_total` int(11) NOT NULL DEFAULT '0',
  `a_chan1` int(11) NOT NULL DEFAULT '0',
  `a_chan2` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Online players per hour' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_requestpass`
--

CREATE TABLE IF NOT EXISTS `t_requestpass` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_username` varchar(30) NOT NULL DEFAULT '',
  `a_code` varchar(12) NOT NULL DEFAULT '',
  `a_addtime` int(11) unsigned NOT NULL DEFAULT '0',
  `a_used` int(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_roles`
--

CREATE TABLE IF NOT EXISTS `t_roles` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_name` varchar(50) NOT NULL DEFAULT '',
  `a_rights` varchar(200) NOT NULL DEFAULT '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  `a_color` varchar(6) NOT NULL DEFAULT '000000',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `t_roles`
--

INSERT INTO `t_roles` (`a_index`, `a_name`, `a_rights`, `a_color`) VALUES
(1, 'Administrator', '11111111111111111111111111111111111111111111111111111111111111111111000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'FF0000'),
(2, 'Head GameMaster', '11111111111011111111111111111011111111111111111111111111110111000100100011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'FFF947'),
(3, 'GameMaster', '11111101001000000000000000001010110100101110110011111111100010000100010011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '0A7CFF'),
(4, 'Trial GameMaster', '11100100000000000000000000000010100100101010110001001100100000000100001011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '6C89AB'),
(7, 'Full GameMaster', '11111111111010001001000000001010111100101110110111111111100110000100010011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'FA7CFF');

-- --------------------------------------------------------

--
-- Table structure for table `t_unstuck_log`
--

CREATE TABLE IF NOT EXISTS `t_unstuck_log` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(11) NOT NULL DEFAULT '-1',
  `a_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `a_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_usernote`
--

CREATE TABLE IF NOT EXISTS `t_usernote` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_user_index` int(10) unsigned NOT NULL DEFAULT '0',
  `a_gm` varchar(50) NOT NULL DEFAULT '',
  `a_note` text NOT NULL,
  `a_timestamp` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`a_index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `t_user_validation`
--

CREATE TABLE IF NOT EXISTS `t_user_validation` (
  `a_index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_username` varchar(16) NOT NULL DEFAULT '',
  `a_password` varchar(32) NOT NULL DEFAULT '',
  `a_email` varchar(200) NOT NULL DEFAULT '',
  `a_securitycode` char(4) NOT NULL DEFAULT '0000',
  `a_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `a_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `a_validationcode` varchar(128) NOT NULL DEFAULT '',
  `a_for_reg` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`a_index`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DELIMITER $$
--
-- Events
--
CREATE EVENT `PlayerOnlineCount` ON SCHEDULE EVERY 1 HOUR STARTS '2016-01-12 17:57:13' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
	INSERT INTO neogeo_web.t_onlinecount(a_total, a_chan1, a_chan2, a_timestamp) VALUES(
	  (SELECT count(*) FROM kor_ndev_neogeo_user.t_users WHERE a_connect != -1),
	  (SELECT count(*) FROM kor_ndev_neogeo_user.t_users WHERE a_connect != -1 AND a_sub_num = 660),
	  (SELECT count(*) FROM kor_ndev_neogeo_user.t_users WHERE a_connect != -1 AND a_sub_num = 661),
	UNIX_TIMESTAMP()
	);
END$$

CREATE EVENT `AutoCloseTicket` ON SCHEDULE EVERY 1 DAY STARTS '2015-11-10 14:10:36' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
	UPDATE t_requestpass SET a_used = 3 WHERE a_addtime < (UNIX_TIMESTAMP() - (60*60*24*3)) AND a_used = 0;
	DELETE FROM t_user_validation WHERE UNIX_TIMESTAMP(a_time) < (UNIX_TIMESTAMP() - (60*60*24*7));	
END$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
