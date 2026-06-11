-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2026 at 10:42 PM
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
(1, 'Fake News Detector', 'v1.0', 'Logistic Regression', 91.30, '0000-00-00', 'inactive', '2026-04-28 10:16:25'),
(2, 'Fake News Detector', 'v2.0', 'Logistic Regression', 98.83, '2026-06-07', 'active', '2026-06-08 05:45:07');

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
(11, 1, NULL, NULL, NULL, 'fake', 58.74, '2026-04-28 10:05:15', 1, NULL),
(12, 5, 'The village of fewer than 700 people, according to the last census, is part of Zone 11, the second-largest disease control zone, which covers an area larger than that of Portugal.\n\nOthusitse Tsamaise is one of the devastated farmers who was fast pushed into poverty after his 20 cattle, his only source of income for himself, his family, and relatives, were gunned down in his presence as they were deemed potential carriers of FMD.', 'https://www.mmegi.bw/news/farmer-devastated-as-stray-cow-costs-him-20-cattle/news', 'www.mmegi.bw', 'fake', 52.64, '2026-06-02 11:19:26', NULL, NULL),
(13, 5, 'The village of fewer than 700 people, according to the last census, is part of Zone 11, the second-largest disease control zone, which covers an area larger than that of Portugal.\n\nOthusitse Tsamaise is one of the devastated farmers who was fast pushed into poverty after his 20 cattle, his only source of income for himself, his family, and relatives, were gunned down in his presence as they were deemed potential carriers of FMD.', 'https://www.mmegi.bw/news/farmer-devastated-as-stray-cow-costs-him-20-cattle/news', 'www.mmegi.bw', 'fake', 52.64, '2026-06-02 11:23:01', NULL, NULL),
(14, 5, 'The village of fewer than 700 people, according to the last census, is part of Zone 11, the second-largest disease control zone, which covers an area larger than that of Portugal.\n\nOthusitse Tsamaise is one of the devastated farmers who was fast pushed into poverty after his 20 cattle, his only source of income for himself, his family, and relatives, were gunned down in his presence as they were deemed potential carriers of FMD.', 'https://www.mmegi.bw/news/farmer-devastated-as-stray-cow-costs-him-20-cattle/news', 'www.mmegi.bw', 'fake', 52.64, '2026-06-02 11:23:07', NULL, NULL),
(15, 5, 'The village of fewer than 700 people, according to the last census, is part of Zone 11, the second-largest disease control zone, which covers an area larger than that of Portugal.\n\nOthusitse Tsamaise is one of the devastated farmers who was fast pushed into poverty after his 20 cattle, his only source of income for himself, his family, and relatives, were gunned down in his presence as they were deemed potential carriers of FMD.', 'https://www.mmegi.bw/news/farmer-devastated-as-stray-cow-costs-him-20-cattle/news', 'www.mmegi.bw', 'fake', 52.64, '2026-06-02 11:24:17', NULL, NULL),
(16, 5, 'Only three teams have managed to win the Orange FA Cup since its inception. Orapa United were the first side to lay hands on the trophy before Gaborone United went on a rampage, winning it for three successive times followed by Galaxy in the past two seasons.\r\n\r\nFor Seemo \'16\' Mpatane and his technical squad, FA Cup victory also guarantees continental football in the CAF Confederation Cup and the gaffer can take plenty of credit in how his side ended what could have been a disappointing campaign', NULL, NULL, 'fake', 56.18, '2026-06-02 11:24:25', NULL, NULL),
(17, 5, 'This was revealed by Botswana Investment and Trade Centre’s Chief Operations Officer, Anthony Sefako, last week. Speaking at Thursday’s Botswana-South Africa Business Forum, he said the two economies remain deeply interconnected through banking systems, integrated supply chains, mining operations and broader trade relations. From an annual import bill of approximately US$6.4 billion, 61.3% of imports originate from South Africa, officials revealed. According to Sefako, imports from South Africa ', 'https://www.mmegi.bw/business/botswana-south-africa-trade-reaches-r82bn/news', 'www.mmegi.bw', 'fake', 57.37, '2026-06-02 11:26:00', NULL, NULL),
(18, 5, 'You Cannot Spray Everything. But You Can Do This\n\nMore than a year after Foot and Mouth Disease (FMD) first triggered widespread concern across South Africa and neighbouring countries, the outbreak continues to affect livestock operations unabated. Confirmed new cases have climbed from 932 in March 2026 to 2,034 by 22nd May, now affecting all nine provinces, with KwaZulu-Natal, Free State, and North West among the hardest hit, and cross-border risks with Botswana remaining high.\n\nFor many livest', 'https://lifestyleandtech.co.za/business/article/2026-06-02/foot-and-mouth-disease-biosecurity-is-about-consistency', 'lifestyleandtech.co.za', 'real', 76.41, '2026-06-02 20:25:03', NULL, NULL),
(19, 5, 'You Cannot Spray Everything. But You Can Do This\n\nMore than a year after Foot and Mouth Disease (FMD) first triggered widespread concern across South Africa and neighbouring countries, the outbreak continues to affect livestock operations unabated. Confirmed new cases have climbed from 932 in March 2026 to 2,034 by 22nd May, now affecting all nine provinces, with KwaZulu-Natal, Free State, and North West among the hardest hit, and cross-border risks with Botswana remaining high.\n\nFor many livest', 'https://lifestyleandtech.co.za/business/article/2026-06-02/foot-and-mouth-disease-biosecurity-is-about-consistency', 'lifestyleandtech.co.za', 'real', 76.41, '2026-06-02 20:26:37', NULL, NULL),
(20, 5, 'Foot-and-Mouth Disease : Biosecurity is About Consistency', NULL, NULL, 'fake', 50.42, '2026-06-02 20:43:09', NULL, NULL),
(21, 5, 'You Cannot Spray Everything. But You Can Do This\r\n\r\nMore than a year after Foot and Mouth Disease (FMD) first triggered widespread concern across South Africa and neighbouring countries, the outbreak continues to affect livestock operations unabated. Confirmed new cases have climbed from 932 in March 2026 to 2,034 by 22nd May, now affecting all nine provinces, with KwaZulu-Natal, Free State, and North West among the hardest hit, and cross-border risks with Botswana remaining high.\r\n\r\nFor many li', NULL, NULL, 'real', 71.98, '2026-06-02 20:43:50', NULL, NULL),
(22, 5, '\"As U.S. budget fight looms, Republicans flip their fiscal script\",\"WASHINGTON (Reuters) - The head of a conservative Republican faction in the U.S. Congress, who voted this month for a huge expansion of the national debt to pay for tax cuts, called himself a “fiscal conservative” on Sunday and urged budget restraint in 2018. In keeping with a sharp pivot under way among Republicans, U.S. Representative Mark Meadows, speaking on CBS’ “Face the Nation,” drew a hard line on federal spending, which', NULL, NULL, 'real', 99.81, '2026-06-08 05:58:15', NULL, NULL),
(23, 5, 'title,text,subject,date\r\n\"As U.S. budget fight looms, Republicans flip their fiscal script\",\"WASHINGTON (Reuters) - The head of a conservative Republican faction in the U.S. Congress, who voted this month for a huge expansion of the national debt to pay for tax cuts, called himself a “fiscal conservative” on Sunday and urged budget restraint in 2018. In keeping with a sharp pivot under way among Republicans, U.S. Representative Mark Meadows, speaking on CBS’ “Face the Nation,” drew a hard line o', NULL, NULL, 'real', 99.53, '2026-06-08 06:10:27', NULL, NULL),
(24, 5, 'Donald Trump Sends Out Embarrassing New Year’s Eve Message; This is Disturbing,\"Donald Trump just couldn t wish all Americans a Happy New Year and leave it at that. Instead, he had to give a shout out to his enemies, haters and  the very dishonest fake news media.  The former reality show star had just one job to do and he couldn t do it. As our Country rapidly grows stronger and smarter, I want to wish all of my friends, supporters, enemies, haters, and even the very dishonest Fake News Media, ', NULL, NULL, 'real', 97.22, '2026-06-08 06:12:14', NULL, NULL),
(25, 5, 'Donald Trump Sends Out Embarrassing New Year’s Eve Message; This is Disturbing,\"Donald Trump just couldn t wish all Americans a Happy New Year and leave it at that. Instead, he had to give a shout out to his enemies, haters and  the very dishonest fake news media.  The former reality show star had just one job to do and he couldn t do it. As our Country rapidly grows stronger and smarter, I want to wish all of my friends, supporters, enemies, haters, and even the very dishonest Fake News Media, ', NULL, NULL, 'real', 97.22, '2026-06-08 06:14:37', NULL, NULL),
(26, 5, 'Drunk Bragging Trump Staffer Started Russian Collusion Investigation,\"House Intelligence Committee Chairman Devin Nunes is going to have a bad day. He s been under the assumption, like many of us, that the Christopher Steele-dossier was what prompted the Russia investigation so he s been lashing out at the Department of Justice and the FBI in order to protect Trump. As it happens, the dossier is not what started the investigation, according to documents obtained by the New York Times.Former Trum', NULL, NULL, 'real', 99.66, '2026-06-08 06:14:43', NULL, NULL);

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
(1, 'paschalhumble', 'paschalhumble130@gmail.com', 'scrypt:32768:8:1$27aErEwXv4CtG9xH$77b983aaa1c8b95854465be80621aba1d44419bb368ba818b44b4e99a00a1706027803f273fb4089dbffcacb51da50569a5b2d1b166ee9db838c90660d084987', 'user', '2026-03-19 22:04:32'),
(5, 'bentony', 'bentony779@gmailcom', 'scrypt:32768:8:1$ChedysdkwQuU1C97$ff2c1dc95ac7a141ce332abca2fdb9d1674195219a9057fb69e85f7a7729a7c47051c99b9d75e8b59ed5aa3c7f58a8b8932166d937ac6a2842edd12a65f87932', 'user', '2026-06-02 10:56:36');

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
  MODIFY `model_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `news_items`
--
ALTER TABLE `news_items`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `predictions`
--
ALTER TABLE `predictions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
