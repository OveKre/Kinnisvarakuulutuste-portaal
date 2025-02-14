CREATE TABLE properties (
                            id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                                COMMENT 'Primaarvõti (UNSIGNED INT), et välistada negatiivsed ID-d ja anda suurem positiivne vahemik. AUTO_INCREMENT loob iga uue rida jaoks unikaalse ID.',
                            address VARCHAR(255) NOT NULL
                                COMMENT 'Kinnisvara aadress. 255 märki on piisav, kuna aadressid võivad olla pikkade tänavanimedega.',
                            city VARCHAR(255) NOT NULL
                                COMMENT 'Linna või asula nimi. Suurendatud 255-ni juhuks, kui nimi on pikem kui 100 märki.',
                            postal_code VARCHAR(100) NOT NULL
                                COMMENT 'Postiindeks või -kood, mis võib sisaldada tähti, sidekriipse jms (seetõttu VARCHAR, mitte INT). Pikkus tõstetud 100-ni, et katta keerukamad vormid.',
                            type VARCHAR(100) NOT NULL
                                COMMENT 'Kinnisvara tüüp (nt maja, korter, krunt). Suurendatud 100-ni, et vajadusel mahutada pikemaid kirjeldusi.',
                            size_m2 INT UNSIGNED NOT NULL
                                COMMENT 'Suurus ruutmeetrites. UNSIGNED INT, sest väärtus ei või olla negatiivne ja TINYINT jääks liiga väikeseks suuremate objektide korral.',

                            INDEX (city),
                            INDEX (postal_code)
) ENGINE=InnoDB;

CREATE TABLE agents (
                        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                            COMMENT 'Primaarvõti (UNSIGNED), et vältida negatiivseid ID-sid. AUTO_INCREMENT tekitab unikaalse ID iga maakleri jaoks.',
                        name VARCHAR(255) NOT NULL
                            COMMENT 'Maakleri nimi. Suurendatud 255-ni, et toetada ka pikemaid või kahetiseid nimesid.',
                        phone VARCHAR(100) NOT NULL
                            COMMENT 'Telefoninumber. Kasutame VARCHAR, sest see võib sisaldada +, -, () jm sümboleid. Pikendatud 100-ni, et toetada rahvusvahelisi vorminguid.',
                        email VARCHAR(255) NOT NULL
                            COMMENT 'Maakleri e-posti aadress, max 255 märki on standardne, et ka pikemad domeeninimed ära mahuksid.'
) ENGINE=InnoDB;

CREATE TABLE sellers (
                         id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                             COMMENT 'Primaarvõti (UNSIGNED). Kasutame INT, et mahutada palju müüjaid, ja välistada negatiivsed ID-d.',
                         name VARCHAR(255) NOT NULL
                             COMMENT 'Müüja või kontaktisiku nimi. Suurendatud 255-ni pikemate nimede või topeltnimede jaoks.',
                         phone VARCHAR(100) NOT NULL
                             COMMENT 'Kontakttelefon (VARCHAR). 100 märki, kuna telefon võib sisaldada riigikoodi, plussmärki, tühikuid jne.',
                         email VARCHAR(255) NOT NULL
                             COMMENT 'Kontakt-e-post. 255 on tavapärane maksimaalne pikkus e-postide salvestamiseks.'
) ENGINE=InnoDB;

CREATE TABLE listings (
                          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
                              COMMENT 'Primaarvõti (UNSIGNED INT), et ID-d oleksid alati positiivsed. AUTO_INCREMENT pakub järjestikuseid ID-sid.',
                          property_id INT NOT NULL
                              COMMENT 'Viitab properties.id-le. INT, kuna see on piisav enamiku projektide jaoks. NOT NULL, sest kuulutus peab kuuluma konkreetsele kinnisvaraobjektile.',
                          agent_id INT NULL
                              COMMENT 'Viitab agents.id-le, võib olla NULL, kui maaklerit pole. INT on piisav maaklerite ID-de jaoks.',
                          seller_id INT NOT NULL
                              COMMENT 'Viitab sellers.id-le. NOT NULL, sest igal kuulutusel on müüja või omaniku info.',
                          title VARCHAR(255) NOT NULL
                              COMMENT 'Kuulutuse pealkiri, kuni 255 märki. Sobib hästi lühikese, kuid paindliku tekstiväljana.',
                          description TEXT NOT NULL
                              COMMENT 'Pikem kirjeldus. TEXT võimaldab salvestada rohkem infot kui VARCHAR(255).',
                          price DECIMAL(10,2) UNSIGNED NOT NULL
                              COMMENT 'Hind. DECIMAL(10,2) hoiab ära ujukomavigu, UNSIGNED, sest hind ei ole negatiivne.',
                          created_at DATETIME NOT NULL
                              COMMENT 'Kuulutuse loomise aeg. DATETIME väldib TIMESTAMPi ajavööndipiiranguid ja 2038. a probleemi.',
                          updated_at DATETIME NOT NULL
                              COMMENT 'Viimase uuenduse aeg. DATETIME valik samadel põhjustel kui created_at.',

                          FOREIGN KEY (property_id) REFERENCES properties(id),  -- Seos kinnisvaraobjektiga
                          FOREIGN KEY (agent_id) REFERENCES agents(id),         -- Seos maakleriga (võib olla NULL)
                          FOREIGN KEY (seller_id) REFERENCES sellers(id)        -- Seos müüjaga
) ENGINE=InnoDB;

CREATE TABLE view_stats (
                            id INT AUTO_INCREMENT PRIMARY KEY
                                COMMENT 'Primaarvõti (INT). AUTO_INCREMENT tekitab unikaalse rea igale vaatamisele. UNSIGNED võib kasutada, kuid INT on siin samuti toimiv.',
                            listing_id INT UNSIGNED NOT NULL
                                COMMENT 'Viitab listings.id-le. UNSIGNED, sest listings.id on samuti UNSIGNED. NOT NULL, sest vaatamise kirje peab kehtima konkreetsel kuulutusel.',
                            view_date DATETIME NOT NULL
                                COMMENT 'Vaatamise kuupäev ja kellaaeg. DATETIME, et hoida täpset timestampi ja vältida ajavööndi konversioone.',
                            ip_address VARCHAR(255) NOT NULL
                                COMMENT 'Külastaja IP-aadress või muu identifikaator. Pikendatud 255-ni, et katta potentsiaalselt täiendava info.',
                            user_agent VARCHAR(255) NOT NULL
                                COMMENT 'Brauseri User-Agent string. 255 märki on enamasti piisav pikemate stringide jaoks.',
                            created_at DATETIME NOT NULL
                                COMMENT 'Kirje loomise aeg. Kasutame DATETIME samadel alustel, mis mujal.',

                            FOREIGN KEY (listing_id) REFERENCES listings(id)       -- Seos vaatamise ja kuulutuse vahel
) ENGINE=InnoDB;
