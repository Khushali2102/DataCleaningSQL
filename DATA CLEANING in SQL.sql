-- Cleaning Data in SQL Queries

Select * from PortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format
Select SaleDateConverted, Convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing 
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing 
SET SaleDateConverted = Convert(Date,SaleDate)


-- Populate Property Adress Data

Select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress, b.PropertyAddress) 
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing




SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS RestOfAddress
FROM 
    PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing 
Add PropertySplitAddress nvarchar(250);

Update NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvilleHousing 
Add PropertyCity nvarchar(250);

Update NashvilleHousing 
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



--owner Adress
Select OwnerAddress from PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress nvarchar(250);

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing 
Add OwnerSplitCity nvarchar(250);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing 
Add OwnerSplitState nvarchar(250);

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select * from PortfolioProject.dbo.NashvilleHousing


--Change Y and N TO Yes and No in "Sold as Vacant" field
Select  Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' Then 'YES'
     when SoldAsVacant = 'N' Then 'NO'
	 Else SoldAsVacant
	 END
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =  CASE when SoldAsVacant = 'Y' Then 'YES'
     when SoldAsVacant = 'N' Then 'NO'
	 Else SoldAsVacant
	 END


--Remove Duplicate

WITH RowNumCTE AS(

SELECT *, ROW_NUMBER() Over(
Partition BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY
uniqueId
) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelId
)


Select * from RowNumCTE
where row_num >1
order by ParcelID

--DELETE from RowNumCTE
--where row_num >1
--order by ParcelID


----DELETE UNUSED COLUMN

Select *
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN ownerAddress, TaxDistrict, PropertyAddress, SaleDate
