Data Cleaning Portfolio

/*

Cleaning Data in SQL Queries

*/


Select *
From [Portfolio project].dbo.Nashvillehousing


--Standardize Date Format



Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio project].dbo.Nashvillehousing


Update Nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)




--Populate Property Address data

Select *
From [Portfolio project].dbo.Nashvillehousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio project].dbo.Nashvillehousing a
JOIN [Portfolio project].dbo.Nashvillehousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio project].dbo.Nashvillehousing a
JOIN [Portfolio project].dbo.Nashvillehousing b
on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--Breaking out Address Into Individual Columns (Address, City, State


Select PropertyAddress
From [Portfolio project].dbo.Nashvillehousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
 
 From [Portfolio project].dbo.Nashvillehousing


ALTER TABLE Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *

From [Portfolio project].dbo.Nashvillehousing





Select OwnerAddress

From [Portfolio project].dbo.Nashvillehousing



Select
PARSENAME(OwnerAddress, 1)
From [Portfolio project].dbo.Nashvillehousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From [Portfolio project].dbo.Nashvillehousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
From [Portfolio project].dbo.Nashvillehousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio project].dbo.Nashvillehousing



ALTER TABLE Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *

From [Portfolio project].dbo.Nashvillehousing


------------------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in *Sold as Vacant* field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio project].dbo.Nashvillehousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio project].dbo.Nashvillehousing


Update Nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio project].dbo.Nashvillehousing




	  






----------------------------------------------------------------------------------------------------------------------------------------

	  --REMOVE DUPLICATES 


WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
	             SalePrice,
	             SaleDate,
	             LegalReference
	             ORDER BY
	                UniqueID
	                ) row_num

From [Portfolio project].dbo.Nashvillehousing
--order by ParcelID
)
Select *
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress



------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns



Select *
From [Portfolio project].dbo.Nashvillehousing


ALTER TABLE [Portfolio project].dbo.Nashvillehousing
DROP COLUMN OwnerAddress, TaxiDistrict, PropertyAddress


ALTER TABLE [Portfolio project].dbo.Nashvillehousing
DROP COLUMN SaleDate






