-- exploratory data analysis

select *
from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2 
where percentage_laid_off =1
order by total_laid_off desc;

select * 
from layoffs_staging2 
where percentage_laid_off =1
order by funds_raised_millions desc;

select company , sum(total_laid_off)
from layoffs_staging2 
group by company
order by 2 desc;

select min(`date`) , max(`date`)
from layoffs_staging2;

select industry , sum(total_laid_off)
from layoffs_staging2 
group by industry
order by 2 desc;

select country , sum(total_laid_off)
from layoffs_staging2 
group by country
;
select `date` , sum(total_laid_off)
from layoffs_staging2 
group by `date`
order by `date` desc;


select `date` , sum(total_laid_off)
from layoffs_staging2 
group by `date`
order by 1 desc;

select year(`date`) , sum(total_laid_off)
from layoffs_staging2 
group by year(`date`)
order by 1 desc;

select stage , sum(total_laid_off)
from layoffs_staging2 
group by stage
order by 1 desc;

select substring(`date`,6,2) as `month` ,sum(total_laid_off)
from layoffs_staging2
group by `month`;

select substring(`date`,1,7) as `month` ,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 ; 

with rolling_total as
(
select substring(`date`,1,7) as `month` ,sum(total_laid_off) as total
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
) 
select `month` ,total, sum(total) over (order by `month`) as rolling_total
from rolling_total;


with rolling_total as 
(
    SELECT 
        SUBSTRING(`date`,1,7) AS `month`,
        YEAR(`date`) AS `year`,
        SUM(total_laid_off) AS total
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY `month`, `year`
)
SELECT `year`,
    `month`,
    total,
    SUM(total) OVER (
        PARTITION BY `year`
        ORDER BY `month`
		) AS rolling_total
FROM rolling_total;


select company , year(`date`),sum(total_laid_off)
from layoffs_staging2 
group by company , year(`date`)
order by company asc;

select company , year(`date`),sum(total_laid_off)
from layoffs_staging2 
group by company , year(`date`)
order by 3 desc;


with company_year (company,years,total_laid_off) as
(
select company , year(`date`),sum(total_laid_off)
from layoffs_staging2 
group by company , year(`date`)

) select * , dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
order by ranking asc
 ;



with company_year (company,years,total_laid_off) as
(
select company , year(`date`),sum(total_laid_off)
from layoffs_staging2 
group by company , year(`date`)

), company_year_rank as
(
 select * , dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
 select *
 from company_year_rank
 where ranking <= 5;
