CREATE TABLE properties (
                            id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                                COMMENT 'Primaarvõti, kasutame INT, sest TINYINT oleks liiga väike suure objektiarvu korral. AUTO_INCREMENT loob unikaalse ID automaatselt.',
                            address VARCHAR(255) NOT NULL
                                COMMENT 'Kinnisvara aadress. VARCHAR(255) on piisavalt pikk, kuna aadressid võivad olla erineva pikkusega.',
                            city VARCHAR(255) NOT NULL
                                COMMENT 'Linn/asula nimi. VARCHAR(100) katab enamasti kõik juhtumid, sest linnade nimed pole tavaliselt väga pikad.',
                            postal_code VARCHAR(100) NOT NULL
                                COMMENT 'Postiindeks (võib sisaldada ka tähti/märke). INT ei sobiks, kuna mõnel pool on formaadis täht+number.',
                            type VARCHAR(100) NOT NULL
                                COMMENT 'Kinnisvara tüüp (nt maja, korter, krunt). VARCHAR(50) piisab tüübi nimetuse hoidmiseks.',
                            size_m2 INT UNSIGNED NOT NULL
                                COMMENT 'Suurus m². UNSIGNED INT, sest ruutmeetrite arv on alati positiivne; TINYINT oleks liiga väike suuremate objektide korral.',

                            INDEX (city),
                            INDEX (postal_code)
) ENGINE=InnoDB;

CREATE TABLE agents (
                        id INT  UNSIGNED AUTO_INCREMENT PRIMARY KEY
                            COMMENT 'Primaarvõti. Kasutame INT, et mahutada suur hulk maaklereid. AUTO_INCREMENT tagab unikaalse ID.',
                        name VARCHAR(255) NOT NULL
                            COMMENT 'Maakleri nimi. VARCHAR(100) sobib ka pikemate nimede jaoks.',
                        phone VARCHAR(100) NOT NULL
                            COMMENT 'Maakleri telefon, salvestame tekstina (mitte INT) kuna numbrid võivad sisaldada sümboleid (+, -) ja algusnulli.',
                        email VARCHAR(255) NOT NULL
                            COMMENT 'Maakleri e-posti aadress. VARCHAR(255) on tavaline maksimaalne pikkus e-posti väljade jaoks.'
) ENGINE=InnoDB;

CREATE TABLE sellers (
                         id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                             COMMENT 'Primaarvõti. Kasutame INT suure hulga müüjate jaoks, AUTO_INCREMENT tekitab unikaalse ID.',
                         name VARCHAR(255) NOT NULL
                             COMMENT 'Müüja/omaniku/kontaktisiku nimi. VARCHAR(100) on piisav enamiku nimede jaoks.',
                         phone VARCHAR(100) NOT NULL
                             COMMENT 'Kontakttelefon, tekstivormingus, sest võib sisaldada +, - või teisi märke.',
                         email VARCHAR(255) NOT NULL
                             COMMENT 'Kontakt-e-post. VARCHAR(255) katab pikemad domeeninimed.'
) ENGINE=InnoDB;

CREATE TABLE listings (
                          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                              COMMENT 'Primaarvõti, kuulutuse ainulaadne ID. INT on piisav suure kuulutuste mahu jaoks.',
                          property_id INT NOT NULL
                              COMMENT 'Viitab properties.id-le. Kasutame INT NOT NULL, sest ilma kinnisvaraobjektita kuulutust ei saa olla.',
                          agent_id INT NULL
                              COMMENT 'Viitab agents.id-le, võib olla NULL kui maaklerit pole. INT on piisav maaklerite arvu jaoks.',
                          seller_id INT NOT NULL
                              COMMENT 'Viitab sellers.id-le. Kasutame INT NOT NULL, kuna igal kuulutusel peab olema müüja.',
                          title VARCHAR(255) NOT NULL
                              COMMENT 'Kuulutuse pealkiri, max 255 märki. VARCHAR sobib lühikese tekstina.',
                          description TEXT NOT NULL
                              COMMENT 'Pikem kirjeldus, TEXT võimaldab salvestada rohkem kui 255 märki.',
                          price DECIMAL(10,2) UNSIGNED NOT NULL
                              COMMENT 'Hind rahalises väärtuses. DECIMAL(10,2) tagab täpsuse rahasummadega, FLOAT võiks tekitada ümardusprobleeme.',
                          created_at DATETIME NOT NULL
                              COMMENT 'Kuulutuse loomise aeg. DATETIME valime TIMESTAMP asemel, et vältida ajavööndi ja 2038. aasta piiranguid.',
                          updated_at DATETIME NOT NULL
                              COMMENT 'Kuulutuse uuendamise aeg. Sama põhjendus kui created_at juures.',

                          FOREIGN KEY (property_id) REFERENCES properties(id),  -- Seos kinnisvaraobjektiga
                          FOREIGN KEY (agent_id) REFERENCES agents(id),         -- Seos maakleriga (võib olla NULL)
                          FOREIGN KEY (seller_id) REFERENCES sellers(id)        -- Seos müüjaga
) ENGINE=InnoDB;

CREATE TABLE view_stats (
                            id INT AUTO_INCREMENT PRIMARY KEY
                                COMMENT 'Primaarvõti, automaatne ID. INT katab ära suure vaatamiste hulga.',
                            listing_id INT UNSIGNED NOT NULL
                                COMMENT 'Viitab listings.id-le, näitab millist kuulutust vaadati. INT NOT NULL, sest vaatamise kirje peab alati kuulutama kehtivale kuulutusele.',
                            view_date DATETIME NOT NULL
                                COMMENT 'Vaatamise kuupäev/kellaaeg. DATETIME, et säilitada täpne aeg ja vältida timestampi ajalist piirangut.',
                            ip_address VARCHAR(255) NOT NULL
                                COMMENT 'Külastaja IP-aadress. 45 märki hõlmab nii IPv4 kui IPv6 näiteid.',
                            user_agent VARCHAR(255) NOT NULL
                                COMMENT 'Brauseri User-Agent. Tekst võib olla pikk, mistõttu VARCHAR(255).',
                            created_at DATETIME NOT NULL
                                COMMENT 'Kirje loomise aeg. DATETIME pakub ühtlustatud mudelit, ei sõltu serveri ajavööndist nagu TIMESTAMP.',

                            FOREIGN KEY (listing_id) REFERENCES listings(id)       -- Seos vaatamise ja kuulutuse vahel
) ENGINE=InnoDB;
