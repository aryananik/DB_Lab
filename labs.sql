CREATE SCHEMA IF NOT EXISTS `Bookstore` DEFAULT CHARACTER SET utf8 ;
USE `Bookstore` ;

-- -----------------------------------------------------
-- Table `Bookstore`.`book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`book` (
  `idbook` INT NOT NULL,
  `namebook` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`idbook`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bookstore`.`pubhouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`pubhouse` (
  `idpubhouse` INT NOT NULL,
  `namepubhouse` VARCHAR(45) NOT NULL,
  `circulation` INT NOT NULL,
  PRIMARY KEY (`idpubhouse`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bookstore`.`edition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`edition` (
  `idedition` INT NOT NULL,
  `pages` INT NOT NULL,
  `year` INT NOT NULL,
  `pubhouse_idpubhouse` INT NOT NULL,
  `book_idbook` INT NOT NULL,
  PRIMARY KEY (`idedition`, `pubhouse_idpubhouse`, `book_idbook`),
  INDEX `fk_edition_pubhouse_idx` (`pubhouse_idpubhouse` ASC) VISIBLE,
  INDEX `fk_edition_book1_idx` (`book_idbook` ASC) VISIBLE,
  CONSTRAINT `fk_edition_pubhouse`
    FOREIGN KEY (`pubhouse_idpubhouse`)
    REFERENCES `Bookstore`.`pubhouse` (`idpubhouse`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_edition_book1`
    FOREIGN KEY (`book_idbook`)
    REFERENCES `Bookstore`.`book` (`idbook`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bookstore`.`author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`author` (
  `idauthor` INT NOT NULL,
  `nameauthor` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`idauthor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bookstore`.`book_has_author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`book_has_author` (
  `book_idbook` INT NOT NULL,
  `author_idauthor` INT NOT NULL,
  PRIMARY KEY (`book_idbook`, `author_idauthor`),
  INDEX `fk_book_has_author_author1_idx` (`author_idauthor` ASC) VISIBLE,
  INDEX `fk_book_has_author_book1_idx` (`book_idbook` ASC) VISIBLE,
  CONSTRAINT `fk_book_has_author_book1`
    FOREIGN KEY (`book_idbook`)
    REFERENCES `Bookstore`.`book` (`idbook`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_has_author_author1`
    FOREIGN KEY (`author_idauthor`)
    REFERENCES `Bookstore`.`author` (`idauthor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT `Bookstore`.`author`(idauthor, nameauthor) 
VALUES (1015, 'Д.Адамс');
INSERT `Bookstore`.`author`(idauthor, nameauthor) 
VALUES 
(1014, 'Т.Драйзер'),
(1019, 'Дж.Оруэлл'),
(1016, 'Х.Мураками'),
(2108, 'Э.Бронте'),
(1827, 'Э.Петчетт'),
(1022, 'М.А.Булгаков');
ALTER TABLE book DROP authorbook;
SELECT * FROM author;
INSERT `Bookstore`.`author`(idauthor, nameauthor) 
VALUES 
(1001, 'А.С.Бортковский'),
(1002, 'А.В.Пантелеев');
ALTER TABLE pubhouse DROP circulation;
ALTER TABLE edition ADD COLUMN circulation INT NOT NULL;
INSERT Bookstore.book(idbook, namebook) 
VALUES 
(1, 'Грозовой перевал'),
(2, 'Финансист');
INSERT Bookstore.book(idbook, namebook) 
VALUES 
(354098, 'Линейная алгебра'),
(490843, 'Голландский дом'),
(109205, 'Автостопом по галактике'),
(509647, 'Норвежский лес'),
(209837, 'Мастер и Маргарита'),
(205430, 'Кафка на пляже'),
(876457, '1984'),
(567787, 'Скотный двор');
INSERT Bookstore.pubhouse(idpubhouse, namepubhouse) 
VALUES 
(1, 'Синдбад'),
(2, 'Эксмо'),
(3, 'Азбука'),
(4, 'АСТ'),
(5, 'Высшая школа');
INSERT Bookstore.book_has_author(book_idbook, author_idauthor) 
VALUES 
(354098, 1001),
(354098, 1002),
(150986, 1014),
(109205, 1015),
(509647, 1016),
(205430, 1016),
(876457, 1019),
(567787, 1019),
(209837, 1022),
(490843, 1827),
(765690, 2108);
INSERT Bookstore.edition(idedition, pages, year, pubhouse_idpubhouse, book_idbook, circulation) 
VALUES 
(121, 415, 2017, 2, 109205, 900),
(123, 460, 2020, 2, 109205, 1200),
(241, 460, 2011, 4, 150986, 700),
(231, 367, 2015, 3, 150986, 850),
(233, 367, 2022, 3, 150986, 1100),
(321, 342, 2018, 2, 205430, 600),
(411, 268, 2020, 1, 209837, 890),
(553, 325, 2013, 5, 354098, 200),
(611, 417, 2022, 1, 490843, 3000),
(725, 298, 2017, 2, 509647, 2100),
(821, 196, 2013, 2, 567787, 970),
(946, 349, 2016, 4, 765690, 4000),
(1031, 312, 2016, 3, 876457, 2800);
/*3.1 Составить список авторов с указанием количества изданных книг (в том числе в соавторстве)*/
select count(book_idbook) as amount, nameauthor as Name
from author, book_has_author
where author_idauthor = idauthor
group by author_idauthor;

/*3.2 Определить для каждого автора книгу с самым большим тиражом*/
SELECT nameauthor, max(circulation), namebook as Title
  FROM edition, author, book_has_author, book
  WHERE book_idbook = book_id and book_id = idbook and author_idauthor = idauthor
 GROUP BY idauthor;

/*3.3 Определить авторов, для которых среднее число страниц в книге не превышает 300*/
SELECT avg(pages) AS pages, namebook as bn, nameauthor as Name
  FROM edition, author, book_has_author, book
  WHERE book_idbook = book_id and book_id = idbook and author_idauthor = idauthor 
 GROUP BY author_idauthor
 having pages <= 300;
 
ALTER TABLE edition CHANGE book_idbook book_id INT;
 /*4.1 Определить авторов, у которых имеются книги с максимальным тиражом больше среднего*/
 SELECT nameauthor, max(circulation) as print
  FROM edition, author, book_has_author
  WHERE book_id = book_idbook and author_idauthor = idauthor
 GROUP BY idauthor
 HAVING print > (select avg(circulation) from edition);

/*4.2 Определить авторов, чьи книги опубликованы более чем в двух разных издательствах*/
SELECT nameauthor as name, count(pubhouse_idpubhouse) as amount
FROM author, book_has_author, (SELECT distinct pubhouse_idpubhouse, book_id from edition) as pubh
WHERE book_id = book_idbook and author_idauthor = idauthor
GROUP BY idauthor
HAVING amount > 2;

/*4.3 Увеличить тираж книги, если она имеет 2 и более авторов*/
update edition set circulation = circulation * 2, book_id = book_id
where book_id in (select book_idbook from book_has_author 
group by book_idbook having count(author_idauthor) >= 2);

select count(author_idauthor) from book_has_author group by author_idauthor;


/* 5.1 Определить издательства, не издавшие ни одной книги*/
SELECT namepubhouse FROM pubhouse
    LEFT JOIN edition ON idpubhouse = pubhouse_idpubhouse
    WHERE pubhouse_idpubhouse IS NULL;
    
/* 5.2 Вывести авторов с количеством опубликованных книг, если книг нет, то написать «отсутствуют»*/
SELECT nameauthor, count(book_idbook) FROM author, book_has_author
WHERE idauthor = author_idauthor GROUP BY nameauthor
UNION
SELECT nameauthor, 'отсутствуют' AS count_author
    FROM author
    LEFT JOIN book_has_author ON idauthor = author_idauthor
    WHERE book_idbook IS NULL;
    
/*5.3 Вывести список книг с количеством изданий, тираж которых равен 1000*/
SELECT idbook FROM book
	RIGHT JOIN edition ON book_id = idbook
	WHERE sum(circulation) = 1000
	GROUP BY  book_id;
SELECT book_id, count(book_id) as pubhouse, sum(circulation) as amount FROM edition
LEFT JOIN book ON book_id = idbook
GROUP BY  book_id
HAVING amount = 1000;

alter table edition modify column pages INT NULL;

/*Создать модифицируемое представление для таблицы с самым большим числом полей. 
В представлении скрыть хотя бы один столбец и несколько строк. Выполнить для полученного представления запрос INSERT*/
CREATE VIEW ed as SELECT idedition, year, pubhouse_idpubhouse, book_id, circulation from edition
WHERE year != 2016;
INSERT INTO ed (idedition, year, pubhouse_idpubhouse, book_id, circulation) 
VALUES (912, 2002, 1, 765690, 580);
select * from ed;
select * from edition;
drop VIEW ed;
/*6.1 Создать представление по книгам с указанием одного из авторов и последнего года издания*/
CREATE VIEW bookview as SELECT book_idbook, namebook, max(year), nameauthor 
FROM book, edition, author, book_has_author
WHERE book_id = book_idbook and book_idbook = idbook and idauthor = author_idauthor
GROUP BY book_id;
SELECT * FROM bookview;
drop view bookview;
select * from book_has_author;

/*6.2 Создать итоговое представление по авторам с указанием количества изданных книг, 
      количества различных соавторов, количества переизданий его книг*/
create view authorview as SELECT author.nameauthor as author, count(distinct book_idbook) as books, 
count(book_idbook) as coauthor, count(e.book_id) as publishing
from book_has_author
join edition e on book_idbook = e.book_id
left join author on author_idauthor = idauthor
group by author_idauthor;
select * from authorview;
CREATE VIEW authorview as SELECT nameauthor as NAME, count(distinct book_idbook) as 'books', 
count(author_idauthor) as 'co-authors', count(book_id) as 'edition'
FROM author, book_has_author, edition
WHERE author_idauthor = idauthor and book_id = book_idbook
GROUP BY nameauthor;
DROP VIEW authorview;
-- ---
select book_has_author.author_idauthor, book_has_author2.author_idauthor as
CoAuth
from book_has_author inner join book_has_author as book_has_author2 on
book_has_author.book_idbook = book_has_author2.book_idbook;

select author.nameauthor, author.idauthor, COUNT(DISTINCT(MY.CoAuth)) - 1 as sumCoAuthors
from author, (select book_has_author.author_idauthor, book_has_author2.author_idauthor as
CoAuth
from book_has_author inner join book_has_author as book_has_author2 on
book_has_author.book_idbook = book_has_author2.book_idbook) as MY
where author.idauthor = MY.author_idauthor
group by author.idAuthor;

select author.nameauthor, author.idauthor, count(book_has_author.book_idbook) as
sumbook
from author left join book_has_author on author.idauthor =
book_has_author.author_idauthor
GROUP BY nameauthor having sumbook > 0 union select
author.nameauthor, author.idauthor, count(book_has_author.book_idbook) as sumbook
from author left join book_has_author on author.idauthor =
book_has_author.author_idauthor
GROUP BY nameauthor having sumbook = 0;

select book_has_author.author_idauthor, (COUNT(edition.book_id)) as Editions
from book_has_author left outer join edition
on book_has_author.book_idbook = edition.book_id
group by book_has_author.author_idauthor;
use bookstore;
create view authorview as
(
	select MY1.nameauthor, MY1.idauthor, MY1.sumbook, MY2.sumCoAuthors, MY3.Editions
	from 
     (select author.nameauthor, author.idauthor, COUNT(DISTINCT(MY.CoAuth)) - 1 as sumCoAuthors
	from author, 
    (select book_has_author.author_idauthor, book_has_author2.author_idauthor as CoAuth
	from book_has_author inner join book_has_author as book_has_author2 
    on book_has_author.book_idbook = book_has_author2.book_idbook) as MY
	where author.idauthor = MY.author_idauthor
	group by author.idAuthor) as MY2,
    
	(select author.nameauthor, author.idauthor, count(book_has_author.book_idbook) as sumbook
	from author left join book_has_author on author.idauthor = book_has_author.author_idauthor
	GROUP BY nameauthor) as MY1,
    
	(select book_has_author.author_idauthor, (COUNT(book_has_author.book_idbook)) as Editions
	from book_has_author left join edition
	on book_has_author.book_idbook = edition.book_id
	group by book_has_author.author_idauthor) as MY3
	where MY1.idauthor = MY2.idauthor and MY2.idauthor = MY3.author_idauthor
);
drop view authorview;
select * from authorview;

/*7.1 Создать процедуру, вставляющую записи через первое представление из предыдущего задания. Вставить как минимум
 2 записи (т.е. вызвать процедуру дважды).*/
 1011, 2022, 1, 876457, 200
 DELIMITER $$
create procedure Insert_ed (id int, year int, ph int, book int, circ int)
begin
insert ed(idedition, year, pubhouse_idpubhouse, book_id, circulation) values(id, year, ph, book, circ);
end $$
DELIMITER ;
call Insert_ed(1011, 2022, 1, 876457, 200);
call Insert_ed(1021, 2019, 2, 876457, 300);
select * from ed;
/*Получить результат, формируемый третьим представлением (предыдущего задания) через 
объединение нескольких запросов, объединённых в процедуру.*/
DELIMITER $$
create procedure authorstat ()
begin
declare done int default 0;
declare id int;
declare sumbook int;
declare coauth int;
declare edition int;
declare Name char(50);
declare authcursor cursor for select idauthor, nameauthor from
author;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
create temporary table resauth(idauthor int, nameauthor
char(50), sumbook int, coauthor int, edition int);
open authcursor;
repeat
	fetch authcursor into id, Name;
	IF NOT done THEN
		set sumbook = (select count(book_idbook) from book_has_author
		where book_has_author.author_idauthor = id);

		set coauth = (select count(distinct(tabcoauth.coauthor)) - 1 from (select
		book_has_author.author_idauthor, book_has_author2.author_idauthor as coauthor
		from book_has_author inner join book_has_author as book_has_author2 
		on book_has_author.book_idbook = book_has_author2.book_idbook) as tabcoauth
		where id = tabcoauth.author_idauthor);

		set edition = (select count(book_id) from book_has_author, edition
		where author_idauthor = id and book_id = book_idbook);

		insert resauth value(id, Name, sumbook, coauth, edition);
	END IF;
until done end repeat;
close authcursor;
select * from resauth;
drop temporary table resauth;
end$$
DELIMITER ;

call authorstat;
drop procedure authorstat;

/*7.3 Создать процедуру с параметром по умолчанию и выходным параметром.
Cчитаем сколько книг, изданных 2 изданием, имеют меньше 310 страниц*/
drop procedure procedure7;
DELIMITER $$
create procedure procedure7(in pubhouse int, out amount int)
begin
IF pubhouse is null THEN SET pubhouse = 2;
END IF;
set amount = (select count(pages) from edition where
edition.pubhouse_idpubhouse = pubhouse_idpubhouse and edition.pages < 310);
end$$
DELIMITER ;
set @amount = 0;
call procedure7(null, @amount);
select @amount;