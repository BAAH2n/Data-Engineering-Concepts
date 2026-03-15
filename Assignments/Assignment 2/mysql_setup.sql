CREATE DATABASE IF NOT exists assignment_2;
USE assignment_2;

DROP TABLE IF EXISTS calls;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name   VARCHAR(25) NOT NULL,
    team        VARCHAR(25) NOT NULL,
    role        VARCHAR(25) NOT NULL,
    hire_date   DATE NOT NULL
);

CREATE TABLE calls (
    call_id     INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    call_time   DATETIME NOT NULL,
    phone       VARCHAR(20) NOT NULL,
    direction   ENUM('inbound','outbound') NOT NULL,
    status      ENUM('answered','missed','voicemail','dropped') NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Index for incremental loading (watermark on call_time)
CREATE INDEX idx_calls_call_time ON calls(call_time);


INSERT INTO employees (full_name, team, role, hire_date) VALUES
('Olena Kovalenko',   'Tier 1 Support', 'Agent',        '2021-03-15'),
('Dmytro Shevchenko', 'Tier 1 Support', 'Agent',        '2020-07-01'),
('Anna Bondarenko',   'Tier 1 Support', 'Agent',        '2022-01-10'),
('Ivan Melnyk',       'Tier 1 Support', 'Agent',        '2021-09-20'),
('Mariya Tkachenko',  'Tier 1 Support', 'Senior Agent', '2019-05-12'),
('Petro Lysenko',     'Tier 1 Support', 'Agent',        '2023-02-28'),
('Yulia Moroz',       'Tier 1 Support', 'Agent',        '2022-06-15'),
('Serhiy Polishchuk', 'Tier 1 Support', 'Agent',        '2021-11-03'),
('Kateryna Rudenko',  'Tier 1 Support', 'Team Lead',    '2018-04-22'),
('Andriy Savchenko',  'Tier 1 Support', 'Agent',        '2023-08-14'),
('Natalia Marchenko', 'Tier 2 Support', 'Agent',        '2020-02-17'),
('Oleksandr Boyko',   'Tier 2 Support', 'Agent',        '2021-06-30'),
('Iryna Honcharenko', 'Tier 2 Support', 'Senior Agent', '2019-10-05'),
('Viktor Kravchenko', 'Tier 2 Support', 'Agent',        '2022-04-18'),
('Tetiana Oliynyk',   'Tier 2 Support', 'Agent',        '2023-01-09'),
('Mykola Ponomarenko','Tier 2 Support', 'Agent',        '2020-08-25'),
('Oksana Hrytsenko',  'Tier 2 Support', 'Team Lead',    '2018-12-01'),
('Roman Sydorenko',   'Tier 2 Support', 'Agent',        '2021-03-07'),
('Larysa Zaitseva',   'Tier 2 Support', 'Agent',        '2022-09-22'),
('Bohdan Fedorenko',  'Tier 2 Support', 'Senior Agent', '2019-07-14'),
('Svitlana Vasylenko','Tier 3 Support', 'Specialist',   '2018-06-10'),
('Taras Ivanenko',    'Tier 3 Support', 'Specialist',   '2019-01-28'),
('Halyna Kuzma',      'Tier 3 Support', 'Specialist',   '2020-05-03'),
('Vitaliy Petrenko',  'Tier 3 Support', 'Senior Spec.', '2017-11-19'),
('Daryna Stepanenko', 'Tier 3 Support', 'Specialist',   '2021-08-06'),
('Yevhen Romanenko',  'Tier 3 Support', 'Team Lead',    '2017-03-30'),
('Ruslana Zinchenko', 'Tier 3 Support', 'Specialist',   '2022-12-11'),
('Oleg Dmytrenko',    'Tier 3 Support', 'Specialist',   '2023-04-25'),
('Valentyna Klymenko','Tier 3 Support', 'Specialist',   '2020-10-17'),
('Mykhailo Pavlenko', 'Tier 3 Support', 'Senior Spec.', '2018-09-08'),
('Alina Chernysh',    'QA',             'QA Analyst',   '2021-02-14'),
('Stanislav Kozak',   'QA',             'QA Analyst',   '2020-04-09'),
('Diana Reshetnyk',   'QA',             'Senior QA',    '2019-08-21'),
('Artem Bilous',      'QA',             'QA Analyst',   '2022-07-30'),
('Liudmyla Havrysh',  'QA',             'QA Lead',      '2018-01-15'),
('Kostiantyn Tkach',  'Training',       'Trainer',      '2020-11-06'),
('Zhanna Yarosh',     'Training',       'Trainer',      '2021-05-19'),
('Vladyslav Hnatyuk', 'Training',       'Senior Trainer','2019-02-25'),
('Milana Chumak',     'Training',       'Trainer',      '2023-06-12'),
('Denys Korchak',     'Training',       'Training Lead','2017-07-08'),
('Kira Antoniuk',     'Workforce Mgmt', 'WFM Analyst',  '2021-10-01'),
('Maksym Sokolov',    'Workforce Mgmt', 'WFM Analyst',  '2022-03-14'),
('Tamara Bilyk',      'Workforce Mgmt', 'WFM Lead',     '2019-04-27'),
('Ihor Horbachov',    'Workforce Mgmt', 'WFM Analyst',  '2023-09-05'),
('Nadiya Levchenko',  'Operations',     'Ops Manager',  '2017-12-20'),
('Fedir Antonov',     'Operations',     'Ops Analyst',  '2020-06-18'),
('Sofiia Yurchenko',  'Operations',     'Ops Analyst',  '2021-07-23'),
('Heorhiy Dubov',     'Operations',     'Ops Lead',     '2018-08-11'),
('Lesya Nesterenko',  'Operations',     'Ops Analyst',  '2022-11-29'),
('Pylyp Mazur',       'Operations',     'Ops Analyst',  '2023-03-17');

INSERT INTO calls (employee_id, call_time, phone, direction, status) VALUES
( 1, '2026-03-15 08:02:14', '+380501234567', 'inbound',  'answered'),
( 3, '2026-03-15 08:07:45', '+380671112233', 'inbound',  'answered'),
( 5, '2026-03-15 08:15:30', '+380931234567', 'outbound', 'answered'),
( 2, '2026-03-15 08:22:10', '+380441234567', 'inbound',  'missed'),
( 8, '2026-03-15 08:35:55', '+380501239876', 'inbound',  'voicemail'),
( 4, '2026-03-15 08:41:02', '+380671119988', 'outbound', 'answered'),
(11, '2026-03-15 08:48:33', '+380935556677', 'inbound',  'answered'),
( 7, '2026-03-15 08:55:19', '+380442223344', 'inbound',  'dropped'),
( 9, '2026-03-15 09:03:22', '+380509876543', 'inbound',  'answered'),
(12, '2026-03-15 09:11:05', '+380679998877', 'outbound', 'answered'),
( 6, '2026-03-15 09:18:47', '+380937776655', 'inbound',  'answered'),
(14, '2026-03-15 09:25:31', '+380443334455', 'inbound',  'missed'),
( 1, '2026-03-15 09:33:58', '+380505554433', 'outbound', 'answered'),
(15, '2026-03-15 09:42:14', '+380672221100', 'inbound',  'voicemail'),
(10, '2026-03-15 09:51:09', '+380938889900', 'inbound',  'answered'),
(21, '2026-03-15 10:05:16', '+380507771122', 'inbound',  'answered'),
(22, '2026-03-15 10:12:44', '+380673334455', 'outbound', 'answered'),
( 3, '2026-03-15 10:20:08', '+380939991122', 'inbound',  'dropped'),
(13, '2026-03-15 10:28:37', '+380445556677', 'inbound',  'answered'),
( 5, '2026-03-15 10:35:55', '+380508887766', 'outbound', 'answered'),
(16, '2026-03-15 10:43:21', '+380676665544', 'inbound',  'missed'),
(18, '2026-03-15 10:52:40', '+380934443322', 'inbound',  'answered'),
(25, '2026-03-15 11:01:33', '+380502223311', 'inbound',  'answered'),
(27, '2026-03-15 11:09:17', '+380678887799', 'outbound', 'voicemail'),
(30, '2026-03-15 11:18:45', '+380936661188', 'inbound',  'answered'),
(20, '2026-03-15 11:26:02', '+380441117722', 'inbound',  'answered'),
(19, '2026-03-15 11:34:28', '+380509993344', 'outbound', 'answered'),
(24, '2026-03-15 11:42:51', '+380674442266', 'inbound',  'dropped'),
(11, '2026-03-15 11:50:14', '+380935558899', 'inbound',  'answered'),
( 2, '2026-03-15 11:58:39', '+380447773311', 'outbound', 'answered');