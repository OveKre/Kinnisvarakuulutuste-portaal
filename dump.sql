

CREATE TABLE properties (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primaarvõti, unikaalne ID',
                            address VARCHAR(255) NOT NULL COMMENT 'Kinnisvara aadress, kuni 255 märki',
                            city VARCHAR(100) NOT NULL COMMENT 'Linn või asula, kuni 100 märki',
                            postal_code VARCHAR(20) NOT NULL COMMENT 'Postiindeks, nt 12345 või 123456',
                            type VARCHAR(50) NOT NULL COMMENT 'Kinnisvara tüüp (nt maja, korter, krunt)',
                            size_m2 INT UNSIGNED NOT NULL COMMENT 'Suurus ruutmeetrites, ainult positiivne',
                            INDEX (city) COMMENT 'Kasutaja teeb päringu WHERE city = Tallinn ,siis indeks teeb selles veerus tunduvalt kiiremaks ',
                            INDEX (postal_code) COMMENT  'postiindeks, index kiirendab otsingut kui sisestatakse postiindeksi vaartus '
) ENGINE=InnoDB;

CREATE TABLE agents (
                        id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primaarvõti, unikaalne ID',
                        name VARCHAR(100) NOT NULL COMMENT 'Maakleri nimi, kuni 100 märki',
                        phone VARCHAR(20) NOT NULL COMMENT 'Maakleri telefoninumber',
                        email VARCHAR(255) NOT NULL COMMENT 'Maakleri e-post, max 255 märki'
) ENGINE=InnoDB;

CREATE TABLE sellers (
                         id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primaarvõti, unikaalne ID',
                         name VARCHAR(100) NOT NULL COMMENT 'Müüja/omaniku/kontaktisiku nimi',
                         phone VARCHAR(20) NOT NULL COMMENT 'Kontakttelefon',
                         email VARCHAR(255) NOT NULL COMMENT 'Kontakt-e-post'
) ENGINE=InnoDB;

CREATE TABLE listings (
                          id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primaarvõti, kuulutuse ID',
                          property_id INT NOT NULL COMMENT 'Viit properties tabelisse',
                          agent_id INT NULL COMMENT 'Viit agents tabelisse, võib olla NULL kui pole maaklerit',
                          seller_id INT NOT NULL COMMENT 'Viit sellers tabelisse',
                          title VARCHAR(255) NOT NULL COMMENT 'Kuulutuse pealkiri, kuni 255 märki',
                          description TEXT NOT NULL COMMENT 'Kuulutuse kirjeldus, võib olla pikk',
                          price DECIMAL(10,2) NOT NULL COMMENT 'Kinnisvara hind, DECIMAL(10,2) rahaga tegelemiseks',
                          created_at DATETIME NOT NULL COMMENT 'Kuulutuse loomise aeg',
                          updated_at DATETIME NOT NULL COMMENT 'Kuulutuse uuendamise aeg',
                          FOREIGN KEY (property_id) REFERENCES properties(id),  -- Millise kuulutusega seotud on --
                          FOREIGN KEY (agent_id) REFERENCES agents(id), -- Milline maakler vahendab või halbas kuulutust
                          FOREIGN KEY (seller_id) REFERENCES sellers(id) -- Kes on omanik , vüi kontaktandmed --
) ENGINE=InnoDB;

CREATE TABLE view_stats (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primaarvõti, unikaalne ID',
                            listing_id INT NOT NULL COMMENT 'Viit listings tabelisse',
                            view_date DATETIME NOT NULL COMMENT 'Vaatamise kuupäev/kellaaeg',
                            ip_address VARCHAR(45) NOT NULL COMMENT 'Külastaja IP-aadress (toetab IPv6, kuni 45 märki)',
                            user_agent VARCHAR(255) NOT NULL COMMENT 'Brauseri User-Agent, max 255 märki',
                            created_at DATETIME NOT NULL COMMENT 'Kirje salvestamise aeg',
                            FOREIGN KEY (listing_id) REFERENCES listings(id)  -- Seob view_stats kirje konkreetse kuulutusega listings tabelis --  --
) ENGINE=InnoDB;
