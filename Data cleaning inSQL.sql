/*

cleaning data in sql query*

*/


Select * From Portfolio.dbo.NashvilleHousing



Select SaleDate, CONVERT(DATE,SaleDate )
From Portfolio.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate )


-- Alter table to add new column
Alter Table NashvilleHousing
Add SaleDateConverted Date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate )

Select SaleDateConverted
From Portfolio.dbo.NashvilleHousing

--populate property adress data

Select  PropertyAddress
From Portfolio.dbo.NashvilleHousing
where PropertyAddress is null

Select  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing as a
join Portfolio.dbo.NashvilleHousing AS b
    on a.ParcelID=B.ParcelID
	 AND A.UniqueID<>b.UniqueID
where a.PropertyAddress is null

/*SELECT a.ParcelID,
       a.PropertyAddress AS Address_A,
       b.PropertyAddress AS Address_B,
       ISNULL(a.PropertyAddress, b.PropertyAddress) AS MergedAddress
FROM Portfolio.dbo.NashvilleHousing AS a
JOIN Portfolio.dbo.NashvilleHousing AS b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;*/





/* ISNULL(): to replace null values with
 the corresponding PropertyAddress from b.*/

update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing as a
join Portfolio.dbo.NashvilleHousing AS b
    on a.ParcelID=B.ParcelID
	 AND A.UniqueID<>b.UniqueID
where a.PropertyAddress is null

--------------------------------------------------------------------------------------

--Breaking out Address Into Individual Columns (Address, City, State)

Select PropertyAddress
From Portfolio.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID

--Syntax: SUBSTRING(string_expression, start_position, length)

Select PropertyAddress
From Portfolio.dbo.NashvilleHousing


--CHARINDEX(substring, string_expression)
Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) AS ADRESS
From Portfolio.dbo.NashvilleHousing



Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) AS ADRESS,
CHARINDEX(',',PropertyAddress) AS CommaPosition
From Portfolio.dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS ADRESS
From Portfolio.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS ADRESS,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS ADRESS
From Portfolio.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertysplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Select OwnerAddress From Portfolio.dbo.NashvilleHousing


/*PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3): This portion replaces commas
 with dots in the OwnerAddress column and then parses the address to extract 
 the third part, typically representing the */

SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS State,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS Street
FROM 
    Portfolio.dbo.NashvilleHousing;





ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
 SET  OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 

 ALTER TABLE NashvilleHousing
Add OwnerSplitStreet Nvarchar(255);

Update NashvilleHousing
 SET  OwnerSplitStreet= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


 
Select *
From Portfolio.dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count (SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
order by Count (SoldAsVacant)--OR 2



Select SoldAsVacant
 , CASE When SoldAsVacant ='Y' THEN 'Yes'
   When SoldAsVacant ='N' THEN 'No'
   ELSE SoldasVacant
   END
From Portfolio.dbo.NashvilleHousing

 ALTER TABLE NashvilleHousing
Add SoldAsVacant Nvarchar(255);

Update NashvilleHousing
 SET  SoldAsVacant= CASE When SoldAsVacant ='Y' THEN 'Yes'
   When SoldAsVacant ='N' THEN 'No'
   ELSE SoldasVacant
   END

   --------------------------------------------------------------------------
   --Remove Duplicates
WITH RowNumCTE AS(
Select*,
  ROW_NUMBER() OVER(     /*calculates a row number  for each row based on the specified partitioning and ordering*/
  PARTITION BY ParcelID,
               PropertyAddress,
               SalePrice,
			   SaleDate,
               LegalReference
               ORDER BY
               UniqueID
               ) row_num
From Portfolio.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
  
  
WITH RowNumCTE AS(
Select*,
  ROW_NUMBER() OVER(     /*calculates a row number  for each row based on the specified partitioning and ordering*/
  PARTITION BY ParcelID,
               PropertyAddress,
               SalePrice,
			   SaleDate,
               LegalReference
               ORDER BY
               UniqueID
               ) row_num
From Portfolio.dbo.NashvilleHousing
--order by ParcelID
)
DELETE 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress   
 ------------------------------------------------------------------------------------------------------
 --DELETE UNUSED COLUMNS
 --Delete Unused Columns
Select From Portfolio.dbo NashvilleHousing


ALTER TABLE Portfolio.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate