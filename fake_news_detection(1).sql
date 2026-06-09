-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2026 at 09:12 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fake_news_detection`
--

-- --------------------------------------------------------

--
-- Table structure for table `models`
--

CREATE TABLE `models` (
  `model_id` int(11) NOT NULL,
  `model_name` varchar(100) NOT NULL,
  `version` varchar(20) DEFAULT NULL,
  `algorithm_type` varchar(100) DEFAULT NULL,
  `accuracy` decimal(5,2) DEFAULT NULL,
  `trained_on` date DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `models`
--

INSERT INTO `models` (`model_id`, `model_name`, `version`, `algorithm_type`, `accuracy`, `trained_on`, `status`, `created_at`) VALUES
(1, 'Fake News Detector', 'v1.0', 'Logistic Regression', 91.30, '0000-00-00', 'active', '2026-04-28 10:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `news_items`
--

CREATE TABLE `news_items` (
  `news_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `source` varchar(150) DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `date_published` date DEFAULT NULL,
  `uploaded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `news_items`
--

INSERT INTO `news_items` (`news_id`, `title`, `content`, `source`, `language`, `date_published`, `uploaded_by`, `created_at`) VALUES
(1, 'Botswana News', 'This is a test article about Botswana economy.', 'test.com', NULL, NULL, NULL, '2026-04-28 10:03:06');

-- --------------------------------------------------------

--
-- Table structure for table `predictions`
--

CREATE TABLE `predictions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `text` longtext DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  `confidence` float DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `news_id` int(11) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `predictions`
--

INSERT INTO `predictions` (`id`, `user_id`, `text`, `url`, `source`, `result`, `confidence`, `created_at`, `news_id`, `model_id`) VALUES
(9, 1, 'In a bold new chapter for African cinema, the Africa Magic Viewers’ Choice Awards (AMVCA) has unveiled its nominees for its 11th edition. The announcement, broadcast on Sunday, 23rd March, across Africa Magic channels, marks another milestone in recognising the creative prowess that is reshaping the continent’s film and television landscape.\n\nDr Busola Tejumola, Executive Head of Content and Channels, West Africa at MultiChoice, remarked, “Seeing this year’s nominees is truly inspiring. Each ent', 'https://botswanaunplugged.com/amvca-11-africa-magic-announces-nominees-voting-now-open/', 'botswanaunplugged.com', 'real', 66.86, '2026-04-28 07:12:54', NULL, NULL),
(10, 1, 'In a bold new chapter for African cinema, the Africa Magic Viewers’ Choice Awards (AMVCA) has unveiled its nominees for its 11th edition. The announcement, broadcast on Sunday, 23rd March, across Africa Magic channels, marks another milestone in recognising the creative prowess that is reshaping the continent’s film and television landscape.\n\nDr Busola Tejumola, Executive Head of Content and Channels, West Africa at MultiChoice, remarked, “Seeing this year’s nominees is truly inspiring. Each ent', 'https://botswanaunplugged.com/amvca-11-africa-magic-announces-nominees-voting-now-open/', 'botswanaunplugged.com', 'real', 66.86, '2026-04-28 07:16:44', NULL, NULL),
(11, 1, NULL, NULL, NULL, 'fake', 58.74, '2026-04-28 10:05:15', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL,
  `prediction_id` int(11) NOT NULL,
  `generated_by` int(11) DEFAULT NULL,
  `report_type` varchar(100) DEFAULT NULL,
  `report_details` text DEFAULT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','researcher','user') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'paschalhumble', 'paschalhumble130@gmail.com', 'scrypt:32768:8:1$27aErEwXv4CtG9xH$77b983aaa1c8b95854465be80621aba1d44419bb368ba818b44b4e99a00a1706027803f273fb4089dbffcacb51da50569a5b2d1b166ee9db838c90660d084987', 'user', '2026-03-19 22:04:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `models`
--
ALTER TABLE `models`
  ADD PRIMARY KEY (`model_id`);

--
-- Indexes for table `news_items`
--
ALTER TABLE `news_items`
  ADD PRIMARY KEY (`news_id`),
  ADD KEY `uploaded_by` (`uploaded_by`);

--
-- Indexes for table `predictions`
--
ALTER TABLE `predictions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `news_id` (`news_id`),
  ADD KEY `model_id` (`model_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `prediction_id` (`prediction_id`),
  ADD KEY `generated_by` (`generated_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `models`
--
ALTER TABLE `models`
  MODIFY `model_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `news_items`
--
ALTER TABLE `news_items`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `predictions`
--
ALTER TABLE `predictions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `news_items`
--
ALTER TABLE `news_items`
  ADD CONSTRAINT `news_items_ibfk_1` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `predictions`
--
ALTER TABLE `predictions`
  ADD CONSTRAINT `predictions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `predictions_ibfk_2` FOREIGN KEY (`news_id`) REFERENCES `news_items` (`news_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `predictions_ibfk_3` FOREIGN KEY (`model_id`) REFERENCES `models` (`model_id`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
