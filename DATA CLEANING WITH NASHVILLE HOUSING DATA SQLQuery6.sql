--DATA CLEANING 

--1.CLEANING DATA IN SQL QUERIES
select *
from [Nashville Housing Data]


--2.STANDADIZING DATA FORMAT

select salesdateconverted, convert(date,saledate)
from [Nashville Housing Data]

update [Nashville Housing Data]
set saledate = convert(date,saledate)

alter table [Nashville Housing Data]
add salesdateconverted date;

update [Nashville Housing Data]
set salesdateconverted = convert(date,saledate)



--3.POPULATING PROPERTY ADDRESS for DATA missing property address

select *
from [Nashville Housing Data]
--where propertyaddress is null
order by ParcelID

select *
from [Nashville Housing Data]
--where propertyaddress is null
order by ParcelID


-- where they have uniqueID diferrentiate parcelID -- isnull checks to see if there is a null
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
from [Nashville Housing Data] a
join [Nashville Housing Data] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull( a.propertyaddress,b.PropertyAddress)
from [Nashville Housing Data] a
join [Nashville Housing Data] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]


--4.BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

select PropertyAddress
from [Nashville Housing Data]
--where propertyaddress is null
--order by ParcelID

--uisng parsename to take break address into categories above 

select
parsename(replace(PropertyAddress,',','.') ,2)
,parsename(replace(PropertyAddress,',','.') ,1)
from [Nashville Housing Data]

-- adding two more tables to put the separated columns value
alter table [Nashville Housing Data]
add Propertysplitaddress Nvarchar(255);


update [Nashville Housing Data]
set Propertysplitaddress = parsename(replace(PropertyAddress,',','.') ,2)

alter table [Nashville Housing Data]
add Propertysplitcities Nvarchar(255);

update [Nashville Housing Data]
set Propertysplitcities = parsename(replace(PropertyAddress,',','.') ,1)

select *
from [Nashville Housing Data]

--for owner address usine parsename instead 

select OwnerAddress
from [Nashville Housing Data]

select
parsename(replace(OwnerAddress,',','.') ,3)
,parsename(replace(OwnerAddress,',','.') ,2)
,parsename(replace(OwnerAddress,',','.') ,1)
from [Nashville Housing Data]

alter table [Nashville Housing Data]
add ownersplitcity Nvarchar(255);

update [Nashville Housing Data]
set ownersplitcity = parsename(replace(OwnerAddress,',','.') ,2)

alter table [Nashville Housing Data]
add ownersplitaddress Nvarchar(255);

update [Nashville Housing Data]
set ownersplitaddress = parsename(replace(OwnerAddress,',','.') ,3)

alter table [Nashville Housing Data]
add ownersplitstate Nvarchar(255);

update [Nashville Housing Data]
set ownersplitstate = parsename(replace(OwnerAddress,',','.') ,1)

select *
from [Nashville Housing Data]




--5.CHANGE Y AND N TO YES AND NO "SOLD AS VACANT" FIELD 

select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Housing Data]
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end 
from [Nashville Housing Data]

update [Nashville Housing Data]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end 


--REMOVE DUPLICATES

--using CTE  to check for duplicates 

with rowNumCTE as(
select *,
row_number () over (
partition by ParcelID,PropertyAddress,Saleprice,SaleDate,LegalReference
order by UniqueID) row_num
from [Nashville Housing Data]
)
select *
from rowNumCTE
where row_num > 1
order by PropertyAddress

-- to delete dupilcates 

with rowNumCTE as(
select *,
row_number () over (
partition by ParcelID,PropertyAddress,Saleprice,SaleDate,LegalReference
order by UniqueID) row_num
from [Nashville Housing Data]
)
delete
from rowNumCTE
where row_num > 1


select *
from [Nashville Housing Data]



--DELETE UNUSED COLUMNS

--dropping columns made in errror

ALTER TABLE [Nashville Housing Data]
DROP COLUMN PropertyAddress ;

ALTER TABLE [Nashville Housing Data]
DROP COLUMN OwnerAddress ;

ALTER TABLE [Nashville Housing Data]
DROP COLUMN TaxDistrict;

ALTER TABLE [Nashville Housing Data]
DROP COLUMN SaleDate;

select *
from [Nashville Housing Data]




