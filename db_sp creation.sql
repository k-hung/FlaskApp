
##  tbl_user - Database Implementation for users.
DROP DATABASE IF EXISTS BucketList;
CREATE DATABASE BucketList;
USE BucketList;
CREATE TABLE tbl_user (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `user_name` varchar(225) NULL,
  `user_username` varchar(225) NULL,
  `user_password` varchar(225) NULL,
  PRIMARY KEY (`user_id`));

ALTER TABLE tbl_user AUTO_INCREMENT = 1; ##Ensures that user ID's start from 1.

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
##  sp_validateLogin - STORED PROCEDURE - to get user details based on username.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validateLogin`(
IN p_username varchar(20)
)
BEGIN
    select * from tbl_user where user_username = p_username;
END$$
DELIMITER ;
##  tbl_wish - Database Implementation for wishes.
CREATE TABLE `tbl_wish` (
  `wish_id` int(11) NOT NULL AUTO_INCREMENT,
  `wish_title` varchar(45) DEFAULT NULL,
  `wish_description` varchar(5000) DEFAULT NULL,
  `wish_user_id` int(11) DEFAULT NULL,
  `wish_date` datetime DEFAULT NULL,
  PRIMARY KEY (`wish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

ALTER TABLE tbl_wish AUTO_INCREMENT = 1; ##Ensures that wish ID's start from 1.

##  sp_addWish - STORED PROCEDURE - to add items to the tbl_wish table.
DROP PROCEDURE IF EXISTS `sp_addWish`;
DELIMITER $$
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

##  sp_GetWishByUser - STORED PROCEDURE - to retrieve a wish.
DROP PROCEDURE IF EXISTS `sp_GetWishByUser`;
DELIMITER $$
CREATE PROCEDURE `sp_GetWishByUser` (
IN p_user_id bigint
)
BEGIN
    select * from tbl_wish where wish_user_id = p_user_id;
END$$
DELIMITER ;
##  sp_GetWishByID - STORED PROCEDURE - to fetch data from the database.
##                 - to get particular wish details using the wish ID and user ID.
DROP PROCEDURE IF EXISTS `sp_GetWishById`;
DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishById`(
IN p_wish_id bigint,
In p_user_id bigint
)
BEGIN
select * from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

##  sp_update Wish - STORED PROCEDURE - to update wishes after editing.
DROP PROCEDURE IF EXISTS `sp_updateWish`;
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

##  sp_deleteWish - STORED PROCEDURE - to delete a wish.
## The PROCEDURE takes in the wish ID and user ID and deletes the corresponding wish from the database.
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
##  sp_GetWishByUser - STORED PROCEDURE - to get wish by user
DROP PROCEDURE IF EXISTS `sp_GetWishByUser`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishByUser`(
IN p_user_id bigint,
IN p_limit int,
IN p_offset int
)
BEGIN
    SET @t1 = CONCAT( 'select * from tbl_wish where wish_user_id = ', p_user_id, ' order by wish_date desc limit ',p_limit,' offset ',p_offset);
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt1;
END$$
DELIMITER ;

## sp_GetWishByUser - STORED PROCEDURE - modify for Pagination Update for Pages.
## added a new output parameter called p_total and selected the total count of the wishes based on the user id.
DROP PROCEDURE IF EXISTS `sp_GetWishByUser`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishByUser`(
IN p_user_id bigint,
IN p_limit int,
IN p_offset int,
out p_total bigint
)
BEGIN
    select count(*) into p_total from tbl_wish where wish_user_id = p_user_id;
    SET @t1 = CONCAT( 'select * from tbl_wish where wish_user_id = ', p_user_id, ' order by wish_date desc limit ',p_limit,' offset ',p_offset);
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;
## tbl_wish - implementation of 3 new columns.
ALTER TABLE `BucketList`.`tbl_wish` 
ADD COLUMN `wish_file_path` VARCHAR(200) NULL AFTER `wish_date`,
ADD COLUMN `wish_accomplished` INT NULL DEFAULT 0 AFTER `wish_file_path`,
ADD COLUMN `wish_private` INT NULL DEFAULT 0 AFTER `wish_accomplished`;

##  sp_addWish - STORED PROCEDURE - to include the newly added fields to the database. =
DROP PROCEDURE IF EXISTS `sp_addWish`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title varchar(45),
    IN p_description varchar(1000),
    IN p_user_id bigint,
    IN p_file_path varchar(200),
    IN p_is_private int,
    IN p_is_done int
)
BEGIN
    insert into tbl_wish(
        wish_title,
        wish_description,
        wish_user_id,
        wish_date,
        wish_file_path,
        wish_private,
        wish_accomplished
    )
    values
    (
        p_title,
        p_description,
        p_user_id,
        NOW(),
        p_file_path,
        p_is_private,
        p_is_done
    );
END$$
DELIMITER ;

##  sp_updateWish - STORED PROCEDURE - to include the three newly added fields.
DROP PROCEDURE IF EXISTS `sp_updateWish`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateWish`(
IN p_title varchar(45),
IN p_description varchar(1000),
IN p_wish_id bigint,
In p_user_id bigint,
IN p_file_path varchar(200),
IN p_is_private int,
IN p_is_done int
)
BEGIN
update tbl_wish set
    wish_title = p_title,
    wish_description = p_description,
    wish_file_path = p_file_path,
    wish_private = p_is_private,
    wish_accomplished = p_is_done
    where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

##  sp_GetWishById - STORED PROCEDURE - to include the additional fields as shown: 
DROP PROCEDURE IF EXISTS `sp_GetWishById`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishById`(
IN p_wish_id bigint,
In p_user_id bigint
)
BEGIN
select wish_id,wish_title,wish_description,wish_file_path,wish_private,wish_accomplished from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

##  sp_updateWish - STORED PROCEDURE - to include the newly added fields.
DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_updateWish`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateWish`(
IN p_title varchar(45),
IN p_description varchar(1000),
IN p_wish_id bigint,
In p_user_id bigint,
IN p_file_path varchar(200),
IN p_is_private int,
IN p_is_done int
)
BEGIN
update tbl_wish set
    wish_title = p_title,
    wish_description = p_description,
    wish_file_path = p_file_path,
    wish_private = p_is_private,
    wish_accomplished = p_is_done
    where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;
##  sp_GetAllWishes - STORED PROCEDURE - to fetch the data from the database to populate the dashboard.
USE `BucketList`;
DROP PROCEDURE IF EXISTS `sp_GetAllWishes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes`()
BEGIN
    select wish_id,wish_title,wish_description,wish_file_path from tbl_wish where wish_private = 0;
END$$
DELIMITER ;

##  tbl_likes - a table which will keep track of the likes a particular wish has garnered.
CREATE TABLE tbl_likes (
  `wish_id` INT NOT NULL,
  `like_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `wish_like` INT NULL DEFAULT 0,
  PRIMARY KEY (`like_id`)
  );

##  sp_AddUpdateLikes - STORED PROCEDURE - updates likes whenever a user likes or dislikes a particular wish.
DELIMITER $$ 
DROP PROCEDURE IF EXISTS `sp_AddUpdateLikes`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddUpdateLikes`(
    p_wish_id int,
    p_user_id int,
    p_like int
)
BEGIN
    if (select exists (select 1 from tbl_likes where wish_id = p_wish_id and user_id = p_user_id)) then
 
        update tbl_likes set wish_like = p_like where wish_id = p_wish_id and user_id = p_user_id;
         
    else
         
        insert into tbl_likes(
            wish_id,
            user_id,
            wish_like
        )
        values(
            p_wish_id,
            p_user_id,
            p_like
        );
 
    end if;
END$$
DELIMITER ;
##  sp_addWish - STORED PROCEDURE - to add an entry into the tbl_likes table.
##  This feature shows the total number of counts a particular wish has garnered. 
##  When a new wish gets added it'll make an entry into the tbl_likes table.
DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_addWish`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title varchar(45),
    IN p_description varchar(1000),
    IN p_user_id bigint,
    IN p_file_path varchar(200),
    IN p_is_private int,
    IN p_is_done int
)
BEGIN
    insert into tbl_wish(
        wish_title,
        wish_description,
        wish_user_id,
        wish_date,
        wish_file_path,
        wish_private,
        wish_accomplished
    )
    values
    (
        p_title,
        p_description,
        p_user_id,
        NOW(),
        p_file_path,
        p_is_private,
        p_is_done
    );
 
    SET @last_id = LAST_INSERT_ID();
    insert into tbl_likes(
        wish_id,
        user_id,
        wish_like
    )
    values(
        @last_id,
        p_user_id,
        0
    );
END$$
DELIMITER ;

##  getSum - FUNCTION - takes the wish ID and return the total number of likes.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSum`(
    p_wish_id int
) RETURNS int(11)
BEGIN
    select sum(wish_like) into @sm from tbl_likes where wish_id = p_wish_id;
RETURN @sm;
END$$
DELIMITER ;

##  sp_GetAllWishes - STORED PROCEDURE - modify to include the number of likes each wish has garnered.
DROP PROCEDURE IF EXISTS `sp_GetAllWishes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes`()
BEGIN
    select wish_id,wish_title,wish_description,wish_file_path,getSum(wish_id)
    from tbl_wish where wish_private = 0;
END$$
DELIMITER ;

##  hasLiked - FUNCTION - takes in user ID and wish ID as the parameters and returns whether the wish has been liked by the user or not.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `hasLiked`(
    p_wish int,
    p_user int
) RETURNS int(11)
BEGIN
     
    select wish_like into @myval from tbl_likes where wish_id =  p_wish and user_id = p_user;
RETURN @myval;
END$$
DELIMITER ;

##  sp_GetAllWishes - STORED PROCEDURE - Modify to include FUNCTION 'hasLiked' indicating the user like status.
DROP PROCEDURE IF EXISTS `sp_GetAllWishes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes`(
    p_user int
)
BEGIN
    select wish_id,wish_title,wish_description,wish_file_path,getSum(wish_id),hasLiked(wish_id,p_user)
    from tbl_wish where wish_private = 0;
END$$
DELIMITER ;

##  sp_AddUpdateLikes - STORED PROCEDURE - modify to toggle the like/unlike in the stored PROCEDURE.
##  Earlier we were passing in the like status, 1 for a like and 0 for unlike.
DROP PROCEDURE IF EXISTS `sp_AddUpdateLikes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddUpdateLikes`(
    p_wish_id int,
    p_user_id int,
    p_like int
)
BEGIN
     
    if (select exists (select 1 from tbl_likes where wish_id = p_wish_id and user_id = p_user_id)) then
 
         
        select wish_like into @currentVal from tbl_likes where wish_id = p_wish_id and user_id = p_user_id;
         
        if @currentVal = 0 then
            update tbl_likes set wish_like = 1 where wish_id = p_wish_id and user_id = p_user_id;
        else
            update tbl_likes set wish_like = 0 where wish_id = p_wish_id and user_id = p_user_id;
        end if;
         
    else
         
        insert into tbl_likes(
            wish_id,
            user_id,
            wish_like
        )
        values(
            p_wish_id,
            p_user_id,
            p_like
        );
 
 
    end if;
END$$
DELIMITER ;

##  sp_getLikeStatus - STORED PROCEDURE - modify to include FUNCTIONs 'getSum' & 'hasLiked' to get the status.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getLikeStatus`(
    IN p_wish_id int,
    IN p_user_id int
)
BEGIN
    select getSum(p_wish_id),hasLiked(p_wish_id,p_user_id);
END$$
DELIMITER ;
