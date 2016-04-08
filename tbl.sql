DROP DATABASE IF EXISTS FeelsApp;
CREATE DATABASE FeelsApp;
USE FeelsApp;

    CREATE TABLE tbl_User (
        `usr_id` bigint NOT NULL AUTO_INCREMENT,
        `usr_name` varchar(225) NULL,
        `usr_username` varchar(225) NULL,	##varchar 225 crucial due to having it hashed later on for security reasons.
        `usr_password` varchar(225) NULL,
        PRIMARY KEY (`usr_id`)
    );

        ALTER TABLE tbl_User AUTO_INCREMENT = 1;
        ##Ensures that user ID's start from 1.

        ##  sp_createUser - STORED PROCEDURE - to check if user/username already exists.
        DELIMITER $$
        CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser`(
            IN p_name varchar(225),
            IN p_username varchar(225),
            IN p_password varchar(225)
        	)
            BEGIN
                if ( select exists (select 1 from tbl_user where user_username = p_username) ) THEN
                 
                    select 'Username Exists !!';
                 
            ELSE
             
                insert into tbl_user
                (
                    user_name,
                    user_username,
                    user_password
                )
                values
                (
                    p_name,
                    p_username,
                    p_password
                );
             
            END IF;
        END$$
        DELIMITER ;

    Create Table tbl_UltCat (
    `c1_id` bigint NOT NULL,
    `c1_name` varchar(45) NULL,
    PRIMARY KEY(`c1_id`)
    );

    Create Table tbl_SubCat(
    `c2_id` bigint NOT NULL,
    `c2_name` varchar(45) NULL,
    PRIMARY KEY(`c2_id`)
    );

    Create Table tbl_Emots(
    `c1_id` bigint references tbl_UltCat,
    `c1_name` varchar(45) references tbl_UltCat,
    `c2_id` bigint references tbl_SubCat,
    `c2_name` varchar(45) references tbl_SubCat,
    `Emo_id` bigint NOT NULL,
    `Emo_name` varchar(45) NOT NULL,
    PRIMARY KEY(`Emo_id`)
    );

    Create Table tbl_ChTn(
    `Emo_id` bigint references tbl_Emots,
    `Emo_name` varchar(45) references tbl_Emots,
    `Chtn_id` bigint NOT NULL AUTO_INCREMENT, ##Should we AtIncrmt? Not sure of the list yet.
    `Chtn_name` varchar(45) NOT NULL,
    `Chtn_url` varchar(100) NOT NULL,
    PRIMARY KEY(`Chtn_id`)
    );

    ALTER TABLE tbl_ChTn AUTO_INCREMENT = 1;

    desc tbl_User;
    desc tbl_UltCat;
    desc tbl_SubCat;
    desc tbl_Emots;
    desc tbl_ChTn;


