
##Part 1 Begins Below:
##  tbl_user - Database Implementation for users.
drop database if exists BucketList;
create database BucketList;
use BucketList;
CREATE TABLE `BucketList`.`tbl_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `user_name` varchar(225) NULL,
  `user_username` varchar(225) NULL,
  `user_password` varchar(225) NULL,
  PRIMARY KEY (`user_id`));

##  sp_createUser - Stored Procedure to check if user/username already exists.
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

##Part 1 Ends.

##Part 2 Begins Below:
##  sp_validateLogin - Stored Procedure to get user details based on username.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validateLogin`(
IN p_username varchar(20)
)
BEGIN
    select * from tbl_user where user_username = p_username;
END$$
DELIMITER ;

##Part 2 Ends.

##Part 3 Begins Below:
##  tbl_wish - Database Implementation for wishes.
CREATE TABLE `tbl_wish` (
  `wish_id` int(11) NOT NULL AUTO_INCREMENT,
  `wish_title` varchar(45) DEFAULT NULL,
  `wish_description` varchar(5000) DEFAULT NULL,
  `wish_user_id` int(11) DEFAULT NULL,
  `wish_date` datetime DEFAULT NULL,
  PRIMARY KEY (`wish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

##  sp_addWish - Stored Procedure to add items to the tbl_wish table.
USE `BucketList`;
DROP procedure IF EXISTS `BucketList`.`sp_addWish`;
DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title varchar(45),
    IN p_description varchar(1000),
    IN p_user_id bigint
)
BEGIN
    insert into tbl_wish(
        wish_title,
        wish_description,
        wish_user_id,
        wish_date
    )
    values
    (
        p_title,
        p_description,
        p_user_id,
        NOW()
    );
END$$
DELIMITER ;

##  sp_GetWishByUser - Stored Procedure to retrieve a wish.
USE `BucketList`;
DROP procedure IF EXISTS `sp_GetWishByUser`;
 
DELIMITER $$
USE `BucketList`$$
CREATE PROCEDURE `sp_GetWishByUser` (
IN p_user_id bigint
)
BEGIN
    select * from tbl_wish where wish_user_id = p_user_id;
END$$
DELIMITER ;

##Part 3 Ends.

##Part 4 Begins Below:
##  sp_GetWishByID - Stored Procedure to fetch data from the database.
##                 - to get particular wish details using the wish ID and user ID.
USE `BucketList`;
DROP procedure IF EXISTS `BucketList`.`sp_GetWishById`;
DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishById`(
IN p_wish_id bigint,
In p_user_id bigint
)
BEGIN
select * from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

##  sp_update Wish - Stored Procedure to update wishes after editing.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateWish`(
IN p_title varchar(45),
IN p_description varchar(1000),
IN p_wish_id bigint,
In p_user_id bigint
)
BEGIN
update tbl_wish set wish_title = p_title,wish_description = p_description
    where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

##  sp_deleteWish - Stored Procedure to delete a wish.
## The procedure takes in the wish ID and user ID and deletes the corresponding wish from the database.
DELIMITER $$
USE `BucketList`$$
CREATE PROCEDURE `sp_deleteWish` (
IN p_wish_id bigint,
IN p_user_id bigint
)
BEGIN
delete from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

##Part 4 Ends
