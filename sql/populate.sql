--------------------------------------------------
--- Populate the existing tables
--------------------------------------------------

INSERT INTO category VALUES
('Produtos Vegan'),
('Bebidas'),
('Águas'),
('Bolachas'),
('Laticínios'),
('Refrigerantes'),
('Chocolate'),
('Batatas fritas'),
('Snacks'),
('Águas minerais');

INSERT INTO simple_category VALUES 
('Águas minerais'),
('Refrigerantes'),
('Chocolate'),
('Batatas fritas');

INSERT INTO super_category VALUES 
('Águas'),
('Bebidas'), 
('Bolachas'), 
('Laticínios'),
('Snacks');

INSERT INTO has_other VALUES 
('Águas minerais', 'Águas'),
('Águas', 'Bebidas'), 
('Refrigerantes', 'Bebidas'),
('Chocolate', 'Snacks'),
('Bolachas', 'Snacks'),
('Batatas fritas', 'Snacks');

INSERT INTO product VALUES 
(1287633, 'Águas minerais', 'Evian'), 
(1293874, 'Refrigerantes', 'Coca-Cola'),
(9871237, 'Refrigerantes', 'Ice-Tea Limão'),
(2934857, 'Chocolate', 'Kit-Kat'),
(3847583, 'Batatas fritas', 'Lays Camponesas'),
(9717326, 'Bebidas', 'Prime'), 
(1129383, 'Bolachas', 'Chipmix'), 
(2364788, 'Bolachas', 'Filipinos Clássico'),
(7653765, 'Laticínios', 'Ucal s/ Lactose'), 
(3254978, 'Laticínios', 'Ucal Normal');

INSERT INTO has_category VALUES 
(9717326, 'Bebidas'), 
(1287633, 'Águas'), 
(1129383, 'Bolachas'), 
(7653765, 'Laticínios'),
(1293874, 'Bebidas'),
(2934857, 'Snacks');

INSERT INTO IVM VALUES 
(1982, 'Peterson-Whyte'), 
(2193, 'AFEN'), 
(3564, 'Vought International'), 
(1678, 'Weyland-Yutani'), 
(3457, 'Serdial Vending'), 
(6543, 'Serdial Vending'),
(2545, 'AFEN'),
(4857, 'SANDEN Vendo');

INSERT INTO retail_point VALUES 
('R. Camélias', 'Bobadela', 'Lisbon'), 
('R. Olivença', 'Coimbra', 'Coimbra'), 
('R. do Adro', 'Montelavar', 'Lisbon'), 
('R. de Santa Iria', 'Vila Real', 'Vila Real'),
('Taguspark', 'Oeiras', 'Lisbon'),
('Galp-L', 'Loures', 'Lisbon'),
('BP-L', 'Loures', 'Lisbon'),
('Av. dos Aliados', 'Oporto', 'Oporto');

INSERT INTO installed_at VALUES 
(1982, 'Peterson-Whyte', 'R. Camélias'),
(2193, 'AFEN', 'R. Olivença'),
(3564, 'Vought International', 'R. do Adro'),
(1678, 'Weyland-Yutani', 'R. de Santa Iria'),
(3457, 'Serdial Vending', 'Taguspark'),
(6543, 'Serdial Vending', 'Galp-L'),
(2545, 'AFEN', 'BP-L'),
(4857, 'SANDEN Vendo', 'Av. dos Aliados');

INSERT INTO shelf VALUES
(4, 2545, 'AFEN', 1, 'Bebidas'),
(2, 2545, 'AFEN', 5, 'Bolachas'),
(10, 2545, 'AFEN', 3, 'Chocolate'),
(1, 3457, 'Serdial Vending', 2, 'Bebidas'),
(2, 3457, 'Serdial Vending', 3, 'Snacks'),
(2, 1982, 'Peterson-Whyte', 1, 'Bebidas'),
(2, 4857, 'SANDEN Vendo', 1, 'Snacks'),
(5, 4857, 'SANDEN Vendo', 4, 'Bebidas'),
(4, 4857, 'SANDEN Vendo', 4, 'Batatas fritas'),
(8, 4857, 'SANDEN Vendo', 2, 'Laticínios'),
(3, 2193, 'AFEN', 2, 'Bebidas'),
(2, 2193, 'AFEN', 3, 'Snacks'),
(6, 6543, 'Serdial Vending', 1, 'Refrigerantes'),
(7, 6543, 'Serdial Vending', 5, 'Bolachas'),
(8, 6543, 'Serdial Vending', 3, 'Chocolate'),
(1, 3564, 'Vought International', 1, 'Bebidas'),
(1, 1678, 'Weyland-Yutani', 7, 'Laticínios');

INSERT INTO planogram VALUES
(1293874, 4, 2545, 'AFEN', 4, 35, 'loc'),
(2364788, 2, 2545, 'AFEN', 5, 40, 'loc'),
(2934857, 10, 2545, 'AFEN', 2, 15, 'loc'),
(9717326, 4, 2545, 'AFEN', 3, 37, 'loc'),
(1287633, 1, 3457, 'Serdial Vending', 5, 60, 'loc'),
(3847583, 2, 3457, 'Serdial Vending', 3, 26, 'loc'),
(9717326, 2, 1982, 'Peterson-Whyte', 5, 50, 'loc'),
(2934857, 2, 4857, 'SANDEN Vendo', 5, 55, 'loc'),
(9871237, 5, 4857, 'SANDEN Vendo', 2, 35, 'loc'),
(3847583, 2, 4857, 'SANDEN Vendo', 5, 70, 'loc'),
(2364788, 2, 4857, 'SANDEN Vendo', 5, 45, 'loc'),
(3847583, 4, 4857, 'SANDEN Vendo', 6, 40, 'loc'),
(7653765, 8, 4857, 'SANDEN Vendo', 7, 20, 'loc'),
(1293874, 6, 6543, 'Serdial Vending', 3, 33, 'loc'),
(9871237, 6, 6543, 'Serdial Vending', 3, 20, 'loc'),
(2364788, 7, 6543, 'Serdial Vending', 2, 15, 'loc'),
(2934857, 8, 6543, 'Serdial Vending', 3, 20, 'loc'),
(1129383, 3, 2193, 'AFEN', 6, 37, 'loc'),
(3847583, 2, 2193, 'AFEN', 3, 70, 'loc'),
(1287633, 1, 3564, 'Vought International', 5, 60, 'loc'),
(7653765, 1, 1678, 'Weyland-Yutani', 8, 66, 'loc');

INSERT INTO retailer VALUES
(34798, 'Juvenal Barbosa'),
(98324, 'Orlando Fonseca'),
(12345, 'Jerónimo dos Santos'),
(28341, 'SONAE'),
(93734, 'José Carlos Antunes'),
(66433, 'Maria Guedes'),
(13267, 'Ramiro Lopes da Silva');

INSERT INTO responsible_for VALUES 
('Bebidas', 34798, 1982, 'Peterson-Whyte'),
('Laticínios', 98324, 1678, 'Weyland-Yutani'),
('Refrigerantes', 12345, 6543, 'Serdial Vending'),
('Águas', 34798, 3457, 'Serdial Vending'),
('Bebidas', 28341, 2545, 'AFEN'),
('Snacks', 12345, 4857, 'SANDEN Vendo'),
('Chocolate', 66433, 2193, 'AFEN'),
('Snacks', 93734, 3564, 'Vought International');

INSERT INTO replenishment_event VALUES
(1293874, 4, 2545, 'AFEN', TIMESTAMP '2022-06-18 11:09:07', 20, 66433),
(2364788, 2, 2545, 'AFEN', TIMESTAMP '2022-06-14 11:27:21', 40, 93734),
(9717326, 4, 2545, 'AFEN', TIMESTAMP '2022-06-11 10:53:32', 30, 66433),
(2934857, 10, 2545, 'AFEN', TIMESTAMP '2022-06-10 12:05:25', 30, 93734),
(1287633, 1, 3457, 'Serdial Vending', TIMESTAMP '2022-05-16 07:52:28', 57, 13267),
(3847583, 2, 3457, 'Serdial Vending', TIMESTAMP '2022-05-09 07:48:14', 24, 12345),
(1287633, 1, 3457, 'Serdial Vending', TIMESTAMP '2022-05-09 07:47:54', 51, 13267),
(9717326, 2, 1982, 'Peterson-Whyte', TIMESTAMP '2022-05-15 08:05:06', 37, 34798),
(2934857, 2, 4857, 'SANDEN Vendo', TIMESTAMP '2022-06-04 07:29:07', 18, 28341),
(3847583, 4, 4857, 'SANDEN Vendo', TIMESTAMP '2022-06-04 07:32:25', 19, 28341),
(9871237, 5, 4857, 'SANDEN Vendo', TIMESTAMP '2022-06-08 08:19:36', 20, 28341),
(3847583, 2, 4857, 'SANDEN Vendo', TIMESTAMP '2022-06-12 08:30:04', 65, 28341),
(2364788, 2, 4857, 'SANDEN Vendo', TIMESTAMP '2022-06-12 08:32:47', 36, 28341),
(7653765, 8, 4857, 'SANDEN Vendo', TIMESTAMP '2022-06-12 08:33:59', 15, 28341),
(2364788, 7, 6543, 'Serdial Vending', TIMESTAMP '2022-06-09 09:29:17', 10, 93734),
(1293874, 6, 6543, 'Serdial Vending', TIMESTAMP '2022-06-14 09:32:37', 31, 13267),
(9871237, 6, 6543, 'Serdial Vending', TIMESTAMP '2022-06-19 09:09:38', 16, 93734),
(2934857, 8, 6543, 'Serdial Vending', TIMESTAMP '2022-06-24 09:15:15', 20, 13267),
(1129383, 3, 2193, 'AFEN', TIMESTAMP '2022-06-24 19:32:41', 55, 98324),
(3847583, 2, 2193, 'AFEN', TIMESTAMP '2022-06-23 18:59:51', 45, 66433),
(1287633, 1, 3564, 'Vought International', TIMESTAMP '2022-06-06 14:23:28', 57, 13267),
(7653765, 1, 1678, 'Weyland-Yutani', TIMESTAMP '2022-06-21 06:55:36', 40, 98324),
(7653765, 1, 1678, 'Weyland-Yutani', TIMESTAMP '2022-06-24 07:03:47', 30, 98324);