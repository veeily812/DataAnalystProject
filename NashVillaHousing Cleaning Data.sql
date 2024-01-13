--Cleaning Data in SQL Queries
---------------------------------------------------

Select *
from NashvillaHousing


----------------------------------------------------
--Standardize Date For at
SELECT SaleDate , Convert(Date,SaleDate)
FROM NashvillaHousing
----------------------------------------------------
--Populate property Address data ( same ID but differnet UniqueId )

select *
From NashvillaHousing
--where PropertyAddress is null
ORder by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from NashvillaHousing a
JOIN NashvillaHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from NashvillaHousing a
JOIN NashvillaHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
----------------------------------------------------------------
-- Breaking out Address into individual columns ( Address, City, State )
SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) AS Address


ALTER TABLE NashvillaHousing
Add PropertySplitAddress Nvarchar(225)

UPdate NashvillaHousing
Set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvillaHousing
Add PropertySplitCity Nvarchar(225)

UPdate NashvillaHousing
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

SELECT * 
FROM NashvillaHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.' ), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.' ), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.' ), 1)
from NashvillaHousing

ALter table NashvillaHousing
ADD OwnerSplitAddress nvarchar(225);

update NashvillaHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.' ), 3)

ALter table NashvillaHousing
ADD OwnerSplitCity nvarchar(225);

update NashvillaHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.' ), 2)

ALter table NashvillaHousing
ADD OwnerSplitState nvarchar(225);

update NashvillaHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.' ), 1)
--------------------------------------------------------------------
--Change Y ans N to Yes and No in ' SoldAsVacant ' field
SELECT DISTINCT(SoldAsVacant), count(SoldAsVacant)
FrOM NashvillaHousing
Group by SoldAsVacant
order by 2

SELECT SoldAsVacant 
, case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
ELSE  SoldAsVacant
END
From NashvillaHousing

-----------------------------------------

--Remove Duplicate
WITH RowNumCTE AS 
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, Saleprice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS Row_num
    FROM NashvillaHousing
)
SELECT *
FROM RowNumCTE
WHERE Row_num > 1
--order by PropertyAddress

SELECT * 
FROM NashvillaHousing
------------------------------------------------------------------

-- Remove Duplicate
SELect *
FROM NashvillaHousing

ALter TABLE NashvillaHousing
DROP column OWNerAddress

